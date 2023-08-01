# KxCheckout

KxCheckout is a supermarket checkout system implemented following TDD and using Elixir

## Setup

### Optional Erlang & Elixir Installation

Erlang and Elixir need to be installed, install them by

```bash
# Using brew
brew install erlang elixir

# Using asdf
# Install Erlang
asdf add plugin erlang
asdf install erlang latest
asdf global erlang latest

# Install Elixir
asdf add plugin elixir
asdf install elixir latest
asdf global elixir latest

```

### Clone & Test

```bash
 # To run and test;
 # first clone the project
 git clone https://github.com/tlarevo/KxCheckout.git

 # then run mix test
 mix test

```

## Use as a Library

Add following to `mix.exs` under `deps`

```elixir
def deps do
  [
    {:kx_checkout, git: "https://github.com/tlarevo/KxCheckout.git", brance: :master}
  ]
end
```
