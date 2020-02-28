defmodule RankEm.Repo.Migrations.CreateScraperSchedules do
  use Ecto.Migration

  def change do
    create table(:scraper_schedules) do
      add :scraper, :string
      add :interval_seconds, :integer
      add :status, :string

      timestamps()
    end

  end
end
