defmodule Hello do
  def hello do
    HelloNIF.hello()
  end
end

defmodule HelloNIF do
  @moduledoc false

  @on_load :load_nifs

  @target Hello.MixProject.target()

  def load_nifs do
    path = :code.priv_dir(:hello) ++ '/hello_nif-#{@target}'
    :ok = :erlang.load_nif(path, 0)
  end

  def hello do
    :erlang.nif_error("NIF library not loaded")
  end
end
