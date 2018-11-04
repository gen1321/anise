defmodule AbsintheTestApp.SubscriptionTest do
  use AbsintheTestAppWeb.SubscriptionCase

  @mutation """
  mutation createUser($email: String, $name: String){
    createUser(email: $email, name: $name){
      email
    }
  }
  """
  @subscription """
   subscription {
     userAdded {
       name
     }
   }
  """
  describe "subscription" do
    test "sub with fufilment", %{socket: socket, conn: conn} do
      assert %{
               payload: %{subscriptionId: sub_id},
               status: :ok
             } = subscribe(socket, @subscription)

      graphql(conn, "/api", @mutation, %{email: "test@example.com", name: "Boris"})

      expected = %{result: %{data: %{"userAdded" => %{"name" => "Boris"}}}}
      assert_subscription_fulfilment fufilment
      assert fufilment = expected
    end

    test "sub without fufilment", %{socket: socket, conn: conn} do
      assert %{
               payload: %{subscriptionId: sub_id},
               status: :ok
             } = subscribe(socket, @subscription)

      expected = %{
        result: %{data: %{"userAdded" => %{"name" => "Boris"}}}
      }

      refute_subscription_fulfilment(^expected)
    end
  end
end
