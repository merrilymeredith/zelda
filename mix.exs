defmodule Zelda.Mixfile do
  use Mix.Project

  def project do
    [app: :zelda,
     version: "0.0.3",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod:          {Zelda, []},
      applications: [
        :logger,
        :httpoison, :slacker,
        :sqlitex, :esqlite,
        :sqlite_ecto, :ecto,
        :inflex, :eex,
        :websocket_client
      ]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:slacker, "~> 0.0.1"},
      {:websocket_client, github: "jeremyong/websocket_client"},
      {:sqlite_ecto, "~> 1.1.0"},
      {:exrm, "~> 1.0.0-rc7"},
      {:credo, "~> 0.2.5", only: :dev}
    ]
  end
end
