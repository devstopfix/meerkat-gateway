defmodule Buckets.TokenBucketTest do
  use ExUnit.Case, async: false
  use ExUnitProperties

  alias Buckets.TokenBucket
  alias Buckets.SternBrocot

  property "bucket_of_size_n_has_n_tokens" do
    check all(n <- StreamData.positive_integer()) do
      {:ok, pid} = TokenBucket.start([requests_per_second: n], refill: false)
      Enum.map(Range.new(1, n), fn _ -> refute TokenBucket.empty?(pid) end)
      assert TokenBucket.empty?(pid)
    end
  end

  property "buckets_get_emptied_and_refilled" do
    check all(n <- StreamData.positive_integer()) do
      {:ok, pid} = TokenBucket.start([requests_per_second: n], refill: false)
      Enum.map(Range.new(1, n), fn _ -> refute TokenBucket.empty?(pid) end)
      assert TokenBucket.empty?(pid), "Not all tokens drained"
      :ok = Process.send(pid, :refill, [])
      assert false == TokenBucket.empty?(pid), "Bucket remains empty after refill"
    end
  end

  # calculate_refill_rate

  property :calculate_refill_rate_always_adds_tokens do
    check all(requests_per_second <- StreamData.positive_integer()) do
      [tokens: tokens, interval_ms: _] = SternBrocot.find(requests_per_second)
      assert tokens > 0
      assert tokens <= requests_per_second
    end
  end

  property :calculate_refill_rate_interval_is_at_least_50_fps do
    check all(requests_per_second <- StreamData.positive_integer()) do
      [tokens: _, interval_ms: interval_ms] = SternBrocot.find(requests_per_second)
      assert interval_ms >= 1
      assert interval_ms <= 1000
    end
  end

  property :calculate_refill_rate do
    check all(requests_per_second <- StreamData.positive_integer()) do
      [tokens: tokens_per_refill, interval_ms: interval_ms] =
        SternBrocot.find(requests_per_second)

      tokens_in_bucket_after_1_second =
        trunc(Float.ceil(1000.0 / interval_ms)) * tokens_per_refill

      assert tokens_in_bucket_after_1_second >= requests_per_second
      assert tokens_in_bucket_after_1_second <= requests_per_second * 1.01
    end
  end

  # dec_to_zero

  property :dec_positive_numbers do
    check all(n <- StreamData.positive_integer()) do
      assert n - 1 == TokenBucket.dec_to_zero(n)
    end
  end

  property :dec_negative_numbers_are_zero do
    check all(n <- StreamData.positive_integer()) do
      assert 0 == TokenBucket.dec_to_zero(-n)
    end
  end

  test "Dec zero stays zero" do
    assert 0 == TokenBucket.dec_to_zero(0)
  end
end
