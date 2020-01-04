![Elixir](https://elixir-lang.org/images/logo/logo.png)

# Cheatsheet - Modules and functions

## Modules

```
defmodule Waitress do
  def greet(name) do
    "hello " <> name
  end
end

```

## Named functions

```
  # public
  def greet(name) do
    prepare_greet(name)
  end

  # private
  defp prepare_greet(name) do
    "Hello " <> name
  end

 # Remember keyword lists?
def greet(name) when is_binary(name)  do
  prepare_greet(name)
end
 # is same like this
def greet(name) when is_binary(name), do: prepare_greet(name)

 # function capturing
iex(1)> say_hi = &Waitress.greet/1
&Waitress.greet/1
iex(2)> is_function(say_hi)
true
iex(3)> say_hi.("Venus")
"Hello Venus"
 # Or
iex(4)> captured = &("Welcome" <> &1) # &1 is first argument   
#Function<6.128620087/1 in :erl_eval.expr/5>
iex(5)> captured.("Venus")
"WelcomeVenus"


```

## Functions and default values

Function has multiple clauses + default values? Then the default values have to be declared in a function head without a function body.
```
defmodule Tax do
  def calc(price, item \\ nil, tax \\ 0.19)

  def calc(price, item, tax) when is_nil(item) do
    price * tax
  end

  def calc(price, item, tax) do
    price * item * tax
  end
end
```

## Module attributes

@:
- vsn: Is used by code reloading mechanism in erlang vm else it use MD5 checksum
- moduledoc: Documentation for module
- doc: Documentation for macros and functions
- behaviour: Specify an OTP or user-defined behaviour
- before_compile: Injects something before compilation

[Guide for documentation](https://hexdocs.pm/elixir/writing-documentation.html)
[Doc generator in html](https://github.com/elixir-lang/ex_doc)
[Example](./example_code/waitress.ex)
```
defmodule MyServer do
  @vsn 2
end
```

### As 'constants'

@default_name will be read at compilation time.

```
  @default_name "customer"

  def greet("") do
    "hello " <> @default_name
  end
```

## Typespecs

Its purpose:
- As documentation
- Static code analysis with Dialyzer
```
defmodule LousyCalculator do
  @typedoc """
  Just a number followed by a string.
  """
  @type number_with_remark :: {number, String.t}

  @spec add(number, number) :: number_with_remark
  def add(x, y), do: {x + y, "You need a calculator to do that?"}

  @spec multiply(number, number) :: {number, String.t}
  def multiply(x, y), do: {x * y, "It is like addition on steroids."}
end
```

## Behaviours

Allows 'Java-like interfaces'
```
 # Definition
defmodule Parser do
  @callback parse(String.t) :: {:ok, term} | {:error, String.t}
  @callback extensions() :: [String.t]

  def parse!(implementation, contents) do
    case implementation.parse(contents) do
      {:ok, data} -> data
      {:error, error} -> raise ArgumentError, "parsing error: #{error}"
    end
  end
end

 # Implementation
defmodule JSONParser do
  @behaviour Parser

  @impl Parser
  def parse(str), do: {:ok, "some json " <> str} # ... parse JSON
  
  @impl Parser
  def extensions, do: ["json"]
end
```

## Elixir project order

- ebin - contains the compiled bytecode
- lib - contains elixir code (usually .ex files)
- test - contains tests (usually .exs files)