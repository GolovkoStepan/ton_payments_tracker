defmodule TonPaymentsTracker.TrackerSystemTest do
  use TonPaymentsTracker.DataCase

  import Mock

  alias TonPaymentsTracker.PaymentsHistory
  alias TonPaymentsTracker.Repo

  alias TonPaymentsTracker.{
    TonApiClient,
    ApiFetcher,
    DatabaseHandler,
    PaymentsChecker,
    TrackerSupervisor
  }

  @code "QWERTY"
  @value 500
  @transactions [
    %{
      hash: "wrrewweytuoertoe34f83y4f9",
      from: "32tygf473if3g3i46f",
      message: @code,
      value: @value
    },
    %{
      hash: "wrrewweytuoertoe34f83y4f9",
      from: "32tygf473if3g3i46f",
      message: @code,
      value: @value
    }
  ]

  describe "processes work test" do
    import TonPaymentsTracker.PaymentsHistoryFixtures

    test "processes started" do
      refute nil == Process.whereis(TrackerSupervisor)
      refute nil == Process.whereis(ApiFetcher)
      refute nil == Process.whereis(DatabaseHandler)
      refute nil == Process.whereis(PaymentsChecker)
    end

    test_with_mock "confirm payment", TonApiClient, get_transactions: fn -> @transactions end do
      payment = payment_fixture(%{code: @code, value: @value})
      refute payment.confirmed

      Process.sleep(5_000)

      last_transaction = PaymentsHistory.list_transactions() |> List.last()
      assert last_transaction.message == @code
      assert last_transaction.value == @value

      assert Repo.reload!(payment).confirmed
    end
  end
end
