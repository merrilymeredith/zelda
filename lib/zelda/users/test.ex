defmodule Zelda.Users.Test do
  use Zelda.Users

  def fetch_users do
    %{"1" => "Foo", "2" => "Bar", "3" => "Baz", "4" => "Quux", "5" => "Xyzzy"}
  end
end
