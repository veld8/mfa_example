defmodule MfaExample.Repo do
  use Ecto.Repo,
    otp_app: :mfa_example,
    adapter: Ecto.Adapters.Postgres
end
