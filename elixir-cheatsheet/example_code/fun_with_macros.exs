IO.inspect(quote do: 1 + 2)
# => {:+, [context: Elixir, import: Kernel], [1, 2]}

IO.inspect(quote do: div(10, 5))
# => {:div, [context: Elixir, import: Kernel], [10, 5]}

defmodule Math do
  defmacro say({:+, _meta_data, [lhs, rhs]}) do
    quote do
      # Without quote it will look for a  variable or method named "lhs" & "rhs"
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs + rhs
      IO.puts "#{lhs} plus #{rhs} is #{result}"
    end
  end
end
require Math
Math.say(1 + 2)
