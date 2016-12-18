defmodule Meerkat.Buckets.TokenBucketTest do

  use ExUnit.Case, async: true
  use ExCheck
  doctest Meerkat.Buckets.TokenBucket

  import Meerkat.Buckets.TokenBucket

  test "Bucket with zero rate limit is empty" do
    {:ok, pid} = start({0, :per, :second}, [refill: false])
    assert empty?(pid)
  end

  property :bucket_of_size_n_has_n_tokens do
    for_all {n} in {non_neg_integer} do
      {:ok, pid} = start({n, :per, :second}, [refill: false])
      Enum.map(Range.new(1,n), fn(_) -> refute empty?(pid) end)
      assert empty?(pid)
    end
  end

# TODO how do we send an info message to a process?
#  property :buckets_get_refilled do
#    for_all {n} in {pos_integer} do
#      {:ok, pid} = start({n, :per, :second}, [refill: false])
#      Enum.map(Range.new(1,n), fn(_) -> refute empty?(pid) end)
#      assert empty?(pid)
#      Process.send(pid, :refill)
#      refute empty?(pid)
#    end
#  end

  # dec_to_zero

  test "Dec zero stays zero" do
    assert 0 == dec_to_zero(0)
  end

  property :dec_positive_numbers do
    for_all {n} in {pos_integer} do
      assert n-1 == dec_to_zero(n)
    end
  end

  property :dec_negative_numbers_are_zero do
    for_all {n} in {pos_integer} do
      assert 0 == dec_to_zero(-n)
    end
  end

end