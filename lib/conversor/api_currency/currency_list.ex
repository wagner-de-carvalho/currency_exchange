defmodule Conversor.ApiCurrency.CurrencyList do
  alias Conversor.Database.DB

  use Tesla
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.Retry,
    delay: 500,
    max_retries: 5,
    max_delay: 10_000

  plug Tesla.Middleware.Timeout, timeout: 100_000

  alias Conversor.Error
  alias Tesla.Env

  @api_key System.get_env("API_KEY", "5b023ecffc205090dd0023dd1c90fbd0")
  @currencies_list_url System.get_env("CURRENCIES_URL", "http://api.currencylayer.com/list")

  @doc """
  loads currencies to the database.
  ## Parameters
  - key: key on the database.
  ## Example
        iex> CurrencyList.load_currencies(:currencies)
        :ok
  """
  @spec load_currencies(binary()):: :ok
  def load_currencies(key \\ :currencies) do
    request_list()
    |> DB.add_transaction(key)
  end

  @doc """
  fetches currencies from the database.
  ## Parameters
  - key: key on the database.
  """
  @spec get_currencies(atom) :: map()
  def get_currencies(key \\ :currencies) do
    DB.get_currencies(key)
  end

  @doc """
  validates two provided currencies.
  ## Parameters
  - from: origin currency.
  - to: destiny currency.
  - amount: the amount of money to be exchanged.
  ## Errors
  `%Conversor.Error{error: "Currency BR is invalid", type: :bad_request}` = when currency is invalid.
  ## Example
        iex> CurrencyList.validate_currencies("USD", "BRL")
        :ok
  """
  @spec validate_currencies(String.t(), String.t()) :: :ok | %Error{}
  def validate_currencies(from, to) do
    currencies = get_currencies()

    cond do
      is_map_key(currencies, from) == false ->
        Error.build("Currency #{from} is invalid", :bad_request)

      is_map_key(currencies, to) == false ->
        Error.build("Currency #{to} is invalid", :bad_request)

      from == to ->
        Error.build("Currencies #{from} and #{to} must be different", :bad_request)

      true ->
        :ok
    end
  end

  @spec request_list(String.t()) :: map()
  defp request_list(api_key \\ @api_key) do
    "#{@currencies_list_url}?access_key=#{api_key}"
    |> get()
    |> handle_request_list()
  end

  defp handle_request_list({:ok, %Env{body: %{"currencies" => currencies}}}), do: currencies
end
