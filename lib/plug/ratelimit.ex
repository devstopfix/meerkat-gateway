defmodule Plug.Ratelimit do
  @moduledoc """
  A plug that enforces rate limiting (requests per second)
  """

  import Plug.Conn

  alias Buckets.TokenBucket, as: TokenBucket

  @doc """
  args MUST have a keyword of the form:

      [requests_per_second: x]

  where x is a positive integer.
  """
  def init(args) do
    requests_per_second = Keyword.get(args, :requests_per_second)
    {:ok, pid} = TokenBucket.start(requests_per_second)
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
