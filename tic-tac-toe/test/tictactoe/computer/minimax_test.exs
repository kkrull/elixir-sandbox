defmodule MinimaxTest do
  use ExUnit.Case

  describe "#start_link/1" do
    setup [:player_context, :minimax_context]

    test "starts a Minimax Process", context do
      assert Process.alive?(context.scorer) === true
    end
  end

  describe "#score/3" do
    setup [:player_context, :minimax_context]

    test "scores a game ending in a draw as 0", context do
      game = %GameWithKnownStates{is_over: true}
      assert Minimax.score(context.scorer, game, context.max) === 0
    end

    test "scores a game won by the maximizing player as +1", context do
      game = %GameWithKnownStates{is_over: true, winner: context.max}
      assert Minimax.score(context.scorer, game, context.max) === 1
    end

    test "scores a game won by the minimizing player as -1", context do
      game = %GameWithKnownStates{is_over: true, winner: context.min}
      assert Minimax.score(context.scorer, game, context.max) === -1
    end

    test "scores an unfinished game", context do
      game =
        %GameWithKnownStates{}
        |> GameWithKnownStates.add_known_state("Draw", %GameWithKnownStates{is_over: true})

      assert Minimax.score(context.scorer, game, context.max) === 0
    end

    test "the maximizing player picks the space with the highest score", context do
      game =
        %GameWithKnownStates{}
        |> GameWithKnownStates.add_known_state("Draw", %GameWithKnownStates{is_over: true})
        |> GameWithKnownStates.add_known_state("MaxWins", GameWithKnownStates.won_by(context.max))

      assert Minimax.score(context.scorer, game, context.max) === 1
    end

    test "the minimizing player picks the space with the lowest score", context do
      game =
        %GameWithKnownStates{}
        |> GameWithKnownStates.add_known_state("Draw", %GameWithKnownStates{is_over: true})
        |> GameWithKnownStates.add_known_state("Min", GameWithKnownStates.won_by(context.min))

      assert Minimax.score(context.scorer, game, context.min) === -1
    end

    test "the maximizing player assumes the minimizing player picks the lowest score", context do
      game = game_with_2_moves_remaining(context)
      assert Minimax.score(context.scorer, game, context.max) === 0
    end

    test "the minimizing player assumes the maximizing player picks the highest score", context do
      game = game_with_2_moves_remaining(context)
      assert Minimax.score(context.scorer, game, context.min) === 0
    end

    defp game_with_2_moves_remaining(context) do
      left_tree =
        %GameWithKnownStates{}
        |> GameWithKnownStates.add_known_state("Draw", %GameWithKnownStates{is_over: true})
        |> GameWithKnownStates.add_known_state("Max", GameWithKnownStates.won_by(context.max))

      right_tree =
        %GameWithKnownStates{}
        |> GameWithKnownStates.add_known_state("Draw", %GameWithKnownStates{is_over: true})
        |> GameWithKnownStates.add_known_state("Min", GameWithKnownStates.won_by(context.min))

      %GameWithKnownStates{}
      |> GameWithKnownStates.add_known_state("Left", left_tree)
      |> GameWithKnownStates.add_known_state("Right", right_tree)
    end
  end

  defp minimax_context(context) do
    %{scorer: start_supervised!({Minimax, [context.max, context.min]})}
  end

  defp player_context(_context) do
    %{
      max: "Max",
      min: "Min"
    }
  end
end
