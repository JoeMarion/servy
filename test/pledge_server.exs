defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  test "the server caches only the most recent three pledges and their totals" do
    PledgeServer.start()

    [{"larry", 100}, {"moe", 200}, {"curly", 500}, {"daisy", 400}]
    |> Enum.map(&PledgeServer.create_pledge(elem(&1, 0), elem(&1, 1)))

    most_recent_pledges = [{"daisy", 400}, {"curly", 500}, {"moe", 200}]

    assert PledgeServer.recent_pledges() == most_recent_pledges

    assert PledgeServer.total_pledged() == 1100
  end
end
