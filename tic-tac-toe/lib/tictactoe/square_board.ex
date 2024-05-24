defmodule SquareBoard do
  @moduledoc "A square game board that can tell who owns which spaces whether any player has won."

  defstruct open_spaces: [], player_rows: []

  @no_owner false

  def new(edge_size) do
    rows = columns = (edge_size === 0 && []) || 1..edge_size
    spaces = for r <- rows, c <- columns, do: Space.on_grid(r, c)
    player_rows = List.duplicate(List.duplicate(@no_owner, edge_size), edge_size)

    %SquareBoard{
      open_spaces: spaces,
      player_rows: player_rows
    }
  end

  def player_rows(board) do
    board.player_rows
  end

  def player_columns(board) do
    column_indices = 0..length(board.player_rows)

    Enum.map(
      column_indices,
      fn c ->
        Enum.map(board.player_rows, fn row -> Enum.at(row, c) end)
      end
    )
  end

  def player_diagonals(board) do
    player_backslash =
      board.player_rows
      |> Enum.with_index()
      |> Enum.map(fn {row, i} -> Enum.at(row, i) end)

    player_slash =
      board.player_rows
      |> Enum.with_index()
      |> Enum.map(fn {row, i} -> Enum.at(row, length(row) - 1 - i) end)

    [player_backslash, player_slash]
  end

  defimpl GameState do
    def available_spaces(board) do
      board.open_spaces
    end

    def find_winner(board) do
      case board.player_rows do
        [] ->
          false

        rows ->
          rows
          |> Enum.concat(SquareBoard.player_columns(board))
          |> Enum.concat(SquareBoard.player_diagonals(board))
          |> find_winner_in_lines()
      end
    end

    defp find_winner_in_lines(lines) do
      case lines do
        [] ->
          false

        [line | other_lines] ->
          line_winner(line) || find_winner_in_lines(other_lines)
      end
    end

    defp line_winner(line) do
      Enum.reduce(line, fn owns_line, owns_space -> owns_space === owns_line && owns_space end)
    end

    def is_over?(board) do
      cond do
        Enum.empty?(board.open_spaces) ->
          true

        find_winner(board) ->
          true

        true ->
          false
      end
    end

    def place_symbol(board, player, space) do
      %{
        board
        | open_spaces: board.open_spaces -- [space],
          player_rows: claim_space(board.player_rows, player, space)
      }
    end

    defp claim_space(rows, player, space) do
      claimed_row = space.row_index

      for {row, r} <- Enum.with_index(rows) do
        case r do
          ^claimed_row ->
            claim_space_in_row(row, player, space.column_index)

          _ ->
            row
        end
      end
    end

    defp claim_space_in_row(row, player, index) do
      for {current_owner, c} <- Enum.with_index(row) do
        case c do
          ^index ->
            player

          _ ->
            current_owner
        end
      end
    end
  end
end
