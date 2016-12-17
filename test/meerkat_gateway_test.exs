defmodule MeerkatGatewayTest do
  use ExUnit.Case
  doctest Meerkat.Gateway

  test "hello world" do
    res = HTTPoison.get! "http://localhost:8093"
    assert res.status_code == 200
    assert res.body == "Hello world!"
  end

end
