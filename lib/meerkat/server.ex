defmodule Meerkat.Server do

    @moduledoc """
    The Cowboy HTTP server that proxies all HTTP requests
    and applies policies.
    """

#    use Application.Behaviour

    def start(_type, _args) do
        dispatch = :cowboy_router.compile([
                     {:_, [{"/", Meerkat.Gateway.RequestHandler, []}]}
                   ])
        {:ok, _} = :cowboy.start_http(:http, 100,
                                      [port: 8093],
                                      [env: [dispatch: dispatch]])
        Meerkat.Gateway.Supervisor.start_link
    end

end