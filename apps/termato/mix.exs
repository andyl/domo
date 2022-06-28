defmodule Termato.MixProject do
  use Mix.Project

  def project do
    [
      app: :termato,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Termato.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.5"},
      {:websockex, "~> 0.4"},
      {:plug_socket, "~> 0.1.0"},
      {:httpoison, "~> 1.8"},
      {:csv, "~> 2.4"},
      {:tzdata, "~> 1.1"},
    ]
  end
end
