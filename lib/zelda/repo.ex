defmodule Zelda.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :zelda,
    adapter: Sqlite.Ecto
end
