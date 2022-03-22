defmodule Conversor.Repo do
  use Ecto.Repo,
    otp_app: :conversor,
    adapter: Ecto.Adapters.Postgres
end
