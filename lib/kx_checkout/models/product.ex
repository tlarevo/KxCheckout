defmodule KxCheckout.Models.Product do
  defstruct product_code: nil, name: nil, price: 0.00, stock: 0

  @type t :: %__MODULE__{
          product_code: atom(),
          name: bitstring(),
          price: float(),
          stock: integer()
        }
end
