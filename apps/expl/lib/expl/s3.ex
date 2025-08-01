defmodule Expl.S3 do
  @moduledoc nil

  def get_object(%Expl.Db.S3Object{} = resource, opts \\ []) do
    request = do_get_object(resource, opts)
    {ExAws.request(request), request.dest}
  end

  def get_object!(%Expl.Db.S3Object{} = resource, opts \\ []) do
    request = do_get_object(resource, opts)
    {ExAws.request!(request), request.dest}
  end

  defp do_get_object(%Expl.Db.S3Object{} = resource, opts) do
    output_path =
      Keyword.get_lazy(opts, :output, fn ->
        Path.join([".cache", "s3", resource.bucket_name, resource.object_key])
      end)

    output_path
    |> Path.dirname()
    |> File.mkdir_p!()

    ExAws.S3.download_file(
      resource.bucket_name,
      resource.object_key,
      output_path
    )
  end

  def get_objects(resources, opts \\ []) do
    output_fn = Keyword.get(opts, :output_fn, nil)

    Stream.map(resources, fn resource ->
      get_object(
        resource,
        ((output_fn && [output: output_fn.(resource)]) || []) ++
          opts
      )
    end)
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

  defp opts(options),
    do: [
      prefix: query_prefix(options)
    ]

  # TODO: Add ability to iterate over a range
  defp query_prefix(options) do
    # Expl.S3.ObjectPrefix.from_datetime(options[:datetime], object_prefix: "concentrate")
    Expl.S3.ObjectPrefix.from_datetime(
      options[:datetime],
      object_prefix: options[:source] || nil
    )
  end
end
