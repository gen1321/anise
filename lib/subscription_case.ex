defmodule Anise.SubscriptionCase do
  @moduledoc """
    Conveniences for testing Absinthe subscriptions

  # Usage

  ## Setup
  You need to use `use` macro, and pass required options.
  ```elixir
  @endpoint MyAppWeb.Endpoint
  use Anise.SubscriptionCase,
    schema: MyAppWeb.Schema,
    socket: MyAppWeb.UserSocket
  ```

  Example above is from application specific SubscriptionCase, like ones that Phoenix generates.

  ## Usage

  ```elixir
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
  ```
  """
  use ExUnit.CaseTemplate
  alias Absinthe.Phoenix.SubscriptionTest

  using(opts) do
    quote do
      use Phoenix.ConnTest
      use Phoenix.ChannelTest
      # validates schema and import base absinthe testings functions
      use Absinthe.Phoenix.SubscriptionTest,
        schema: Keyword.get(unquote(opts), :schema)

      setup do
        # connects to socket
        {:ok, socket} =
          Phoenix.ChannelTest.connect(
            Keyword.get(unquote(opts), :socket),
            Keyword.get(unquote(opts), :socket_params) || %{}
          )

        # Join socket
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)
        {:ok, socket: socket, conn: Phoenix.ConnTest.build_conn()}
      end

      import unquote(__MODULE__)
    end
  end

  use Phoenix.ChannelTest

  @doc false
  def subscribe(socket, subscription_query) do
    ref = SubscriptionTest.push_doc(socket, subscription_query)
    Phoenix.ChannelTest.assert_reply(ref, :ok, _)
  end

  @doc """
   When subscription fufiled it receives data from it.

  ## WARNING
  Paylod are patterns, dont forget to pin variables!
  ### Exapmples
  Good
  ```elixir
  expected = %{result: %{data: %{"userAdded" => %{"name" => "Boris"}}}}
  assert_subscription_fulfilment fufilment
  assert fufilment = expected
  ```

  Bad
  ```elixir
  expected = %{result: %{data: %{"userAdded" => %{"name" => "Boris"}}}}
  assert_subscription_fulfilment expected
  ```
  """
  defmacro assert_subscription_fulfilment(expected) do
    quote do
      assert_push("subscription:data", unquote(expected))
    end
  end

  @doc """
  Same as assert_subscription_fulfilment but refute
  """
  defmacro refute_subscription_fulfilment(expected) do
    quote do
      refute_push("subscription:data", unquote(expected))
    end
  end
end
