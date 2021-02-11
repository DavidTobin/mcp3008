defmodule Mcp3008.DeviceTest do
  use ExUnit.Case
  doctest Mcp3008.Device

  alias Mcp3008.Device

  test "expects a valid channel to be provided to read_channel" do
    assert Device.read_channel(8, make_ref(), make_ref()) ==
             {:error, :invalid_channel_read}

    assert Device.read_channel(:hello, make_ref(), make_ref()) ==
             {:error, :invalid_channel_read}

    assert Device.read_channel({1, 2}, make_ref(), make_ref()) ==
             {:error, :invalid_channel_read}

    assert Device.read_channel(-1, make_ref(), make_ref()) ==
             {:error, :invalid_channel_read}
  end
end
