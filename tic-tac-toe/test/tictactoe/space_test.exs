defmodule SpaceTest do
  use ExUnit.Case

  describe "#on_grid/2" do
    test "returns a Space at the specified grid position" do
      assert %Space{row_number: 1, column_number: 2} = Space.on_grid(1, 2)
    end
  end

  describe "#parse/1" do
    test "returns {:ok, space} when the text can be parsed" do
      assert {:ok, %Space{}} = Space.parse("A1")
    end

    test "returns {:error, message} when the text can not be parsed" do
      assert {:error, "88 is not a space"} = Space.parse("88\n")
    end

    test "parses 'A1' as the space at (1, 1)" do
      {:ok, space} = Space.parse("A1")
      assert space.row_number === 1
      assert space.column_number === 1
    end

    test "adds a row for each number over 1" do
      {:ok, space} = Space.parse("A2")
      assert space.row_number === 2
    end

    test "adds a column for each column after A" do
      {:ok, space} = Space.parse("B1")
      assert space.column_number === 2
    end

    test "Z is the last column" do
      {:ok, space} = Space.parse("Z1")
      assert space.column_number === 26
    end

    test "upcases the column letter" do
      {:ok, space} = Space.parse("a1")
      assert space.column_number === 1
    end
  end

  describe ".column_index" do
    test "returns the 0-based index of the column" do
      assert Space.on_grid(1, 1).column_index === 0
      assert Space.on_grid(1, 2).column_index === 1
    end
  end

  describe ".column_letter" do
    test "returns 'A' for the first column" do
      space = Space.on_grid(1, 1)
      assert space.column_letter === "A"
    end

    test "follows the alphabet for each column past 1" do
      space = Space.on_grid(1, 2)
      assert space.column_letter === "B"
    end
  end

  describe ".id" do
    test "returns 'A1' for the space at 1,1" do
      space = Space.on_grid(1, 1)
      assert space.id === "A1"
    end

    test "increments the row number for each row past 1" do
      space = Space.on_grid(2, 1)
      assert space.id === "A2"
    end

    test "follows the alphabet for each column past 1" do
      space = Space.on_grid(1, 2)
      assert space.id === "B1"
    end
  end

  describe ".row_index" do
    test "returns the 0-based index of the row" do
      assert Space.on_grid(1, 1).row_index === 0
      assert Space.on_grid(2, 1).row_index === 1
    end
  end
end
