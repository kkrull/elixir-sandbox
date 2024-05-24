defmodule MinimaxPlayer do
  @moduledoc "Uses Minimax to pick an optimal space, for a game in a given state of possible moves and outcomes."

  defstruct [:minimax_pid, :own_symbol, :opponent_symbol]

  def new(minimax_pid, own_symbol, opponent_symbol) do
    %MinimaxPlayer{
      minimax_pid: minimax_pid,
      own_symbol: own_symbol,
      opponent_symbol: opponent_symbol
    }
  end

  defimpl Player do
    def pick_space(player, current_board) do
      case GameState.available_spaces(current_board) do
        [] ->
          {:error, "no spaces available"}

        spaces ->
          next_boards =
            Enum.map(spaces, fn space ->
              GameState.place_symbol(current_board, player.own_symbol, space)
            end)

          next_scores =
            Enum.map(
              next_boards,
              fn board -> Minimax.score(player.minimax_pid, board, player.opponent_symbol) end
            )

          pick_board_with_highest_score(next_boards, next_scores)
      end
    end

    defp pick_board_with_highest_score(boards, scores) do
      Enum.zip(boards, scores)
      |> Enum.reduce(fn x, best -> if elem(x, 1) > elem(best, 1), do: x, else: best end)
      |> elem(0)
    end

    def symbol(player), do: player.own_symbol
  end
end
