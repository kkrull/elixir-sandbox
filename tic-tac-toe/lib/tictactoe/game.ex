defmodule Game do
  @moduledoc "Alternates turns in a 2 player game until the game is over."

  defstruct [:herald, :player_one, :player_two]

  def new(herald, player_one, player_two) do
    %{
      herald: herald,
      player_one: player_one,
      player_two: player_two
    }
  end

  def play(game, board) do
    Herald.game_started(game.herald, board)
    play(game, board, game.player_one, game.player_two)
  end

  def play(game, board, current_player, opponent) do
    cond do
      winner = GameState.find_winner(board) ->
        Herald.winner(game.herald, winner)

      GameState.is_over?(board) ->
        Herald.draw_game(game.herald)

      true ->
        Herald.next_turn(game.herald, current_player)
        next_board = Player.pick_space(current_player, board)
        Herald.turn_completed(game.herald, next_board)
        play(game, next_board, opponent, current_player)
    end
  end
end

