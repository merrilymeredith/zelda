defmodule Zelda.Commands do
  use GenServer
  alias Zelda.Ignore
  alias Zelda.Users

  @api_token Application.get_env(:zelda, :slack_token)

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: :commands])
  end

  def send_cmd(msg, command, args) do
    GenServer.cast :commands, {command, args, msg}
  end

  def reply(text, msg) do
    Zelda.Slack.say( :slack, msg["channel"], text )
  end

  # Server Callbacks

  def handle_cast({"help", _args, msg}, state) do
    """
    Hi, I'm Zelda, a simple bot run by Meredith H to spot short tokens that include an id and reply with complete links.
    
    I know about the following:  #{Zelda.Link.get_types}
    Commands: leave, ignore, ignore <user>, unignore <user>
    """ |> reply(msg)

    {:noreply, state}
  end
  
  def handle_cast({"leave", _args, msg}, state) do
    Slacker.Web.channels_leave(@api_token, channel: msg["channel"])

    {:noreply, state}
  end

  # FIXME: user is a user id, i need the name too
  # and for ignore-someone-else i need the id from the name
  def handle_cast({"ignore", [""], msg}, state) do
    id = msg["user"]
    name = Users.lookup_by(:id, id)
    Ignore.ignore( id, name )

    reply("Ignoring #{name}.", msg)
    {:noreply, state}
  end

  def handle_cast({"ignore", [name | _args], msg}, state) do
    case Users.lookup_by(:name, name) do
      nil ->
        reply "I don't know a #{name}!", msg
      id ->
        Ignore.ignore id, name
        reply "Ignoring #{name}.", msg
    end
    {:noreply, state}
  end

  def handle_cast({"unignore", [name | _args], msg}, state) do
    Ignore.unignore :slack_name, name
    reply "No longer ignoring #{name}.", msg
    {:noreply, state}
  end

  def handle_cast({"stop", _args, _msg}, _state) do
    System.halt
  end
end
