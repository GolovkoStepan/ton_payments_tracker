defmodule TonPaymentsTracker.PaymentsHistoryTest do
  use TonPaymentsTracker.DataCase

  alias TonPaymentsTracker.PaymentsHistory

  describe "transactions" do
    alias TonPaymentsTracker.PaymentsHistory.Transaction

    import TonPaymentsTracker.PaymentsHistoryFixtures

    @invalid_attrs %{from: nil, hash: nil, message: nil, value: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert PaymentsHistory.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert PaymentsHistory.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{from: "some from", hash: "some hash", message: "some message", value: 42}

      assert {:ok, %Transaction{} = transaction} = PaymentsHistory.create_transaction(valid_attrs)
      assert transaction.from == "some from"
      assert transaction.hash == "some hash"
      assert transaction.message == "some message"
      assert transaction.value == 42
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PaymentsHistory.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{from: "some updated from", hash: "some updated hash", message: "some updated message", value: 43}

      assert {:ok, %Transaction{} = transaction} = PaymentsHistory.update_transaction(transaction, update_attrs)
      assert transaction.from == "some updated from"
      assert transaction.hash == "some updated hash"
      assert transaction.message == "some updated message"
      assert transaction.value == 43
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = PaymentsHistory.update_transaction(transaction, @invalid_attrs)
      assert transaction == PaymentsHistory.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = PaymentsHistory.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> PaymentsHistory.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = PaymentsHistory.change_transaction(transaction)
    end
  end
end
