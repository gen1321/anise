defmodule AbsintheTestAppWeb.Schema do
  use Absinthe.Schema

  alias AbsintheTestApp.User

  object :user do
    field(:email, non_null(:string))
    field(:name, non_null(:string))
  end

  query do
    field :user, :user do
      resolve(fn _, _, _ ->
        {:ok, %User{email: "test@email.com", name: "testname"}}
      end)
    end
  end

  mutation do
    field :create_user, :user do
      arg(:email, non_null(:string))
      arg(:name, non_null(:string))

      resolve(fn _, %{email: email, name: name}, _ ->
        {:ok, %User{email: email, name: name}}
      end)
    end
  end

  subscription do
    field :user_added, :user do
      config(fn args, _ ->
        {:ok, topic: "*"}
      end)

      trigger(:create_user,
        topic: fn _ ->
          "*"
        end
      )

      resolve(fn user, _, _ ->
        {:ok, user}
      end)
    end
  end
end
