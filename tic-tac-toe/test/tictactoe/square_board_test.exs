defmodule SquareBoardTest do
  use ExUnit.Case

  @a1 Space.on_grid(1, 1)
  @b1 Space.on_grid(1, 2)
  @a2 Space.on_grid(2, 1)
  @b2 Space.on_grid(2, 2)

  describe "#new/1" do
    test "returns a SquareBoard that is the specified number of spaces on a side" do
      board = SquareBoard.new(2)
      assert %SquareBoard{} = board
      assert 4 = length(GameState.available_spaces(board))
    end
  end

  describe "#player_rows/1" do
    test "returns an empty List when the board has no size" do
      board = SquareBoard.new(0)
      assert [] = SquareBoard.player_rows(board)
    end

    test "returns a List of row Lists" do
      board = SquareBoard.new(2)
      assert [[_, _], [_, _]] = SquareBoard.player_rows(board)
    end

    test "shows players occupying spaces by their symbols" do
      board =
        SquareBoard.new(1)
        |> GameState.place_symbol("X", @a1)

      assert [["X"]] = SquareBoard.player_rows(board)
    end

    test "it uses false for spaces with no owner" do
      board = SquareBoard.new(1)
      assert [[false]] = SquareBoard.player_rows(board)
    end
  end

  describe "GameState#available_spaces/1" do
    test "a 0x0 board has no available spaces" do
      board = SquareBoard.new(0)
      assert [] = GameState.available_spaces(board)
    end

    test "returns Spaces that identify their position on the game board" do
      board = SquareBoard.new(1)
      assert [@a1] = GameState.available_spaces(board)
    end

    test "an empty board has all its spaces available" do
      available_spaces =
        SquareBoard.new(2)
        |> GameState.available_spaces()
        |> MapSet.new()

      assert MapSet.equal?(available_spaces, MapSet.new([@a1, @b1, @a2, @b2]))
    end
  end

  describe "GameState#find_winner/1" do
    test "returns false for a 0x0 board" do
      board = SquareBoard.new(0)
      assert GameState.find_winner(board) == false
    end

    test "returns the symbol of a player holding the only space of a 1x1 board" do
      winner =
        SquareBoard.new(1)
        |> GameState.place_symbol("X", @a1)
        |> GameState.find_winner()

      assert winner == "X"
    end

    test "returns the symbol of a player holding all spaces in the first row" do
      winner =
        SquareBoard.new(2)
        |> GameState.place_symbol("X", @a1)
        |> GameState.place_symbol("X", @b1)
        |> GameState.find_winner()

      assert winner == "X"
    end

    test "returns the symbol of a player holding all spaces in the same row" do
      winner =
        SquareBoard.new(2)
        |> GameState.place_symbol("X", @a2)
        |> GameState.place_symbol("X", @b2)
        |> GameState.find_winner()

      assert winner == "X"
    end

    test "returns the symbol of a player holding all spaces in the first column" do
      winner =
        SquareBoard.new(2)
        |> GameState.place_symbol("X", @a1)
        |> GameState.place_symbol("X", @a2)
        |> GameState.find_winner()

      assert winner == "X"
    end

    test "returns the symbol of a player holding all spaces in the same column" do
      winner =
        SquareBoard.new(2)
        |> GameState.place_symbol("X", @b1)
        |> GameState.place_symbol("X", @b2)
        |> GameState.find_winner()

      assert winner == "X"
    end

    test "returns the symbol of a player holding all spaces in the \ diagnonal" do
      winner =
        SquareBoard.new(2)
        |> GameState.place_symbol("X", @a1)
        |> GameState.place_symbol("X", @b2)
        |> GameState.find_winner()

      assert winner == "X"
    end

    test "returns the symbol of a player holding all spaces in the / diagnonal" do
      winner =
        SquareBoard.new(2)
        |> GameState.place_symbol("X", @a2)
        |> GameState.place_symbol("X", @b1)
        |> GameState.find_winner()

      assert winner == "X"
    end

    test "returns false no line is owned by the same player" do
      winner =
        SquareBoard.new(2)
        |> GameState.place_symbol("X", @a1)
        |> GameState.place_symbol("O", @b1)
        |> GameState.find_winner()

      assert winner == false
    end
  end

  describe "GameState#is_over?/1" do
    test "returns true for a 0x0 board" do
      board = SquareBoard.new(0)
      assert GameState.is_over?(board) == true
    end

    test "returns false for a board with available spaces and no winner" do
      board = SquareBoard.new(1)
      assert GameState.is_over?(board) == false
    end

    test "returns true for a board that has no available spaces" do
      is_over =
        SquareBoard.new(1)
        |> GameState.place_symbol("X", @a1)
        |> GameState.is_over?()

      assert is_over == true
    end

    test "returns true for a board that has a winner" do
      is_over =
        SquareBoard.new(2)
        |> GameState.place_symbol("X", @a1)
        |> GameState.place_symbol("X", @b1)
        |> GameState.is_over?()

      assert is_over == true
    end
  end

  describe "GameState#place_symbol/3" do
    test "returns a SquareBoard without any available spaces, given the only available space" do
      remaining_spaces =
        SquareBoard.new(1)
        |> GameState.place_symbol("X", @a1)
        |> GameState.available_spaces()

      assert remaining_spaces == []
    end

    test "returns a board where the player owns an available space in the first row" do
      remaining_spaces =
        SquareBoard.new(2)
        |> GameState.place_symbol("X", @b1)
        |> GameState.available_spaces()
        |> MapSet.new()

      assert MapSet.equal?(remaining_spaces, MapSet.new([@a1, @a2, @b2]))
    end

    test "returns a board where the player owns an available space in the first column" do
      remaining_spaces =
        SquareBoard.new(2)
        |> GameState.place_symbol("X", @a2)
        |> GameState.available_spaces()
        |> MapSet.new()

      assert MapSet.equal?(remaining_spaces, MapSet.new([@a1, @b1, @b2]))
    end
  end

  def with_string_io(_context) do
    case StringIO.open("") do
      {:ok, io} -> %{io: io}
    end
  end
end
