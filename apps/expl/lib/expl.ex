defmodule Expl do
  @moduledoc """
  Expl keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_archive(options) do
    archive_query = build_query(options)

    objects =
      archive_query
      |> find_objects()
      |> filter_objects(options)


  end

  defp build_query(_options) do
    %{
      datetime: nil,
      output: nil,
      feed: nil
    }
  end

  defp find_objects(_query) do
    []
  end

  defp filter_objects(_objects, _options) do
    []
  end
end
