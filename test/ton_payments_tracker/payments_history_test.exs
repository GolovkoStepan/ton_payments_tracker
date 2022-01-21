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

      update_attrs = %{
        from: "some updated from",
        hash: "some updated hash",
        message: "some updated message",
        value: 43
      }

      assert {:ok, %Transaction{} = transaction} =
               PaymentsHistory.update_transaction(transaction, update_attrs)

      assert transaction.from == "some updated from"
      assert transaction.hash == "some updated hash"
      assert transaction.message == "some updated message"
      assert transaction.value == 43
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               PaymentsHistory.update_transaction(transaction, @invalid_attrs)

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

  describe "payments" do
    alias TonPaymentsTracker.PaymentsHistory.Payment

    import TonPaymentsTracker.PaymentsHistoryFixtures

    @invalid_attrs %{code: nil, confirmed: nil, value: nil}

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert PaymentsHistory.list_payments() == [payment]
    end

    test "list_active_payments/0 returns all payments" do
      active_payment = payment_fixture(%{confirmed: false})
      payment_fixture(%{confirmed: true})
      assert PaymentsHistory.list_active_payments() == [active_payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert PaymentsHistory.get_payment!(payment.id) == payment
    end

    test "get_payment_by_transaction/1 returns the payment by transaction" do
      payment = payment_fixture(%{code: "qwerty", value: 500})
      transaction = transaction_fixture(%{message: "qwerty", value: 500})
      assert PaymentsHistory.get_payment_by_transaction(transaction) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      valid_attrs = %{code: "some code", confirmed: true, value: 42}

      assert {:ok, %Payment{} = payment} = PaymentsHistory.create_payment(valid_attrs)
      assert payment.code == "some code"
      assert payment.confirmed == true
      assert payment.value == 42
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PaymentsHistory.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()
      update_attrs = %{code: "some updated code", confirmed: false, value: 43}

      assert {:ok, %Payment{} = payment} = PaymentsHistory.update_payment(payment, update_attrs)
      assert payment.code == "some updated code"
      assert payment.confirmed == false
      assert payment.value == 43
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = PaymentsHistory.update_payment(payment, @invalid_attrs)
      assert payment == PaymentsHistory.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = PaymentsHistory.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> PaymentsHistory.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = PaymentsHistory.change_payment(payment)
    end

    test "confirm_payment/1 updates confirmed field" do
      payment = payment_fixture()
      assert {:ok, record} = PaymentsHistory.confirm_payment(payment)
      assert record.confirmed
    end
  end
end
