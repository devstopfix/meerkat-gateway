defmodule MeerkatGateway.Mixfile do
  use Mix.Project

  def project do
    [app: :meerkat_gateway,
     version: "0.2.2",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [mod: { Meerkat.Server, []},
     applications: [:cowboy,
                    :logger,
                    :httpoison]]
  end

  defp deps do
    [{:cowboy, "~> 1.0.4"},
     {:httpoison, "~> 0.10.0"},
     {:poison, "~> 3.0"},
     {:credo, "~> 0.5", only: [:dev, :test]},
     {:mix_test_watch, "~> 0.2", only: :dev},
     {:excheck, "~> 0.5", only: :test},
     {:triq, github: "triqng/triq", only: :test}]
  end

end
