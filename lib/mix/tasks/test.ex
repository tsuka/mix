defmodule Mix.Tasks.Test do
  use Mix.Task
  @shortdoc "Run a project's tests."
  @moduledoc """
  Run the tests for a project. This will have the effect
  of requiring all files that match the glob pattern in
  :test_pattern inside of your :test_paths. By default,
  :test_pattern is "*_test.exs" by default and
  :test_paths is ["test/"].
  """
  def run(_) do
    Mix.Tasks.run_task "compile"
    project = Mix.Mixfile.get_project
    ExUnit.start []
    Enum.each(project[:test_paths], fn(path) ->
      Enum.each(File.wildcard(File.join([path, "**", project[:test_pattern]])), fn(file) ->
        Code.require_file file
      end)
    end)
  end
end
