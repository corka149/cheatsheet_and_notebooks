# Example for default values for functions
defmodule Tax do
  def calc(price, item \\ nil, tax \\ 0.19)

  def calc(price, item, tax) when is_nil(item) do
    price * tax
  end

  def calc(price, item, tax) do
    price * item * tax
  end
end
