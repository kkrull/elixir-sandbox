defprotocol Herald do
  @moduledoc "Announces game events."

  def draw_game(herald)
  def next_turn(herald, player)
  def game_started(herald, board)
  def turn_completed(herald, board)
  def winner(herald, player_symbol)
end
