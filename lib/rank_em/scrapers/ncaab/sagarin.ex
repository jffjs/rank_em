defmodule RankEm.Scrapers.NCAAB.Sagarin do
  alias RankEm.Scrapers.NCAAB.Normalize

  @re ~r/(?<rank>\d{1,3})\s+(?<team>['&a-zA-Z\s\.\-\(\)]+)\s*=\s+(?<RATING>\d+\.\d+)\s+(?<wins>\d+)\s+(?<losses>\d+)\s+(?<SCHEDL>\d+\.\d+)\s*\(.*\)\s+\d+\s+\d+\s+\|\s+\d+\s+\d+\s+\|\s+(?<PREDICTOR>\d+\.\d+)\s+\d+\s+\|\s+(?<GOLDEN_MEAN>\d+\.\d+)\s+\d+\s+\|\s+(?<RECENT>\d+\.\d+)\s+\d+\s+(?<conference>[\w\-\s]+)/
  @url "http://sagarin.com/sports/cbsend.htm"

  def scrape() do
    with {:ok, %HTTPoison.Response{body: html}} <- HTTPoison.get(@url),
         {:ok, document} <- Floki.parse_document(html) do
      text = Floki.text(document)

      results =
        String.split(text, "\r\n")
        |> Enum.map(&Regex.named_captures(@re, &1))
        |> Enum.filter(& &1)
        |> Enum.take(353)
        |> Enum.map(&convert_attrs/1)
        |> Enum.map(&normalize/1)

      {:ok, results}
    end
  end

  @stats ~w(GOLDEN_MEAN PREDICTOR RATING RECENT SCHEDL)

  defp convert_attrs(attrs) do
    stats = Map.take(attrs, @stats)

    %{}
    |> Map.put(:rank, attrs["rank"])
    |> Map.put(:team, String.trim(attrs["team"]))
    |> Map.put(:conference, String.trim(attrs["conference"]))
    |> Map.put(:wins, attrs["wins"])
    |> Map.put(:losses, attrs["losses"])
    |> Map.put(:stats, stats)
    |> Map.put(:index, "sagarin")
    |> Map.put(:league, "ncaab")
  end

  defp normalize(attrs) do
    %{
      attrs
      | team: Normalize.team(attrs[:team]),
        conference: Normalize.conference(attrs[:conference])
    }
  end
end
