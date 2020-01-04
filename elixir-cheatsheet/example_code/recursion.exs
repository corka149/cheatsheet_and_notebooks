# Instead of loops - FP uses recursion
defmodule Recursion do
  def factorial(n) do
   calc_factorial(1, n)
  end

  # Called 'base case'
  defp calc_factorial(x, n) when n <= 1 do
    x * n 
  end

  defp calc_factorial(x, n) do
    calc_factorial(x * n, n - 1)    
  end
end

IO.puts(Recursion.factorial(5))
