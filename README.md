# MfaExample

This repo shows an example of a basic Phoenix LiveView app with Multi Factor Authentication (MFA). 

The app consists of a clean Phoenix App with `mix phx.gen.auth`. Afterwards the MFA was added. The changes are visible in the [add-mfa](https://github.com/veld8/mfa_example/tree/add-mfa) branch.

## TOTP
This app uses Time-based One-Time Passwords (TOTP). The library used for working with TOTP is [NimbleTOTP](https://github.com/dashbitco/nimble_totp).

For more information about TOTP look [here](https://en.wikipedia.org/wiki/Time-based_One-Time_Password).

## Inspiration
A lot of the code was inspired by or blatently copied from the [Bytepack Archive](https://github.com/dashbitco/bytepack_archive) by Dashbit.

## CSS and layout
I have not put any time in adding CSS or other design elements to the code. Therefore the modal for showing backup recovery codes is not showed correctly.

## Start Phoenix
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## License
U can freely use, modify or publish the code in this repo.
Use the code in this repo at your own risk. I do not give any warranty regarding the code in this repo.
