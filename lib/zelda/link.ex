defmodule Zelda.Link do
  use GenServer
  import Zelda.Ignore, only: [is_ignored?: 2]

  @match     Application.get_env(:zelda, :match)[:link]
  @aliases   Application.get_env(:zelda, :link_aliases)
  @templates Application.get_env(:zelda, :link_templates)

  def make_link({type, id}) do
    type = @aliases[type] || type
    if tmpl = @templates[type] do
      EEx.eval_string tmpl, assigns: [id: id]
    end
  end
  def make_link(_), do: nil

  def match_token(string) when is_binary(string) do
    [_, _, type, id] = Regex.run(@match, string)
    { String.to_existing_atom(type), id }
  rescue  _ -> nil
  end
  def match_token(_), do: nil

  def get_link(string), do: string |> match_token |> make_link

  def get_link_detail(string) do
    token = match_token(string)
    if link = make_link(token) do
      {type, id} = token
      {link, type, id}
    else
      nil
    end
  end

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, HashDict.new, [name: :link])
  end

  def say_link(msg, token) do
    GenServer.cast :link, {:say_link, token, msg}
  end

  def re_link(msg, token) do
    GenServer.cast :link, {:re_link, token, msg}
  end

  def get_types do
    @templates ++ @aliases
      |> Keyword.keys
      |> Enum.sort
      |> Enum.map(&Atom.to_string(&1))
      |> Enum.join(", ")
  end

  # Utility stuff

  def reply(text, msg) do
    Zelda.Slack.say( :slack, msg["channel"], text )
  end

  # Server Callbacks

  def handle_cast({:say_link, token, msg}, last_ids) do
    if !is_ignored?(:slack_id, msg["user"]) do
      {link, _type, id} = get_link_detail(token)

      last_ids = last_ids |> Dict.put( msg["channel"], id )
      link |> reply(msg)
    end
    {:noreply, last_ids}
  rescue _ in MatchError -> {:noreply, last_ids}
  end

  def handle_cast({:re_link, token, msg}, last_ids) do
    last_id = Dict.fetch!( last_ids, msg["channel"] )
    handle_cast {:say_link, token |> String.replace(~s[!$], last_id), msg}, last_ids
  rescue _ in KeyError -> {:noreply, last_ids}
  end
end
