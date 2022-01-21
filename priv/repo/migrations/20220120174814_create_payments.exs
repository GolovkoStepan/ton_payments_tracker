defmodule TonPaymentsTracker.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :code, :string
      add :value, :bigint
      add :confirmed, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:payments, [:code])
  end
end
