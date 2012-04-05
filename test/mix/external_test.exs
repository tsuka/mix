defmodule ExternalTest do
  use ExUnit.Case
  import Mix.External

  test :take_all do
    assert_equal "foo\n", take_all(run_cmd("echo", ["foo"]))
  end

  test :lists do
    assert_equal "foo\n", take_all(run_cmd('echo', ['foo']))
  end
end
