defmodule Mix.Tasks do
  @moduledoc """
  Utilities for finding tasks and returning them as modules.
  """

  @doc """
  List all of the tasks on the load path
  as their respective modules.
  """
  def list_tasks() do
    load_all_tasks
    Enum.reduce(:code.all_loaded, [], fn({module, _}, acc) ->
      proper = Regex.run(%r/Mix\.Tasks\..*/, atom_to_list(module))
      if proper && is_task?(module) do
        acc = [module|acc]
        acc
      else:
        acc
      end
    end)
  end

  defp load_all_tasks() do
    Enum.each(:code.get_path, fn(x) ->
      files = File.wildcard(x ++ '/__MAIN__/Mix/Tasks/**/*.beam')
      Enum.each(files, fn(x) ->
        get_module(:filename.rootname(File.basename(x)))
      end)
    end)
  end

  @doc """
  Takes a raw task name (totally lower case) and
  tries to load that task's associated module.
  If the task does not exist or cannot be loaded,
  a tuple of {:error, what} is returned. If the
  task module is successfully loaded, a tuple of
  {:module, module} is returned.
  """
  def get_module(s) when is_list(s), do: get_module list_to_binary(s)
  def get_module(s) do
    name = Module.concat(Mix.Tasks, capitalize_task(s))
    :code.ensure_loaded(name)
  end

  @doc """
  Run a task with arguments. If no arguments are
  passed, an empty list is used.
  """
  def run_task(name, args // []) do
    case Mix.Tasks.get_module(name) do
    match: {:module, module}
      if is_task?(module) do
        module.run(args)
      else:
        IO.puts "That task could not be found."
      end
    match: {:error, _}
      IO.puts "That task could not be found."
    end
  end

  @doc """
  Takes a module and extracts the last portion of it,
  lower-cases the first letter, and returns the name.
  """
  def module_to_task(module) do
    to_lower(List.last(Regex.split(%r/\./, list_to_binary(atom_to_list(module)), 4)))
  end

  @doc """
  Takes a task as a string like "foo" or "foo.bar"
  and capitalizes each segment to form a module name.
  """
  def capitalize_task(s) do
    Enum.join(Enum.map(Regex.split(%r/\./, s), Mix.Utils.capitalize(&1)), ".")
  end

  @doc """
  Find out if a module defines a :run function
  of one argument. This indicates whether or not
  it is a task as opposed to a module holding
  other namespaced tasks.
  """
  def is_task?(module) do
    Enum.find(module.module_info(:functions), fn({name, arity}) ->
      name == :run && arity == 1
    end)
  end

  defp to_lower(task) do
    list_to_binary(:string.to_lower(binary_to_list task))
  end
end
