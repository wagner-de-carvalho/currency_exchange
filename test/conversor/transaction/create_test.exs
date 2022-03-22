defmodule Conversor.Transaction.CreateTest do
  use Conversor.DataCase, async: true
  alias Conversor.Error
  alias Conversor.Transaction.Create

  describe "create_transaction/1" do
    test "when all params are valid, creates Transaction" do
      params =  %{
        "destiny_currency" => "JPY",
        "origin_amount" => 1,
        "origin_currency" => "BRL",
        "user_id" => "3"
      }
      {:ok, transaction} = Create.create_transaction(params)

      assert %Transaction{} = transaction
    end

    test "when there are invalid params, returns error" do
      params =  %{
        "destiny_currency" => "JPY",
        "origin_amount" => -1,
        "origin_currency" => "BRL",
        "user_id" => "3"
      }
      transaction = Create.create_transaction(params)

      assert %Error{} = transaction
    end
  end

  describe "add_transaction/1" do
    test "add transaction to database, returns :ok" do
      transaction =  %Transaction{
        date: ~U[2022-01-28 05:15:36.178170Z],
        destiny_amount: 21.126702640180557,
        destiny_currency: "JPY",
        id: "c20ecc97-e19c-4405-81e9-8e0c721f8d76",
        origin_amount: 1.0,
        origin_currency: "BRL",
        rate: 21.126702640180557,
        user_id: "3"
      }

      response = Create.add_transaction(transaction)
      assert :ok = response
    end

  end
end
