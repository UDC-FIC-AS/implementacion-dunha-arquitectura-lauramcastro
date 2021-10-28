defmodule DbusTest do
  use ExUnit.Case
  doctest Dbus

  test "greets the world" do
    assert Dbus.hello() == :world
  end
end
