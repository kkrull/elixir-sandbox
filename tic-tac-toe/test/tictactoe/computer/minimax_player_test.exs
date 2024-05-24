defmodule MinimaxPlayerTest do
  use ExUnit.Case

  @a1 Space.on_grid(1, 1)
  @b1 Space.on_grid(1, 2)

  @a2 Space.on_grid(2, 1)
  @b2 Space.on_grid(2, 2)

  describe "#new/2" do
    test "returns a MinimaxPlayer with the specified player symbols" do
      assert %MinimaxPlayer{} = MinimaxPlayer.new(:minimax, "C", "H")
    end
  end

  describe "Player#pick_space/2" do
    setup do
      %{minimax: start_supervised!({MinimaxMock, []})}
    end

    test "returns an error tuple when no spaces are available", context do
      player = MinimaxPlayer.new(context.minimax, "C", "H")
      board = SquareBoard.new(0)
      assert {:error, "no spaces available"} = Player.pick_space(player, board)
    end

    test "returns a game board, when at least 1 space is available", context do
      new_board =
        MinimaxPlayer.new(context.minimax, "C", "H")
        |> Player.pick_space(SquareBoard.new(1))

      assert %SquareBoard{} = new_board
    end

    test "picks a space on the board, when at least 1 space is available", context do
      new_board =
        MinimaxPlayer.new(context.minimax, "C", "H")
        |> Player.pick_space(SquareBoard.new(1))

      assert GameState.available_spaces(new_board) == []
      assert GameState.find_winner(new_board) === "C"
    end

    test "uses Minimax to score opponent responses to reachable game states", context do
      initial_board = SquareBoard.new(1)
      player = MinimaxPlayer.new(context.minimax, "C", "H")
      Player.pick_space(player, initial_board)

      child_board = GameState.place_symbol(initial_board, "C", @a1)
      MinimaxMock.score_should_have_received(context.minimax, child_board, "H")
    end

    test "picks the space leading to the highest score", context do
      two_spaces_left =
        SquareBoard.new(2)
        |> GameState.place_symbol("H", @a1)
        |> GameState.place_symbol("C", @b1)

      # Imagine a game where you can only win with a vertical line
      draw = GameState.place_symbol(two_spaces_left, "C", @a2)
      MinimaxMock.set_score(context.minimax, draw, 0)
      computer_wins = GameState.place_symbol(two_spaces_left, "C", @b2)
      MinimaxMock.set_score(context.minimax, computer_wins, 1000)

      player = MinimaxPlayer.new(context.minimax, "C", "H")
      resulting_board = Player.pick_space(player, two_spaces_left)
      assert ^computer_wins = resulting_board
    end
  end
end
