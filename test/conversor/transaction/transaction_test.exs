defmodule Conversor.Transaction.TransactionTest do
  use Conversor.DataCase, async: true

  describe "%Transaction{}" do
    test "when params are valid, returns Transaction struct" do
      response = %Transaction{
        user_id: "1",
        origin_currency: "USD",
        destiny_currency: "BRL",
        origin_amount: 1
      }

      assert %Transaction{} = response
    end
  end
end
