defmodule Domo.Users.Period do
  use Ecto.Schema
  import Ecto.Changeset

  schema "periods" do
    field :end_at, :naive_datetime
    field :note, :string
    field :seconds, :integer
    field :start_at, :naive_datetime
    field :status, :string
    field :sequence, :integer
    field :tags, :string
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(period, attrs) do
    period
    |> cast(attrs, [:title, :sequence, :seconds, :start_at, :end_at, :status, :note, :tags])
    |> validate_required([:title, :sequence, :seconds, :start_at, :end_at, :status, :note, :tags])
  end
end
