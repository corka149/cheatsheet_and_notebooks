defmodule Waitress do
  def greet(name) when is_binary(name), do: prepare_greet(name)

  # private
  defp prepare_greet("Mars") do
    "Greetings, Mars, old friend"
  end

  # private
  defp prepare_greet(name) do
    "Hello " <> name
  end
end

IO.puts Waitress.greet("Earth")             # "Hello Earth"
# IO.puts Waitress.prepare_greet("Jupiter") # Error: function Waitress.prepare_greet/1 is undefined or private
IO.puts Waitress.greet("Mars")              # "Greetings, Mars, old friend"
# IO.puts Waitress.greet(1)                 # Error: no function clause matching in Waitress.greet/1 
