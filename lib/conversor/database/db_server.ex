defmodule Conversor.Database.DBServer do
  use GenServer
  require Logger
  alias Conversor.ApiCurrency.CurrencyList

  @impl true
  def init(_value) do
    start =
      CubDB.start_link(
        data_dir: "priv/database",
        auto_compact: true,
        name: :database
      )

    CurrencyList.load_currencies()

    {:ok, start}
  end

  def start_link(_default) do
    Logger.info("Repository started !", ansi_color: :blue)

    GenServer.start_link(__MODULE__, :ok, timeout: 8_000)
  end
end
