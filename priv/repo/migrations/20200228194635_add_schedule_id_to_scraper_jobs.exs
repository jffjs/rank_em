defmodule RankEm.Repo.Migrations.AddScheduleIdToScraperJobs do
  use Ecto.Migration

  def change do
    alter table(:scraper_jobs) do
      add :schedule_id, references(:scraper_schedules)
    end

    create index(:scraper_jobs, [:schedule_id])
  end
end
