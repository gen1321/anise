defmodule Anise do
  @moduledoc """
   Anis is a set of helpers/aseertions for Absinthe
  """

  @doc """
    Creates `graphql` funtcions that performs request.

  ```elixir
    graphql(conn, "/api", @mutation, %{email: "test@example.com", name: "Boris"})
  ```
  """
  defmacro __using__(_opts) do
    import Phoenix.ConnTest, only: [post: 3]

    quote do
      def graphql(conn, endpoint, query) do
        post(conn, endpoint, %{query: query})
      end

      def graphql(conn, endpoint, query, variables) do
        post(conn, endpoint, %{query: query, variables: variables})
      end
    end
  end
end
