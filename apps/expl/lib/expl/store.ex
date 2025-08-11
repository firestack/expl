defmodule Expl.Store do
  @moduledoc nil

  import Ecto.Query

  def create_s3_query(query_options) do
    %Expl.Db.S3Query{}
    |> Expl.Db.S3Query.changeset(query_options)
    |> Expl.Repo.insert()
  end

  def get_s3_query(query_options) do
    from(query in Expl.Db.S3Query,
      where: query.start_at <= ^query_options[:start_at],
      where: query.end_at >= ^query_options[:end_at],
      where: query.s3_bucket == ^query_options[:s3_bucket],
      where: ^with_bucket_prefix(query_options[:bucket_prefix])
    )
    |> Expl.Repo.all()
  end

  def with_bucket_prefix(nil), do: true

  def with_bucket_prefix(bucket_prefix),
    do: dynamic([query], query.bucket_prefix == ^bucket_prefix)

  @doc """
  Records S3 object data into the store for cached lookups
  """
  def create_object_info(object_params) do
    %Expl.Db.S3Object{}
    |> Expl.Db.S3Object.changeset(object_params)
    |> Expl.Repo.insert(on_conflict: :nothing)
  end
end
