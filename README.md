# Rate Limit Plug

[Elixir](http://elixir-lang.org/) [Plug](https://hexdocs.pm/plug/readme.html) giving requests per second rate limiting capability.

A resource can be protected by a pro-rata rate limit. For example a limit of 4 requests a second will allow a request every 250ms - you cannot use up all requests in the first few milliseconds of a period.

The response code when the limit is exceeded is [429 Too Many Requests](https://tools.ietf.org/html/rfc6585#section-4). This plug uses the [Token Bucket Algorithm](https://en.wikipedia.org/wiki/Token_bucket).

[![Build Status](https://github.com/devstopfix/plug-ratelimit/workflows/ci/badge.svg)](https://github.com/devstopfix/plug-ratelimit/actions)
[![Hex.pm](https://img.shields.io/hexpm/v/plug_ratelimit.svg?style=flat-square)](https://hex.pm/packages/plug_ratelimit)


## Example

There is an example app in [example/demo.exs](example/demo.exs). To run:

```bash
mix run --no-halt example/demo.exs
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

### Dev

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


## Credits

* This library uses a Stern-Brocot tree to find a good ratio of the number of tokens to add to the bucket at a given interval - this ratio is a variation of the algorithm described in [John D. Cook's Best rational approximation](https://www.johndcook.com/blog/2010/10/20/best-rational-approximation/)
