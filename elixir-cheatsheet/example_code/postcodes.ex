defmodule Postcodes do
  use GenServer

  ## CLIENT

  def create() do
    GenServer.start_link(__MODULE__, :ok, [name: :postcodes])
  end

  def add(city, code) do
    GenServer.cast(:postcodes, {:add, city, code})
  end

  def get(city) do
    GenServer.call(:postcodes, {:lookup, city})
  end


  ## SERVER - GenServer Callbacks

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @doc """
  handle_call is synchronous.
  """
  @impl true
  def handle_call({:lookup, city}, _from, %{} = cities_and_codes) do
    IO.puts "Fetch codes for city #{city}"
    {:reply, Map.fetch(cities_and_codes, city), cities_and_codes}
  end

  @doc """
  handle_cast is asynchronous.
  """
  @impl true
  def handle_cast({:add, city, code}, cities_and_code) do
    IO.puts "Add code #{code} for city #{city}"
    {:noreply, Map.update(cities_and_code, city, [], fn codes -> [code | codes] end)}
  end
end
