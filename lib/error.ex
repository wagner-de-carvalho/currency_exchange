defmodule Conversor.Error do
  defstruct error: nil, type: nil

  def build(error, type), do: %__MODULE__{error: error, type: type}
end
