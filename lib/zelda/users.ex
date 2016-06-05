defmodule Zelda.Users do
  @moduledoc """
  Maintains an in-memory list of users in the Slack team along with their IDs,
  for quick lookup.
  """

  @callback fetch_users :: map

  defmacro __using__(_) do
    quote do
      use GenServer
      @behaviour Zelda.Users

      # Client

      def init(_args) do
        case fetch_users do
          list when is_map(list) -> {:ok, list}
          _                      -> {:error, "Couldn't initialize user list"}
        end
      end

      # Server callbacks

      def handle_call(:refresh, _from, _state) do
        state = fetch_users
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

      def handle_call(:list, _from, state), do: {:reply, state, state}

      def handle_cast({:add, user_id, user_name}, state) do
        {:noreply, Map.put(state, user_id, user_name)}
      end
    end
  end

  def start_link() do
    GenServer.start_link Application.get_env(:zelda, :users_module), nil, [name: :users]
  end

  def add_user(user_id, user_name), do: GenServer.cast(:users, {:add, user_id, user_name})
  def lookup_by(by, value),         do: GenServer.call(:users, {:query, by, value})
  def list_users(),                 do: GenServer.call(:users, :list)
end
