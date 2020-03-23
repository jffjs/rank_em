defmodule RankEm.Repo.Migrations.CreateConferences do
  use Ecto.Migration

  def change do
    create table(:conferences) do
      add :name, :string
      add :other_names, {:array, :string}

      timestamps()
    end
  end
end
