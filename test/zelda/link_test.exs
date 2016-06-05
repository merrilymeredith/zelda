defmodule Zelda.LinkTest do
  use ExUnit.Case

  alias Zelda.Link

  test "Link.match_token" do
    assert Link.match_token("foo gh:bac321 baz")  == {:ok, {:gh, "bac321"}}
    assert Link.match_token("foo gh:<blah > baz") == {:ok, {:gh, "blah "}}
  end

  test "Link.make_link" do
    assert Link.make_link({:gh,     "123cab/proj"}) ==
      {:ok, {"https://github.com/123cab/proj", :gh, "123cab/proj"}}
    assert Link.make_link({:github, "123cab/proj"}) ==
      {:ok, {"https://github.com/123cab/proj", :gh, "123cab/proj"}}
  end

  test "Link.get_link" do
    assert Link.get_link("foo github:54321") == "https://github.com/54321"
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
end
