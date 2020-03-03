defmodule RankEm.Scrapers.NCAAB.ApPoll do
  @behaviour RankEm.Scrapers.Scraper

  import RankEm.Scrapers.TableHelpers
  alias RankEm.Scrapers.NCAAB.Normalize

  @url "https://apnews.com/APTop25CollegeBasketballPoll"

  @impl RankEm.Scrapers.Scraper
  def scrape() do
    with {:ok, %HTTPoison.Response{body: html, status_code: 200}} <- HTTPoison.get(@url),
         {:ok, document} <- Floki.parse_document(html),
         rows when rows != [] <- Floki.find(document, "table tbody tr") do
      {
        :ok,
        rows
        |> Enum.map(&parse_row/1)
        |> Enum.filter(&valid_attrs?/1)
        |> Enum.map(&convert_attrs/1)
        |> Enum.map(&normalize/1)
      }
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

  @stats ~w(points)

  defp parse_row(row) do
    %{}
    |> put_from_column(row, 1, :rank)
    |> put_from_column_with_link(row, 3, :team)
    |> put_win_loss(row)
    |> put_from_column(row, 5, :conference)
    |> put_from_column(row, 6, "points")
  end

  defp put_win_loss(attrs, row) do
    case row |> column(3) |> Floki.find("span[class^='record']") |> List.first() do
      {"span", _, children} ->
        Map.put(
          attrs,
          :win_loss,
          children
          |> Enum.filter(&is_binary/1)
          |> Enum.join()
          |> String.trim()
          |> String.replace(~r/[\(\)]/, "")
        )

      _ ->
        attrs
    end
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
    |> Map.put(:index, "ap_poll")
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
