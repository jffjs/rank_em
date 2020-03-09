defmodule RankEmWeb.Admin.ScheduleView do
  use RankEmWeb, :view

  alias RankEm.Scheduling.Schedule

  def schedule_statuses() do
    Enum.map(Schedule.statuses(), fn status ->
      {String.capitalize(status), status}
    end)
  end
end
