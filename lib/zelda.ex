defmodule Zelda do

  @moduledoc """
  Zelda, a simple Slack bot that listens for "type:id" tokens in chat and
  replies with helpful links to the object that's been referenced.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    import Application, only: [get_env: 2]

    children = [
      worker(Zelda.Repo, []),
      worker(Zelda.Commands, []),
      worker(Zelda.Link, []),
      worker(Zelda.Users, []),
      worker(Zelda.Slack, []),
    ]

    Supervisor.start_link(
      children,
      name:     Zelda.Sup,
      strategy: :one_for_one,
    )
  end

  def slack_token do
    System.get_env("SLACK_API_TOKEN") ||
    Application.get_env(:zelda, :slack_token) ||
    raise RuntimeError, message: "No Slack API Token configured"
  end
end
