defmodule TimeshiftCLI.MixProject do
  use Mix.Project

  def project do
    [
      app: :timeshift_cli,
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
      {:google_api_sheets, "~> 0.0.1"},
      {:goth, "~> 0.11.0"},
      {:poison, "~> 3.0"},
      {:timex, "~> 3.1"},
      {:exvcr, "~> 0.10", only: :test}
    ]
  end
end
