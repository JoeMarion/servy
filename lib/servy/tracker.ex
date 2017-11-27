defmodule Servy.Tracker do
  @doc """
  Simulates sending a reuest to an external API
  to get the GPS coordinates of a wildthing.
  """
  def get_location(wildthing) do
    # CODE GOES HERE TO SEND A REQIEST TO THE EXTERNAL API

    # Sleep to simulate the API delat:
    :timer.sleep(500)

    # Example responses reurned from the API:
    locations = %{
      "roscoe" => %{ lat: "44.4280", lng: "110.5885 W"},
      "smokey" => %{ lat: "48.7596", lng: "113.7870 W"},
      "brutus" => %{ lat: "43.7904 N", lng: "110.6818 W"},
      "bigfoot" => %{ lat: "29.0469", lng: "98.8667 W"}
    }

    Map.get(locations, wildthing)
  end
end
