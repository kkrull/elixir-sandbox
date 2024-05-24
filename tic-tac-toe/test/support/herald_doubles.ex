defmodule HeraldSpy do
  @moduledoc "Spies on interactions with the Herald."

  defstruct [:pid]

  def new(pid) do
    %HeraldSpy{pid: pid}
  end

  def current_player(herald) do
    GenServer.call(herald.pid, :current_player)
  end

  def game_result(herald) do
    GenServer.call(herald.pid, :game_result)
  end

  def game_started_board(herald) do
    GenServer.call(herald.pid, :game_started_board)
  end

  def turn_completed_boards(herald) do
    GenServer.call(herald.pid, :turn_completed_boards)
  end

  defimpl Herald do
    def draw_game(herald), do: GenServer.call(herald.pid, {:game_result, :draw})
    def game_started(herald, board), do: GenServer.call(herald.pid, {:game_started, board})
    def next_turn(herald, player), do: GenServer.call(herald.pid, {:next_turn, player})
    def turn_completed(herald, board), do: GenServer.call(herald.pid, {:turn_completed, board})
    def winner(herald, player), do: GenServer.call(herald.pid, {:game_result, {:winner, player}})
  end

  defmodule Server do
    @moduledoc "Records interactions with the Herald."
    use GenServer

    def start_link(opts) do
      GenServer.start_link(Server, opts)
    end

    def init(_opts) do
      {
        :ok,
        %{
          current_player: false,
          game_result: false,
          game_started_board: false,
          turn_completed_boards: []
        }
      }
    end

    def handle_call(:current_player, _from, state) do
      {:reply, state.current_player, state}
    end

    def handle_call(:game_result, _from, state) do
      {:reply, state.game_result, state}
    end

    def handle_call({:game_result, result}, _from, state) do
      {
        :reply,
        :ok,
        %{state | game_result: result}
      }
    end

    def handle_call({:game_started, board}, _from, state) do
      {
        :reply,
        :ok,
        %{state | game_started_board: board}
      }
    end

    def handle_call(:game_started_board, _from, state) do
      {:reply, state.game_started_board, state}
    end

    def handle_call({:next_turn, player}, _from, state) do
      {
        :reply,
        :ok,
        %{state | current_player: player}
      }
    end

    def handle_call({:turn_completed, board}, _from, state) do
      {
        :reply,
        :ok,
        %{state | turn_completed_boards: [board | state.turn_completed_boards]}
      }
    end

    def handle_call(:turn_completed_boards, _from, state) do
      {:reply, state.turn_completed_boards, state}
    end
  end
end
