defmodule Mix.Tasks.Help do
  @behavior Mix.Task
  @moduledoc """
  Print help information for tasks.

  If given a task name, prints the documentation for that task.
  If no task name is given, prints the short form documentation
  for all tasks.

  Arguments:
    task: Print the @doc documentation for this task.
    none: Print the short form documentation for all tasks.
  """
  def run([]) do
    modules = Mix.Tasks.list_tasks
    docs = lc module in modules do
      {module, short_docs(module.__info__(:moduledoc))}
    end
    Enum.each(docs, fn({module, doc}) ->
      task = Mix.Tasks.module_to_task(module)
      if doc do
        IO.puts(task <> ": " <> doc)
      else:
        IO.puts(task <> ": " <> "run `mix help " <>
                task <> "` to see documentation.")
      end
    end)
  end

  def run([task]) do
    case Mix.Tasks.get_module(task) do
    match: {:module, module}
      docs = module.__info__(:moduledoc)
      if docs do
        IO.puts docs
      else:
        IO.puts "There is no documentation for this task."
      end
    match: {:error, _}
      IO.puts "No task by that name was found."
    end
  end

  defp short_docs(nil), do: nil
  defp short_docs({_, nil}), do: nil
  defp short_docs({_, docs}) do
    case Regex.run(%r/(.*)\n\n.+/, docs) do
    match: [_, docs]
      docs
    match: nil
      nil
    end
  end
end
