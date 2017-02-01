defmodule Plug.Ratelimit do

	@moduledoc """
	A plug that enforces rate limiting (requests per second)
	"""

  import Plug.Conn
  #alias Plug.Conn
  alias Meerkat.Buckets.TokenBucket, as: TokenBucket

  def init(_opts) do
    {:ok, pid} = TokenBucket.start({4, :per, :second}, [refill: false])
  	{pid}
  end

  def call(conn, {bucket}) do
  	case TokenBucket.empty?(bucket) do
      true  -> too_many_requests(conn)
  		false -> conn
  	end
  end

  defp too_many_requests(conn) do
  	conn
  	|> send_resp(429, "Too Many Requests")
  	|> halt
  end

end
