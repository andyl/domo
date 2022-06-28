defmodule Domo.Users.Period do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  schema "periods" do
    field :end_at, :utc_datetime
    field :headline, :string
    field :notes, :string
    field :seconds, :integer
    field :start_at, :utc_datetime
    field :status, :string
    field :sequence, :integer
    field :tags, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(period, attrs) do
    period
    |> cast(attrs, [:headline, :sequence, :seconds, :start_at, :end_at, :status, :notes, :tags])
    |> validate_required([:sequence, :seconds, :start_at, :end_at, :status])
  end
end
