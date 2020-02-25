defmodule RankEm.Scrapers.Kenpom do
  @url "https://kenpom.com/"

  def scrape() do
    %HTTPoison.Response{body: html, status_code: 200} = HTTPoison.get!(@url)
    document = Floki.parse_document!(html)
    rows = Floki.find(document, "table#ratings-table tbody tr")

    data =
      for row <- rows do
        parse_row(row)
      end

    Enum.filter(data, fn attr ->
      attr[:rank] && attr[:team]
    end)
  end

  defp parse_row(row) do
    %{}
    |> put_from_column(row, 1, :rank)
    |> put_from_column_with_link(row, 2, :team)
    |> put_from_column_with_link(row, 3, :conference)
    |> put_from_column(row, 4, :win_loss)
    |> put_from_column(row, 5, :adj_em)
    |> put_from_column(row, 6, :adj_o)
    |> put_from_column(row, 8, :adj_d)
    |> put_from_column(row, 10, :adj_t)
    |> put_from_column(row, 12, :luck)
    |> put_from_column(row, 14, :sos_adj_em)
    |> put_from_column(row, 16, :sos_opp_o)
    |> put_from_column(row, 18, :sos_opp_d)
    |> put_from_column(row, 20, :noncon_adj_em)
  end

  defp column(row, n) do
    Floki.find(row, "td:nth-child(#{n})") |> List.first()
  end

  defp link(column) do
    Floki.find(column, "a") |> List.first()
  end

  defp put_from_column(attrs, row, n, field) do
    case column(row, n) do
      {"td", _, [val | _]} -> Map.put(attrs, field, val)
      _ -> attrs
    end
  end

  defp put_from_column_with_link(attrs, row, n, field) do
    case link(column(row, n)) do
      {"a", _, [val | _]} -> Map.put(attrs, field, val)
      _ -> attrs
    end
  end
end
