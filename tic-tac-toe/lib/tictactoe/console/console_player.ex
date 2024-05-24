defmodule ConsolePlayer do
  @moduledoc "A player that picks moves by writing to an IO process."

  defstruct [:io, :symbol]

  def new(io, symbol) do
    %ConsolePlayer{
      io: io,
      symbol: symbol
    }
  end

  defimpl Player do
    def pick_space(player, board) do
      IO.write(player.io, "Please enter the coordiantes of an available space: ")
      input_text = IO.read(player.io, :line)

      case Space.parse(input_text) do
        {:ok, space} ->
          if Enum.member?(GameState.available_spaces(board), space) do
            GameState.place_symbol(board, player.symbol, space)
          else
            IO.puts(player.io, "#{space.id} is not available")
            pick_space(player, board)
          end

        {:error, message} ->
          IO.puts(player.io, message)
          pick_space(player, board)
      end
    end

    def symbol(player), do: player.symbol
  end
end
