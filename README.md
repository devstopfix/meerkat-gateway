# Rate Limiting Plug

[Plug](https://hexdocs.pm/plug/readme.html) giving requests per second rate limiting.

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


# Dev

Start REPL:

    iex -S mix


Load plug:

```elixir
c "lib/plug/ratelimit.ex"
{:ok, _} = Plug.Adapters.Cowboy.http Plug.Ratelimit, []

```

Exercise:

    curl http://localhost:4000/

