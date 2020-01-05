defmodule Monitoring do
  @moduledoc """
  Shows monitoring and restarting ability of Elixir's supervision.
  """

  ## SHEPHERD

  def spawn_shepherd(amount_sheeps) do
    Process.spawn(Monitoring, :shepherd, [amount_sheeps], [:monitor])
  end

  def shepherd(amount_sheeps) do
    sheeps = Range.new(1, amount_sheeps)
    |> Enum.map(fn x -> spawn_sheep(x) end)
    |> Enum.reduce(%{}, fn {num, {_pid, ref}}, acc -> Map.put(acc, ref, num) end)

    watch(sheeps)
  end

  defp watch(sheeps) do
    receive do
      {:DOWN, ref, _kind, _pid, _type} ->
        number = Map.get(sheeps, ref, -1)
        {_oldval, sheeps} = Map.pop(sheeps, ref)
        IO.puts "Buy new sheep with for number #{number}."

        {num, {_pid, ref}} = spawn_sheep(number)
        sheeps = Map.put(sheeps, ref, num)
        watch(sheeps)
    after 5_000 ->
      IO.puts "Nothing happend"
      watch(sheeps)
    end
  end

  ~S"""
  GenServers can listen on "DOWN message" like so:

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, genserver_state) do
    # ... logic goes here
    {:noreply, genserver_state}
  end
  """

  ## SHEEPs

  defp spawn_sheep(number) do
    {number, Process.spawn(fn -> sheep(number) end, [:monitor])}
  end

  defp sheep(number) do
    be_sheep(number)
  end

  defp be_sheep(number) do
    Process.sleep(round(15_000 * :rand.uniform()))
    if is_alive?() do
      raise "Sheep #{number} died."
    end
    be_sheep(number)
  end

  defp is_alive? do
    round(100 * :rand.uniform()) >= 90
  end
end
