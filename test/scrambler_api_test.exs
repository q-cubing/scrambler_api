defmodule ScramblerApiTest do
  use ExUnit.Case
  doctest ScramblerApi

  test "greets the world" do
    assert ScramblerApi.hello() == :world
  end
end
