defmodule Zelda do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    api_token = Application.get_env(:zelda, :slack_token)

    children = [
      worker(Zelda.Repo, []),
      worker(Zelda.Slack.Users, []),
      worker(Zelda.Commands, []),
      worker(Zelda.Link, []),
      worker(Zelda.Slack, [api_token, [name: :slack]]),
    ]

    children |> Supervisor.start_link(
      name:     Zelda.Sup,
      strategy: :one_for_one,
    )
  end
end
