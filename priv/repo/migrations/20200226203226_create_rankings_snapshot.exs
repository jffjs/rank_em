defmodule RankEm.Repo.Migrations.CreateRankingsSnapshot do
  use Ecto.Migration

  def change do
    create table(:rankings_snapshots) do
      add :index, :string
      add :rank, :integer
      add :team, :string
      add :conference, :string
      add :wins, :integer
      add :losses, :integer
      add :stats, :map
      add :snapshot_ts, :naive_datetime
      add :league, :string
      add :job_id, references(:scraper_jobs)

      timestamps()
    end
  end
end
