defmodule AniseTest do
  use ExUnit.Case
  use Anise.SubscriptionCase, schema: IO, socket: IO
  @endpoint IO

  describe "t" do
    test "1" do
      1 + 2
    end
  end
end
