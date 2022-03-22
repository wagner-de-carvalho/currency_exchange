defmodule Conversor.Transaction.GetTest do
  use Conversor.DataCase, async: true
  alias Conversor.Transaction.Get

  describe "all_by_user_id/1" do
    test "when id exists, gets all user's transactions" do
      response = Get.all_by_user_id("1")
      assert [%Transaction{} | _] = response
    end
  end

  describe "all_transactions/0" do
    test "Gets all transactions in database" do
      {:ok, transactions} = Get.all_transactions()
      assert [%Transaction{} |_ ] = transactions
    end
  end
end
