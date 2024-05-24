defmodule GameWithKnownStates do
  @moduledoc "A pre-determined tree of game states."

  defstruct is_over: false,
            next_games: [],
            open_spaces: [],
            winner: false

  def new do
    %GameWithKnownStates{}
  end

  def won_by(winner) do
    %GameWithKnownStates{is_over: true, winner: winner}
  end

  def add_known_state(game, space, next_game) do
    %GameWithKnownStates{
      game
      | next_games: game.next_games ++ [next_game],
        open_spaces: game.open_spaces ++ [space]
    }
  end

  defimpl GameState do
    def available_spaces(game), do: game.open_spaces
    def find_winner(game), do: game.winner
    def is_over?(game), do: game.is_over

    def place_symbol(game, _player, space),
      do: @for.fetch_game!(space, game.open_spaces, game.next_games)
  end

  def fetch_game!(space, open_spaces, next_games) do
    case open_spaces do
      [] ->
        raise ArgumentError, "unknown space: #{space}}"

      [^space | _] ->
        hd(next_games)

      [_ | tail] ->
        fetch_game!(space, tail, tl(next_games))
    end
  end
end
