defmodule Plug.Ratelimit do
  @moduledoc """
  A plug that enforces rate limiting (requests per second)
  """

  import Plug.Conn

  alias Buckets.TokenBucket, as: TokenBucket

  @doc """
  MUST have a keyword of the form:

      [limit:, {x, :per, :second}]

  where x is a positive integer.
  """
  def init(opts) do
    {:ok, limit} = Keyword.fetch(opts, :limit)
    {:ok, pid} = TokenBucket.start(limit)
    {pid}
  end

  def call(conn, {bucket}) do
    case TokenBucket.empty?(bucket) do
      true -> too_many_requests(conn)
      false -> conn
    end
  end

  defp too_many_requests(conn) do
    conn
    |> send_resp(429, "Too Many Requests")
    |> halt
  end
end
