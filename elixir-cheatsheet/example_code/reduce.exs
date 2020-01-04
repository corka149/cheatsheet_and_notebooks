defmodule Reduce do
  # Matches only a none empty list
  def concat([head | tail], str) do
    concat(tail, str <> head)
  end

  # Matches an empty list
  def concat([], str) do
    str
  end
end

# Can also be solved with the Enum module:
# Enum.reduce(["s", "u", "n", "e", "v"], "", &<>/2)
