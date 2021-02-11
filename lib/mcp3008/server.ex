defmodule Mcp3008.Server do
  use GenServer

  alias Circuits.{SPI, GPIO}
  alias Mcp3008.Device

  defmodule State do
    @moduledoc false
    defstruct spi: nil, port: nil
  end

  @type t :: pid()

  # Public API

  @spec start_link(pos_integer) :: {:ok, t()} | GenServer.on_start()
  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
  end

  @spec read_channel_value(pos_integer()) :: {:ok, pos_integer()} | {:error, atom()}
  def read_channel_value(channel) do
    GenServer.call(__MODULE__, {:get_channel, channel})
  end

  # Gen server

  @impl true
  def terminate(_, %State{spi: spi, port: port}) do
    SPI.close(spi)
    GPIO.close(port)
  end

  @impl true
  def init(port) do
    with {:ok, port} <- GPIO.open(port, :output),
         {:ok, ref} <-
           (
             GPIO.write(port, 0)
             GPIO.write(port, 1)

             SPI.open("spidev0.0")
           ) do
      {:ok, %State{spi: ref, port: port}}
    else
      error -> error
    end
  end

  @impl true
  def handle_call({:get_channel, channel}, _from, %State{spi: spi, port: port} = state) do
    {:reply, Device.read_channel(channel, spi, port), state}
  end
end
