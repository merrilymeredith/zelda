defmodule Zelda.Commands do
  require Logger

  @api_token Application.get_env(:zelda, :slack_token)

  def handle_cmd(_slack, _msg, "help", _args) do
    replies = [
      """
      Hi, I'm Zelda, a simple bot run by Meredith H to spot short tokens
      that include an id and reply with complete links.
      
      I know about the following:  zr/zrgit, bugzid, grafana, barkeep
      You can also tell me to leave.
      """, 
    ]
    
    {:ok, replies}
  end
  
  def handle_cmd(_slack, msg, "leave", _args) do
    Slacker.Web.channels_leave(@api_token, channel: msg["channel"])

    {:ok, []}
  end
end
