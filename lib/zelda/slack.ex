defmodule Zelda.Slack do
  use Slacker
  use Slacker.Matcher

  alias Zelda.Link
  alias Zelda.Commands
  alias Zelda.State

  # the start_link provided by slacker doesn't pass opts, I want to register a
  # name for this process
  def start_link(api_token, opts) do
    GenServer.start_link(__MODULE__, api_token, opts)
  end

  match ~r/\b([a-z_]+:[\w-]+)\b/, :say_link
  match ~r/\b([a-z_]+:!\$)/, :re_link
  match ~r/^zelda:\s*(\w+)\s*(.*)$/, :do_command

  # TODO: link handling should maybe be its own process like commands, as Slack
  # likes to re-send messages so if our Slack process dies, it just dies five
  # times in a row and quits.

  def say_link(slack, msg, token) do
    {link, _type, id} = Link.get_link_detail(token)

    State.set(:last_id, msg["channel"], id)
    say slack, msg["channel"], link
  rescue _ in MatchError -> ()
  end
  
  def re_link(slack, msg, token) do
    last_id = State.get(:last_id, msg["channel"])
    say_link slack, msg, String.replace(token, ~s[!$], last_id)
  rescue _ in MatchError -> ()
  end

  def do_command(_slack, msg, command, args) do
    Commands.send_cmd(
      msg,
      String.downcase(command),
      String.split(args, ~r/\s+/, trim: true)
    )
  end


  def handle_cast({:handle_incoming, "team_join", %{"user" => user}}, state) do
    Zelda.Slack.Users.add_user user["id"], user["name"]
    {:noreply, state}
  end
end
