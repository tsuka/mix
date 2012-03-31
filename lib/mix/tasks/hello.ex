defmodule Mix.Tasks.Hello do
  @behavior Mix.Task

  @doc """
  This is short documentation, see.

  A test task.
  """
  def run(_) do
    IO.puts "Hello, World!"
  end
end
