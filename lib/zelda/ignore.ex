defmodule Zelda.Ignore do

  @moduledoc """
  Implements ignore (ignore messages from this user) tests and storage.
  """

  alias Zelda.Repo
  alias Zelda.Model.Ignore

  def is_ignored?(type, value) do
    Repo.get_by(Ignore, [{type, value}]) != nil
  end

  def ignore(slack_id, slack_name) do
    Repo.insert %Ignore{
      slack_id:   slack_id,
      slack_name: slack_name,
    }
  end

  def unignore(type, value) do
    case Repo.get_by(Ignore, [{type, value}]) do
      nil -> nil
      rec -> Repo.delete(rec)
    end
  end
end
