defmodule Expl.Repo.Migrations.CreateS3ObjectTable do
  use Ecto.Migration

  def change do
    create table "s3_object" do
      add :feed, {:array, :text}
      add :environment, :string
      add :data_type, :string
      add :key_date, :utc_datetime_usec

      add :bucket_name, :string, null: false
      add :object_key, :string, null: false
      add :object_etag, :string

      add :object_modified_at, :utc_datetime_usec, null: false
      add :object_storage_class, :string, null: false

      timestamps()
    end

    create index("s3_object", [:object_key, :object_etag, :bucket_name], unique: true)
  end
end
