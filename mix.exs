defmodule FilePreviews.Mixfile do
  use Mix.Project

  def project do
    [
      app: :filepreviews,
      version: "1.0.1",
      elixir: "~> 1.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.7.1"},
      {:poison, "~> 3.1.0"},
      {:exvcr, "~> 0.4.0", only: :test},
      {:ex_doc, "~> 0.19.1", only: :dev}
    ]
  end

  defp description do
    """
    FilePreviews.io API client library for Elixir.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["José Padilla"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/GetBlimp/filepreviews-elixir"}
    ]
  end
end
