defmodule Meerkat.Gateway.RequestHandler do

  @moduledoc """
  Process to handle a single HTTP request.
  """

  def init(_transport, req, []) do
    {:ok, req, nil}
  end

  @doc """
  Handle a HTTP request. New process is spawned for each request.
  """

  def handle(req, state) do
    self |> inspect |> IO.puts
    {:ok, req} = proxy_request(req)
    {:ok, req, state}
  end

  @doc """
  Call the downstream API
  """

  def proxy_request(req) do
    # TODO timeout
    case HTTPoison.get("http://localhost:8093/fixture/200.json") do
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