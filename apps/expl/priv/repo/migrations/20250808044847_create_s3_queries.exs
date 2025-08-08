defmodule Expl.Repo.Migrations.CreateS3Queries do
  use Ecto.Migration

  def change do
    create table(:s3_queries) do
      add :start_at, :utc_datetime_usec
      add :end_at, :utc_datetime_usec
      add :s3_bucket, :string
      add :bucket_prefix, :string
      add :limit, :integer

      timestamps()
    end
  end
end
