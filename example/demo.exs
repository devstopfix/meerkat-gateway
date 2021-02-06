defmodule Demo do
  @moduledoc """
  Run with:

      mix run --no-halt example/demo.exs

  Test with:

      seq 15 | xargs -Iz curl -w " %{http_code}\n" http://localhost:4000/

  """

  use Plug.Router

  plug(Plug.Ratelimit, requests_per_second: 4)
  plug(:match)
  plug(:dispatch)

  def init(options), do: options

  get("/", do: send_resp(conn, 204, ""))

  match(_, do: send_resp(conn, 404, "Not Found"))
end

{:ok, _} = Plug.Adapters.Cowboy.http(Demo, [])
