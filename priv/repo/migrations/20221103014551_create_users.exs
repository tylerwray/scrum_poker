defmodule ScrumPoker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uuid, :uuid, null: false
      add :avatar_url, :string
      add :deck_color, :string
      add :display_name, :string
      add :email, :string
      add :github_token, :string

      timestamps()
    end

    create unique_index(:users, [:uuid])
  end
end
