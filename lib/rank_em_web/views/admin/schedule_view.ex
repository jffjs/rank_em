defmodule RankEmWeb.Admin.ScheduleView do
  use RankEmWeb, :view

  alias RankEm.Scheduling.{Recurrence, Schedule}
  alias RankEm.Scrapers

  def scraper_options() do
    Enum.map(Scrapers.list_scrapers(), fn scraper ->
      {shorten_scraper_name(scraper), scraper}
    end)
  end

  def schedule_statuses() do
    Enum.map(Schedule.statuses(), fn status ->
      {String.capitalize(status), status}
    end)
  end

  def shorten_scraper_name(scraper) do
    String.replace(scraper, "Elixir.RankEm.Scrapers.", "")
  end

  def recurrence_string(recurrence) do
    Recurrence.to_string(recurrence)
  end
end
