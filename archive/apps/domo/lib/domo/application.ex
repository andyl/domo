defmodule Domo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Domo.Repo,
      {Phoenix.PubSub, name: Domo.PubSub},
      Domo.Counter
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Domo.Supervisor)
  end
end
