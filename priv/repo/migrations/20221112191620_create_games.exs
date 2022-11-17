defmodule ScrumPoker.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE deck_sequence AS ENUM ('fibonacci', 'linear', 'tshirt')"
    drop_query = "DROP TYPE IF EXISTS deck_sequence"

    execute(create_query, drop_query)

    create table(:games) do
      add :created_by, references("users", column: :uuid, type: :uuid), null: false
      add :deck_sequence, :deck_sequence, null: false
      add :description, :string
      add :join_code, :string, null: false

      timestamps()
    end
  end
end
