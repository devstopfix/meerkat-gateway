defmodule Meerkat.Buckets.TokenBucketTest do

  use ExUnit.Case, async: true
  use ExCheck
  doctest Meerkat.Buckets.TokenBucket

  alias Meerkat.Buckets.TokenBucket, as: TokenBucket

  test "Bucket with zero rate limit is empty" do
    {:ok, pid} = TokenBucket.start({0, :per, :second}, [refill: false])
    assert TokenBucket.empty?(pid)
  end

  property :bucket_of_size_n_has_n_tokens do
    for_all {n} in {pos_integer} do
      {:ok, pid} = TokenBucket.start({n, :per, :second}, [refill: false])
      Enum.map(Range.new(1,n), fn(_) -> refute TokenBucket.empty?(pid) end)
      assert TokenBucket.empty?(pid)
    end
  end

  property :buckets_get_emptied_and_refilled do
    for_all {n} in {pos_integer} do
      {:ok, pid} = TokenBucket.start({n, :per, :second}, [refill: false])
      Enum.map(Range.new(1,n), fn(_) -> refute TokenBucket.empty?(pid) end)
      assert TokenBucket.empty?(pid), "Not all tokens drained"
      :ok = Process.send(pid, :refill, [])
      assert false == TokenBucket.empty?(pid), "Bucket remains empty after refill"
    end
  end

  # calculate_refill_rate

  property :calculate_refill_rate_always_adds_tokens do
    for_all {requests_per_second} in {pos_integer} do
      {:ok, _, tokens} = TokenBucket.calculate_refill_rate(requests_per_second)
      assert tokens > 0
      assert tokens <= requests_per_second
    end
  end

  property :calculate_refill_rate_interval_is_at_least_50_fps do
    for_all {requests_per_second} in {pos_integer} do
      {:ok, interval_ms, _} = TokenBucket.calculate_refill_rate(requests_per_second)
      assert interval_ms >=   20
      assert interval_ms <= 1000
    end
  end

  @tag iterations: 20
  property :calculate_refill_rate do
    for_all {requests_per_second} in {pos_integer} do
      {:ok, interval_ms, tokens_per_refill} = TokenBucket.calculate_refill_rate(requests_per_second)
      tokens_in_bucket_after_1_second = trunc(Float.ceil(1000.0 / interval_ms)) * tokens_per_refill
      assert tokens_in_bucket_after_1_second >= requests_per_second
      assert tokens_in_bucket_after_1_second <= requests_per_second * 1.01
    end
  end

  # dec_to_zero

  test "Dec zero stays zero" do
    assert 0 == TokenBucket.dec_to_zero(0)
  end

  property :dec_positive_numbers do
    for_all {n} in {pos_integer} do
      assert n-1 == TokenBucket.dec_to_zero(n)
    end
  end

  property :dec_negative_numbers_are_zero do
    for_all {n} in {pos_integer} do
      assert 0 == TokenBucket.dec_to_zero(-n)
    end
  end

end