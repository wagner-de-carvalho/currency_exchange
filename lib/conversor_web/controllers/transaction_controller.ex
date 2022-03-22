defmodule ConversorWeb.TransactionController do
  use ConversorWeb, :controller
  alias ConversorWeb.FallbackController
  alias Conversor.Transaction.{Create, Get}

  action_fallback FallbackController

  def show(conn, _params) do
    with {:ok, transactions} <- Get.all_transactions() do
      conn
      |> put_status(:ok)
      |> render("transactions.json", transactions: transactions)
    end
  end

  def by_user(conn, %{"id" => user_id}) do
    with transactions <- Get.all_by_user_id(user_id) do
      conn
      |> put_status(:ok)
      |> render("transactions.json", transactions: transactions)
    end
  end

  def convert(conn, params) do
    with {:ok, %Transaction{} = transaction} <- Create.create_transaction(params) do
      Create.add_transaction(transaction)

      conn
      |> put_status(:created)
      |> render("transactions.json", transactions: transaction)
    end
  end
end
