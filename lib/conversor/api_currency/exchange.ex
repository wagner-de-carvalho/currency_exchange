defmodule Conversor.ApiCurrency.Exchange do
  @moduledoc """
   Module responsible for making exchange between currencies.
   The most used function is `exchange/3`, which actually performs the exchanges.
  """
  use Tesla
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.Retry,
    delay: 500,
    max_retries: 5,
    max_delay: 10_000

  plug Tesla.Middleware.Timeout, timeout: 100_000

  alias Conversor.ApiCurrency.CurrencyList
  alias Conversor.Error
  alias Tesla.Env

  @api_key System.get_env("API_KEY", "5b023ecffc205090dd0023dd1c90fbd0")
  @base_url System.get_env("BASE_URL", "http://apilayer.net/api/live")

  @doc """
  exchanges between two provided currencies.
  ## Parameters
  - from: origin currency.
  - to: destiny currency.
  - amount: the amount of money to be exchanged.
  ## Errors
  `%Conversor.Error{ error: "amount -1 must be equal or greater than 1",type: :bad_request}` = when amount is less than 1.
  `%Conversor.Error{error: "Currency XYZ is invalid", type: :bad_request}` = when currencies provided are not supported.
  ## Example
        iex> Exchange.exchange("BRL", "USD", 1)
        %{destiny_currency: 0.18406423400012442, rate: 0.18406423400012442}
  """
  @spec exchange(String.t(), String.t(), integer) :: map() | %Error{}
  def exchange(_, _, amount) when amount <= 0,
    do: Error.build("amount #{amount} must be equal or greater than 1", :bad_request)

  def exchange("USD", "BRL", amount) do
    %{"USDBRL" => brl} = request_api("USD", "BRL")
    %{destiny_currency: brl * amount, rate: rate(brl * amount, amount)}
  end

  def exchange(from, to, amount) do
    result = request_api(from, to)

    case result do
      %Error{} = error ->
        error

      value ->
        result = convert(value["USD#{from}"], value["USD#{to}"], amount)
        %{destiny_currency: result, rate: rate(result, amount)}
    end
  end

  @spec convert(number(), number(), number()) :: float()
  defp convert(from, to, amount), do: to / from * amount

  @spec rate(number(), number()) :: float()
  defp rate(value, amount), do: value / amount

  @spec request_api(String.t(), String.t()) :: map() | %Error{}
  defp request_api(from, to) do
    case CurrencyList.validate_currencies(from, to) do
      %Error{} = error ->
        error

      :ok ->
        "#{@base_url}?access_key=#{@api_key}&currencies=#{from},#{to},BRL&source=USD&format=1"
        |> get()
        |> handle_request_api()
    end
  end

  defp handle_request_api({:ok, %Env{body: %{"error" => error}}}),
    do: Error.build(error, :bad_request)

  defp handle_request_api({:ok, %Env{body: %{"quotes" => quotes}}}), do: quotes
end
