defmodule TonPaymentsTracker.TrackerSupervisor do
  use Supervisor
  require Logger

  alias TonPaymentsTracker.{ApiFetcher, DatabaseHandler, PaymentsChecker}

  def start_link(_opts) do
    log("Tracker system supervisor process started...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    log("Launching child processes...")

    children = [
      {PaymentsChecker, []},
      {DatabaseHandler, []},
      {ApiFetcher, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp log(msg) do
    Logger.info("| #{__MODULE__} | #{msg}")
  end
end
