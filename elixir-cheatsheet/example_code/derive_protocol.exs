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
