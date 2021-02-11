defmodule Mcp3008 do
  @moduledoc """
  This library allows interfacing with the MCP3008 analog to digital converter module on a Raspberry PI.

  ## Example

    To get started, add the server to your supervision tree and specify a CLK port value.

    ```
    def children() do
      [
        {Mcp3008.Server, clk_port}
      ]
    end
  ```
  """

  @doc """
  Reads from the specified channel. To read a value in differential mode, pass a tuple with the specified ports. In single mode, the channel must be a value between 0-7. Valid differential mode values are:


  {0, 1} => CH0+, CH1-

  {1, 0} => CH0-, CH1+

  {2, 3} => CH2+, CH3-

  {3, 2} => CH2-, CH3+

  {4, 5} => CH4+, CH5-

  {5, 4} => CH4-, CH5+

  {6, 7} => CH6+, CH6-

  {7, 6} => CH6-, CH7+


  ## Examples

      # CH0
      iex> Mcp3008.read_channel(0)
      500

      # {CH0 = IN+, CH1 = IN-}
      iex> Mcp3008.read_channel({0, 1})
      500

      # {CH0 = IN-, CH1 = IN+}
      iex> Mcp3008.read_channel({1, 0})
      500
  """
  @spec read_channel(pos_integer() | {pos_integer(), pos_integer}) ::
          {:ok, pos_integer()} | {:error, atom()}
  def read_channel(channel) do
    Mcp3008.Server.read_channel_value(channel)
  end
end
