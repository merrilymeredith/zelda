defmodule Zelda.Link do
  use GenServer
  alias Zelda.Slack
  alias Zelda.Ignore

  @match     Application.get_env(:zelda, :match)[:link]
  @aliases   Application.get_env(:zelda, :link_aliases)
  @templates Application.get_env(:zelda, :link_templates)

  @doc ~s"""
    Interprets a tuple `{type, id}` through the template matching `type` and
    returns a detail tuple of `{link, type, id}`.

        iex> Zelda.Link.make_link({:ok, {:github, "123cab"}})
        {:ok, {"https://github.com/123cab", "github", "123cab"}}
  """
  def make_link({:ok, {type, id}}) do
    type = @aliases[type] || type
    cond do
      tmpl = @templates[type] ->
        {:ok, {EEx.eval_string(tmpl, assigns: [id: id]), type, id}}
      false ->
        {:error, "No Template"}
    end
  end
  def make_link(e = {:error, _}), do: e

  @doc ~s"""
    Searches a given string for a "link token" and returns a tuple of
    `{type, id}` if one is found.

        iex> Zelda.Link.match_token("foo gh:bac321 baz")
        {:ok, {:gh, "bac321"}}
  """
  def match_token(string) when is_binary(string) do
    case Regex.run(@match, string) do
      [_, _, type, id] -> {:ok, {String.to_existing_atom(type), id}}
      nil              -> {:error, "No Match"}
    end
  rescue ArgumentError -> {:error, "No Template"}
  end
  def match_token(_), do: {:error, "No Match"}

  @doc ~s"""
    Given a string to search, returns a tuple `{link, type, id}` for the first
    link token matched, if any.

        iex> Zelda.Link.get_link("gh:bac321")
        {"https://github.com/bac321", :github, "bac321"}
  """
  def get_link_detail(string) do
    result = string |> match_token |> make_link
    case result do
      {:ok, detail} -> detail
      {:error, _} -> nil
    end
  end

  @doc ~s"""
    Returns only the link/url result of `get_link_detail`, if any.

        iex> Zelda.Link.get_link("gh:bac321")
        "https://github.com/bac321"
  """
  def get_link(string) do
    case get_link_detail(string) do
      {link, _, _} -> link
      nil -> nil
    end
  end

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, HashDict.new, [name: :link])
  end

  def say_link(slack, msg, token, _, _) do
    GenServer.cast :link, {:say_link, slack, token, msg}
  end

  def re_link(slack, msg, token) do
    GenServer.cast :link, {:re_link, slack, token, msg}
  end

  def get_types do
    @templates ++ @aliases
      |> Keyword.keys
      |> Enum.sort
      |> Enum.map(&Atom.to_string(&1))
      |> Enum.join(", ")
  end

  # Server Callbacks

  def handle_cast({:say_link, slack, token, msg}, last_ids) do
    if not Ignore.is_ignored?(:slack_id, msg["user"]) do
      {link, _type, id} = get_link_detail(token)

      last_ids = last_ids |> Dict.put( msg["channel"], id )
      link |> Slack.reply(slack, msg)
    end
    {:noreply, last_ids}
  rescue _ in MatchError -> {:noreply, last_ids}
  end

  def handle_cast({:re_link, slack, token, msg}, last_ids) do
    last_id = Dict.fetch!( last_ids, msg["channel"] )
    handle_cast {:say_link, token |> String.replace(~s[!$], last_id), slack, msg}, last_ids
  rescue _ in KeyError -> {:noreply, last_ids}
  end
end
