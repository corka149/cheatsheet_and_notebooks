defmodule KeyValue do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send caller, Map.get(map, key)
        loop(map)
      {:put, key, value} ->
        loop(Map.put(map, key, value))
      end
  end
end

# in interactive shell:
# iex(1)> {:ok, pid} = KeyValue.start_link
# {:ok, #PID<0.108.0>}
# iex(2)> send pid, {:put, :john, "Pizza"} 
# {:put, :john, "Pizza"}
# iex(3)> send pid, {:get, :john, self()}
# {:get, :john, #PID<0.106.0>}
# iex(4)> flush()
# "Pizza"
# :ok
