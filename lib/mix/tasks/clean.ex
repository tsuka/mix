defmodule Mix.Tasks.Clean do
  use Mix.Task
  @shortdoc "Delete compile path and target."
  @moduledoc """
  Deletes the files in compile path and target path.
  This has the effect of wiping all generated artifacts
  and .beam files.
  """
  def run(_) do
    project = Mix.Mixfile.get_project
    compile = project[:compile_path]
    target  = project[:target_path]
    IO.puts Enum.join(["Deleting files in ", compile, "..."])
    delete_in_dir compile
    IO.puts Enum.join(["Deleting files in ", target, "..."])
    delete_in_dir target
  end

  defp delete_in_dir(dir) do
    Enum.each(List.reverse(File.wildcard(File.join([dir, "**"]))), fn(file) ->
      if :filelib.is_dir(file) do
        :file.del_dir file
      else:
        :file.delete file
      end
    end)
  end
end
