defmodule Expl.Repo do
  use Ecto.Repo,
    otp_app: :expl,
    adapter: Ecto.Adapters.SQLite3
end
