defmodule AbsintheTestAppWeb.Router do
  use AbsintheTestAppWeb, :router
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api
    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: AbsintheTestAppWeb.Schema,
    )
    forward("/", Absinthe.Plug, schema: AbsintheTestAppWeb.Schema)
  end
end
