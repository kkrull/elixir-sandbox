defmodule ConsolePlayerTest do
  use ExUnit.Case

  @a1 Space.on_grid(1, 1)
  @b2 Space.on_grid(2, 2)

  describe "#new/2" do
    setup :with_string_io

    test "accepts a StringIO and a player symbol", context do
      assert %ConsolePlayer{} = ConsolePlayer.new(context.io, "X")
    end
  end

  describe "Player#pick_space/2" do
    setup [:with_string_io, :with_player]

    @prompt "Please enter the coordiantes of an available space: "
    @not_a_space "88 is not a space\n"
    @no_B2_for_you "B2 is not available\n"

    test "prompts the player for input", context do
      next_board = %GameWithKnownStates{is_over: true}

      initial_board =
        GameWithKnownStates.new()
        |> GameWithKnownStates.add_known_state(@a1, next_board)

      Player.pick_space(context.player, initial_board)
      assert {:ok, {_, @prompt}} = StringIO.close(context.io)
    end

    test "repeats prompts until parseable coordiantes are entered" do
      next_board = %GameWithKnownStates{is_over: true}

      initial_board =
        GameWithKnownStates.new()
        |> GameWithKnownStates.add_known_state(@a1, next_board)

      {:ok, io} = StringIO.open("88\nA1")
      player = ConsolePlayer.new(io, "X")
      Player.pick_space(player, initial_board)

      expected = @prompt <> @not_a_space <> @prompt
      assert {:ok, {_, ^expected}} = StringIO.close(io)
    end

    test "repeats prompts until the coordinates of an available space are entered" do
      next_board = %GameWithKnownStates{is_over: true}

      initial_board =
        GameWithKnownStates.new()
        |> GameWithKnownStates.add_known_state(@a1, next_board)

      {:ok, io} = StringIO.open("B2\nA1")
      player = ConsolePlayer.new(io, "X")
      Player.pick_space(player, initial_board)

      expected = @prompt <> @no_B2_for_you <> @prompt
      assert {:ok, {_, ^expected}} = StringIO.close(io)
    end

    test "parses the space from the input ID" do
      next_board = %GameWithKnownStates{is_over: true}

      initial_board =
        GameWithKnownStates.new()
        |> GameWithKnownStates.add_known_state(@b2, next_board)

      {:ok, io} = StringIO.open("B2\n")
      player = ConsolePlayer.new(io, "X")
      Player.pick_space(player, initial_board)
    end

    test "places the player's symbol on the board, at the input space", context do
      next_board = %GameWithKnownStates{is_over: true}
      board_server = start_supervised!({BoardSpy.Server, {[@a1], [next_board]}})
      initial_board = BoardSpy.new(board_server)

      Player.pick_space(context.player, initial_board)
      assert BoardSpy.place_symbol_symbols(initial_board) === ["X"]
    end

    test "returns the updated board", context do
      next_board = %GameWithKnownStates{is_over: true}

      initial_board =
        GameWithKnownStates.new()
        |> GameWithKnownStates.add_known_state(@a1, next_board)

      assert Player.pick_space(context.player, initial_board) === next_board
    end

    def with_player(context) do
      %{player: ConsolePlayer.new(context.io, "X")}
    end
  end

  describe "Player#symbol/1" do
    setup :with_string_io

    test "returns the player's symbol", context do
      player = ConsolePlayer.new(context.io, "X")
      assert Player.symbol(player) === "X"
    end
  end

  def with_string_io(_context) do
    case StringIO.open("A1") do
      {:ok, io} ->
        %{io: io}
    end
  end
end
