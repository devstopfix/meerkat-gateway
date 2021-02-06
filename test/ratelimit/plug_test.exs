defmodule Plug.Ratelimit.PlugTest do
  use ExUnit.Case, async: false
  use Plug.Test

  defmodule Router do
    use Plug.Router

    plug(Plug.Ratelimit, requests_per_second: 1, message: "HALT!")
    plug(:match)
    plug(:dispatch)

    def call(conn, opts) do
      super(conn, opts)
    end

    get "/" do
      send_resp(conn, 200, "OK")
    end
  end

  test "second call is throttled with message" do
    conn = conn(:get, "/")
    assert %{status: 200, resp_body: "OK"} = Router.call(conn, [])
    assert %{status: 429, resp_body: "HALT!"} = Router.call(conn, [])
  end
end
