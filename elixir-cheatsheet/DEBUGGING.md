![Elixir](https://elixir-lang.org/images/logo/logo.png)

# Debugging

- IO.inspect/1 & /2: Prints value and returns it without changing. '/2' can add a label.
- binding/0: Returns variable and names.
- IEx.pry: Is the same as 'IO.puts binding()'
- break!/2: Allows to set breakpoint without code modification
- 'iex -S mix' + ':debugger.start()': For line by line debugging
- 'iex -S mix' + ':observer.start()': For complex systems
