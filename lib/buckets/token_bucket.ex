defmodule Buckets.TokenBucket do
  @moduledoc """
  A Token Bucket fills with tokens at a regular rate, up until a preset limit.
  Another process may ask if the bucket is empty or not. Each empty request
  drains a token from the bucket.

  See [Token Bucket Algorithm](https://en.wikipedia.org/wiki/Token_bucket)
  """

  use GenServer

  @doc """
  Create a Token Bucket process that allows 10 requests per second:

      {:ok, pid} = Buckets.TokenBucket.start({10, :per, :second})
      Buckets.TokenBucket.empty?(pid)

  By default the bucket will refill itself. To disable refill for testing:

      {:ok, pid} = Buckets.TokenBucket.start({2, :per, :second}, [refill: false])
      false = Buckets.TokenBucket.empty?(pid)
      false = Buckets.TokenBucket.empty?(pid)
      true  = Buckets.TokenBucket.empty?(pid)
  """
  def start(config, opts \\ [refill: true]) do
    {req, :per, :second} = config
    {:ok, interval_ms, tokens} = calculate_refill_rate(req)
    bucket = %{:max_tokens => req,
               :tokens => req,
               :refill_tokens => tokens,
               :interval_ms => interval_ms,
               :refill => opts[:refill]}
    GenServer.start(__MODULE__, bucket, opts)
  end

  def init(state) do
    unless Map.get(state, :refill) == false do
      Process.send(self(), :refill, [])
    end
    {:ok, Map.delete(state, :refill)}
  end

  @doc """
  Returns true if the bucket is empty, otherwise false.
  Removes a token from the bucket after the test.
  """

  def empty?(pid) do
    GenServer.call(pid, :empty)
  end

  # Callbacks

  @doc """
  Each call to this function removes a token from the bucket.
  Returns true if the bucket is not empty before the call is made,
  otherwise false if empty.
  """
  def handle_call(:empty, _from, bucket) do
    new_bucket = Map.update(bucket, :tokens, 0, &dec_to_zero/1)
    case Map.get(bucket, :tokens, 0) do
      0   -> {:reply, true, new_bucket}
      _   -> {:reply, false, new_bucket}
    end
  end

  @doc """
  Add tokens to the bucket, and schedule the next refill.
  """

  def handle_info(:refill, bucket) do
    %{max_tokens: max_tokens,
     refill_tokens: refill_tokens,
     tokens: tokens_in_bucket,
     interval_ms: interval_ms} = bucket
    Process.send_after(self(), :refill, interval_ms)
    more_tokens = Enum.min([tokens_in_bucket + refill_tokens, max_tokens])
    {:noreply, %{bucket | :tokens => more_tokens}}
  end

  # Calculate the refill rate

  defp correct_refill_rate?(interval_ms, tokens, requests_per_second) do
    requests_per_second == (1000.0 / interval_ms) * tokens
  end

  @doc """
  Calculate all the combinations of refill rates that give us the correct
  requests per second, and choose the one with the highest refill rate.
  This gives us a fair distribution of tokens added over the second.
  """

  def calculate_refill_rate(requests_per_second) do
    hd(for interval_ms <- 20..1000, tokens <- requests_per_second..1,
      correct_refill_rate?(interval_ms, tokens, requests_per_second),
      do: {:ok, interval_ms, tokens})
  end

  @doc """
  Decrement n, minimum value is zero.
  """

  def dec_to_zero(n) do
    if n > 0 do
      n - 1
    else
      0
    end
  end

end
