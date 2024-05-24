defprotocol Player do
  @moduledoc "Picks spaces on a game board."

  def pick_space(player, board)
  def symbol(player)
end
