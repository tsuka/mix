defmodule Mix.Tasks.Help do
  @behavior Mix.Task

  @doc """
  Print help information for tasks.

  Arguments: task
  If given a task name, prints the documentation for that task.
  If no task name is given, prints the short form documentation
  for all tasks.
  """
  def run([]) do
    modules = Mix.Tasks.list_tasks
    docs = lc module in modules do
      {module, short_docs(get_task_docs(module.__info__(:docs)))}
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
      docs = get_task_docs(module.__info__(:docs))
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
  defp short_docs(docs) do
    case Regex.run(%r/(.*)\n\n.+/, docs) do
    match: [_, docs]
      docs
    match: nil
      nil
    end
  end

  defp get_task_docs(docs) do
    task = Enum.find(docs, fn(x) ->
      case x do
      match: {{:run, _}, _, _, _}
        x
      else:
        nil
      end
    end)
    case task do
    match: nil
      nil
    match: {_, _, _, docs}
      docs
    end
  end
end
