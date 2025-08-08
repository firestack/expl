defmodule Expl.Db.S3Query do
  use TypedEctoSchema
  import Ecto.Changeset

  typed_schema "s3_queries" do
    field :start_at, :utc_datetime_usec
    field :end_at, :utc_datetime_usec

    field :s3_bucket, :string
    field :bucket_prefix, :string

    field :limit, :integer

    timestamps()
  end

  @doc false
  def changeset(s3_query, attrs) do
    s3_query
    |> cast(attrs, [:start_at, :end_at, :s3_bucket, :bucket_prefix, :limit])
    |> validate_required([:start_at, :end_at, :s3_bucket, :bucket_prefix, :limit])
  end
end
