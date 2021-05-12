defmodule HelloTest do
  use ExUnit.Case, async: true

  test "it works" do
    assert Hello.hello() == :world
  end
end
