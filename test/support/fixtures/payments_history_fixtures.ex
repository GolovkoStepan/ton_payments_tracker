defmodule TonPaymentsTracker.PaymentsHistoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TonPaymentsTracker.PaymentsHistory` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        from: random_str(),
        hash: random_str(),
        message: random_str(),
        value: 420000
      })
      |> TonPaymentsTracker.PaymentsHistory.create_transaction()

    transaction
  end

  defp random_str(str_length \\ 50) do
    for _ <- 1..str_length, into: "", do: <<Enum.random('0123456789abcdef')>>
  end
end
