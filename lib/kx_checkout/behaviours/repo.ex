defmodule KxCheckout.Behaviours.Repo do
  @callback insert(atom() | module(), any(), any()) :: :ok | :error
  @callback get(atom() | module(), any()) :: any()
  @callback all(atom() | module()) :: any()
  @callback update(atom() | module(), any(), any()) :: :ok | :error
end
