defmodule GameTest do
  use ExUnit.Case

  @a1 Space.on_grid(1, 1)
  @b1 Space.on_grid(1, 2)

  describe "#play/2" do
    setup [:with_collaborators, :with_game]

    test "tells the Herald when a game has started", context do
      draw_board = %GameWithKnownStates{is_over: true}
      Game.play(context.game, draw_board)
      assert HeraldSpy.game_started_board(context.herald) === draw_board
    end

    test "tells the Herald when a game has eneded in a draw", context do
      draw_board = %GameWithKnownStates{is_over: true}
      Game.play(context.game, draw_board)
      assert HeraldSpy.game_result(context.herald) === :draw
    end

    test "returns the game's winner, when the game has been won", context do
      player_one_won = %GameWithKnownStates{is_over: true, winner: context.player_one}
      Game.play(context.game, player_one_won)

      player = context.player_one
      assert {:winner, ^player} = HeraldSpy.game_result(context.herald)
    end

    test "has the current player pick a space, when the game is not over", context do
      next_board = %GameWithKnownStates{is_over: true}

      initial_board =
        %GameWithKnownStates{}
        |> GameWithKnownStates.add_known_state(@a1, next_board)

      PlayerSpy.pick_space_returns(context.player_one, next_board)
      Game.play(context.game, initial_board)

      symbol_one = Player.symbol(context.player_one)
      assert PlayerSpy.pick_space_symbols(context.player_one) === [symbol_one]
    end

    test "tells the Herald whose turn it is and what the new board looks like", context do
      next_board = %GameWithKnownStates{is_over: true}

      initial_board =
        %GameWithKnownStates{}
        |> GameWithKnownStates.add_known_state(@a1, next_board)

      PlayerSpy.pick_space_returns(context.player_one, next_board)
      Game.play(context.game, initial_board)
      assert HeraldSpy.current_player(context.herald) === context.player_one
      assert HeraldSpy.turn_completed_boards(context.herald) === [next_board]
    end

    test "alternates players until the game is over", context do
      second_move = %GameWithKnownStates{is_over: true}

      first_move =
        %GameWithKnownStates{}
        |> GameWithKnownStates.add_known_state(@b1, second_move)

      initial_board =
        %GameWithKnownStates{}
        |> GameWithKnownStates.add_known_state(@a1, first_move)

      PlayerSpy.pick_space_returns(context.player_one, first_move)
      PlayerSpy.pick_space_returns(context.player_two, second_move)

      Game.play(context.game, initial_board)

      assert PlayerSpy.pick_space_symbols(context.player_one) === [
               Player.symbol(context.player_one),
               Player.symbol(context.player_two)
             ]

      assert HeraldSpy.current_player(context.herald) === context.player_two
    end
  end

  def with_collaborators(_context) do
    herald_server = start_supervised!({HeraldSpy.Server, []})
    player_server = start_supervised!({PlayerSpy.Server, []})

    %{
      herald: HeraldSpy.new(herald_server),
      player_one: PlayerSpy.new("A", player_server),
      player_two: PlayerSpy.new("B", player_server)
    }
  end

  def with_game(context) do
    %{game: Game.new(context.herald, context.player_one, context.player_two)}
  end
end
