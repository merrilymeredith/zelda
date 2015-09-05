defmodule ZeldaTest do
  use ExUnit.Case

  import Mock

  alias Zelda.Link
  alias Zelda.Commands
  alias Zelda.Ignore

  test "Link.match_token" do
    assert Link.match_token("foo zr:bac321 baz")    == {"zr", "bac321"}
    assert Link.match_token("foo z_r:bac-321 baz") == {"z_r", "bac-321"}
  end

  test "Link.make_link" do
    assert Link.make_link("") == nil
    assert Link.make_link({"zr", "123cab"})              == "https://git.ziprecruiter.com/ZipRecruiter/ziprecruiter/commit/123cab"
    assert Link.make_link({"bugzid", "12345"})           == "https://ziprecruiter.fogbugz.com/f/cases/12345/"
    assert Link.make_link({"grafana", "blah-dashboard"}) == "https://stats.ziprecruiter.com/grafana/dashboard/db/blah-dashboard"
  end

  test "Link.get_link" do
    assert Link.get_link("foo bugzid:54321") == "https://ziprecruiter.fogbugz.com/f/cases/54321/"
    assert Link.get_link("foo: blah") == nil
    assert Link.get_link("baz:blah") == nil
    assert Link.get_link(nil) == nil
  end

  test "Link.get_link_detail" do
    assert Link.get_link_detail("foo bugzid:54321") == {"https://ziprecruiter.fogbugz.com/f/cases/54321/", "bugzid", "54321"}
    refute Link.get_link_detail("foo: blah")
    refute Link.get_link_detail("baz:blah")
    refute Link.get_link_detail(nil)
  end


  test "Commands.handle_cmd help" do
    with_mock Zelda.Slack, [say: fn (_, _channel, _text) -> () end] do
      {:noreply, _} = Commands.handle_cast({"help", [], %{"channel" => "mock"}}, [])
      assert called Zelda.Slack.say( :slack, "mock", :_ )
    end
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
