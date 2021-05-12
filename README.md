# MixZigCC

See [`examples/hello/mix.exs`](examples/hello/mix.exs).

## Usage

    iex> Mix.install([{:hello, github: "wojtekmach/mix_zig_cc", sparse: "examples/hello"}])
    iex> Hello.hello
    :world

With Docker:

    $ docker run --rm -it elixir:1.12 iex
    iex> Mix.install([{:hello, github: "wojtekmach/mix_zig_cc", sparse: "examples/hello"}])
    iex> Hello.hello
    :world
