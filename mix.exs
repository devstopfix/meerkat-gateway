defmodule PlugRateLimit.Mixfile do
  use Mix.Project

  def project do
    [
      app: :plug_ratelimit,
      version: "0.21.37",
      elixir: "~> 1.10",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [applications: [:logger, :cowboy, :plug, :stream_data]]
  end

  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.11"},
      {:credo, "~> 1.5", only: [:dev, :test]},
      {:stream_data, "~> 0.5", only: [:dev, :test]}
    ]
  end
end
