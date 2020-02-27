defmodule RankEm.Scrapers.Scraper do
  @callback scrape() :: {:ok, [map]} | {:error, String.t()}

  @spec scrape(atom) :: {:ok, [map]} | {:error, String.t()}
  def scrape(implementation) do
    implementation.scrape()
  end
end
