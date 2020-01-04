-module(calculator).

-export([divide/2]).

divide(Dvidend, Divisor) when is_integer(Dvidend) and is_integer(Divisor) ->
    io:fwrite("Will divide ~B by ~B.~n", [Dvidend, Divisor]),
    Dvidend / Divisor;
divide(Dvidend, Divisor) when is_float(Dvidend) and is_float(Divisor) ->
    io:fwrite("Will divide ~g by ~g.~n", [Dvidend, Divisor]),
    Dvidend / Divisor;
divide(Dvidend, Divisor) when is_float(Dvidend) and is_float(Divisor) ->
    io:fwrite("Invalid format"),
    error.
