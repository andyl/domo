defmodule Domo.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      deps: deps(),
      aliases: aliases()
    ]
  end

  def releases do
    [
      domo: [
        applications: [
          domo: :permanent,
          domo_web: :permanent,
          termato: :permanent
        ]
      ]
    ]
  end

  defp deps do
    []
  end

  defp aliases do
    [
      setup: ["ecto.drop", "ecto.create", "ecto.migrate", "run apps/domo/priv/repo/seeds.exs"]
    ]
  end
end
