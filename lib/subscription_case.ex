defmodule Anise.SubscriptionCase do
  use ExUnit.CaseTemplate
  alias Absinthe.Phoenix.SubscriptionTest

  using(opts) do
    quote do
      use Phoenix.ChannelTest
      use Phoenix.ConnTest
      #set @endpoint
      Module.put_attribute(__MODULE__, :endpoint, Keyword.get(unquote(opts), :endpoint))

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

      def subscribe(socket, subscription_query) do
        ref = SubscriptionTest.push_doc socket, subscription_query
        Phoenix.ChannelTest.assert_reply(ref, :ok, _)
      end

      defmacro assert_subscription_fulfilment(expected) do
        quote do
          assert_push "subscription:data", unquote(expected) 
        end
      end

      defmacro refute_subscription_fulfilment(expected) do
        quote do
          refute_push "subscription:data", unquote(expected) 
        end
      end
    end
  end
end
