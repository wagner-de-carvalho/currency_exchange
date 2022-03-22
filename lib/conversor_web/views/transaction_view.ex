defmodule ConversorWeb.TransactionView do
  use ConversorWeb, :view

  def render("transactions.json", %{transactions: transactions}) do
    transactions
  end
end
