# GenServer test

A quick test making a GenServer that keeps track of how many messages it has received.

```
$ iex -S mix
Erlang/OTP 21 [erts-10.0.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe] [dtrace]

Compiling 1 file (.ex)
Generated gen_server_demo app
Interactive Elixir (1.6.6) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> s = Scorer.start
{:ok, #PID<0.160.0>}
iex(2)> GenServer.cast(:scorer, "test")
[%Scorer.State{num_messages: 0}}]: test}
:ok
iex(3)> GenServer.cast(:scorer, "test")
[%Scorer.State{num_messages: 1}}]: test}
:ok
```
