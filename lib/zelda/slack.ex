defmodule Zelda.Slack do
  @slack_module Application.get_env(:zelda, :slack_module)

  def start_link() do
    apply @slack_module, :start_link, []
  end

  def reply(text, slack, msg) do
    apply @slack_module, :reply, [text, slack, msg]
  end
end

