defmodule Zelda do
  use Application

  def start(_type, _args) do
    Zelda.Supervisor.start_link
  end
end
