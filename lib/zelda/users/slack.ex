defmodule Zelda.Users.Slack do
  use Zelda.Users

  def fetch_users do
    {:ok, %{members: members}} = Slacker.Web.users_list(Zelda.slack_token)
    members
      |> Enum.map( fn (user) -> {user["id"], user["name"]} end )
      |> Enum.into( Map.new )
  end
end
