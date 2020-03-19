defmodule RankEm.Scrapers.NCAAB.Massey do
  @behaviour RankEm.Scrapers.Scraper

  alias RankEm.Scrapers.NCAAB.Normalize

  @url "https://www.masseyratings.com/ratejson.php?s=309912&sub=11590"

  @impl RankEm.Scrapers.Scraper
  def scrape() do
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(@url),
         {:ok, json} <- Jason.decode(body),
         rows when rows != [] and not is_nil(rows) <- json["DI"] do
      {:ok,
       rows
       |> Enum.map(&parse_row/1)
       |> Enum.filter(&valid_attrs?/1)
       |> Enum.map(&convert_attrs/1)
       |> Enum.map(&normalize/1)}
    else
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "#{@url} returned status code #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, Atom.to_string(reason)}

      {:error, message} ->
        {:error, message}

      [] ->
        {:error, "No results"}

      nil ->
        {:error, "No results"}
    end
  end

  @stats ~w(RAT PWR OFF DEF HFA SoS SSF EW EL)

  defp parse_row(row) do
    %{}
    |> Map.put(:team, list_value(row, 0))
    |> Map.put(:conference, list_value(row, 1))
    |> Map.put(:win_loss, value(row, 2))
    |> Map.put(:rank, value(row, 5))
    |> Map.put("RAT", value(row, 6))
    |> Map.put("PWR", value(row, 8))
    |> Map.put("OFF", value(row, 10))
    |> Map.put("DEF", value(row, 12))
    |> Map.put("HFA", value(row, 13))
    |> Map.put("SoS", value(row, 15))
    |> Map.put("SSF", value(row, 17))
    |> Map.put("EW", value(row, 18))
    |> Map.put("EL", value(row, 19))
  end

  defp value(row, idx) do
    row |> Enum.drop(idx) |> List.first()
  end

  defp list_value(row, idx) do
    row
    |> Enum.drop(idx)
    |> List.first()
    |> List.first()
  end

  defp valid_attrs?(attrs), do: attrs[:rank] && attrs[:team]

  defp convert_attrs(attrs) do
    [wins, losses] = String.split(attrs[:win_loss], "-")
    stats = Map.take(attrs, @stats)

    attrs
    |> Map.take([:rank, :team, :conference])
    |> Map.put(:stats, stats)
    |> Map.put(:wins, wins)
    |> Map.put(:losses, losses)
    |> Map.put(:index, "massey")
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
