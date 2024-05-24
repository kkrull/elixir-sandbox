# Tic-tac-toe

Tic-tac-toe in [Elixir][elixir-home].


## Development and Runtime Environment

Development is done using Elixir 1.6.6 on MacOS High Sierra.


## Installing Elixir

Compiled distributions exist for a number of operating systems.  Installation instructions for some common operating systems are repeated here.  Instructions for a number of other operating systems are listed on the [Elixir Distributions][elixir-distributions] page.

Once the tools have been installed, the following commands should exist on your `PATH`

```bash
$ elixir --version
Erlang/OTP 21 [erts-10.0.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe] [dtrace]

Elixir 1.6.6 (compiled with OTP 20)
```

```bash
$ mix --version
Erlang/OTP 21 [erts-10.0.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe] [dtrace]

Mix 1.6.6 (compiled with OTP 20)
```

```bash
$ iex --version
Erlang/OTP 21 [erts-10.0.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe] [dtrace]

IEx 1.6.6 (compiled with OTP 20)
```


### MacOS Installation

Packages exist with some commonly-used package managers:

* Homebrew: `brew install elixir`
* MacPorts: `sudo port install elixir`


### Ubuntu Installation

Packages can be installed from the Erlang Solutions repository.

```bash
$ apt-get update
$ apt-get install wget gnupg

$ wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
$ apt-get update
$ apt-get install esl-erlang
$ apt-get install elixir
```


### Ubuntu on Docker Installation

The Ubuntu instructions were verified by using a Docker base image for Ubuntu 18.04.  This approach is tested on Docker with `ubuntu:18.04 74f8760a2a8b`.

```
## Local machine
$ docker run -it --name elixirtest -v ~/.ssh:/root/.ssh:ro ubuntu:18.04 bash

## In the Docker container, as root
# apt-get update
# apt-get install git
# mkdir ~/git
# cd ~/git
# git clone ...

## ... then follow the rest of the Ubuntu instructions ...
# apt-get update
# apt-get install wget gnupg

# wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
# apt-get update
# apt-get install esl-erlang
# apt-get install elixir
```


## Running

Run the game as follows:

```bash
$ cd <path to this repository>
$ mix run scripts/computer-vs-computer.exs #Computer vs. Computer game
$ mix run scripts/human-vs-computer.exs #Human vs. Computer game
```


## Development

Many common development tasks are run with Elixir's built-in tool [Mix][mix].

### Compiling

```bash
$ mix compile
```


### Continuous Integration

Continuous integration is performed on a [BitBucket pipeline][bitbucket-pipeline] configured in `bitbucket-pipelines.yml`.

This file defines:

* the command used to run the tests
* the Docker image that has the same version of Elixir that is used for development


### Formatting

To re-format code according to the rules defined in `.formatter.exs`:

```bash
$ mix format
```


### Shell

An interactive shell can be run with Mix enabled, so that commands like `recompile/0` work.

```bash
$ iex -S mix
```

Press `Ctrl+\\` to exit, or `Ctrl+C` twice.


### Testing

Tests are written in [ExUnit][exunit], and they can be run as follows:

```bash
$ mix test         #Run tests with console output
$ mix test --cover #Generate code coverage reports in cover/
```

Pending tests must still do something (degenerate), and they are identified by adding `@tag :pending`.

```elixir
@tag :pending
test "pending", do: :break_something
```

Test test runner is configured in `test/test_helper.exs` to skip these tests.


[bitbucket-pipeline]: https://confluence.atlassian.com/bitbucket/language-guides-856821477.html
[elixir-home]: https://elixir-lang.org/
[elixir-distributions]: https://elixir-lang.org/install.html#distributions
[exunit]: https://hexdocs.pm/ex_unit/ExUnit.html
[mix]: https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html
