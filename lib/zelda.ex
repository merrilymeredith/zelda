defmodule Zelda do

  @moduledoc """
  Zelda, a simple Slack bot that listens for "type:id" tokens in chat and
  replies with helpful links to the object that's been referenced.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Zelda.Repo, []),
      worker(Zelda.Commands, []),
      worker(Zelda.Link, []),
    ]

    if Application.get_env(:zelda, :connect_slack) do
      children = children ++ [
        worker(Zelda.Slack, [slack_token]),
        worker(Zelda.Users, []),
      ]
    end

    children |> Supervisor.start_link(
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
