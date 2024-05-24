defmodule Minimax do
  @moduledoc "Scores a zero-sum, two player game that can end in either player winning or in a draw."

  use GenServer

  def start_link(opts = [_maximizer, _minimizer]) do
    GenServer.start_link(Minimax, opts)
  end

  def init([maximizer, minimizer]) do
    {:ok, %{maximizer: maximizer, minimizer: minimizer}}
  end

  def score(scorer, game, player) do
    GenServer.call(scorer, {:score, game, player})
  end

  def handle_call({:score, game, player}, _from, state) do
    {:reply, calculate_score(game, state, player), state}
  end

  defp calculate_score(game, state, player) do
    cond do
      GameState.find_winner(game) === state.maximizer ->
        1

      GameState.find_winner(game) === state.minimizer ->
        -1

      GameState.is_over?(game) ->
        0

      player === state.maximizer ->
        next_game_states(game, player)
        |> Enum.map(fn next_game -> calculate_score(next_game, state, state.minimizer) end)
        |> Enum.max()

      player === state.minimizer ->
        next_game_states(game, player)
        |> Enum.map(fn next_game -> calculate_score(next_game, state, state.maximizer) end)
        |> Enum.min()
    end
  end

  defp next_game_states(game, player) do
    game
    |> GameState.available_spaces()
    |> Enum.map(fn space -> GameState.place_symbol(game, player, space) end)
  end
end
