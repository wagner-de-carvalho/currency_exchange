defmodule Conversor.ApiCurrency.CurrencyListTest do
  use Conversor.DataCase, async: true

  alias Conversor.ApiCurrency.CurrencyList
  alias Conversor.ApiCurrency.Exchange
  alias Conversor.Error

  describe "load_currencies/1" do
    test "loads currencies and save to database" do
      response = CurrencyList.load_currencies()
      assert :ok = response
    end
  end

  describe "get_currencies/1" do
    test "get currencies available saved on database" do
      response = CurrencyList.get_currencies()

      assert %{"BRL" => _brl} = response
    end
  end

  describe "validate_currencies/2" do
    test "when all params are valid, returns :ok" do
      response = CurrencyList.validate_currencies("BRL", "USD")

      assert :ok = response
    end

    test "when one or tw params are invalid, returns an error" do
      response = CurrencyList.validate_currencies("XYZ", "USD")

      assert %Error{} = response
    end
  end
end
