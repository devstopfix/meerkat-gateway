# Rate Limit Plug

[Plug](https://hexdocs.pm/plug/readme.html) giving requests per second rate limiting.

A resource can be protected by a pro-rata rate limit. For example a limit of 4 requests a second will allow a request every 250ms - you cannot use up all requests in the first few milliseconds of a period.

The response code returned when the limit is exceeded is [429 Too Many Requests](https://tools.ietf.org/html/rfc6585#section-4)

Master: [![Build Status](https://travis-ci.org/devstopfix/plug-ratelimit.svg?branch=master)](https://travis-ci.org/devstopfix/plug-ratelimit)

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

    ab -n 4 http://127.0.0.1:4000/
