defmodule TonPaymentsTracker.DatabaseHandler do
  use GenServer
  require Logger

  alias TonPaymentsTracker.{PaymentsChecker, PaymentsHistory}

  def start_link(_opts) do
    log("Database handler process started...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_info({:api_fetch_result, transactions}, state) do
    log("Received data: #{inspect(transactions)}.")
    save_to_db(transactions)
    {:noreply, state}
  end

  defp save_to_db(transactions_data) do
    records =
      Enum.map(transactions_data, fn transaction_data ->
        case PaymentsHistory.create_transaction(transaction_data) do
          {:ok, record} -> record
          {:error, _} -> nil
        end
      end)
      |> Enum.reject(&is_nil/1)

    if Enum.any?(records) do
      send(Process.whereis(PaymentsChecker), {:new_transactions, records})
    end
  end

  defp log(msg) do
    Logger.info("| #{__MODULE__} | #{msg}")
  end
end
