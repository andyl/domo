defmodule Domo.Repo do
  use Ecto.Repo,
    otp_app: :domo,
    adapter: Ecto.Adapters.Postgres
end
