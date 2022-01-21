defmodule TonPaymentsTracker.ApiFetcher do
  use GenServer
  require Logger

  alias TonPaymentsTracker.{TonApiClient, DatabaseHandler}

  def start_link(_opts) do
    log("Api fetcher process started...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.send_after(self(), :run_fetch, module_config(:api_request_delay))
    {:ok, %{}}
  end

  def handle_info(:run_fetch, state) do
    send_data()
    {:noreply, state}
  end

  defp send_data do
    log("Fetch data from api...")
    send(Process.whereis(DatabaseHandler), {:api_fetch_result, TonApiClient.get_transactions()})
    Process.send_after(self(), :run_fetch, module_config(:api_request_delay))
  end

  defp log(msg) do
    Logger.info("| #{__MODULE__} | #{msg}")
  end

  defp module_config(conf) do
    get_in(Application.get_env(:ton_payments_tracker, __MODULE__), [conf])
  end
end
