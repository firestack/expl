defmodule Expl do
  @moduledoc """
  Expl keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_archive(options) do
    objects =
      options
      |> build_query()
      |> find_objects()

    # |> filter_objects(options)
  end

  defp build_query(options) do
    %{
      environment: nil,
      datetime: nil,
      output: nil,
      feed: nil
    }
    |> Map.merge(options)
  end

  defp find_objects(options) do
    options
    |> bucket()
    |> ExAws.S3.list_objects_v2(list_objects_params(options))
    # |> ExAws.request!()
    |> ExAws.stream!()
    |> Stream.map(&Map.merge(&1, process_object(&1)))
  end

  defp bucket(%{environment: :prod}), do: "mbta-gtfs-s3"
  defp bucket(%{environment: :dev_blue}), do: "mbta-gtfs-s3-dev-blue"

  defp list_objects_params(%{datetime: %DateTime{} = datetime}),
    do: [prefix: Expl.S3ObjectPrefix.from_datetime(datetime)] ++ list_objects_params()

  defp list_objects_params(), do: []

  defp process_object(%{
         key: key,
         e_tag: e_tag,
         last_modified: last_modified,
         storage_class: storage_class
       }) do
    %{
      # todo: __struct__: Expl.Db.S3
      key: key,
      e_tag: e_tag,
      key_modified_at:
        (
          {:ok, datetime, _} = DateTime.from_iso8601(last_modified)
          datetime
        ),
      storage_class: storage_class,

      # processed key
      # environment_id:
      # environment:

      feed: Expl.Feeds.feed_from_key(key)
      # producer: producer(key, options)
    }
  end

  defp filter_objects(objects, _options) do
    %{body: %{contents: contents}} = objects
    contents
  end
end
