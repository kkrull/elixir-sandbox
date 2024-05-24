defmodule Space do
  @moduledoc "A space on a grid, like on a game board."

  defstruct [
    :id,
    :row_number,
    :column_number,
    :row_index,
    :column_index,
    :column_letter
  ]

  @id_regex ~r/^([A-Za-z])(\d)$/
  def parse(id) do
    trimmed_id = String.trim_trailing(id)

    case Regex.run(@id_regex, trimmed_id) do
      nil ->
        {:error, "#{trimmed_id} is not a space"}

      [_, letter_string, row_string] ->
        column_number = parse_column_number(letter_string)
        row_number = String.to_integer(row_string)
        {:ok, on_grid(row_number, column_number)}
    end
  end

  @ascii_code_for_A 65
  defp parse_column_number(single_letter_string) do
    letter_char =
      single_letter_string
      |> String.upcase()
      |> to_charlist()
      |> hd()

    letter_char - @ascii_code_for_A + 1
  end

  def on_grid(row_number, column_number) do
    column_letter = "#{[@ascii_code_for_A + column_number - 1]}"

    %Space{
      id: column_letter <> "#{row_number}",
      row_number: row_number,
      column_number: column_number,
      row_index: row_number - 1,
      column_index: column_number - 1,
      column_letter: column_letter
    }
  end
end
