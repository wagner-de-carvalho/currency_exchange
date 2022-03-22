defmodule Conversor.Transaction.Get do
  alias Conversor.Database.DB

  @doc """
  fetches all transactions belonging to a single user.
  ## Parameters
  - user_id: user's id.
  """
  @spec all_by_user_id(String.t()) :: list()
  def all_by_user_id(user_id) do
    user_id
    |> DB.all_by_user_id()
    |> handle_all_by_user_id()
  end

  @doc """
  fetches all transactions from the database.
  """
  @spec all_transactions() :: tuple()
  def all_transactions, do: DB.all()

  defp handle_all_by_user_id({:ok, transactions}), do: transactions
end
