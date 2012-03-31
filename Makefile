compile:
	@ elixirc "lib/**/*.ex" -o exbin/ --docs

clean:
	@ rm -rf exbin

test: compile
	@ time elixir -pa exbin/ -r "test/**/*_test.exs"

