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

  def default_task(project) do
    if project && project[:default] do
      project[:default]
    else:
      "help"
    end
  end

  defp project_defaults() do
    [compile_path: "exbin/",
     erlang_compile_path: "ebin/",
     test_paths: ["test/"],
     test_pattern: "*_test.exs",
     source_paths: ["lib/"],
     erlang_source_paths: ["src/"],
     compile_first: [],
     target_path: "target/"]
  end
end
