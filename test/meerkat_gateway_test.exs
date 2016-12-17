defmodule MeerkatGatewayTest do
  use ExUnit.Case
  doctest Meerkat.Gateway

  @server URI.parse("http://localhost:8093")

  test "hello world" do
    {:ok, res } = @server |> URI.to_string |> HTTPoison.get
    assert res.status_code == 200
    assert res.body == "Hello world!"
  end

  test "Static JSON response" do
    url = @server |> Map.put(:path, "/fixture/200.json") |> URI.to_string
    {:ok, res} = HTTPoison.get url
    assert res.status_code == 200
    assert {:ok, %{"ok" => true}} == Poison.Parser.parse(res.body)
  end

end
