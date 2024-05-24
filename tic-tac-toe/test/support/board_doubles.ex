defmodule BoardSpy do
  @moduledoc "Spies on interactions with a Board."

  defstruct [:pid]

  def new(pid) do
    %BoardSpy{pid: pid}
  end

  def place_symbol_symbols(board) do
    GenServer.call(board.pid, :place_symbol_symbols)
  end

  defimpl GameState do
    def available_spaces(board), do: GenServer.call(board.pid, :available_spaces)
    def find_winner(_board), do: raise("not implemented")
    def is_over?(_board), do: raise("not implemented")

    def place_symbol(board, player, space),
      do: GenServer.call(board.pid, {:place_symbol, player, space})
  end

  defmodule Server do
    @moduledoc "Records interactions with a Board."
    use GenServer

    def start_link(args) do
      GenServer.start_link(Server, args)
    end

    def init({available_spaces, place_symbol_returns}) do
      {
        :ok,
        %{
          available_spaces: available_spaces,
          place_symbol_returns: place_symbol_returns,
          place_symbol_symbols: []
        }
      }
    end

    def handle_call(:available_spaces, _from, state) do
      {:reply, state.available_spaces, state}
    end

    def handle_call({:place_symbol, player, _space}, _from, state) do
      case state.place_symbol_returns do
        [next_board | other_boards] ->
          next_state = %{
            state
            | place_symbol_returns: other_boards,
              place_symbol_symbols: state.place_symbol_symbols ++ [player]
          }

          {:reply, next_board, next_state}
      end
    end

    def handle_call(:place_symbol_symbols, _from, state) do
      {:reply, state.place_symbol_symbols, state}
    end
  end
end
