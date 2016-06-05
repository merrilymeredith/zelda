defmodule Zelda.IgnoreTest do
  use ExUnit.Case

  alias Zelda.Ignore

  test "Ignore" do
    slack_id   = "U123456789"
    slack_name = "quux"

    # Not started sometimes by the time we get to this test?
    Zelda.Repo.start_link

    Zelda.Repo.transaction fn ->
      refute Ignore.is_ignored?(:slack_id, slack_id)

      assert {:ok, _} = Ignore.ignore(slack_id, slack_name)
      assert Ignore.is_ignored?(:slack_id, slack_id)

      assert Ignore.unignore(:slack_name, slack_name)
      refute Ignore.is_ignored?(:slack_id, slack_id)
    end
  end
end
