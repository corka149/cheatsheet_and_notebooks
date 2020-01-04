![Elixir](https://elixir-lang.org/images/logo/logo.png)

# Cheatsheet - Sigils

A mechanism for working with textual representations.

## Delimiters

```
~r/hello/
~r|hello|
~r"hello"
~r'hello'
~r(hello)
~r[hello]
~r{hello}
~r<hello>

iex(1)> ~s"""
...(1)> this
...(1)> is
...(1)> multiline
...(1)> """
```

## RegEx

[Official documentation](https://hexdocs.pm/elixir/Regex.html)
Regular expressions created via sigils are pre-compiled and stored in the .beam file.

```
iex(1)> test = "Test"
"Test"
iex(2)> regex = ~r/es/
~r/es/
iex(3)> test =~ regex
true

iex(4)> test = "tEsT"
"tEsT"
iex(5)> regex = ~r/es/i
~r/es/i
iex(6)> test =~ regex  
true
```

## Strings, char lists, and word lists sigils

Strings
```
iex(1)> ~s(The " does not need escaping. Same goes for ' here.)
"The \" does not need escaping. Same goes for ' here."

 # s != S
iex(1)> planet = "Venus"
"Venus"
iex(2)> ~s(Hi #{planet})
"Hi Venus"
iex(3)> ~S(Hi #{planet})
"Hi \#{planet}"
```

Char lists
```
iex(1)> planet = 'Venus'
'Venus'
iex(2)> ~c(Hi #{planet})
'Hi Venus'
iex(3)> ~C(Hi #{planet})
'Hi \#{planet}'
```

Word lists - splits by spaces
```
iex(1)> ~w(Venus Mars Saturn)
["Venus", "Mars", "Saturn"]
iex(2)> ~w(Venus Mars Saturn)c
['Venus', 'Mars', 'Saturn']
iex(3)> ~w(Venus Mars Saturn)s
["Venus", "Mars", "Saturn"]
iex(4)> ~w(Venus Mars Saturn)a
[:Venus, :Mars, :Saturn]
```

## Custom sigils

Call the ~r equals sigil_r/2.
```
iex(1)> defmodule UpperLower do
...(1)>  def sigil_l(string, []), do: String.downcase(string)
...(1)>  def sigil_l(string, [?u]), do: String.upcase(string)   
...(1)> end

iex(2)> import UpperLower
UpperLower
iex(3)> ~l(TesT)         
"test"
iex(4)> ~l(TesT)u        
"TEST"
```