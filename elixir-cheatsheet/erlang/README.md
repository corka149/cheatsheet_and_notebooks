# Erlang

Some basic Erlang - mainly for the difference between Erlang and Elixir.

## Boolean Algebra & Comparison operators

```Erlang
1> true and false.
false
2> false or true.
true
3> true xor false.
true
4> not false.
true
5> true andalso false. % Will evaluate both sides
false
6> false orelse false. % Will evaluate both sides
false
```

## io:format

In depth source [official documentation](http://erlang.org/doc/man/io.html#format-2).
