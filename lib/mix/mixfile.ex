defmodule Mix.Mixfile do
  @moduledoc """
  Tools for loading mix project files.
  """

  @doc """
  Load a mix project file.
  """
  def load() do
    Code.require_file("mix")
  end
end
