defmodule Mix.Tasks.Hello do
  use Mix.Task
  @shortdoc "This is short documentation, see."
  @moduledoc """
  A test task.
  """
  def run(_) do
    IO.puts "Hello, World!"
  end
end
