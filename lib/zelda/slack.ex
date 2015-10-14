defmodule Zelda.Slack do
  use Slacker
  use Slacker.Matcher

  @matches Application.get_env(:zelda, :match)

  match @matches[:link],    [Zelda.Link, :say_link]
  match @matches[:repeat],  [Zelda.Link, :re_link]
  match @matches[:command], [Zelda.Commands, :do_command]

  def handle_cast({:handle_incoming, "team_join", %{"user" => user}}, state) do
    Zelda.Users.add_user user["id"], user["name"]
    {:noreply, state}
  end

  def reply(text, slack, msg) do
    say(slack, msg["channel"], text )
  end
end
