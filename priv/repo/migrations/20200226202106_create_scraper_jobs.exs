defmodule RankEm.Repo.Migrations.CreateScraperJobs do
  use Ecto.Migration

  def change do
    create table(:scraper_jobs) do
      add :scraper, :string
      add :start_ts, :naive_datetime
      add :end_ts, :naive_datetime
      add :status, :string
      add :failure_msg, :string

      timestamps()
    end
  end
end
