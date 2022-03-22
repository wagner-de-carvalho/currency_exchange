defmodule Conversor.Database.DBTest do
  use Conversor.DataCase, async: true
  alias Conversor.Database.DB
  alias Conversor.Transaction.Create, as: CreateTransaction
  alias Conversor.User.Create, as: CreateUser
end
