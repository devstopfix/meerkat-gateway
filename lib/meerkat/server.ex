defmodule Meerkat.Server do

    @moduledoc """
    The Cowboy HTTP server that proxies all HTTP requests
    and applies policies.
    """


    def start(_type, _args) do
        dispatch = :cowboy_router.compile([{:_, [
            {"/api/[...]", Meerkat.Gateway.RequestHandler, []},
            {"/fixture/[...]", :cowboy_static, {:dir, "public",
            [{:mimetypes, {"application", "json", []}}]}}]}])

        bootstrap()

        {:ok, _} = :cowboy.start_http(:http, 100,
                                      [port: 8093],
                                      [env: [dispatch: dispatch]])
        Meerkat.Gateway.Supervisor.start_link
    end

    defp bootstrap() do
      {:ok, pid} = Meerkat.Buckets.TokenBucket.start({2, :per, :second})
      Process.register(pid, :throttle)
    end

end