defmodule Expl.ConfigSources.DeltaConfig do
  @moduledoc nil

  @type t() :: %__MODULE__{
          type: :s3,
          bucket: binary(),
          prefix: binary() | nil,
          producers: list(binary())
        }

  @enforce_keys [:bucket, :type]
  defstruct @enforce_keys ++ [:prefix, :producers]
end
