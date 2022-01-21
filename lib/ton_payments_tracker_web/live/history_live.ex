defmodule TonPaymentsTrackerWeb.HistoryLive do
  use TonPaymentsTrackerWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      TonPaymentsTrackerWeb.Endpoint.subscribe("history")
    end

    {:ok, assign(socket, update_count: 0)}
  end

  def handle_info(:update, socket) do
    {:noreply, assign(socket, update_count: socket.assigns.update_count + 1)}
  end
end
