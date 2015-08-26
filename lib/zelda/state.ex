defmodule Zelda.State do
  def start_link(name) do
    Agent.start_link(&HashDict.new/0, name: name)
  end

  def get(state, key),        do: Agent.get(state, &Dict.get(&1, key))
  def set(state, key, value), do: Agent.update(state, &Dict.put(&1, key, value))
  def del(state, key),        do: Agent.update(state, &Dict.delete(&1, key))
end
