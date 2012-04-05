defmodule ExternalTest do
  use ExUnit.Case

  test :take_all do
    assert_equal "foo\n", Mix.External.take_all(Mix.External.run_cmd("echo", ["foo"]))
  end
end
