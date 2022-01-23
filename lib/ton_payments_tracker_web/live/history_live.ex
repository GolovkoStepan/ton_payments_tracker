defmodule TonPaymentsTrackerWeb.HistoryLive do
  use TonPaymentsTrackerWeb, :live_view

  alias TonPaymentsTracker.PaymentsHistory

  def mount(_params, _session, socket) do
    if connected?(socket) do
      TonPaymentsTrackerWeb.Endpoint.subscribe("history")
    end

    {
      :ok,
      assign(socket, payments: PaymentsHistory.list_payments())
    }
  end

  def handle_event("create-payment", %{"value" => value}, socket) do
    case value do
      "" ->
        {:noreply, put_flash(socket, :error, "Сумма платежа не была указана.")}

      sum ->
        sum_in_nanoton = convert_to_nanoton(sum)
        payment_code = generate_code()
        {:ok, payment} = PaymentsHistory.create_payment(%{code: payment_code, value: sum_in_nanoton})

        {
          :noreply,
          socket
          |> put_flash(:info, "Код для платежа: #{payment_code}, сумма: #{sum}")
          |> update(:payments, fn payments -> [payment | payments] end)
        }
    end
  end

  def handle_info(:update, socket) do
    {:noreply, assign(socket, payments: PaymentsHistory.list_payments())}
  end

  defp generate_code do
    for _ <- 1..60, into: "", do: <<Enum.random('0123456789ASDFGHJKLZXCVBNMQWERTYUIOP')>>
  end

  def convert_to_nanoton(sum) do
    {float_value, _} = Float.parse(sum)
    trunc(float_value * 1_000_000_000)
  end
end
