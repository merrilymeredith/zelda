defmodule Zelda.CommandsTest do
  use ExUnit.Case

  alias Zelda.Commands

  test "Commands.handle_cmd help" do
    Commands.handle_cast({"help", [], self, %{"channel" => "mock"}}, [])
    assert_received {:"$gen_cast", {:send_message, "mock", _help_reply}}
  end
end
