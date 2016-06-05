defmodule ZeldaTest do
  use ExUnit.Case

  alias Zelda.Link
  alias Zelda.Commands
  alias Zelda.Ignore
  alias Zelda.Users

  test "Link.match_token" do
    assert Link.match_token("foo gh:bac321 baz")    == {:ok, {:gh, "bac321"}}
    assert Link.match_token("foo gh:<blah > baz") == {:ok, {:gh, "blah "}}
  end

  test "Link.make_link" do
    assert Link.make_link({:gh,     "123cab/proj"}) ==
      {:ok, {"https://github.com/123cab/proj", :gh, "123cab/proj"}}
    assert Link.make_link({:github, "123cab/proj"}) ==
      {:ok, {"https://github.com/123cab/proj", :gh, "123cab/proj"}}
  end

  test "Link.get_link" do
    assert Link.get_link("foo github:54321")   == "https://github.com/54321"
    assert Link.get_link("github:<foo baz>") == "https://github.com/foo%20baz"
    assert Link.get_link("foo: blah") == nil
    assert Link.get_link("baz:blah")  == nil
    assert Link.get_link(nil)         == nil
  end

  test "Link.get_link_detail" do
    assert Link.get_link_detail("foo github:54321") == {"https://github.com/54321", :gh, "54321"}
    assert Link.get_link_detail("foo: blah") == {:error, "No Match"}
    assert Link.get_link_detail("baz:blah")  == {:error, "No Template"}
    assert Link.get_link_detail(nil)         == {:error, "No Match"}
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

  test "Users" do
    assert %{}     = Users.list_users
    assert :ok     = Users.add_user "4321a", "Chloe"
    assert "Chloe" = Users.lookup_by :id, "4321a"
    assert "4321a" = Users.lookup_by :name, "Chloe"
  end
end
