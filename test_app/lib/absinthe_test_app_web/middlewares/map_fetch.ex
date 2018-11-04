defmodule AbsintheTestAppWeb.Middleware.MapFetch do
  @moduledoc """
  A stricter default resolver.
  """

  @behaviour Absinthe.Middleware

  @spec call(%{source: map(), state: any(), value: any()}, any()) :: %{
    source: map(),
    state: :resolved,
    value: any()
  }
  def call(%{source: source} = res, key) do
    %{res | state: :resolved, value: Map.fetch!(source, key)}
  end
end
