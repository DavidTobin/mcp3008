defmodule Mcp3008.MixProject do
  use Mix.Project

  def project do
    [
      app: :mcp3008,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

      # Docs
      name: "MCP3008 ADC Library",
      homepage: "https://github.com/davidtobin/mcp3008.git",
      docs: [main: "Mcp3008"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/davidtobin/mcp3008"},
      description:
        "This library allows interfacing with the MCP3008 analog to digital converter module on a Raspberry PI."
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_gpio, "~> 0.4"},
      {:circuits_spi, "~> 0.1"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end
