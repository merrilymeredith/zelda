defmodule Zelda.Repo do
  use Ecto.Repo,
    otp_app: :zelda,
    adapter: Sqlite.Ecto
end
