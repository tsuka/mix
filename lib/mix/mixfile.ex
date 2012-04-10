defmodule Mix.Mixfile do
  @moduledoc """
  Tools for loading mix project files.
  """

  @doc """
  Load a mix project file.
  """
  def load() do
    if :filelib.is_file("mix.exs") do
      Code.require_file("mix")
    end
    case get_project do
    match: nil
      nil
    match: project
      add_local_code project
    end
  end

  @doc """
  Load the project.
  """
  def get_project() do
    case :code.ensure_loaded(Mix.Project) do
    match: {:module, _}
      Keyword.merge(project_defaults, Mix.Project.project, fn(_, x, y) ->
        if is_list(x) && is_list(y) do
          x ++ y
        else:
          y
        end
      end)
    else:
      nil
    end
  end

  @doc """
  Takes a project. If this argument is `nil` or is a Keyword
  that does not contain the `:default` key, returns "help".
  Otherwise, returns the value at the `:default` key in the
  project.
  """
  def default_task(project) do
    if project && project[:default] do
      project[:default]
    else:
      "help"
    end
  end

  defp add_local_code(project) do
    Code.append_path(project[:compile_path])
    Code.append_path(project[:erlang_compile_path])
  end

  defp project_defaults() do
    [compile_path: "ebin/",
     erlang_compile_path: "ebin/",
     test_paths: ["test/"],
     test_pattern: "*_test.exs",
     source_paths: ["lib/"],
     erlang_source_paths: ["src/"],
     compile_first: [],
     target_path: "target/"]
  end
end
