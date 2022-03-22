defmodule Conversor.Database.DB do
  alias Ecto.UUID
  alias Transaction

  @doc """
  adds values to database.
  ## Parameters
  - transaction: %Transaction{}.
  - key: an identifier to map in the database.
  - amount: the amount of money to be exchanged.
  """
  @spec add_transaction(%Transaction{}, String.t()) :: :ok
  def add_transaction(transaction, key \\ UUID.generate()) do
    GenServer.whereis(:database)
    |> CubDB.put(key, transaction)
  end

  @doc """
  fetches all transactions in the database.
  """
  @spec all() :: tuple()
  def all do
    GenServer.whereis(:database)
    |> CubDB.select(
      pipe: [
        drop: 1,
        map: fn {_key, transaction} -> transaction end
      ]
    )
  end

  @doc """
  fetches all transactions belonging to a single user.
  ## Parameters
  - user_id: user's id.
  """
  @spec all_by_user_id(String.t()) :: tuple()
  def all_by_user_id(user_id) do
    GenServer.whereis(:database)
    |> CubDB.select(
      pipe: [
        drop: 1,
        filter: fn {_, transaction} -> transaction.user_id == user_id end,
        map: fn {_, transaction} -> transaction end
      ]
    )
  end

  @doc """
  exchanges between two provided currencies.
  ## Parameters
  - key: resource id.
  """
  @spec get_currencies(atom()) :: map()
  def get_currencies(key \\ :currencies) do
    GenServer.whereis(:database)
    |> CubDB.get(key, %{})
  end
end
