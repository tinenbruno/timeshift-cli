defmodule TimeshiftCLITest do
  use ExUnit.Case
  doctest TimeshiftCLI

  test "greets the world" do
    assert TimeshiftCLI.hello() == :world
  end
end
