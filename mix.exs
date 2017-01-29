defmodule Exads.Mixfile do
  use Mix.Project

  def project do
    [app: :exads,
     version: "0.0.1",
     elixir: "~> 1.1-dev",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     dialyzer: dialyzer()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Configuration of the `dialyxir`-package
  def dialyzer do
    [plt_file: {:no_warn, "./plt/.local.plt"}, ignore_warnings: "dialyzer.ignore-warnings"]
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
      {:dialyxir, "~> 0.4", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev},
      {:earmark, "~> 1.0", only: :dev},
      {:inch_ex, "~> 0.5", only: :dev},
      {:credo, "~> 0.5", only: :dev}
    ]
  end
end
