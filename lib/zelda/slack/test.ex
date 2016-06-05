defmodule Zelda.Slack.Test do
  @moduledoc """
  Testing module to disable slack connection. TODO: an interface to fake messages?
  Connecting / Receiving really needs to be split from matching and routing...
  """

  use GenServer
  use Zelda.Slack.Matcher

  def start_link(_slack_token, options \\ []) do
    GenServer.start_link(__MODULE__, [], options)
  end

  def reply(text, slack, %{"channel" => channel}) do
    require Logger
    Logger.info "Reply to #{channel}: #{text}"
    GenServer.cast(slack, {:send_message, channel, text})
  end

  def handle_cast({:send_message, _channel, _text}, state), do: {:noreply, state}
end

