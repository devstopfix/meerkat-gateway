defmodule PlugRateLimit.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_ratelimit,
     version: "0.19.233",
     elixir: "~> 1.6",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :cowboy, :plug, :stream_data]]
  end

  defp deps do
    [{:cowboy, "~> 1.0.4"},
     {:plug, "~> 1.0"},
     {:credo, "~> 1.1", only: [:dev, :test]},
     {:stream_data, "~> 0.4", only: [:dev, :test]}]
  end

end
