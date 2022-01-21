defmodule TonPaymentsTracker.PaymentsChecker do
  use GenServer
  require Logger

  alias Phoenix.PubSub
  alias TonPaymentsTracker.PaymentsHistory

  def start_link(_opts) do
    log("Payments checker process started...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_info({:new_transactions, transactions}, state) do
    log("New transactions signal received. Count: #{Enum.count(transactions)}.")

    case check_payments(transactions) do
      :not_found ->
        log("No payments found.")
        {:noreply, state}

      :found ->
        log("Payments found.")
        PubSub.broadcast(TonPaymentsTracker.PubSub, "history", :update)
        {:noreply, state}
    end
  end

  defp check_payments(transactions) do
    payments =
      Enum.map(transactions, fn transaction ->
        PaymentsHistory.get_payment_by_transaction(transaction)
      end)
      |> Enum.reject(&is_nil/1)

    case payments do
      [] ->
        :not_found

      records ->
        Enum.each(records, fn record -> PaymentsHistory.confirm_payment(record) end)
        :found
    end
  end

  defp log(msg) do
    Logger.info("| #{__MODULE__} | #{msg}")
  end
end
