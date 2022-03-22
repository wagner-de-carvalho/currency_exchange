defmodule Conversor.ApiCurrency.ExchangeTest do
  use Conversor.DataCase, async: true

  alias Conversor.ApiCurrency.Exchange
  alias Conversor.Error

  describe "exchange/3" do
    test "when all params are correct, exchanges between currencies" do
      response = Exchange.exchange("GBP", "BRL", 3)

      assert %{destiny_currency: _, rate: _} = response
    end

    test "when params are invalid, returns an error" do
      response = Exchange.exchange("XYZ", "BRL", 1)
      assert %Error{} = response
    end

    test "when amount is less than 1, returns an error" do
      response = Exchange.exchange("USD", "BRL", -1)
      assert %Error{} = response
    end
  end
end
