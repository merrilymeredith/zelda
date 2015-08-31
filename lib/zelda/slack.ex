defmodule Zelda.Slack do
  use Slacker
  use Slacker.Matcher

  alias Zelda.Link
  alias Zelda.Commands

  # the start_link provided by slacker doesn't pass opts, I want to register a
  # name for this process
  def start_link(api_token, opts) do
    GenServer.start_link(__MODULE__, api_token, opts)
  end

  match ~r/\b([a-z_]+:[\w-]+)\b/, :say_link
  match ~r/\b([a-z_]+:!\$)/, :re_link
  match ~r/^zelda:\s*(\w+)\s*(.*)$/, :do_command

  def say_link(_slack, msg, token) do
    Link.say_link msg, token
  end
  
  def re_link(_slack, msg, token) do
    Link.re_link msg, token
  end

  def do_command(_slack, msg, command, args) do
    Commands.send_cmd(
      msg,
      String.downcase(command),
      String.split(args, ~r/\s+/, trim: true)
    )
  end

  def handle_cast({:handle_incoming, "team_join", %{"user" => user}}, state) do
    Zelda.Users.add_user user["id"], user["name"]
    {:noreply, state}
  end
end
