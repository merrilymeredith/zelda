defmodule Zelda do
  use Application

  @api_token Application.get_env(:zelda, :slack_token)

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Zelda.Repo, []),
      worker(Zelda.State, [:last_id]),
      worker(Zelda.Slack, [@api_token]),
    ]

    children |> supervise(name: Zelda.Sup, strategy: :one_for_one)
  end
end
