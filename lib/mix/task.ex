defmodule Mix.Task do
  def behaviour_info(:callbacks) do
    [run: 1]
  end
end
