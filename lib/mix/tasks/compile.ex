defmodule Mix.Tasks.Compile do
  @behavior Mix.Task
  @shortdoc "Compile Elixir source files."
  @moduledoc """
  A task to compile Elixir source files. By default,
  output is compiled to exdoc/. Sourcefiles are assumed
  to be in lib/. You can change this by setting :source_paths
  in your project. It is expected to be a list of paths like
  so:

  [source_paths: ["src"]]

  This list will be merged with the
  default one and the compile task will look for source files
  in both lib/ and src/. Setting the compile path works similarly.

  [compile_path: "ebin"]

  This sets the compile path to "ebin" so that source files will
  be compiled to this directory instead of the default one.

  Sometimes files need to be compiled in a specific order. If you
  have this issue, you can use the compile_first key:

  [compile_first: ["lib/foo.ex" "lib/bar.ex"]]

  This will cause foo.ex and bar.ex to be compiled before any
  other files and in the order they appear in the list.
  """
  def run(_) do
  end
end
