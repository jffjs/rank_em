defmodule RankEm.Scrapers.NCAAF.FPI do
  @behaviour RankEm.Scrapers.Scraper

  import RankEm.Scrapers.TableHelpers

  @url "http://www.espn.com/college-football/statistics/teamratings/_/year/2019/key/20191215040000"

  @impl RankEm.Scrapers.Scraper
  def scrape() do
    with {:ok, %HTTPoison.Response{body: html, status_code: 200}} <- HTTPoison.get(@url),
         {:ok, document} <- Floki.parse_document(html),
         rows when rows != [] <- Floki.find(document, "tr[class*='team']") do
      {:ok,
       rows
       |> Enum.map(&parse_row/1)
       |> Enum.filter(&valid_attrs?/1)
       |> Enum.map(&convert_attrs/1)}
    else
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "#{@url} returned status code #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, Atom.to_string(reason)}

      {:error, message} ->
        {:error, message}

      [] ->
        {:error, "No results"}
    end
  end

  defp parse_row(row) do
    %{}
    |> put_from_column(row, 1, :rank)
    |> put_from_column_with_link(row, 2, :team)
    |> put_conference(row)
    |> put_from_column(row, 3, :win_loss)
    |> put_from_column(row, 4, "PROJ W-L")
    |> put_from_column(row, 5, "WIN OUT%")
    |> put_from_column(row, 6, "CONF WIN%")
    |> put_from_column(row, 7, "REM SOS RK")
    |> put_from_column(row, 8, "FPI")
  end

  defp put_conference(attrs, row) do
    case column(row, 2) do
      {"td", _, [_, val | _]} -> Map.put(attrs, :conference, val)
      _ -> attrs
    end
  end

  defp valid_attrs?(attrs), do: attrs[:rank] && attrs[:team]

  @stats ["PROJ W-L", "WIN OUT%", "CONF WIN%", "REM SOS RK", "FPI"]
  defp convert_attrs(attrs) do
    [wins, losses] = String.split(attrs[:win_loss], "-")
    stats = Map.take(attrs, @stats)
    conference = attrs[:conference] |> String.replace(",", "") |> String.trim()

    attrs
    |> Map.take([:rank, :team, :conference])
    |> Map.put(:conference, conference)
    |> Map.put(:stats, stats)
    |> Map.put(:wins, wins)
    |> Map.put(:losses, losses)
    |> Map.put(:index, "fpi")
    |> Map.put(:league, "ncaaf")
  end
end
