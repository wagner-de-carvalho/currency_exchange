defmodule Conversor.Transaction.Create do
  alias Conversor.ApiCurrency.Exchange
  alias Conversor.Database.DB
  alias Conversor.Error
  alias Ecto.UUID
  alias Transaction

  import Ecto.Changeset, only: [apply_action: 2]
  alias Ecto.Changeset

  @doc """
  creates a new transaction.
  ## Parameters
  - params: map containing needed data to create a `%Transaction`.
  ## Params keys
  - user_id = user's id.
  - origin_currency = input currency.
  - destiny_currency = output currency.
  - origin_amount = amount to be exchanged.
  """
  @spec create_transaction(map()) :: tuple() | %Error{}
  def create_transaction(params) do
    params
    |> Transaction.changeset()
    |> handle_create()
  end

  defp handle_create(%Error{} = error), do: error

  defp handle_create(%Changeset{} = transaction) do
    transaction
    |> apply_action(:create)
    |> do_create()
  end

  defp do_create({:error, changeset}), do: Error.build(changeset, :bad_request)

  defp do_create({:ok, transaction}) do
    with result <-
           Exchange.exchange(
             transaction.origin_currency,
             transaction.destiny_currency,
             transaction.origin_amount
           ) do
      out_put =
        transaction
        |> Map.put(:id, UUID.generate())
        |> Map.put(:date, DateTime.utc_now())
        |> Map.put(:destiny_amount, result.destiny_currency)
        |> Map.put(:rate, result.rate)

      {:ok, out_put}
    end
  end

  @doc """
  adds a new transaction to the database.
  ## Parameters
  - transaction: %Transaction{} struct.
  """
  @spec add_transaction(%Transaction{}) :: :ok
  def add_transaction(transaction), do: DB.add_transaction(transaction)
end
