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
      Keyword.merge Mix.Project.project, project_defaults 
    else:
      nil
    end
  end

  defp project_defaults() do
    [compile_path: "exbin/",
     test_paths: ["test/"],
     source_paths: ["lib/"]]
  end
end
