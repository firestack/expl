defmodule Expl.Db.S3Object do
  @moduledoc nil

  use TypedEctoSchema
  alias Ecto.Changeset

  typed_schema "s3_object" do
    # TODO: Map feed to atom when pulling from db
    field :feed, {:array, :string}
    # field :producer, :string

    # AWS Object Information
    field :object_key, :string, null: false
    field :object_etag, :string

    field :object_modified_at, :utc_datetime_usec, null: false
    field :object_storage_class, :string, null: false

    timestamps()
  end

  def changeset(changeset, params) do
    changeset
    |> Changeset.cast(
      params,
      [:feed, :object_key, :object_etag, :object_modified_at, :object_storage_class]
    )
    |> Changeset.validate_required([:object_key, :object_modified_at, :object_storage_class])
  end
end
