defmodule Zelda.Slack do
  use Slacker
  use Slacker.Matcher

  alias Zelda.Link
  alias Zelda.Commands
  alias Zelda.State

  # the start_link provided by slacker doesn't pass opts
  def start_link(api_token, opts) do
    GenServer.start_link(__MODULE__, api_token, opts)
  end

  match ~r/\b(\w+:[\w-]+)\b/, :say_link
  match ~r/\b(\w+:")\s*/, :re_link
  match ~r/^zelda:\s*(\w+)\s*(.*)$/, :do_command

  def say_link(slack, msg, token) do
    if {link, _type, id} = Link.get_link_detail(token) do
      State.set(:last_id, msg["channel"], id)
      say slack, msg["channel"], link
    end
  end
  
  def re_link(slack, msg, token) do
    if last_id = State.get(:last_id, msg["channel"]) do
      say_link slack, msg, String.replace(token, ~s["], last_id) 
    end
  end

  def do_command(slack, msg, command, args) do
    Commands.send_cmd(
      msg,
      String.downcase(command),
      String.split(args, ~r/\s+/, trim: true)
    )
  end
end
