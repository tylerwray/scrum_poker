defmodule ScrumPoker.Repo.Migrations.AddColorScheme do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :color_scheme, :string
    end
  end
end
