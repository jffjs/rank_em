defmodule RankEmWeb.ViewHelpers do
  alias RankEm.Scrapers

  def scraper_options() do
    Enum.map(Scrapers.list_scrapers(), fn scraper ->
      {shorten_scraper_name(scraper), scraper}
    end)
  end

  def shorten_scraper_name(scraper) do
    String.replace(scraper, "Elixir.RankEm.Scrapers.", "")
  end
end
