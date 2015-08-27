defmodule Zelda.Link do
  def get_types do
    "zr/zrgit, bb, bb_stg, bugzid, grafana, barkeep"
  end

  # aliases
  def make_link({:zrgit, id}), do: make_link({:zr, id})

  def make_link({type, id}) do
    case type do
      :zr      -> "https://git.ziprecruiter.com/ZipRecruiter/ziprecruiter/commit/#{id}"
      :bb      -> "https://buildbot.ziprecruiter.com/builders/buildbot-01_sandbox_Builder/builds/#{id}"
      :bb_stg  -> "https://buildbot.ziprecruiter.com/builders/buildbot-01_stg_Builder/builds/#{id}"
      :bugzid  -> "https://ziprecruiter.fogbugz.com/f/cases/#{id}/"
      :grafana -> "https://stats.ziprecruiter.com/grafana/dashboard/db/#{id}"
      :barkeep -> "https://barkeep.ziprecruiter.com/commits/ziprecruiter/#{id}"
      _ -> ()
    end
  end
  def make_link(_), do: ()

  def match_token(string) when is_binary(string) do
    [_, type, id] = Regex.run(~r{\b([a-z]+):([\w-]+)\b}, string)
    { String.to_existing_atom(type), id }
  rescue _ -> ()
  end
  def match_token(_), do: ()

  def get_link(string), do: string |> match_token |> make_link

  def get_link_detail(string) do
    token = {type, id} = match_token string
    link  = make_link(token)
    {link, type, id}
  end
end
