# Meerkat Gateway

Simple API Gateway. 

Features to be implemented:

* per-second rate limiting
* mandatory HTTP headers
* forbidden HTTP headers
* JSON threat protection
* XML threat protection

## Installation

Master: [![Build Status](https://travis-ci.org/devstopfix/meerkat-gateway.svg?branch=master)](https://travis-ci.org/devstopfix/meerkat-gateway)

# Run

To test a simple HTTP GET returning *hello world*:

    $ mix run --no-halt
    $ curl -i http://localhost:8093/api/mobile
    >
    HTTP/1.1 200 OK
    server: Cowboy
    content-length: 12

To run a simple load test:

    ab -n 100 -k http://localhost:8093/api/mobile

or run `curl` multiple times:

    seq 3 | xargs -Iz curl http://localhost:8093/api/mobile

### Hex (not yet available)

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `meerkat_gateway` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:meerkat_gateway, "~> 0.1.0"}]
    end
    ```

  2. Ensure `meerkat_gateway` is started before your application:

    ```elixir
    def application do
      [applications: [:meerkat_gateway]]
    end
    ```

