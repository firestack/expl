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
    bucket =
      options
      |> bucket()

    bucket
    |> ExAws.S3.list_objects_v2(list_objects_params(options))
    |> ExAws.stream!()
    |> Stream.map(&Map.merge(&1, process_object(&1, bucket, options.environment |> to_string)))
  end

  defp bucket(%{environment: :prod}), do: "mbta-gtfs-s3"
  defp bucket(%{environment: :dev_blue}), do: "mbta-gtfs-s3-dev-blue"

  defp list_objects_params(%{datetime: %DateTime{} = datetime}),
    do: [prefix: Expl.S3ObjectPrefix.from_datetime(datetime)] ++ list_objects_params()

  defp list_objects_params(), do: []

  defp process_object(
         %{
           key: key,
           e_tag: e_tag,
           last_modified: last_modified,
           storage_class: storage_class
         },
         bucket,
         environment
       ) do
    %Expl.Db.S3Object{}
    |> Expl.Db.S3Object.changeset(%{
      bucket_name: bucket,
      object_key: key,
      object_etag: e_tag,
      object_modified_at: last_modified,
      object_storage_class: storage_class,

      # processed key
      # environment_id:
      environment: environment,
      # source: "concentrate",
      # source: "delta",

      feed: Expl.Feeds.feed_from_key(key),
      data_type: type_from_key(key)
      # producer: producer(key, options)
    })
  end

  defp type_from_key(key) do
    cond do
      String.ends_with?(key, ".json") or String.ends_with?(key, ".json.gz") -> dbg(key); :json
      true -> :pb
    end
    # tmp
    |> to_string()
  end
end
