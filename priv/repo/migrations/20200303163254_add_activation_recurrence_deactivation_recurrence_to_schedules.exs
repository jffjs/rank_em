defmodule RankEm.Repo.Migrations.AddActivationRecurrenceDeactivationRecurrenceToSchedules do
  use Ecto.Migration

  def change do
    alter table(:scraper_schedules) do
      add :activate_recurrence, :string
      add :deactivate_recurrence, :string
    end
  end
end
