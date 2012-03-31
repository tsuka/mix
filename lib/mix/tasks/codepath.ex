defmodule Mix.Tasks.Codepath do
  @behavior Mix.Task
  @doc """
  Prints the current load path.
  """
  def run([]), do: IO.inspect :code.get_path()
  def run([arg]) do
    if arg == "-p" do
      Enum.each(:code.get_path, fn(x) -> IO.puts(x) end)
    end
  end
end
