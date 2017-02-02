# Rate Limit Plug

[Elixir](http://elixir-lang.org/) [Plug](https://hexdocs.pm/plug/readme.html) giving requests per second rate limiting capability.

A resource can be protected by a pro-rata rate limit. For example a limit of 4 requests a second will allow a request every 250ms - you cannot use up all requests in the first few milliseconds of a period.

The response code when the limit is exceeded is [429 Too Many Requests](https://tools.ietf.org/html/rfc6585#section-4). This plug uses the [Token Bucket Algorithm](https://en.wikipedia.org/wiki/Token_bucket).

Master: [![Build Status](https://travis-ci.org/devstopfix/plug-ratelimit.svg?branch=master)](https://travis-ci.org/devstopfix/plug-ratelimit)


# Example

There is an example app in [example/demo.ex](example/demo.ex). To run:

```elixir
iex -S mix

c "example/demo.ex"
{:ok, _} = Plug.Adapters.Cowboy.http Demo, []
```

Then call enough times to exceed the 4 req/sec limit:

```bash
seq 5 | xargs -Iz curl -w " %{http_code}\n" http://localhost:4000/

  ok 200
  ok 200
  ok 200
  ok 200
  Too Many Requests 429
```

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

or run `curl` multiple times:

    seq 5 | xargs -Iz curl http://localhost:4000/
