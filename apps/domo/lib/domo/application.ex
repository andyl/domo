defmodule Domo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Domo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Domo.PubSub}
      # Start a worker by calling: Domo.Worker.start_link(arg)
      # {Domo.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Domo.Supervisor)
  end
end
