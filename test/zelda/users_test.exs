defmodule Zelda.UsersTest do
  use ExUnit.Case

  alias Zelda.Users

  test "Users" do
    assert %{}     = Users.list_users
    assert :ok     = Users.add_user "4321a", "Chloe"
    assert "Chloe" = Users.lookup_by :id, "4321a"
    assert "4321a" = Users.lookup_by :name, "Chloe"
  end
end
