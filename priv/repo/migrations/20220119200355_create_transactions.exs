defmodule TonPaymentsTracker.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :hash, :string
      add :from, :string
      add :message, :string
      add :value, :bigint

      timestamps()
    end

    create unique_index(:transactions, [:hash, :from, :message])
  end
end
