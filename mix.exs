defmodule Exads.Mixfile do
  use Mix.Project

  def project do
    [app: :exads,
     version: "0.0.1",
     elixir: "~> 1.1-dev",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     dialyzer: dialyzer]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Configuration of the `dialyxir`-package
  def dialyzer do
    [plt_file: "./plt/.local.plt"]
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
      {:dialyxir, "~> 0.3.3", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:earmark, "~> 0.1", only: :dev},
      {:inch_ex, "~> 0.5", only: [:dev, :test]},
      {:credo, "~> 0.3", only: [:dev, :test]},
    ]
  end
end
