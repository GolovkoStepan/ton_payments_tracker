defmodule TonPaymentsTracker.PaymentsHistory.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :from, :string    # Адрес отправителя
    field :hash, :string    # Хеш транзакции
    field :message, :string # Сообщение, указываемое при платяже
    field :value, :integer  # Сумма в нанотон (1 TON = 1000000000 Nanoton)

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:hash, :from, :message, :value])
    |> validate_required([:hash, :from, :message, :value])
    |> unique_constraint([:hash, :from, :message])
  end
end
