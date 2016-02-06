defmodule Zelda.Commands do

  @moduledoc """
  The Command server for Zelda, handling commands sent by slack users and
  sometimes dispatching them to other processes.
  """

  use GenServer
  alias Zelda.Ignore
  alias Zelda.Users
  alias Zelda.Slack

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: :commands])
  end

  def send_cmd(slack, msg, command, args) do
    GenServer.cast :commands, {command, args, slack, msg}
  end

  def do_command(slack, msg, command, args) do
    send_cmd(slack, msg,
      String.downcase(command),
      String.split(args, ~r/\s+/, trim: true)
    )
  end

  # Server Callbacks

  def handle_cast({"help", _args, slack, msg}, state) do
    """
    Hi, I'm Zelda, an Elixir bot that listens for short references and replies with a helpful Link!

    Link Types:  #{Zelda.Link.get_types}
    Commands: leave, ignore, ignore <user>, unignore <user>
    """ |> Slack.reply(slack, msg)

    {:noreply, state}
  end

  def handle_cast({"leave", _args, _slack, msg}, state) do
    Slacker.Web.channels_leave(Zelda.slack_token, channel: msg["channel"])

    {:noreply, state}
  end

  def handle_cast({"ignore", [""], slack, msg}, state) do
    id = msg["user"]
    name = Users.lookup_by(:id, id)
    Ignore.ignore( id, name )

    Slack.reply "Ignoring #{name}.", slack, msg
    {:noreply, state}
  end

  def handle_cast({"ignore", [name | _args], slack, msg}, state) do
    case Users.lookup_by(:name, name) do
      nil ->
        Slack.reply "I don't know a #{name}!", slack, msg
      id ->
        Ignore.ignore id, name
        Slack.reply "Ignoring #{name}.", slack, msg
    end
    {:noreply, state}
  end

  def handle_cast({"unignore", [name | _args], slack, msg}, state) do
    Ignore.unignore :slack_name, name
    Slack.reply "No longer ignoring #{name}.", slack, msg
    {:noreply, state}
  end
end
