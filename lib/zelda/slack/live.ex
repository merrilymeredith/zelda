defmodule Zelda.Slack.Live do
  @moduledoc """
  Handles the ongoing Slack RTM API connection by way of the Slacker library.
  Matches link tokens, which are dispatched to Zelda.Link, and commands, which
  are dispatched to Zelda.Commands.  User join events are forwarded to
  Zelda.Users.
  """

  # Step ahead of Slacker.Matcher to always ignore bot messages
  def handle_cast({:handle_incoming, "message", %{"subtype" => "bot_message"}, state}), do: {:noreply, state}

  use Slacker
  use Zelda.Slack.Matcher

  def reply(text, slack, msg) do
    say(slack, msg["channel"], text )
  end
end

