defmodule RankEm.Scheduling.Recurrence do
  use Ecto.Type
  def type, do: :string

  def day_of_year({day, _, _, _}), do: day
  def day_of_month({_, day, _, _}), do: day
  def day_of_week({_, _, day, _}), do: day
  def hour_of_day({_, _, _, hour}), do: hour

  def check_recurrence({day_of_year, _, _, hour}) when not is_nil(day_of_year) do
    now = NaiveDateTime.utc_now()

    day_of_year == Calendar.ISO.day_of_year(now.year, now.month, now.day) &&
      (hour == now.hour || is_nil(hour))
  end

  def check_recurrence({_, day_of_month, _, hour}) when not is_nil(day_of_month) do
    now = NaiveDateTime.utc_now()
    day_of_month == now.day && (hour == now.hour || is_nil(hour))
  end

  def check_recurrence({_, _, day_of_week, hour}) when not is_nil(day_of_week) do
    now = NaiveDateTime.utc_now()

    day_of_week == Calendar.ISO.day_of_week(now.year, now.month, now.day) &&
      (hour == now.hour || is_nil(hour))
  end

  def cast(recurrence_str) when is_binary(recurrence_str) do
    with recurrence when is_tuple(recurrence) <- parse(recurrence_str) do
      {:ok, recurrence}
    end
  end

  def cast({_year, _month, _week, _hour} = recurrence) do
    {:ok, recurrence}
  end

  def cast(_), do: :error

  def load(data) do
    {:ok, parse(data)}
  end

  def dump({year, month, week, hour}) do
    str =
      ""
      |> append_part_to_string("Y", year)
      |> append_part_to_string("M", month)
      |> append_part_to_string("W", week)
      |> append_part_to_string("H", hour)

    case str do
      "" ->
        :error

      _ ->
        {:ok, str}
    end
  end

  def dump(_), do: :error

  @re ~r/^([Yy](\d+))?([Mm](\d+))?([Ww](\d+))?([Hh](\d+))?$/

  def parse(recurrence_str) do
    parts = Regex.run(@re, recurrence_str)

    if parts do
      {}
      |> Tuple.append(part_to_int(parts, 2))
      |> Tuple.append(part_to_int(parts, 4))
      |> Tuple.append(part_to_int(parts, 6))
      |> Tuple.append(part_to_int(parts, 8))
    else
      :error
    end
  end

  defp part_to_int(parts, skip) do
    part =
      parts
      |> Enum.drop(skip)
      |> List.first()

    case part do
      nil -> nil
      "" -> nil
      _ -> String.to_integer(part)
    end
  end

  defp append_part_to_string(string, label, value) do
    string <>
      if value do
        "#{label}#{value}"
      else
        ""
      end
  end
end
