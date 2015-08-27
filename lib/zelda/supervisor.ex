defmodule Zelda.Supervisor do
  use Supervisor

  @api_token Application.get_env(:zelda, :slack_token)

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Zelda.Repo, []),
      worker(Zelda.Slack, [@api_token]),
      worker(Zelda.State, [:last_id]),
    ]

    children |> supervise(strategy: :one_for_one)
  end
end
