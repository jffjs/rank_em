defmodule RankEm.Scrapers.NCAAB.Kenpom do
  import RankEm.Scrapers.TableHelpers

  @url "https://kenpom.com/"

  @spec scrape() :: list(map()) | {:error, any()}
  def scrape() do
    with {:ok, %HTTPoison.Response{body: html}} <- HTTPoison.get(@url),
         {:ok, document} <- Floki.parse_document(html) do
      rows = Floki.find(document, "table#ratings-table tbody tr")

      rows
      |> Enum.map(&parse_row/1)
      |> Enum.filter(&valid_attrs?/1)
      |> Enum.map(&convert_attrs/1)
    end
  end

  @stats ~w(AdjEM AdjO AdjD AdjT Luck SOSAdjEM SOSOppO SOSOppD NCSOSAdjEM)

  defp parse_row(row) do
    %{}
    |> put_from_column(row, 1, :rank)
    |> put_from_column_with_link(row, 2, :team)
    |> put_from_column_with_link(row, 3, :conference)
    |> put_from_column(row, 4, :win_loss)
    |> put_from_column(row, 5, "AdjEM")
    |> put_from_column(row, 6, "AdjO")
    |> put_from_column(row, 8, "AdjD")
    |> put_from_column(row, 10, "AdjT")
    |> put_from_column(row, 12, "Luck")
    |> put_from_column(row, 14, "SOSAdjEM")
    |> put_from_column(row, 16, "SOSOppO")
    |> put_from_column(row, 18, "SOSOppD")
    |> put_from_column(row, 20, "NCSOSAdjEM")
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
    |> Map.put(:index, "kenpom")
    |> Map.put(:league, "ncaab")
  end
end
