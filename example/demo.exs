defmodule Demo do
  @moduledoc """
  Run with:

      mix run --no-halt example/demo.exs

  Test with:

      seq 15 | xargs -Iz curl -w " %{http_code}\n" http://localhost:4000/

  """

  use Plug.Router

  plug(Plug.Ratelimit, limit: {4, :per, :second})
  plug(:match)
  plug(:dispatch)

  def init(options) do
    options
  end

  get "/" do
    conn
    |> send_resp(200, "OK")
    |> halt
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end

{:ok, _} = Plug.Adapters.Cowboy.http(Demo, [])
