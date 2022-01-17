defmodule TonPaymentsTracker.Repo do
  use Ecto.Repo,
    otp_app: :ton_payments_tracker,
    adapter: Ecto.Adapters.Postgres
end
