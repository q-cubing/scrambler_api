defmodule ScramblerApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :scrambler_api,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ScramblerApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.14"},
      {:plug_cowboy, "~> 2.0"},
      {:scrambler, git: "https://github.com/q-cubing/scrambler.git"},
      {:jason, "~> 1.4"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end
end
