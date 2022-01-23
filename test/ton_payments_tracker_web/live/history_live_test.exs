defmodule TonPaymentsTracker.HistoryLiveTest do
  use TonPaymentsTrackerWeb.ConnCase

  import Phoenix.LiveViewTest
  import TonPaymentsTracker.PaymentsHistoryFixtures

  alias TonPaymentsTracker.PaymentsHistory

  defp create_payment(_) do
    payment = payment_fixture()
    %{payment: payment}
  end

  describe "show data" do
    setup [:create_payment]

    test "lists all payments", %{conn: conn, payment: payment} do
      {:ok, _view, html} = live(conn, "/")

      assert html =~ "ID: #{payment.id}"
      assert html =~ "Код: #{payment.code}"
      assert html =~ "Сумма: #{payment.value / 1_000_000_000}"
      assert html =~ "Статус: Не подтвержден"
    end

    test "update payment status", %{conn: conn, payment: payment} do
      {:ok, view, html} = live(conn, "/")

      assert html =~ "Статус: Не подтвержден"

      PaymentsHistory.confirm_payment(payment)
      send(view.pid, :update)

      assert render(view) =~ "Статус: Подтвержден"
    end
  end

  describe "create" do
    test "create payment", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      html =
        view
        |> element("form")
        |> render_submit(%{"value" => "1"})

      payment = PaymentsHistory.list_payments() |> List.last()

      assert html =~ "Код для платежа: #{payment.code}, сумма: 1"
      assert html =~ "ID: #{payment.id}"
      assert html =~ "Код: #{payment.code}"
      assert html =~ "Сумма: #{payment.value / 1_000_000_000}"
      assert html =~ "Статус: Не подтвержден"
    end
  end
end
