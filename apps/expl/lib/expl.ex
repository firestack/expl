defmodule Expl do
  @moduledoc """
  Expl keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_archive(options) do
    options
    |> build_query()
    |> Expl.S3.list_objects!()
    |> Stream.map(&process_object(&1))
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

  defp process_object(%{
         key: key,
         e_tag: e_tag,
         last_modified: last_modified,
         storage_class: storage_class,
         bucket: bucket,
         environment: environment
       }) do
    %Expl.Db.S3Object{}
    |> Expl.Db.S3Object.changeset(%{
      bucket_name: bucket,
      object_key: key,
      object_etag: e_tag,
      object_modified_at: last_modified,
      object_storage_class: storage_class,

      # processed key
      # environment_id:
      environment: to_string(environment),
      # source: "concentrate",
      # source: "delta",

      feed: Expl.Feeds.feed_from_key(key),
      key_date: date_from_key(key),
      data_type: type_from_key(key)
      # producer: producer(key, options)
    })
  end

  defp type_from_key(key) do
    cond do
      String.ends_with?(key, ".json") or String.ends_with?(key, ".json.gz") ->
        :json

      true ->
        :pb
    end
    # temp: schema should be able to handle atoms
    |> to_string()
  end

  defp date_from_key(_key), do: nil
end
