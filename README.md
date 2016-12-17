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

