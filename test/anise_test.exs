defmodule AniseTest do
  use ExUnit.Case
  doctest Anise

  test "greets the world" do
    assert Anise.hello() == :world
  end
end
