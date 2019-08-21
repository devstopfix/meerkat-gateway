defmodule Buckets.SternBrocot do
  @moduledoc """
  In number theory, the Stern–Brocot tree is an infinite complete binary tree
  in which the vertices correspond one-for-one to the positive rational numbers,
  whose values are ordered from the left to the right as in a search tree.

  -- https://en.wikipedia.org/wiki/Stern%E2%80%93Brocot_tree
  """

  def find(requests_per_second)
      when is_integer(requests_per_second) and requests_per_second >= 1 do
    {n, d} = find(requests_per_second / 1000.0, {0, 1}, {1, 0})
    [tokens: n, interval_ms: d]
  end

  defp find(q, {a, b} = l, {c, d} = h) do
    m = mediant(l, h)

    cond do
      m < q -> find(q, {a + c, b + d}, h)
      m > q -> find(q, l, {a + c, b + d})
      true -> {a + c, b + d}
    end
  end

  defp mediant({a, b}, {c, d}) do
    (a + c) / (b + d)
  end
end
