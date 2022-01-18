defmodule TonPaymentsTracker.TonApiClientTest do
  use ExUnit.Case, async: false

  import Mock

  alias TonPaymentsTracker.TonApiClient

  describe "get_transactions/0" do
    @response_body """
    {
      "ok": true,
      "result": [
        {
          "lt": 24761759000003,
          "timestamp": 1642518384,
          "hash": "tDiiI6K1f1FCsj1y2JVjjn6Vx2YqoaXNdAxAoAuR0E4=",
          "fee": 101871,
          "storage_fee": 1871,
          "other_fee": 100000,
          "received": {
            "from": "EQCtiv7PrMJImWiF2L5oJCgPnzp-VML2CAt5cbn1VsKAxLiE",
            "nanoton": 9950000000,
            "message": "i3wW4jQwmkeKk7J65ILYBjYRY17zgGc6U"
          },
          "sent": []
        },
        {
          "lt": 24748208000003,
          "timestamp": 1642474962,
          "hash": "SzOavdooITHMm/BNBl1OaflWgsgGtQp4l1x6aNDHyJ0=",
          "fee": 106369,
          "storage_fee": 6369,
          "other_fee": 100000,
          "received": {
            "from": "EQCr1U4EVmSWpx2sunO1jhtHveatorjfDpttMCCkoa0JyD1P",
            "nanoton": 5000000000,
            "message": "Withdrawal from Whales Pool"
          },
          "sent": []
        }
      ],
      "previous_transaction": {
        "lt": 24470131000003,
        "hash": "ii2rrmcrF45reUZZEipf1It7TLNf+3DPY49MhW1S+3A="
      }
    }
    """

    @expected_result [
      %{
        from: "EQCtiv7PrMJImWiF2L5oJCgPnzp-VML2CAt5cbn1VsKAxLiE",
        hash: "tDiiI6K1f1FCsj1y2JVjjn6Vx2YqoaXNdAxAoAuR0E4=",
        message: "i3wW4jQwmkeKk7J65ILYBjYRY17zgGc6U",
        value: 9_950_000_000
      },
      %{
        from: "EQCr1U4EVmSWpx2sunO1jhtHveatorjfDpttMCCkoa0JyD1P",
        hash: "SzOavdooITHMm/BNBl1OaflWgsgGtQp4l1x6aNDHyJ0=",
        message: "Withdrawal from Whales Pool",
        value: 5_000_000_000
      }
    ]

    test "should send request to api and convert to desired format" do
      with_mock HTTPoison, get: fn _ -> {:ok, %{body: @response_body}} end do
        assert @expected_result = TonApiClient.get_transactions()
      end
    end
  end
end
