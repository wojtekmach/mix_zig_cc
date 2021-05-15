# MixZigCC

A proof of concept of using [`zig cc`](https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html) to cross-compile NIFs for these targets:

- `aarch64-linux`
- `x86_64-linux`
- `x86_64-macos`

See [`examples/hello/c_src/hello_nif.c`](examples/hello/c_src/hello_nif.c), [`examples/hello/mix.exs`](examples/hello/mix.exs).

## Usage

    iex> Mix.install([{:hello, github: "wojtekmach/mix_zig_cc", sparse: "examples/hello"}])
    iex> Hello.hello
    :world

With Docker:

    $ docker run --rm -it elixir:1.12 iex
    iex> Mix.install([{:hello, github: "wojtekmach/mix_zig_cc", sparse: "examples/hello"}])
    iex> Hello.hello
    :world
