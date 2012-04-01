defmodule Mix do
  def start(args // Code.argv) do
    Mix.Mixfile.load()
    case args do
    match: [h]
      Mix.Tasks.run_task h
    match: [h|t]
      Mix.Tasks.run_task h, t
    match: []
      IO.puts "You have to give me a task to execute!"
    end
  end
end
