defmodule MathMap do
  def square_each([head | tail]) do
    [head * head | square_each(tail)]
  end

  def square_each([]) do
    []
  end
end

# Can also be solve with the Enum Module:
# Enum.map([2, 3, 4], &(&1 * &1))
