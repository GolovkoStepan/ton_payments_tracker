# Ton Payments Tracker

Service for tracking payments in the Ton blockchain. After creating a trackable payment, the service will look for it among new transactions. If such a transaction is found, the service will change the payment status to "Confirmed".
When transferring a payment, you must specify the generated key as a message.

You need to add your wallet address to the config:
```
config :ton_payments_tracker, TonPaymentsTracker.TonApiClient,
  wallet_address: "EQCVYqjJbudxIq-DJWZf6S31xhkEKmgeZzQhAubzgcW7qkcJ"
```

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
