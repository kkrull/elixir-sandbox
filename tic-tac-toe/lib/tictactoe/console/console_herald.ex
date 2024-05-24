defmodule ConsoleHerald do
  @moduledoc "Announces game events to a text stream on the console."

  defstruct [:io]

  def new(io) do
    %ConsoleHerald{io: io}
  end

  defimpl Herald do
    def draw_game(herald),
      do: IO.puts(herald.io, "Draw")

    def game_started(herald, board),
      do: draw_board(herald, board)

    def next_turn(herald, player),
      do: IO.puts(herald.io, "\nYour turn, #{Player.symbol(player)}")

    def winner(herald, player_symbol),
      do: IO.puts(herald.io, "#{player_symbol} wins!")

    def turn_completed(herald, board),
      do: draw_board(herald, board)

    defp draw_board(herald, board) do
      case SquareBoard.player_rows(board) do
        [] ->
          :ok

        [first_row | other_rows] ->
          puts_trimmed(herald.io, column_letters_row(first_row))
          puts_trimmed(herald.io, horizontal_border(first_row))

          puts_trimmed(herald.io, board_row(first_row, 1))
          Enum.each(spaced_rows(other_rows, 2), fn line -> puts_trimmed(herald.io, line) end)

          puts_trimmed(herald.io, horizontal_border(first_row))
      end
    end

    defp puts_trimmed(io, line_with_trailing_whitespace) do
      IO.puts(io, String.trim_trailing(line_with_trailing_whitespace))
    end

    defp spaced_rows(rows, start_at_number) do
      rows
      |> Enum.with_index(start_at_number)
      |> Enum.reduce(
        [],
        fn {row, number}, lines ->
          lines ++ [horizonal_separator(row)] ++ [board_row(row, number)]
        end
      )
    end

    @blank_row_label "  "
    @blank_vertical_border " "
    defp column_letters_row(row) do
      letters =
        row
        |> Enum.with_index(1)
        |> Enum.map(fn {_, c} -> Space.on_grid(1, c) end)
        |> Enum.map(fn space -> space.column_letter end)
        |> Enum.map(fn letter -> " #{letter} " end)
        |> Enum.join(" ")

      @blank_row_label <> @blank_vertical_border <> letters
    end

    @intersection "+"
    @horizontal_border "---"
    @between_cells_on_horizontal_border "-"
    defp horizontal_border(row) do
      cells =
        row
        |> Enum.map(fn _ -> @horizontal_border end)
        |> Enum.join(@between_cells_on_horizontal_border)

      @blank_row_label <> @intersection <> cells <> @intersection
    end

    @vertical_separator "|"
    @horizontal_separator "==="
    defp horizonal_separator(row) do
      cells =
        row
        |> Enum.map(fn _ -> @horizontal_separator end)
        |> Enum.join(@intersection)

      @blank_row_label <> @vertical_separator <> cells <> @vertical_separator
    end

    @empty_cell "   "
    @open_space false
    defp board_row(row, row_number) do
      cells =
        for owner <- row do
          if owner === @open_space, do: @empty_cell, else: " #{owner} "
        end

      padded_cells = Enum.join(cells, @vertical_separator)
      "#{row_number} " <> @vertical_separator <> padded_cells <> @vertical_separator
    end
  end
end
