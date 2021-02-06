defmodule Plug.Ratelimit do
  @moduledoc """
  A plug that enforces rate limiting (requests per second)

  Use in your Router:

      plug(Plug.Ratelimit, requests_per_second: 4)
  """

  import Plug.Conn

  alias Buckets.TokenBucket, as: TokenBucket

  @http_429 "Too Many Requests"

  @doc """
  MUST have a keyword of the form:

      [requests_per_second: x]

  where x is a positive integer.

  MAY override the response message with:

      [..., message: "Enhance Your Calm"]
  """
  def init(args) do
    requests_per_second = Keyword.get(args, :requests_per_second)
    message = Keyword.get(args, :message, @http_429)
    {:ok, pid} = TokenBucket.start(requests_per_second)
    [pid: pid, message: message]
  end

  def call(conn, pid: bucket_pid, message: message) do
    case TokenBucket.empty?(bucket_pid) do
      true -> too_many_requests(conn, message)
      false -> conn
    end
  end

  defp too_many_requests(conn, message) do
    conn
    |> send_resp(429, message)
    |> halt
  end
end
