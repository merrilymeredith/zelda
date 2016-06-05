defmodule Zelda.Slack.Test do
  @moduledoc """
  Testing module to disable slack connection. TODO: an interface to fake messages?
  Connecting / Receiving really needs to be split from matching and routing...
  """

  use GenServer
  use Zelda.Slack.Matcher

  def start_link(), do: GenServer.start_link(__MODULE__, [], [name: :slack])

  def handle_cast({:handle_incoming, "team_join", %{"user" => user}}, state) do
    apply Application.get_env(:zelda, :users_module), :add_user, [user["id"], user["name"]]
    {:noreply, state}
  end

  def reply(text, slack, %{"channel" => channel}) do
    require Logger
    Logger.info "Reply to #{channel}: #{text}"
    GenServer.cast(slack, {:send_message, channel, text})
  end

  def handle_cast({:send_message, _channel, _text}, state), do: {:noreply, state}
end

