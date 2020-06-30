defmodule Catlixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :catlixir,
      version: "0.1.9",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Catlixir.Application, []},
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:nostrum, "~> 0.4"},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"},
      {:discord_bot_list, "~> 0.1"},
      {:quantum, "~> 3.0-rc"}
    ]
  end
end
