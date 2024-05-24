defmodule ConsoleHeraldTest do
  use ExUnit.Case

  @a1 Space.on_grid(1, 1)
  @b1 Space.on_grid(1, 2)
  @a2 Space.on_grid(2, 1)
  @b2 Space.on_grid(2, 2)

  setup :with_string_io

  describe "#new/1" do
    test "accepts a form of address for an IO process", context do
      ConsoleHerald.new(context.io)
      StringIO.close(context.io)
    end
  end

  describe "Herald#draw_game/1" do
    test "writes a text statement announcing the most boring way to end a game", context do
      herald = ConsoleHerald.new(context.io)
      Herald.draw_game(herald)

      case StringIO.close(context.io) do
        {:ok, {_, output}} -> assert output == "Draw\n"
      end
    end
  end

  describe "Herald#next_turn/2" do
    test "writes a text statement announcing whose turn it is", context do
      player = PlayerStub.new("X")
      herald = ConsoleHerald.new(context.io)
      Herald.next_turn(herald, player)

      case StringIO.close(context.io) do
        {:ok, {_, output}} -> assert output == "\nYour turn, X\n"
      end
    end
  end

  describe "Herald#turn_completed/2" do
    setup :with_herald

    test "writes no output for an empty board", context do
      board = SquareBoard.new(0)
      Herald.turn_completed(context.herald, board)
      assert {:ok, {_, ""}} = StringIO.close(context.io)
    end

    test "writes a 1x1 board to the given IO process", context do
      board = SquareBoard.new(1)
      Herald.turn_completed(context.herald, board)

      expected = """
          A
        +---+
      1 |   |
        +---+
      """

      case StringIO.close(context.io) do
        {:ok, {_, output}} -> assert output == expected
      end
    end

    test "writes a board with spaces owned by players", context do
      board =
        SquareBoard.new(1)
        |> GameState.place_symbol("X", @a1)

      Herald.turn_completed(context.herald, board)

      expected = """
          A
        +---+
      1 | X |
        +---+
      """

      case StringIO.close(context.io) do
        {:ok, {_, output}} -> assert output == expected
      end
    end

    test "writes a 2x2 board with separators between adjacent cells", context do
      board =
        SquareBoard.new(2)
        |> GameState.place_symbol("a", @a1)
        |> GameState.place_symbol("b", @b1)
        |> GameState.place_symbol("A", @a2)
        |> GameState.place_symbol("B", @b2)

      Herald.turn_completed(context.herald, board)

      expected = """
          A   B
        +-------+
      1 | a | b |
        |===+===|
      2 | A | B |
        +-------+
      """

      case StringIO.close(context.io) do
        {:ok, {_, output}} -> assert output == expected
      end
    end
  end

  describe "Herald#winner/2" do
    test "writes a text statement announcing who won", context do
      herald = ConsoleHerald.new(context.io)
      Herald.winner(herald, "X")

      case StringIO.close(context.io) do
        {:ok, {_, output}} -> assert output == "X wins!\n"
      end
    end
  end

  def with_herald(context) do
    %{herald: ConsoleHerald.new(context.io)}
  end

  def with_string_io(_context) do
    case StringIO.open("") do
      {:ok, io} ->
        %{io: io}
    end
  end
end
