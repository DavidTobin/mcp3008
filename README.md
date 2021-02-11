# Mcp3008

This library allows interfacing with the MCP3008 analog to digital converter module on a Raspberry PI.

## Installation

Add the library to your `mix.exs`.
```elixir
def deps do
  [
    {:mcp3008, "~> 0.1.0"}
  ]
end
```

Add the server to your supervision tree and specify a CLK port value.

```elixir
def children() do
  [
    {Mcp3008.Server, [port]}
  ]
end
```

## Documentation

[https://hexdocs.pm/mcp3008](https://hexdocs.pm/mcp3008).

