defmodule Zelda.Ignore do
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
    Repo.get_by(Ignore, [{type, value}])
     |> Repo.delete!
  end
end
