defmodule KxCheckout.Models.ItemGroup do
  defstruct count: 1, price: 0.00, total: 0.00, discount: 0.00

  @type t :: %__MODULE__{count: integer(), price: float(), total: float(), discount: float()}
end
