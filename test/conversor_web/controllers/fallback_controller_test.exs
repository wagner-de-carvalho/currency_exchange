defmodule ConversorWeb.FallbackControllerTest do
    use ConversorWeb.ConnCase, async: true

    alias Conversor.Transaction.Create

    describe "call/2" do
        test "when call/2 receives an %Error, an exception is raised", %{conn: conn} do
            params = %{
                "user_id" => "3",
                "origin_currency" => "XYZ",
                "destiny_currency" => "JPY",
                "origin_amount" => 1
            }

            result = Create.create_transaction(params)

            response =
                conn
                |> post(Routes.transaction_path(conn, :convert, [result]))
                |> json_response(:bad_request)

            assert %{"message" => _message} = response
        end

        test "when call/2 receives an invalid %Changeset, an exception is raised", %{conn: conn} do
            params = %{
                "user_id" => "3",
                "origin_currency" => "USD",
                "destiny_currency" => "JPY",
                "origin_amount" => -1
            }

            result = Create.create_transaction(params)

            response =
                conn
                |> post(Routes.transaction_path(conn, :convert, [result]))
                |> json_response(:bad_request)

            assert %{"message" => _message} = response
        end

    end
end
