# HelloWorld

Hello World in Elixir, generated with [mix][mix] by `mix new hello_world`.


## Installation

This package can be installed by adding `hello_world` to your list of dependencies in `mix.exs`,
as long as it is [available in Hex](https://hex.pm/docs/publish):

```elixir
def deps do
  [
    {:hello_world, "~> 0.1.0"}
  ]
end
```

## Development

### Compiling

```bash
$ mix compile
```


### Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hello_world](https://hexdocs.pm/hello_world).


### Formatting

To re-format code according to the rules defined in `.formatter.exs`:

```bash
$ mix format
```


### Shell

An interactive shell can be run with Mix enabled, so that commands like `recompile/0` work.

```bash
$ iex -S mix
iex> HelloWorld.hello
:world
```

Press `Ctrl+\\` to exit, or `Ctrl+C` twice.


### Testing

```bash
$ mix test         #Run tests with summary output
$ mix test --trace #Show the names of tests as they run
```


[mix]: https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html

