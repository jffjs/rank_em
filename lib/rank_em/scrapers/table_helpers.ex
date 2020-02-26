defmodule RankEm.Scrapers.TableHelpers do
  def column(row, n) do
    Floki.find(row, "td:nth-child(#{n})") |> List.first()
  end

  def link(column) do
    Floki.find(column, "a") |> List.first()
  end

  def put_from_column(attrs, row, n, field) do
    case column(row, n) do
      {"td", _, [val | _]} -> Map.put(attrs, field, val)
      _ -> attrs
    end
  end

  def put_from_column_with_link(attrs, row, n, field) do
    case link(column(row, n)) do
      {"a", _, [val | _]} -> Map.put(attrs, field, val)
      _ -> attrs
    end
  end
end
