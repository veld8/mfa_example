defmodule MfaExampleWeb.UserSessionController do
  use MfaExampleWeb, :controller

  alias MfaExample.Accounts
  alias MfaExampleWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn = UserAuth.log_in_user(conn, user)

      if Accounts.get_user_totp(user) do
        totp_params = Map.take(user_params, ["remember_me"])

        conn
        |> put_session(:user_totp_pending, true)
        |> redirect(to: Routes.user_totp_path(conn, :new, user: totp_params))
      else
        UserAuth.redirect_user_after_login_with_remember_me(conn, user_params)
      end
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
