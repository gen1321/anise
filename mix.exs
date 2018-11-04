defmodule Anise.MixProject do
  use Mix.Project

  def project do
    [
      app: :anise,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:absinthe_phoenix, "~> 1.4.0"}
    ]
  end

  defp description do
    """
    Library for testing Absinthe Graphql API
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Boris Beginin"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/gen1321/anise"}
    ]
  end
end
