defmodule Mix.Tasks.Codepath do
  @behavior Mix.Task
  @moduledoc """
  Prints the current load path.

  If given the argument -p, prints the code
  load path one path per line. Otherwise, prints
  the whole list in such a way that it can be
  copied and fed back to an Elixir program.

  Arguments:
    -p:   (pretty print)
    none: print a list
  """
  def run([]), do: IO.inspect :code.get_path()
  def run([arg]) do
    if arg == "-p" do
      Enum.each(:code.get_path, fn(x) -> IO.puts(x) end)
    end
  end
end
