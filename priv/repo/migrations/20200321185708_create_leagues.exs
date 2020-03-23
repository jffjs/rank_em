defmodule RankEm.Repo.Migrations.CreateLeagues do
  use Ecto.Migration

  def change do
    create table(:leagues) do
      add :name, :string
      add :long_name, :string
      add :sport, :string

      timestamps()
    end

  end
end
