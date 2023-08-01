defmodule KxCheckout.Models.ShoppingBill do
  defstruct item_details: %{}, gross_total: 0.00, total_discount: 0.00, net_total: 0.00
  alias KxCheckout.Models.ItemGroup

  @type t :: %__MODULE__{
          item_details: %{atom() => ItemGroup.t()},
          gross_total: float(),
          total_discount: float(),
          net_total: float()
        }
end
