defmodule Domo.Users.Interval do
  use Ecto.Schema
  import Ecto.Changeset

  schema "intervals" do
    field :desc, :string
    field :hotkey, :string
    field :name, :string
    field :position, :integer
    field :seconds, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(interval, attrs) do
    interval
    |> cast(attrs, [:position, :seconds, :name, :desc, :hotkey])
    |> validate_required([:position, :seconds, :name, :desc, :hotkey])
  end
end
