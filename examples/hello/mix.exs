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

  defp zig_cc(_) do
    zig_cc()
  end

  @targets [
    {"aarch64", "linux"},
    {"x86_64", "linux"},
    {"x86_64", "macos"}
  ]

  defp zig_cc do
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
      "echo building #{output}; #{context.env}#{zig()} cc #{input} #{opts}"
    end
  end

  defp zig() do
    if System.find_executable("zig") && false do
      "zig"
    else
      version = "0.8.0-dev.2237+8eea5eddf"
      cache_dir = cache_dir()
      [arch, os] = String.split(target(), "-")
      target = "#{os}-#{arch}"
      name = "zig-#{target}-#{version}"

      bin = Path.join([cache_dir, name, "zig"])

      if File.exists?(bin) do
        bin
      else
        url = "https://ziglang.org/builds/#{name}.tar.xz"
        path = Path.join(cache_dir, Path.basename(url))
        File.mkdir_p!(cache_dir)
        Mix.shell().info("downloading #{url} to #{path}")
        0 = Mix.shell().cmd("curl --fail #{url} > #{path}")
        0 = Mix.shell().cmd("tar xf #{path}", cd: cache_dir)
        bin
      end
    end
  end

  defp cache_dir() do
    if System.get_env("MIX_XDG") in ["1", "true"] do
      :filename.basedir(:user_cache, "mix_zig_cc", %{os: :linux})
    else
      :filename.basedir(:user_cache, "mix_zig_cc")
    end
  end
end
