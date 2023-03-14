defmodule Domo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DomoWeb.Telemetry,
      Domo.Repo,
      {Phoenix.PubSub, name: Domo.PubSub},
      {Finch, name: Domo.Finch},
      DomoWeb.Endpoint,
      Domo.Counter
    ]

    opts = [strategy: :one_for_one, name: Domo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    DomoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
