defmodule MeerkatGatewayTest do
  use ExUnit.Case
  doctest Meerkat.Gateway

  @server URI.parse("http://localhost:8093")

  defp response_headers(res) do
    res
    |> Map.get(:headers)
    |> Enum.reduce(%{}, fn({key, value}, m) -> Map.put(m, key, value) end)
  end

  defp response_header(res, name) do
    res
    |> response_headers
    |> Map.get(name)
  end

  test "Static JSON response" do
    url = @server |> Map.put(:path, "/fixture/200.json") |> URI.to_string
    {:ok, res} = HTTPoison.get url
    assert res.status_code == 200
    assert {:ok, %{"ok" => true}} == Poison.Parser.parse(res.body)
    assert "application/json" == response_header(res, "content-type")
  end

  test "GET hello-world proxy returns JSON" do
    url = @server |> Map.put(:path, "/api/hello-world-proxy-v1.0") |> URI.to_string
    {:ok, res } = HTTPoison.get url
    assert res.status_code == 200
    assert {:ok, %{"ok" => true}} == Poison.Parser.parse(res.body)
    assert "application/json" == response_header(res, "content-type")
  end

end
