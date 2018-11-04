# Anise

Anis is a set of helpers/assertions for Absinthe



## Installation

```elixir
def deps do
  [
    {:anise, "~> 0.1.0"}
  ]
end
```

## Usage

### Without subscriptions
Add `use Anise` on top of your tests. 

Than you can use do that.

```elixir
graphql(conn, "/api", @mutation, %{email: "test@example.com", name: "Boris"})
```
same for queries.

### With subscriptions
Create `subscription_case.ex` in `test/support`.

```elixir
defmodule MyAppWeb.SubscriptionCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint MyAppWeb.Endpoint
      use Anise

      use Anise.SubscriptionCase,
        schema: MyAppWeb.Schema,
        socket: MyAppWeb.UserSocket
      end
  end

  setup do
    :ok
  end
end

```
Then in your subscription tests add `use MyAppWeb.Subscription`

Now you can test your subscritpions.

```elixir
  describe "User add" do
    test "valid data", %{socket: socket, conn: conn} do
      assert %{
               payload: %{subscriptionId: sub_id},
               status: :ok
             } = subscribe(socket, @subscription)

      graphql(conn, "/api", @mutation, %{email: "test@example.com", name: "Boris"})

      expected = %{result: %{data: %{"userAdded" => %{"name" => "Boris"}}}}
      assert_subscription_fulfilment fufilment
      assert fufilment = expected
    end
  end
```
