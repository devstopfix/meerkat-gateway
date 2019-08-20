defmodule Demo do
  use Plug.Router

  plug(Plug.Ratelimit, limit: {4, :per, :second})
  plug(:match)
  plug(:dispatch)

  def init(options) do
    options
  end

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http(Demo, [])
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
