defmodule RankEm.Scrapers.NCAAB.CoachesPoll do
  @behaviour RankEm.Scrapers.Scraper

  import RankEm.Scrapers.TableHelpers
  alias RankEm.Scrapers.NCAAB.Normalize
  alias RankEm.Rankings

  @url "https://www.usatoday.com/sports/ncaab/polls/coaches-poll/"

  @impl RankEm.Scrapers.Scraper
  def scrape() do
    with {:ok, %HTTPoison.Response{body: html, status_code: 200}} <- HTTPoison.get(@url),
         {:ok, document} <- Floki.parse_document(html),
         rows when rows != [] <- Floki.find(document, "table tr") do
      list_of_attrs =
        rows
        |> Enum.map(&parse_row/1)
        |> Enum.filter(&valid_attrs?/1)
        |> Enum.map(&convert_attrs/1)
        |> Enum.map(&normalize/1)

      {:ok, lookup_conferences(list_of_attrs)}
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
    |> put_team(row)
    |> put_from_column(row, 3, :win_loss)
    |> put_from_column(row, 4, "points")
    |> put_from_column_with_link(row, 3, :team)
  end

  defp put_team(attrs, row) do
    case row |> column(2) |> Floki.find(".gnt_sp_t_nm") |> List.first() do
      {_, _, [val | _]} -> Map.put(attrs, :team, val)
      _ -> attrs
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
    |> Map.put(:index, "coaches_poll")
    |> Map.put(:league, "ncaab")
  end

  defp normalize(attrs) do
    %{
      attrs
      | team: Normalize.team(attrs[:team])
    }
  end

  defp lookup_conferences(list_of_attrs) do
    team_conf_map =
      Enum.map(list_of_attrs, & &1[:team])
      |> Rankings.team_conferences("ncaab")
      |> Map.new()

    Enum.map(list_of_attrs, fn attr ->
      Map.put(attr, :conference, team_conf_map[attr[:team]])
    end)
  end
end
