defmodule Zelda.Slack do
  @slack_module Application.get_env(:zelda, :slack_module)

  def start_link() do
    apply @slack_module, :start_link, []
  end

  def reply(text, slack, msg) do
    apply @slack_module, :reply, [text, slack, msg]
  end
end

defmodule Zelda.Slack.Matcher do
  defmacro __using__(_) do
    quote do
      use Slacker.Matcher

      @matches Application.get_env(:zelda, :match)

      match @matches[:link],    [Zelda.Link, :say_link]
      match @matches[:repeat],  [Zelda.Link, :re_link]
      match @matches[:command], [Zelda.Commands, :do_command]

      def handle_cast({:handle_incoming, "team_join", %{"user" => user}}, state) do
        Zelda.Users.add_user user["id"], user["name"]
        {:noreply, state}
      end
    end
  end
end

