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
     assert subscription_fulfilment = %{
       result: %{data: %{"userAdded" => %{"name" => "Boris"}}}
     }
    end

    test "sub without fufilment", %{socket: socket, conn: conn} do
      assert %{
        payload: %{subscriptionId: sub_id},
        status: :ok
      } = subscribe(socket, @subscription)
      expected = %{
        result: %{data: %{"userAdded" => %{"name" => "Boris"}}}
      }
      refute_subscription_fulfilment ^expected
    end
  end
end
