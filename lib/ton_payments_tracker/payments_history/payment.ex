defmodule TonPaymentsTracker.PaymentsHistory.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    # Уникальный код, по которой будет найдена транзакция
    field :code, :string

    # Флаг подтверждения платяжа (устанавливается в true если транзакция была найдена и совпали суммы)
    field :confirmed, :boolean, default: false

    # Сумма платежа (должна совпасть с суммой в транзакции)
    field :value, :integer

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:code, :value, :confirmed])
    |> validate_required([:code, :value, :confirmed])
    |> unique_constraint([:code])
  end
end
