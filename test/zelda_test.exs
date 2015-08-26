defmodule ZeldaTest do
  use ExUnit.Case, async: true

  alias Zelda.Link
  alias Zelda.Slack
  alias Zelda.Commands

  test "Link.match_token" do
    assert Link.match_token("foo zr:bac321 baz") == {:zr, "bac321"}
  end

  test "Link.make_link" do
    assert Link.make_link("") == nil
    assert Link.make_link({:zr, "123cab"})              == "https://git.ziprecruiter.com/ZipRecruiter/ziprecruiter/commit/123cab"
    assert Link.make_link({:bugzid, "12345"})           == "https://ziprecruiter.fogbugz.com/f/cases/12345/"
    assert Link.make_link({:grafana, "blah-dashboard"}) == "https://stats.ziprecruiter.com/grafana/dashboard/db/blah-dashboard"
  end

  test "Link.get_link" do
    assert Link.get_link("foo bugzid:54321") == "https://ziprecruiter.fogbugz.com/f/cases/54321/"
    assert Link.get_link("foo: blah") == nil
    assert Link.get_link("baz:blah") == nil
    assert Link.get_link(nil) == nil
  end

  test "Commands.handle_cmd help" do
    {:ok, [help_text | _]} = Commands.handle_cmd(nil, nil, "help", nil)
    assert help_text |> String.starts_with? "Hi, I'm Zelda"
  end


end
