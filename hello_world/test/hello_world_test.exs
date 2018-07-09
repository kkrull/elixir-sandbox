defmodule HelloWorldTest do
  use ExUnit.Case

  test "greets the world when no name is given" do
    assert HelloWorld.hello() === "Hello World!"
  end

  test "greets a person by name when a name is given" do
    assert HelloWorld.hello("George") === "Hello George!"
  end
end
