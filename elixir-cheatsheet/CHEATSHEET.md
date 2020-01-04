![Elixir](https://elixir-lang.org/images/logo/logo.png)

# Cheatsheet - Basics

## Important hints

- Atoms are not garbage collected

## Operators

List

```
iex(1)> [1,2] ++ [3,4]
[1, 2, 3, 4]
iex(2)> [1,3,2,4] -- [3]
[1, 2, 4]

```

String

```
iex(1)> "Greetings" <> " Mars"
"Greetings Mars"

 # String interpolation - calls to_string
iex(1)> planet = "Mars"
"Mars"
iex(2)> "Hello #{planet}"
"Hello Mars"
iex(3)> tuple = {"Jupiter", "Venus"}
{"Jupiter", "Venus"}
iex(4)> "log: #{tuple}"
** (Protocol.UndefinedError) protocol String.Chars not implemented for {"Jupiter", "Venus"}
iex(4)> "log: #{inspect tuple}"
"log: {\"Jupiter\", \"Venus\"}"
```

boolean

```
 # Same type
iex(1)> true and true or false
true

 # Differrent types
 # all values except false and nil will evaluate to true
iex(2)> false || 13
13
iex(3)> !!(false || 13)
true
iex(4)> !nil
true

 # ==, !=, ===, !==, <=, >=, <, and > as
iex(1)> 1 == 1.0
true
iex(2)> 1 === 1.0
false

```

Sorting order
```
 # number < atom < reference < function < port < pid < tuple < map < list < bitstring
iex(1)> 3 < :atm
true
iex(2)> add = fn a -> a + a end
 #Function>6.128620087/1 in :erl_eval.expr/5<
iex(3)> 3 < add
true
```
[List of operators](https://hexdocs.pm/elixir/operators.html)

## Tuple and List

size/1: operation is in constant time (i.e. the value is pre-calculated)
length/1: operation is linear (i.e. calculating the length gets slower as the input grows)

byte_size/1
String.length/1
```
iex(1)> old = "älter"
"älter"
iex(2)> byte_size(old)
6
iex(3)> String.length(old)
5

```

## For help

Inspect

```
iex(1)> i 1
Term
  1
Data type
  Integer
 # ...
```

Help

```
iex(17)> h ==/2

                               def left == right                                

  @spec term() == term() :: boolean()

Returns true if the two items are equal.

 # ...
```

Pattern matching

```
iex(1)> x = 1 
1
iex(2)> 1 = x
1
iex(3)> 2 = x
** (MatchError) no match of right hand side value: 1

 # Must equal in size and type
iex(1)> t1 = {"Bob", :my_atm}
{"Bob", :my_atm}
iex(2)> {name, atm} = t1
{"Bob", :my_atm}
iex(3)> name 
"Bob"

 # Pattern for list
iex(1)> [head_a | tail_a] = [1, 2, 3]
[1, 2, 3]
iex(2)> head_a
1
iex(3)> tail_a
[2, 3]

 # Pin operator (when you want to pattern match against an existing variable’s)
iex(1)> x = 4
4
iex(2)> {f1, ^x} = {2, 4}
{2, 4}
iex(3)> {f1, ^x} = {2, 5}
** (MatchError) no match of right hand side value: {2, 5}

 # Underscore 
iex(10)> [head_a | _] = [1, 2, 3]     
[1, 2, 3]
iex(11)> _
** (CompileError) iex:11: invalid use of _. "_" represents a value to be ignored in a pattern and cannot be used in expressions
```

## 'case' [+ 'when']

[Guards](https://hexdocs.pm/elixir/guards.html)

```
iex(1)> t = {3, 6, 9}
{3, 6, 9}
iex(2)> case t do
...(2)> {3, x, 9} -> x
...(2)> _ -> 0
...(2)> end
6
 # when (errors in guards do not leak but simply make the guard fail)
iex(3)> case t do     
...(3)> {3, x, 9} when x < 0 -> x
...(3)> _ -> 0                   
...(3)> end                      
0
 # anonymous functions can also have multiple clauses and guards
 iex(1)> make_positiv = fn     
...(1)> x when x < 0 -> x * -1
...(1)> x -> x                
...(1)> end
#Function<6.128620087/1 in :erl_eval.expr/5>
iex(2)> make_positiv.(-2)
2
iex(3)> make_positiv.(2) 
2
```

## 'cond'

The "if else" from imperative languages. Goes into first branch that matches.

```
iex(1)> x = 2
2
iex(2)> cond do                          
...(2)> x -> "matches"                   
...(2)> x == 2 -> "will never be reached"
...(2)> end
"matches"
iex(3)> cond do                          
...(3)> x == 2 -> "will be reached"      
...(3)> x -> "this not"                  
...(3)> end
"will be reached"

```

## 'if' and 'unless'

They are macros and not control structures.
```
iex(1)> if true do
...(1)> IO.puts("Will be printed")
...(1)> end
Will be printed
:ok
iex(2)> unless false do
...(2)> IO.puts("Will be printed")
...(2)> end                       
Will be printed
:ok
```

## Keyword lists and 'do' + 'end'

do/end blocks are a syntactic convenience
```
 # All 3 does the same
iex(1)> x = 2
2
iex(2)> if(2 >= 0, do: "is positiv/zero", else: "is negativ")
"is positiv/zero"

iex(3)> if 2 >= 0, do: "is positiv/zero", else: "is negativ" 
"is positiv/zero"

iex(4)> if 2 >= 0 do        
...(4)> "is positiv/zero"
...(4)> else
...(4)> "is negativ"
...(4)> end
"is positiv/zero"

```

## Keyword lists

Lists with 2-item tuples. Used in functions like 'if'.

- keys must be atoms
- key order is specified by develiper
- keys can be give more than once

[Functions](https://hexdocs.pm/elixir/Keyword.html)
```
iex(1)> [{:a, 1}, {:b, 2}] == [a: 1, b: 2]
true
```

## Maps

- Allow any value as a key
- Keys do not follow any ordering
- Useful for pattern matching

[Functions](https://hexdocs.pm/elixir/Map.html)
```
iex(1)> m = %{:alice => 1234, 17 => "another_value"}
%{17 => "another_value", :alice => 1234}
iex(2)> m[17]
"another_value"
iex(3)> m[:alice]
1234

 # Pattern matching
iex(4)> %{:alice => id } = m
%{17 => "another_value", :alice => 1234}
iex(5)> id
1234

 # Update a value
iex(6)> m = %{m | :alice => 4321}
%{17 => "another_value", :alice => 4321}
iex(7)> m
%{17 => "another_value", :alice => 4321}

 # Accessing value when key is an atom
iex(8)> m.alice
4321

 # Working on nested structures: Put updates an value inside the nested structure
iex(13)> users = [            
...(13)>   john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
...(13)>   mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}  
...(13)> ]                                                                         
[
  john: %{age: 27, languages: ["Erlang", "Ruby", "Elixir"], name: "John"},
  mary: %{age: 29, languages: ["Elixir", "F#", "Clojure"], name: "Mary"}
]

iex(14)> put_in users[:john].name, "Johnny"
[
  john: %{age: 27, languages: ["Erlang", "Ruby", "Elixir"], name: "Johnny"},
  mary: %{age: 29, languages: ["Elixir", "F#", "Clojure"], name: "Mary"}
]

```


## String and binaries

They are UTF-8 encoded binary. [More about the <<>> operator](https://hexdocs.pm/elixir/Kernel.SpecialForms.html#%3C%3C%3E%3E/1)
```
 # Returns character's code point
iex(1)> ?ä
228

 # Defines a binary
iex(2)> <<5, 7, 9>>
<<5, 7, 9>>

 # Show inner binary representation
iex(3)> "ä" <> <<0>>
<<195, 164, 0>>
iex(4)> <<228 :: utf8>>
"ä"
iex(5)> <<300:: size(16)>>
<<1, 44>> # in bits 00000001, 00101100

 # pattern matching with binaries
iex(6)> <<3, 2, y :: binary>> = <<3, 2, 2, 1>>
<<3, 2, 2, 1>>
iex(7)> y
<<2, 1>>
iex(8)> "cor" <> rest = "corka"
"corka"
iex(9)> rest
"ka"

to_string(1)
```

## Charlists

With single quotes it is a charlist.
```
iex(17)> x = 'cörkä'
[99, 246, 114, 107, 228]
iex(18)> is_list(x)
true

to_charlist(1)
```

## Enumerables

### Enum

Enum works with any data that implements the [Enumerable protocol](https://hexdocs.pm/elixir/Enumerable.html). Enum works eager and create intermediate list.
```
 # With ranges
Enum.map(3..5, &(&1 * &1))
 # Or
Enum.map(3..5, fn x -> x * x end)
 # On map
Enum.map(%{ 2 => 3, 4 => 5}, fn {k, v} -> k * v end)
```

### Pipe operator ( |> )

Elixir's operator ' |> ' is like Unix's ' | '.
- Takes expression and passes as first argument to the right function
- [More documentation](https://hexdocs.pm/elixir/Kernel.html#%7C%3E/2)
```
iex> 1..100_000 |> Enum.map(&(&1 * 3)) |> Enum.filter(odd?) |> Enum.sum
 # Is equal to
iex> Enum.sum(Enum.filter(Enum.map(1..100_000, &(&1 * 3)), odd?))
```

# Streams

Same functionality like Map but Streams work lazy.
```
iex(1)> planets = ["Jupiter", "Venus", "Mars", "Saturn"]
["Jupiter", "Venus", "Mars", "Saturn"]

iex(2)> greetings = planets |> Stream.filter(fn str -> String.length(str) > 4 end) |> Stream.map(fn str -> "Hi " <> str end)
#Stream<[
  enum: ["Jupiter", "Venus", "Mars", "Saturn"],
  funs: [#Function<40.2459763/1 in Stream.filter/2>,
   #Function<48.2459763/1 in Stream.map/2>]
]>

# Streams are only consumed by Enum
iex(3)> Enum.map(greetings, fn str -> str <> "!" end)                                                                  ["Hi Jupiter!", "Hi Venus!", "Hi Saturn!"]

# Stream.unfold/2 generates a stream from an existing value
iex(4)> Stream.unfold("Jupiter", &String.next_codepoint/1) |> Enum.to_list()
["J", "u", "p", "i", "t", "e", "r"]
```

## IO

Can be used for terminal interactions
```
iex(1)> result = IO.gets "Your favorite food? "
Your favorite food? Pizza
"Pizza\n"
 # Writes to stdout but you can also do: "IO.puts :stderr ..."
iex(2)> IO.puts "You said: " <> result
You said: Pizza

:ok
```

### 'File' module

- Files are opened in binary mode
- :utf8 can be used for UTF-8 encoding

File can also
- .rm: Deleting files
- .mkdir or mkdir_p: Maken directories
- .cp_r: Copy recursive
- .rm_rf: Delete recursive
```
iex(1)> {:ok, file} = File.open "filewrite.test", [:write]
{:ok, #PID<0.105.0>}
iex(2)> IO.binwrite file, "Greetings Venus"
:ok
iex(3)> File.close file
:ok
iex(4)> File.read "filewrite.test"
{:ok, "Greetings Venus"}
```

## 'alias', 'require' and 'import'

- Can be used for multiple modules, eg: import MyApp.{Greeter, Waitress}
- An alias in Elixir is a capitalized identifier (like String)
- Alias without ", as:" aliases the last part (eg Foo.Bar to Bar)
```
alias Foo.Bar, as: Bar

# Require the module in order to use its macros
require Foo

# Import functions from List so they can be called without the `List.` prefix
import List, only: [duplicate: 2] 
# 'only:' can be omitted | :except is also
# possible | only: macros
# does automatically 'requires'

# Injects code
use Foo
```

# Structs

- Structs use the module name where they are defined
- Are created with: %Modulename{}
- Are maps (but without its protocols implementations)
- Work with Map module

[Struct example](./example_code/waitress.ex)
```
defmodule Waitress do
  defstruct name: "unkown", age: -1
end

iex(1)> w = %Waitress{age: 41}
** (ArgumentError) the following keys must also be given when building struct Waitress: [:id]
iex(1)> w = %Waitress{id: 1, age: 41}
%Waitress{age: 41, id: 1, name: "unkown"}

 # Update the struct
iex(2)> w = %{w | name: "Alice"}
%Waitress{age: 41, id: 1, name: "Alice"}

 # Pattern matching
iex(3)> %{age: w_age} = w
%Waitress{age: 41, id: 1, name: "Alice"}
iex(4)> w_age
41
iex(5)> %Waitress{age: w_age} = w
%Waitress{age: 41, id: 1, name: "Alice"}
iex(6)> %Waitress{age: w_age} = {}
** (MatchError) no match of right hand side value: {}
iex(6)> %{age: w_age} = {}        
** (MatchError) no match of right hand side value: {}
iex(6)> w.__struct__
Waitress
```

## Protocols

[Protocol example](./example_code/greeter.exs)
```
 # Example protocol (note 'any'):
defprotocol Size do
  @doc "Calculates the size (and not the length!) of a data structure"
  def size(data)
end

 # Default behaviour, note 'any':
defimpl Size, for: Any do
  def size(_), do: 0
end

 # Explicit derive the default behaviour
defmodule OtherUser do
  @derive [Size]
  defstruct [:name, :age]
end
```

## Comprehensions

They filter and map values to new enumerables.
```
 # 'n <- 1..5' is the generator
iex(1)> for n <- 1..5, do: n * n
[1, 4, 9, 16, 25]

 # filtering - discards false and nil
iex(2)> for n <- 1..5, rem(n, 2) == 0, do: n * n
[4, 16]

 # multiple generators
iex(3)> for n <- 1..5,
...(3)>  m <- 6..9 do
...(3)>  n * m
...(3)> end
[6, 7, 8, 9, 12, 14, 16, 18, 18, 21, 24, 27, 24, 28, 32, 36, 30, 35, 40, 45]

 # bitstring generators
iex(4)> bitstring = "lowercase"
"lowercase"
iex(5)> for <<c <- bitstring>>, do: c - 32    
'LOWERCASE'

 # into: for changing the target type
iex(6)> for <<c <- bitstring>>, into: "", do: <<c - 32>>
"LOWERCASE"
iex(7)> for <<c <- bitstring>>, do: <<c - 32>>          
["L", "O", "W", "E", "R", "C", "A", "S", "E"]
```

## Sigils

[GOTO](./SIGILS.md)

## Processes

[GOTO](./PROCESSES.md)

## Modules, behaviour, typespecs and functions

[GOTO](./MODULES_AND_FUNCTIONS.md)

## Try, catch and rescue

[GOTO](./ERRORS.md)

## Debugging

[GOTO](./DEBUGGING.md)

## Libraries provided by Erlang

[Examples](https://elixir-lang.org/getting-started/erlang-libraries.html)

- [The binary module](http://erlang.org/doc/man/binary.html)
- [Formatted text output](http://erlang.org/doc/man/io.html#format-1)
- [The crypto module](http://erlang.org/doc/man/crypto.html) - Must be included as :crypto dependency
- Erlang Term Storage: [ETS](http://erlang.org/doc/man/ets.html) and [DETS](http://erlang.org/doc/man/dets.html) for storing large date in memory
- [Math](http://erlang.org/doc/man/math.html)
- [Queue - (FIFO)](http://erlang.org/doc/man/queue.html)
- [Random](http://erlang.org/doc/man/rand.html)
- [ZIP](http://erlang.org/doc/man/zip.html)
- [ZLIB - (e.g. gzip)](http://erlang.org/doc/man/zlib.html)
