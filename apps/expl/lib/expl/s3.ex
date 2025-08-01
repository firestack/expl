defmodule Expl.S3 do
  @moduledoc nil

  def get_object(%Expl.Db.S3Object{} = resource, opts \\ []) do
    ExAws.request(do_get_object(resource, opts))
  end

  def get_object!(%Expl.Db.S3Object{} = resource, opts \\ []) do
    ExAws.request!(do_get_object(resource, opts))
  end

  defp do_get_object(%Expl.Db.S3Object{} = resource, opts) do
    ExAws.S3.download_file(
      resource.bucket,
      resource.object_key,
      Keyword.get(opts, :output, :memory)
    )
  end

  def list_objects!(options) do
    bucket = bucket(options)
    list_objects_v2_opts = opts(options)

    ExAws.S3.list_objects_v2(bucket, list_objects_v2_opts)
    |> ExAws.stream!()
    |> Stream.map(&Map.merge(&1, %{bucket: bucket, environment: options.environment}))
  end

  defp bucket(%{environment: environment}), do: bucket(environment)

  defp bucket(:prod), do: "mbta-gtfs-s3"
  defp bucket(:dev_blue), do: "mbta-gtfs-s3-dev-blue"

  defp opts(options), do: [
    prefix: query_prefix(options)
  ]

  defp query_prefix(options) do
    # Expl.S3.ObjectPrefix.from_datetime(options[:datetime], object_prefix: "concentrate")
    Expl.S3.ObjectPrefix.from_datetime(
      options[:datetime],
      object_prefix: options[:source] || nil
    )
  end
end
