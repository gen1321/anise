defmodule Anise do
  defmacro __using__(_opts) do
    import Phoenix.ConnTest
    quote do
      def graphql(conn, endpoint, query) do
        post(conn ,endpoint, %{query: query})
      end

      def graphql(conn, endpoint, query, variables) do
        post(conn, endpoint, %{query: query, variables: variables})
      end
    end
  end
end
