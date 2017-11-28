defmodule Servy.SensorServer do

  @name :sensor_server

  use GenServer

  # Client

  def start_link(interval) do
    IO.puts "Starting the sensor server with #{interval} min refresh.."
    GenServer.start_link(__MODULE__, interval, name: @name)
  end

  def get_sensor_data do
    GenServer.call @name, :get_sensor_data
  end

  # Server Callbacks

  def init(interval) do
    initial_state = run_tasks_to_get_sensor_data()
    schedule_refresh(interval)
    {:ok, initial_state}
  end

  def handle_info({:refresh, interval}, _state) do
    IO.puts "Refreshing the cache..."
    new_state = run_tasks_to_get_sensor_data()
    schedule_refresh(interval)
    {:noreply, new_state}
  end

  def handle_info(unexpected, state) do
    IO.puts "Can't touch this! #{inspect unexpected}"
    {:noreply, state}
  end

  defp schedule_refresh(interval) do
    Process.send_after(self(), {:refresh, interval}, :timer.minutes(interval))
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  defp run_tasks_to_get_sensor_data do
    IO.puts "Running tasks to get sensor data.."

    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end
