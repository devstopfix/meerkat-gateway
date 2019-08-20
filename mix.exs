defmodule PlugRateLimit.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_ratelimit,
     version: "0.19.232",
     elixir: "~> 1.6",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:sasl, :logger, :cowboy, :plug]]
  end

  defp deps do
    [{:cowboy, "~> 1.0.4"},
     {:plug, "~> 1.0"},
     {:credo, "~> 1.1", only: [:dev, :test]},
     {:mix_test_watch, "~> 0.2", only: :dev},
     {:excheck, git: "https://github.com/devstopfix/excheck.git", tag: "0.7.6", only: :test},
     {:triq, "~> 1.3", only: [:dev, :test]}]
  end

end
