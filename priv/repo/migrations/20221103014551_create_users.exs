defmodule ScrumPoker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uuid, :uuid
      add :email, :string
      add :display_name, :string
      add :avatar_url, :string
      add :github_token, :string
      add :deck_sequence, :string
      add :deck_color, :string

      timestamps()
    end

    create unique_index(:users, [:uuid])
  end
end
