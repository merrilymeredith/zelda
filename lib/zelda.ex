defmodule Zelda do

  @moduledoc """
  Zelda, a simple Slack bot that listens for "type:id" tokens in chat and
  replies with helpful links to the object that's been referenced.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    api_token = Application.get_env(:zelda, :slack_token)

    children = [
      worker(Zelda.Repo, []),
      worker(Zelda.Commands, []),
      worker(Zelda.Link, []),
    ]

    if Mix.env != :test do
      children = children ++ [
        worker(Zelda.Slack, [api_token]),
        worker(Zelda.Users, []),
      ]
    end

    children |> Supervisor.start_link(
      name:     Zelda.Sup,
      strategy: :one_for_one,
    )
  end
end
