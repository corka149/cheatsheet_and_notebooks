![Elixir](https://elixir-lang.org/images/logo/logo.png)

# Cheatsheet - Errors and similar things

- Try/Rescue are rarely used

## Errors / Exceptions

When exceptional things happen
```
iex(1)> 1 / 0
** (ArithmeticError) bad argument in arithmetic expression: 1 / 0
    :erlang./(1, 0)
iex(1)> raise "oops"
** (RuntimeError) oops

iex(1)> raise ArithmeticError, message: "Division by 0"
** (ArithmeticError) Division by 0

 # An own created Error
iex(1)> defmodule YetAnotherError do
...(1)>  defexception message: "Well, it went wrong"
...(1)> end

iex(2)> raise YetAnotherError
** (YetAnotherError) Well, it went wrong
```

## Rescue

'Rescue' can catch errors.
```
iex(2)> try do
...(2)>  raise YetAnotherError
...(2)> rescue
...(2)>  yae in YetAnotherError -> yae
...(2)> end
%YetAnotherError{message: "Well, it went wrong"}
```

## Throw

Let a function return early /with a specific value/.
```
iex(1)> char = 'h'
'h'
iex(2)> chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']
['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']
iex(3)> try do                                                    
...(3)>  Enum.each chars, fn(k) ->
...(3)>   if char == k, do: throw(k)
...(3)>  end                        
...(3)>  'k'                        
...(3)> catch                       
...(3)>  l -> "Got #{l}"            
...(3)> end                         
"Got h"
```

## Exits

Let a process sends explicit an exit signal. Its usage is very rare.
```
iex(1)> exit 1337
** (exit) 1337
```

## After

Defines a final-block that will always be executed after a "try&raise Error"
```
iex(1)> try do
...(1)>  1/0
...(1)> after
...(1)>  IO.puts "Finally..."
...(1)> end
Finally...
** (ArithmeticError) bad argument in arithmetic expression: 1 / 0
    :erlang./(1, 0)
```

## Else

It can be use the return value.
```
iex(1)> try do
...(1)>  30 - 15
...(1)> rescue
...(1)>  ArithmeticError -> 0
...(1)> else
...(1)>  x when x > 0 -> "Greater 0"
...(1)>  _ -> "Under 0"
...(1)> end
"Greater 0"
```