defmodule TonPaymentsTracker.PaymentsHistory.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    # Адрес отправителя
    field :from, :string

    # Хеш транзакции
    field :hash, :string

    # Сообщение, указываемое при платяже
    field :message, :string

    # Сумма в нанотон (1 TON = 1000000000 Nanoton)
    field :value, :integer

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
