defmodule Mcp3008.Device do
  alias Circuits.{SPI, GPIO}

  @start_bit 0b00000001
  @junk 0b00000000

  # Table 5-2 from datasheet
  @single_mode_channel_map %{
    0 => 0b10000000,
    1 => 0b10010000,
    2 => 0b10100000,
    3 => 0b10110000,
    4 => 0b11000000,
    5 => 0b11010000,
    6 => 0b11100000,
    7 => 0b11110000
  }

  @differential_channel_map %{
    {0, 1} => 0b00000000,
    {1, 0} => 0b00010000,
    {2, 3} => 0b00100000,
    {3, 2} => 0b00110000,
    {4, 5} => 0b01000000,
    {5, 4} => 0b01010000,
    {6, 7} => 0b01100000,
    {7, 6} => 0b01110000
  }
  @spec read_channel(pos_integer | {pos_integer, pos_integer}, reference(), reference()) ::
          {:ok, pos_integer() | {:error, atom()}}
  def read_channel(channel, spi, port) do
    with {:ok, byte} <- get_channel_byte(channel),
         {:ok, value} <- spi_transfer(byte, spi, port) do
      {:ok, value}
    else
      {:error, error} -> {:error, error}
      _ -> {:error, :unexpected_error}
    end
  end

  # Private
  @spec spi_transfer(integer(), reference(), reference()) ::
          {:error, :invalid_spi_transfer} | {:ok, char()}
  defp spi_transfer(channel_byte, spi, port) do
    GPIO.write(port, 0)

    value =
      case SPI.transfer(spi, <<@start_bit, channel_byte, @junk>>) do
        {:ok, <<_::size(14), value::size(10)>>} ->
          {:ok, value}

        _ ->
          {:error, :invalid_spi_transfer}
      end

    GPIO.write(port, 1)

    Process.sleep(10)

    value
  end

  @spec get_channel_byte(pos_integer() | {pos_integer, pos_integer}) ::
          {:ok, integer()} | {:error, atom()}
  defp get_channel_byte({ch1, ch2}) when ch1 >= 0 and ch2 >= 0 and ch1 <= 7 and ch2 <= 7 do
    case @differential_channel_map[{ch1, ch2}] do
      nil ->
        {:error, :invalid_channel_read}

      byte ->
        {:ok, byte}
    end
  end

  defp get_channel_byte({_ch1, _ch2}), do: {:error, :invalid_channel_read}

  defp get_channel_byte(ch) when is_integer(ch) and ch >= 0 and ch <= 7 do
    {:ok, @single_mode_channel_map[ch]}
  end

  defp get_channel_byte(_channel) do
    {:error, :invalid_channel_read}
  end
end
