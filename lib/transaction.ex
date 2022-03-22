defmodule Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Conversor.ApiCurrency.CurrencyList
  alias Conversor.Error
  alias Ecto.Changeset

  @required_params [:user_id, :origin_currency, :destiny_currency, :origin_amount]

  @derive {Jason.Encoder,
           only: [
             :date,
             :id,
             :user_id,
             :origin_currency,
             :destiny_currency,
             :origin_amount,
             :destiny_amount,
             :rate
           ]}

  embedded_schema do
    field :origin_currency, :string
    field :destiny_currency, :string
    field :destiny_amount, :float
    field :origin_amount, :float, default: 1.0
    field :rate, :float
    field :date, :utc_datetime
    field :user_id, :string
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_number(:origin_amount, greater_than_or_equal_to: 1)
    |> validate_currencies()
  end

  defp validate_currencies(%Changeset{valid?: false} = changeset), do: changeset

  defp validate_currencies(%Changeset{changes: changes} = params) do
    result = CurrencyList.validate_currencies(changes.origin_currency, changes.destiny_currency)

    case result do
      %Error{} = error -> error
      :ok -> params
    end
  end
end
