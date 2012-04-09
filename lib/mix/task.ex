defmodule Mix.Task do
  def behaviour_info(:callbacks) do
    [run: 1]
  end

  # We may want to autoimport a util library in the future.
  defmacro __using__(mod, opts // []) do
    quote do
      @behavior unquote(__MODULE__)
    end
  end
end
