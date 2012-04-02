defmodule Mix.Tasks.Hello do
  @behavior Mix.Task
  @moduledoc """
  This is short documentation, see.

  A test task.
  """
  def run(_) do
    IO.puts "Hello, World!"
  end
end
