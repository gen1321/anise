defmodule AbsintheTestAppWeb.SubscriptionCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint AbsintheTestAppWeb.Endpoint
      use Anise
      use Anise.SubscriptionCase,
        schema: AbsintheTestAppWeb.Schema,
        socket: AbsintheTestAppWeb.UserSocket,
        endpoint:  AbsintheTestAppWeb.Endpoint
    end
  end

  setup do
    :ok
  end
end
