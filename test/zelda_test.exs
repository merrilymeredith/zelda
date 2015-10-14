defmodule ZeldaTest do
  use ExUnit.Case

  alias Zelda.Link
  alias Zelda.Commands
  alias Zelda.Ignore

  test "Link.match_token" do
    assert Link.match_token("foo gh:bac321 baz") == {:ok, {:gh, "bac321"}}
  end

  test "Link.make_link" do
    assert Link.make_link({:error, "blah"}) ==
      {:error, "blah"}
    assert Link.make_link({:ok, {:gh,     "123cab/proj"}}) ==
      {:ok, {"https://github.com/123cab/proj", :gh, "123cab/proj"}}
    assert Link.make_link({:ok, {:github, "123cab/proj"}}) ==
      {:ok, {"https://github.com/123cab/proj", :gh, "123cab/proj"}}
  end

  test "Link.get_link" do
    assert Link.get_link("foo github:54321") == "https://github.com/54321"
    assert Link.get_link("foo: blah") == nil
    assert Link.get_link("baz:blah") == nil
    assert Link.get_link(nil) == nil
  end

  test "Link.get_link_detail" do
    assert Link.get_link_detail("foo github:54321") == {"https://github.com/54321", :gh, "54321"}
    refute Link.get_link_detail("foo: blah")
    refute Link.get_link_detail("baz:blah")
    refute Link.get_link_detail(nil)
  end


  test "Commands.handle_cmd help" do
    Commands.handle_cast({"help", [], self, %{"channel" => "mock"}}, [])
    assert_received {:"$gen_cast", {:send_message, "mock", _help_reply}}
  end


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
