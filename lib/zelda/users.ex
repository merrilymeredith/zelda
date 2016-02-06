defmodule Zelda.Users do

  @moduledoc """
  Maintains an in-memory list of users in the Slack team along with their IDs,
  for quick lookup.
  """

  use GenServer

  @api_token Application.get_env(:zelda, :slack_token)

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, list_users, [name: :users])
  end

  def list_users do
    {:ok, %{members: members}} = Slacker.Web.users_list(@api_token)
    members
      |> Enum.map( fn (user) -> {user["id"], user["name"]} end )
      |> Enum.into( HashDict.new )
  end

  def add_user(user_id, user_name) do
    GenServer.cast :users, {:add, user_id, user_name}
  end

  def lookup_by(by, value) do
    GenServer.call :users, {:query, by, value}
  end


  # Server callbacks

  def handle_call(:refresh, _from, _state) do
    state = list_users
    {:noreply, state}
  end

  def handle_call({:query, :id, user_id}, _from, state) do
    {:reply, state[user_id], state}
  end

  def handle_call({:query, :name, user_name}, _from, state) do
    case Enum.find(state, fn ({_, slack_name}) -> slack_name == user_name end) do
      {user_id, _} -> {:reply, user_id, state}
      _            -> {:reply, nil, state}
    end
  end

  def handle_cast({:add, user_id, user_name}, state) do
    {:noreply, Dict.put(state, user_id, user_name)}
  end

end
