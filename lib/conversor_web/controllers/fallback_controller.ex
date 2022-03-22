defmodule ConversorWeb.FallbackController do
  use ConversorWeb, :controller

  alias Conversor.Error
  alias ConversorWeb.ErrorView
  alias Ecto.Changeset

  def call(conn, %Error{error: error, type: type}) do
    conn
    |> put_status(type)
    |> put_view(ErrorView)
    |> render("error.json", error: error, type: type)
  end

  def call(conn, %Changeset{} = changeset) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("error.json", error: changeset)
  end
end
