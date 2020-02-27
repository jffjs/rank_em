defmodule RankEm.Scrapers.NCAAB.Torvik do
  @behaviour RankEm.Scrapers.Scraper

  import RankEm.Scrapers.TableHelpers

  @url "http://www.barttorvik.com/"

  @impl RankEm.Scrapers.Scraper
  def scrape() do
    with {:ok, %HTTPoison.Response{body: html}} <- HTTPoison.get(@url),
         {:ok, document} <- Floki.parse_document(html),
         rows when rows != [] <- Floki.find(document, "table tbody tr") do
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

  @stats ~w(G ADJOE ADJDE BARTHAG EFG% EFGD% TOR TORD ORB DRB FTR FTRD 2P% 2P%D 3P% 3P%D ADJT WAB)

  defp parse_row(row) do
    %{}
    |> put_from_column(row, 1, :rank)
    |> put_from_column_with_link(row, 2, :team)
    |> put_from_column_with_link(row, 3, :conference)
    |> put_from_column(row, 4, "G")
    |> put_from_column_with_link(row, 5, :win_loss)
    |> put_from_column(row, 6, "ADJOE")
    |> put_from_column(row, 7, "ADJDE")
    |> put_from_column(row, 8, "BARTHAG")
    |> put_from_column(row, 9, "EFG%")
    |> put_from_column(row, 10, "EFGD%")
    |> put_from_column(row, 11, "TOR")
    |> put_from_column(row, 12, "TORD")
    |> put_from_column(row, 13, "ORB")
    |> put_from_column(row, 14, "DRB")
    |> put_from_column(row, 15, "FTR")
    |> put_from_column(row, 16, "FTRD")
    |> put_from_column(row, 17, "2P%")
    |> put_from_column(row, 18, "2P%D")
    |> put_from_column(row, 19, "3P%")
    |> put_from_column(row, 20, "3P%D")
    |> put_from_column(row, 21, "ADJT")
    |> put_from_column(row, 22, "WAB")
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
    |> Map.put(:index, "torvik")
    |> Map.put(:league, "ncaab")
  end
end
