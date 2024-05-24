#!/usr/bin/env mix run

defmodule Main do
  @moduledoc "Entry point for a game between a console (human) player and the computer."

  def main do
    config =
      HumanVsComputerConfig.new()
      |> HumanVsComputerConfig.set_player_one("X")
      |> HumanVsComputerConfig.set_player_two("O")

    herald = ConsoleHerald.new(:stdio)
    initial_board = SquareBoard.new(3)

    game =
      Game.new(
        herald,
        HumanVsComputerConfig.player_one(config),
        HumanVsComputerConfig.player_two(config)
      )

    Game.play(game, initial_board)
  end
end

defmodule HumanVsComputerConfig do
  defstruct [:player_one_symbol, :player_two_symbol]

  def new do
    %HumanVsComputerConfig{}
  end

  def set_player_one(config, symbol) do
    %{config | player_one_symbol: symbol}
  end

  def set_player_two(config, symbol) do
    %{config | player_two_symbol: symbol}
  end

  def player_one(config) do
    ConsolePlayer.new(:stdio, config.player_one_symbol)
  end

  def player_two(config) do
    case Minimax.start_link([config.player_two_symbol, config.player_one_symbol]) do
      {:ok, pid} ->
        MinimaxPlayer.new(pid, config.player_two_symbol, config.player_one_symbol)
    end
  end
end

Main.main()
