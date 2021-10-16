defmodule MfaExample.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MfaExample.Accounts` context.
  """

  @totp_secret Base.decode32!("PTEPUGZ7DUWTBGMW4WLKB6U63MGKKMCA")

  def valid_totp_secret, do: @totp_secret
  def valid_user_password, do: "hello world!"
  def unique_user_email, do: "user#{System.unique_integer([:positive])}@example.com"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> MfaExample.Accounts.register_user()

    user
  end

  def user_totp_fixture(user) do
    %MfaExample.Accounts.UserTOTP{}
    |> Ecto.Changeset.change(user_id: user.id, secret: valid_totp_secret())
    |> MfaExample.Accounts.UserTOTP.ensure_backup_codes()
    |> MfaExample.Repo.insert!()
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
