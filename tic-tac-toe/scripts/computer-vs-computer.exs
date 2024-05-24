#!/usr/bin/env mix run

defmodule Main do
  @moduledoc "Entry point for a game between two computer players."

  def main do
    config =
      ComputerVsComputerConfig.new()
      |> ComputerVsComputerConfig.set_player_one("X")
      |> ComputerVsComputerConfig.set_player_two("O")

    herald = ConsoleHerald.new(:stdio)
    initial_board = SquareBoard.new(3)

    game =
      Game.new(
        herald,
        ComputerVsComputerConfig.player_one(config),
        ComputerVsComputerConfig.player_two(config)
      )

    Game.play(game, initial_board)
  end
end

defmodule ComputerVsComputerConfig do
  defstruct [:player_one_symbol, :player_two_symbol]

  def new do
    %ComputerVsComputerConfig{}
  end

  def set_player_one(config, symbol) do
    %{config | player_one_symbol: symbol}
  end

  def set_player_two(config, symbol) do
    %{config | player_two_symbol: symbol}
  end

  def player_one(config) do
    case Minimax.start_link([config.player_one_symbol, config.player_two_symbol]) do
      {:ok, pid} ->
        MinimaxPlayer.new(pid, config.player_one_symbol, config.player_two_symbol)
    end
  end

  def player_two(config) do
    case Minimax.start_link([config.player_two_symbol, config.player_one_symbol]) do
      {:ok, pid} ->
        MinimaxPlayer.new(pid, config.player_two_symbol, config.player_one_symbol)
    end
  end
end

Main.main()
