defmodule HelloWorldTest do
  use ExUnit.Case

  test "greets the world" do
    assert HelloWorld.hello() === "Hello World!"
  end
end
