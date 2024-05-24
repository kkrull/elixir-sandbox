defmodule MinimaxMock do
  @moduledoc "Mock implementation of Minimax that returns pre-determined scores."
  use GenServer

  @default_score 42

  defmodule State do
    defstruct score_calls: [], scores: []
  end

  def start_link(opts) do
    GenServer.start_link(MinimaxMock, opts)
  end

  def init(_opts) do
    {:ok, %State{}}
  end

  def score_should_have_received(mock, board, player) do
    mock
    |> GenServer.call(:score_calls)
    |> call_should_exist(board, player)
  end

  defp call_should_exist(calls, board, player) do
    case calls do
      [] ->
        raise "no call found: player=#{player}, board=#{inspect(board)}"

      [%{board: ^board, player: ^player} | _] ->
        :ok

      [_ | other_calls] ->
        call_should_exist(other_calls, board, player)
    end
  end

  def set_score(mock, board, score) do
    GenServer.call(mock, {:set_score, board, score})
  end

  def handle_call({:score, board, player}, _from, state) do
    score = lookup_score(board, state.scores)
    this_call = %{board: board, player: player}
    {:reply, score, %{state | score_calls: [this_call | state.score_calls]}}
  end

  def handle_call(:score_calls, _from, state) do
    {:reply, state.score_calls, state}
  end

  def handle_call({:set_score, board, score}, _from, state) do
    {:reply, :ok, %{state | scores: [%{board: board, score: score} | state.scores]}}
  end

  defp lookup_score(board, scores) do
    case scores do
      [] ->
        @default_score

      [%{board: ^board, score: score} | _] ->
        score

      [_ | other_scores] ->
        lookup_score(board, other_scores)
    end
  end
end
