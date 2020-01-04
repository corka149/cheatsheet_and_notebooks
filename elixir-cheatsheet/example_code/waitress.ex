defmodule Waitress do
  @default_name "customer"

  @moduledoc """
  Takes care of custom requests.

  ## Examples
  

    iex> Waitress.greet("Alice")
    hello Alice
  
  """

  @enforce_keys [:id] # Required value
  defstruct [:id, name: "unkown", age: -1]

  def greet("") do
    "hello " <> @default_name
  end

  @doc """
  Greets a customer.
  """
  def greet(name) do
    "hello " <> name
  end
end
