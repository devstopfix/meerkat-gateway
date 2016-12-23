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