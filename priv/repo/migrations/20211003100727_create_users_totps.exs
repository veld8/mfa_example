defmodule MfaExample.Repo.Migrations.CreateUsersTotps do
  use Ecto.Migration

  def change do
    create table(:users_totps, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :secret, :binary
      add :backup_codes, :map
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:users_totps, [:user_id])
  end
end
