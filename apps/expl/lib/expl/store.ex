defmodule Expl.Store do
  @moduledoc nil

  @doc """
  Records S3 object data into the store for cached lookups
  """
  def create_object_info(object_params) do
    %Expl.Db.S3Object{}
    |> Expl.Db.S3Object.changeset(object_params)
    |> Expl.Repo.insert(on_conflict: :nothing)
  end
end
