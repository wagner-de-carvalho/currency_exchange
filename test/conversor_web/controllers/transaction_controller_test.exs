defmodule ConversorWeb.TransactionControllerTest do
    use ConversorWeb.ConnCase, async: true

    describe "convert/2" do
        test "when all params are valid, creates transaction", %{conn: conn} do
            params = %{
                "user_id" => "3",
                "origin_currency" => "BRL",
                "destiny_currency" => "JPY",
                "origin_amount" => 1
            }

            response =
                conn
                |> post(Routes.transaction_path(conn, :convert, params))
                |> json_response(:created)

            assert %Transaction{} = response

        end
    end

    describe "show/2" do
        test "Shows all transactions", %{conn: conn} do
            response =
                conn
                |> get(Routes.transaction_path(conn, :show))
                |> json_response(:ok)

            assert [%{} |_] = response
        end
    end

    describe "by_user/2" do
        test "Shows all transactions performed by the user", %{conn: conn} do
            response =
                conn
                |> get(Routes.transaction_path(conn, :by_user, "1"))
                |> json_response(:ok)

            assert [%{} |_] = response
        end
    end
end
