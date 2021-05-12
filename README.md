# MixZigCC

A proof of concept of using [`zig cc`](https://andrewkelley.me/post/zig-cc-powerful-drop-in-replacement-gcc-clang.html) to cross-compile NIFs for these targets:

- `aarch64-linux`
- `x86_64-linux`
- `x86_64-macos`

```
% file examples/hello/priv/hello_nif-*
examples/hello/priv/hello_nif-aarch64-linux.so: ELF 64-bit LSB shared object, ARM aarch64, version 1 (SYSV), dynamically linked, not stripped
examples/hello/priv/hello_nif-x86_64-linux.so:  ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, not stripped
examples/hello/priv/hello_nif-x86_64-macos.so:  Mach-O 64-bit dynamically linked shared library x86_64
```

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
