defmodule PlayerSpy do
  @moduledoc "Spies on interactions with Players."

  defstruct [:symbol, :pid]

  def new(symbol, pid) do
    %PlayerSpy{
      symbol: symbol,
      pid: pid
    }
  end

  def pick_space_returns(player, next_board) do
    GenServer.call(player.pid, {:pick_space_returns, next_board})
  end

  def pick_space_symbols(player) do
    GenServer.call(player.pid, :pick_space_symbols)
  end

  defimpl Player do
    def pick_space(player, board), do: GenServer.call(player.pid, {:pick_space, player, board})
    def symbol(player), do: player.symbol
  end

  defmodule Server do
    @moduledoc "Records interactions with _all_ Players"
    use GenServer

    def start_link(opts) do
      GenServer.start_link(Server, opts)
    end

    def init(_args) do
      {
        :ok,
        %{
          pick_space_returns: [],
          pick_space_symbols: []
        }
      }
    end

    def handle_call({:pick_space, player, _board}, _from, state) do
      [next_board | other_boards] =
        case state.pick_space_returns do
          [first | others] ->
            [first | others]

          [] ->
            [:default_board]
        end

      next_state = %{
        state
        | pick_space_returns: other_boards,
          pick_space_symbols: state.pick_space_symbols ++ [Player.symbol(player)]
      }

      {:reply, next_board, next_state}
    end

    def handle_call({:pick_space_returns, next_board}, _from, state) do
      {
        :reply,
        :ok,
        %{state | pick_space_returns: state.pick_space_returns ++ [next_board]}
      }
    end

    def handle_call(:pick_space_symbols, _from, state) do
      {:reply, state.pick_space_symbols, state}
    end
  end
end

defmodule PlayerStub do
  @moduledoc "A test-double player that has a symbol, and little else."

  defstruct [:symbol]

  def new(symbol) do
    %PlayerStub{symbol: symbol}
  end

  defimpl Player do
    def pick_space(_player, _board), do: raise("not implemented")
    def symbol(player), do: player.symbol
  end
end
