defmodule Mix do
  def start(args // System.argv) do
    Mix.Mixfile.load
    case args do
    match: [h]
      Mix.Tasks.run_task h
    match: [h|t]
      Mix.Tasks.run_task h, t
    match: []
      Mix.Tasks.run_task(Mix.Mixfile.default_task(Mix.Mixfile.get_project))
    end
  end
end
