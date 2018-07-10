defmodule Scorer do
  @moduledoc false

  use GenServer

  defmodule State do
    defstruct num_messages: 0
  end

  def start do
    GenServer.start_link(Scorer, %State{}, name: :scorer)
  end

  def init(args) do
    {:ok, args}
  end

  def handle_cast(message, state) do
    log_message = "[#{inspect state}}]: #{message}}"
    IO.puts log_message

    new_state = %{state | num_messages: state.num_messages + 1}
    {:noreply, new_state}
  end
end
