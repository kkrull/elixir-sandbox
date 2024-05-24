defprotocol GameState do
  @moduledoc """
  Inspects the current state of the game board and provides a way to get to the next state by picking a space.
  """

  def available_spaces(game)
  def find_winner(game)
  def is_over?(game)
  def place_symbol(game, player, space)
end
