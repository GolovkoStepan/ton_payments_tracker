defmodule TonPaymentsTracker.TonApiClient do
  def get_transactions do
    {:ok, response} = HTTPoison.get(uri(:get_transactions, module_config(:wallet_address)))

    get_in(Jason.decode!(response.body), ["result"])
    |> Enum.map(fn el ->
      %{
        hash: get_in(el, ["hash"]),
        from: get_in(el, ["received", "from"]),
        message: get_in(el, ["received", "message"]),
        value: get_in(el, ["received", "nanoton"])
      }
    end)
  end

  defp uri(:get_transactions, address) do
    "#{module_config(:url)}/getTransactions?address=#{address}"
  end

  defp module_config(conf) do
    get_in(Application.get_env(:ton_payments_tracker, __MODULE__), [conf])
  end
end
