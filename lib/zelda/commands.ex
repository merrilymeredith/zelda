defmodule Zelda.Commands do
  use GenServer

  @api_token Application.get_env(:zelda, :slack_token)

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: :commands])
  end

  def send_cmd(msg, command, args) do
    GenServer.cast :commands, {command, args, msg}
  end

  def reply(text, msg) do
    Zelda.Slack.say( :slack, msg["channel"], text )
  end

  def handle_cast({"help", _args, msg}, state) do
    """
    Hi, I'm Zelda, a simple bot run by Meredith H to spot short tokens that
    include an id and reply with complete links.
    
    I know about the following:  #{Zelda.Link.get_types}
    You can also tell me to leave.
    """ |> reply(msg)

    {:noreply, state}
  end
  
  def handle_cast({"leave", _args, msg}, state) do
    Slacker.Web.channels_leave(@api_token, channel: msg["channel"])

    {:noreply, state}
  end

  # FIXME: user is a user id, i need the name too
  # and for ignore-someone-else i need the id from the name
  def handle_cast({"ignore", [], msg}, state) do
    handle_cast({"ignore", [msg["user"]], msg}, state)
  end

  def handle_cast(msg, "ignore", [name | _args]) do
    Zelda.Ignore.ignore()
  end
end
