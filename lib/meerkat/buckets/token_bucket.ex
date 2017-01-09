defmodule Meerkat.Buckets.TokenBucket do
  @moduledoc """
  A Token Bucket fills with tokens at a regular rate, up until a preset limit.
  Another process may ask if the bucket is empty or not. Each empty request
  drains a token from the bucket.

  See [Token Bucket Algorithm](https://en.wikipedia.org/wiki/Token_bucket)
  """

  use GenServer

  @doc """
  Create a Token Bucket process that allows 10 requests per second:

      {:ok, pid} = Meerkat.Buckets.TokenBucket.start({10, :per, :second})
      Meerkat.Buckets.TokenBucket.empty?(pid)

  By default the bucket will refill itself. To disable refill for testing:

      {:ok, pid} = Meerkat.Buckets.TokenBucket.start({2, :per, :second}, [refill: false])
      false = Meerkat.Buckets.TokenBucket.empty?(pid)
      false = Meerkat.Buckets.TokenBucket.empty?(pid)
      true  = Meerkat.Buckets.TokenBucket.empty?(pid)
  """
  def start(config, opts \\ [refill: true]) do
    {req, :per, :second} = config
    bucket = %{:max_tokens => req,
               :tokens => req,
               :interval_ms => s_to_ms(1),
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

  def handle_call(:empty, _from, bucket) do
    new_bucket = Map.update(bucket, :tokens, 0, &dec_to_zero/1)
    case Map.get(bucket, :tokens, 0) do
      0   -> {:reply, true, new_bucket}
      _   -> {:reply, false, new_bucket}
    end
  end

  def handle_info(:refill, bucket) do
    %{max_tokens: max_tokens, tokens: _, interval_ms: interval_ms} = bucket
    Process.send_after(self(), :refill, interval_ms)
    {:noreply, %{bucket | :tokens => Enum.max([0, max_tokens])}}
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

  defp s_to_ms(n) do
    n * 1000
  end

end