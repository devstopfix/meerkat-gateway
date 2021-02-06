defmodule PlugRateLimit.Mixfile do
  use Mix.Project

  def project do
    [
      app: :plug_ratelimit,
      version: "0.21.39",
      description: "Plug with request/second rate limiting",
      elixir: "~> 1.10",
      deps: deps(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod
    ]
  end

  def application do
    [applications: [:logger, :cowboy, :plug, :stream_data]]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:credo, "~> 1.5", only: [:dev, :test]},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:stream_data, "~> 0.5", only: [:dev, :test]}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["J Every"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/devstopfix/plug-ratelimit"
      }
    ]
  end
end
