defmodule RankEm.Scheduling.Recurrence do
  def check_recurrence(recurrence) when is_binary(recurrence) do
    case parse(recurrence) do
      :error -> false
      recurrence -> check_recurrence(recurrence)
    end
  end

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

  def check_recurrence(_), do: false

  @re ~r/^([Yy](\d+))?([Mm](\d+))?([Ww](\d+))?([Hh](\d+))?$/

  defp parse(recurrence_str) do
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
end
