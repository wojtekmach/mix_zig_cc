defmodule MixZigCCTest do
  use ExUnit.Case
  doctest MixZigCC

  test "greets the world" do
    assert MixZigCC.hello() == :world
  end
end
