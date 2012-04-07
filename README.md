# Mix

Mix is a build tool and development aid for the
[Elixir](http://elixir-lang.org) programming language. It is heavily
inspired by the [Leiningen](https://github.com/technomancy/leiningen)
build tool for Clojure and is written by one of its contributors.

## Tasks

In Mix, a task is simply an Elixir module named with a `Mix.Tasks`
prefix. For example, the `compile` task is a module named
`Mix.Tasks.Compile`.

Here is a simple example task:

```elixir
defmodule Mix.Tasks.Hello do
  @behavior Mix.Task
  @shortdoc "This is short documentation, see."
  @moduledoc """
  A test task.
  """
  def run(_) do
    IO.puts "Hello, World!"
  end
end
```

This defines a task called `hello`. In order to make it a task, it
defines a `run` function that takes a single argument that will be a
list of binary strings which are the arguments that were passed to the
task on the command line or from another task calling this one.

When you invoke `mix hello`, this task will run and print `Hello,
World!`. Mix uses its first argument to lookup the task module and
execute its `run` function.

You're probably wondering why we have a `moduledoc` and `shortdoc`. Mix
has a `help` task for listing tasks and providing documentation of them.
Let's try it out:

```
~/code/mix(master) $ mix help
Available tasks:

iex: Start iex with your project's settings.
compile: Compile Elixir source files.
test: Run a project's tests.
clean: Delete compile path and target.
help: Print help information for tasks.
codepath: Prints the current load path.
hello: This is short documentation, see.
```

This lists all of the tasks that Mix can currently see. See the short
form documentation beside them? That is why we have `shortdoc`. It is a
one line string of documentation to be printed alongside the task name
in `mix help`.

Let's try looking at the long-form documentation of a task:

```
~/code/mix(master) $ mix help help
If given a task name, prints the documentation for that task.
If no task name is given, prints the short form documentation
for all tasks.

Arguments:
  task: Print the @doc documentation for this task.
  none: Print the short form documentation for all tasks.
```

Note that none of this is anything special. This is nothing more than
the `moduledoc` of the `Mix.Tasks.Help` module. It is a good example of
conventions to use when documenting Mix tasks.

## Project Configuration

Like Leiningen, tasks are written and projects are configured using the
same language they are being written for. You write your tasks in Elixir
and you configure your projects in Elixir. Every Elixir project should
have a `mix.exs` file that contains arbitrary Elixir code. This code can
require other files, define tasks, and it should at the very least
provide a basic project configuration. Here is a sample mix.exs file:

```elixir
defmodule Mix.Project do
  def project do
    [name: "mix",
     version: "0.1.0",
     compile_options: [ignore_module_conflict: true, docs: true]]
  end
end
```

Your project definition contains all of your project configuration. In
this case, we're letting Mix know that the name of the project it is
running in is mix (I know, how meta of me), is at version 0.1.0,
that it should ignore module conflicts when compiling, and that it
should compile with docs enabled (necessary for `mix help` to work).

There are a lot of configuration options you can set and any task is
free to invent its own. Mix's configuration is simplistic and concise
because Mix sane defaults for options that most every project will use.
Examples:

* `:compile_path` = `"exbin/"`
* `:source_paths` = `["lib/"]`
* `:test_paths`   = `["test/"]`

... and more. This file is the first thing that Mix loads, so you can do
some pretty cool stuff in there.

## What Mix Can Help You With

Mix does a lot of things out of the box.

### Compilation

Mix can handle your project's compilation for you. If you're a typical
Elixir project that uses `lib/` for source files and `exbin/` for
compiled beam files, you don't even have to provide any
compilation-specific setup. Just throw a simple `Mix.Project` in your
`mix.exs` (possibly with just `name` and `version`) and run `mix
compile`. That should be all you need to do.

As a bonus, Mix will only compile when necessary. If the compile task
gets invoked by you or by some other task that runs it, it will only
compile if source files have actually changed. See `mix help compile`
for more information.

You can, of course, customize this compilation however you want. If you
use some other path for source files or you use multiple paths, Mix can
help you.

### Testing

Mix handles testing for you. When you run `mix test`, it will start up
ExUnit and run all of the tests in `test/` and its subdirectories. By
default, it only runs files that end with `_test.exs`, so you can have
test helpers and such in the same place as your tests. This is
configurable along with the location of tests itself. You can even have
multiple directories with tests. See `mix help test` for more
information.

### iex

Have you gotten sick of typing `iex -pa exbin/` yet? Yeah, so did I. You
can run `mix iex` and you'll instantly have an iex session with your
`:compile_path` on the code path. More importantly, since Mix runs your
`mix.exs` file at startup, anything you do there is available to this
session as well. Get creative.

## Writing Tasks

Tasks are simple things in Mix. They are just modules named a certain
way that have a `run/1` function. They don't even *have* to have
documentation, but I'll punch you in the face if you don't write some
for your own tasks.

Tasks only need to be on the load path in order to be found. For
example, tasks compiled to beam files will be found as long as they're
on the code path. Furthermore, any tasks defined in `mix.exs` or any
files that it requires/loads are also available for use. They'll even be
picked up by `mix help`.

Look at existing tasks for examples. The `hello` task is extremely
simple and a great place to start.

### Namespaced Tasks

While tasks are simple, they can be used to accomplish complex things.
Since they are just Elixir code, anything you can do in normal Elixir
you can do in Mix tasks. This has been known to cause insanity in users
of the build tool and make them do insane things that nobody would do in
any other build tool. As such, they may be inclined to write a 'plugin'.

A Mix 'plugin' isn't anything special. As a matter of fact, it is just a
collection of (or even just one really awesome) task modules. You can
distribute tasks however you want just like normal libraries and thus
they can be reused in many projects.

So, what do you do when you have a whole bunch of related tasks? If you
name them all like `foo`, `bar`, `baz`, etc, eventually you'll end up
with conflicts with other people's tasks. To prevent this, Mix allows
you to namespace tasks.

Let's assume you have a bunch of tasks for working with MongoDB.

```elixir
defmodule Mix.Tasks.Mongodb do
  defmodule Dostuff do
    ...
  end

  defmodule Dootherstuff do
    ...
  end
end
```

Now you'll have two different tasks under the modules
`Mix.Tasks.Mongodb.Dostuff` and `Mix.Tasks.Mongodb.Dootherstuff`
respectively. You can invoke these tasks like so: `mix mongodb.dostuff`
and `mix mongodb.dootherstuff`. Pretty cool, huh?

You should use this feature when you have a bunch of related tasks that
would be unwieldly if named completely independently of each other. If
you have a few unrelated tasks, go ahead and name them however you like.

## Lots To Do

Mix is still very much a work in progress. Refer to the issue tracker
for a list of planned features/ideas. Please add issues for anything
you'd like to see in Mix and feel free to contribute.
