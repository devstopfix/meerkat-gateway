defmodule Meerkat.Gateway.RequestHandler do

  @moduledoc """
  Process to handle a single HTTP request.
  """

  alias Meerkat.Buckets.TokenBucket, as: TokenBucket

  def init(_transport, req, []) do
    {:ok, req, nil}
  end

  @doc """
  Handle a HTTP request. New process is spawned for each request.
  """

  def handle(req, state) do
    self |> inspect |> IO.puts
    if TokenBucket.empty?(:throttle) do
      reply = :cowboy_req.reply(429, [{"content-type", "text/plain"}], "TOO MANY REQUESTS", req)
      {:ok, reply, state}
    else
      {:ok, reply} = proxy_request(req);
      {:ok, reply, state};
    end
  end

  @http_options [recv_timeout: 250]

  @http_headers ["Accept": "Application/json"]

  @doc """
  Call the downstream API
  """

  def proxy_request(req) do
    case HTTPoison.get("http://localhost:8093/fixture/200.json", @http_headers, @http_options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        :cowboy_req.reply(200, headers, body, req)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        :cowboy_req.reply(404, [], "FIXTURE NOT FOUND", req)
      {:error, %HTTPoison.Error{reason: reason}} ->
        :cowboy_req.reply(502, [], reason, req)
    end
  end

  def terminate(_reason, _req, _state), do: :ok
end