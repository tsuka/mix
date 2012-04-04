defmodule Mix.External do
  @moduledoc """
  Utilities for creating and working with external
  processes.
  """

  @doc """
  Takes a program name and optionally a list of
  arguments and runs the command via a port inside
  of an Erlang process. The process pid is returned.
  You can work with this process by sending messages
  to it:

  If you want to take some data from the process:

  `{caller-pid, :take}`

  This will cause the process to try to read for data
  from the program's output. This will be sent to caller-pid
  as {pid, data}. If the program has produced EOF, the message
  {pid, :eof} will be sent.

  You can send data to the process by sending a message:

  `{:put, data}`

  Data is a string that will be sent to the process.

  If you send `{caller-pid, :stream_to_out}`, the process
  will print all of the output from the program to Erlang's
  standard out. This is for convenience.
  """
  def run_cmd(name, args // []) do
    Process.spawn(fn() ->
      port = cmd(name, args)
      loop do
      match:
        receive do
        match: {pid, :take}
          pid <- {Process.self, receive_data(port)}
          recur
      match: {:put, data}
          :erlang.port_command port, data
          recur
        match: {pid, :stream_to_out}
          pid <- {Process.self, internal_stream_to_out(port)}
        end
      end
    end)
  end

  defp internal_stream_to_out(port) do
    case receive_data(port) do
    match: :eof
      :eof
    match: data
      IO.print data
      internal_stream_to_out(port)
    end
  end

  defp receive_data(port) do
    receive do
    match: {^port, {:data, data}}
      data
    match: {^port, :eof}
      :eof
    end
  end

  defp cmd(name, args // []) do
    :erlang.open_port({:spawn_executable, :os.find_executable(name)},
                      [:binary, {:args, args}, :eof, :stream, :in, :out])
  end

  @doc """
  Takes a process returned by run_cmd and streams its
  output to Erlang's standard out. Blocks until finished
  and then returns :ok.
  """
  def stream_to_out(proc) do
    proc <- {Process.self, :stream_to_out}
    receive do
    match: {^proc, :eof}
      :ok
    end
  end

  @doc """
  Takes a process returned by run_cmd and eats all of
  its output until it receives :eof at which point it
  returns all of this output as a single string.
  """
  def take_all(proc) do
    do_take_all(proc)
  end

  defp do_take_all(proc, acc // []) do
    proc <- {Process.self, :take}
    receive do
    match: {^proc, :eof}
      Enum.join acc
    match: {^proc, data}
      do_take_all proc, [data|acc]
    end
  end
end
