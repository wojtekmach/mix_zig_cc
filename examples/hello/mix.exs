defmodule Hello.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      compilers: extra_compilers(Mix.env()) ++ Mix.compilers(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp extra_compilers(env) when env in [:dev, :test], do: [:zig_cc]
  defp extra_compilers(_), do: []

  defp aliases() do
    [
      "compile.zig_cc": &zig_cc/1
    ]
  end

  defp deps do
    []
  end

  defp zig_cc(_) do
    zig_cc()
  end

  @targets [
    {"aarch64", "linux"},
    {"x86_64", "linux"},
    {"x86_64", "macos"}
  ]

  def zig_cc do
    input = "c_src/hello_nif.c"
    output = "priv/hello_nif"

    for target <- @targets do
      cmd = cmd(input, output, target)
      0 = Mix.shell().cmd(cmd)
    end

    :ok
  end

  defp cmd(input, output, target) do
    {arch, os} = target
    include = Path.join([:code.root_dir(), "erts-#{:erlang.system_info(:version)}", "include"])

    context =
      case target do
        {_, "macos"} ->
          # TODO: https://github.com/ziglang/zig/issues/8728
          %{
            opts: "-shared",
            env: "ZIG_SYSTEM_LINKER_HACK=true "
          }

        _ ->
          %{
            opts: "-shared",
            env: ""
          }
      end

    target = "#{arch}-#{os}"
    output = "#{output}-#{target}.so"
    force = false
    opts = "-o #{output} -target #{target} -I#{include} -shared"

    if not force and File.exists?(output) do
      "echo #{output} already exists"
    else
      "echo building #{output}; #{context.env}zig cc #{input} #{opts}"
    end
  end

  def target() do
    case :string.split(:erlang.system_info(:system_architecture), '-', :all) do
      [cpu, _vendor, os | _] ->
        os = if List.starts_with?(os, 'darwin'), do: 'macos', else: os
        cpu = if os == 'macos' and List.starts_with?(cpu, 'arm'), do: 'aarch64', else: cpu
        "#{cpu}-#{os}"

      ['win32'] ->
        "x86_64-windows"
    end
  end
end
