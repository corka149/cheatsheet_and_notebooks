# Protocol example

defprotocol Greeter do
  def greet(data)
end

defmodule User do
  defstruct [:name]

  defimpl Greeter, for: User do 
    def greet(user) do
      %User{name: name} = user
      "hello " <> name
    end
  end
end

# iex(1)> u = %User{name: "Bob"}
# %User{name: "Bob"}
# iex(2)> Greeter.greet(u)
# "hello Bob"

