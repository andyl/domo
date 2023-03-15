defmodule Domo.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    # ----- users

    create table(:users) do
      add :uname, :citext, null: false
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create unique_index(:users, [:uname])
    create unique_index(:users, [:email])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])

    # ----- intervals

    create table(:intervals) do
      add :position, :integer
      add :seconds, :integer
      add :name, :string
      add :desc, :string
      add :hotkey, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:intervals, [:user_id])

    # ----- periods

    create table(:periods) do
      add :title, :string
      add :seconds, :integer
      add :sequence, :integer
      add :start_at, :utc_datetime
      add :end_at, :utc_datetime
      add :status, :string
      add :notes, :string
      add :tags, :string
      add :projects, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:periods, [:user_id])

  end
end
