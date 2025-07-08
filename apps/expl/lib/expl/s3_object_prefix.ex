defmodule Expl.S3ObjectPrefix do
  def from_datetime(datetime, opts \\ []) do
    datetime
    |> prefix_for_date()
    |> object_prefix(Keyword.get(opts, :object_prefix))
  end

  defp prefix_for_date(%DateTime{} = datetime) do
    # Python Format String
    # "{0}/{1:02d}/{2:02d}/{0:02d}-{1:02d}-{2:02d}T{3:02d}:{4:02d}"
    # --> yyyy/mm/dd/yyyy-mm-ddTHH:MM
    %DateTime{
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute
    } = datetime

    # The original format string doesn't format years "correctly",
    # but gets it right because years since unix epoch always have 4 digits
    year = format_integer(year, 4)
    month = format_integer(month, 2)
    day = format_integer(day, 2)
    hour = format_integer(hour, 2)
    minute = format_integer(minute, 2)

    "#{year}/#{month}/#{day}/#{year}-#{month}-#{day}T#{hour}:#{minute}"
  end

  defp format_integer(integer, leading_zeros),
    do:
      integer
      |> Integer.to_string()
      |> String.pad_leading(leading_zeros, "0")

  defp object_prefix(path, nil), do: path
  defp object_prefix(path, prefix) when is_binary(prefix), do: "#{prefix}/#{path}"
end
