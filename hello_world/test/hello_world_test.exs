defmodule HelloWorldTest do
  use ExUnit.Case

  describe "HelloWorld.hello/0" do
    test "greets the world" do
      assert HelloWorld.hello() === "Hello World!"
    end
  end

  describe "HelloWorld.hello/1" do
    test "greets a person by the given name" do
      assert HelloWorld.hello("George") === "Hello George!"
    end
  end
end
