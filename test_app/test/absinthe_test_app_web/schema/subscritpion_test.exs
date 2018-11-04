defmodule AbsintheTestApp.SubscriptionTest do
  use AbsintheTestAppWeb.ChannelCase
  use Anise.SubscriptionCase, schema: AbsintheTestAppWeb.Schema, socket: AbsintheTestAppWeb.UserSocket

  describe "subscription" do
    test "sub", %{socket: socket} do
      IO.inspect socket
    end
  end
end
