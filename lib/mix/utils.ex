defmodule Mix.Utils do
  @doc """
  Capitalize the first character of a string.
  """
  def capitalize(s) when is_list(s), do: capitalize list_to_binary(s)
  def capitalize(<<s>>), do: <<:string.to_upper(s)>>
  def capitalize(<<s, t|binary>>) do
    <<:string.to_upper(s)>> <> t
  end

  def touch(file) do
    info = File.file_info(file).update_mtime(fn(_) -> :calendar.local_time end)
    :file.write_file_info(file, setelem(info, 1, :file_info))
  end
end
