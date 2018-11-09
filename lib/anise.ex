defmodule Anise do
  @moduledoc """
   Anis is a set of helpers/assertions for Absinthe
  """

  @doc """
    Creates `graphql` functions that performs request.

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

      @doc """
      builds a query that can be used to be sent to the server
      * operation_type is either :query or :mutation (the two valid operations
      for GraphQL)
      * operation_name is the name of the operation and should match the
      resolver action
      * args is a list of tuples `{key, type}` describing the variables expected
      by the operation
      * keys is a list of keys we expect to receive as reply from the server

      ```elixir
        # basic query to request Star Wars heroes
        iex> build_query(:query, "allHeroes", [], ~w(id name))
        query allHeroes {
          allHeroes {
            id
            name
          }
        }

        # Query specific hero
        iex> build_query(:query, "hero", [{:id, "ID!"}], ~w(id name))
        query allHeroes($id: "ID!") {
          allHeroes(id: $id) {
            id
            name
          }
        }

        # mutate hero
        iex> update_hero_query = build_query(:query, "updateHero", [{:id, "ID!"}, {:name, "String"}], ~w(id name))
        mutation updateHero($id: "ID!", $name: "String") {
          updateHero(id: $id, name: $name) {
            id
            name
          }
        }
        # You can then call graphql(conn, @endpoint, update_hero_query, %{id: 1, name: "Luke Vador"})
      ```
      """
      def build_query(operation_type, operation_name, args, keys) do
        """
        #{operation_type} #{operation_name}#{sanitize_types(args)} {
          #{operation_name}#{sanitize_args(args)} {
            #{Enum.join(keys, ",\n")}
          }
        }
        """
      end

      defp sanitize_types(nil), do: ""

      defp sanitize_types(list) do
        types = list |> Enum.map(fn {key, type} -> "$#{key}: #{type}" end) |> Enum.join(", ")
        "(#{types})"
      end

      defp sanitize_args(nil), do: ""

      defp sanitize_args(list) when is_list(list) do
        args = list |> Enum.map(fn {key, _type} -> "#{key}: $#{key}" end) |> Enum.join(", ")
        "(#{args})"
      end

      defp build_request(query, variables) do
        %{
          "query" => query,
          "variables" => variables
        }
      end
    end
  end
end
