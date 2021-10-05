defmodule BytepackWeb.UserSettingsLiveTest do
  use MfaExampleWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import MfaExample.AccountsFixtures
  import Swoosh.TestAssertions

  setup :register_and_log_in_user

  describe "Edit" do
    test "update email", %{conn: conn} do
      {:ok, settings_live, html} = live(conn, Routes.user_settings_path(conn, :edit))

      assert html =~ "Change e-mail"

      change_with_errors =
        settings_live
        |> form("#form-update-email", user: [email: "bad"])
        |> render_change()

      assert change_with_errors =~ "must have the @ sign and no spaces"

      change_with_errors =
        settings_live
        |> form("#form-update-email", user: [email: unique_user_email()], current_password: "bad")
        |> render_change()

      assert change_with_errors =~ "is not valid"

      email = unique_user_email()

      settings_live
      |> form("#form-update-email",
        user: [email: email],
        current_password: valid_user_password()
      )
      |> render_submit() =~
        "A link to confirm your e-mail change has been sent to the new address."

      assert_email_sent(to: email, subject: "Update email instructions")
    end

    test "update password", %{conn: conn} do
      {:ok, settings_live, html} = live(conn, Routes.user_settings_path(conn, :edit))

      assert html =~ "Change password"

      change_with_errors =
        settings_live
        |> form("#form-update-password",
          user: [password: "bad", password_confirmation: valid_user_password()]
        )
        |> render_change()

      assert change_with_errors =~ "does not match password"
      assert change_with_errors =~ "should be at least 12 character(s)"

      change_with_errors =
        settings_live
        |> form("#form-update-password",
          current_password: "bad",
          user: [password: valid_user_password(), password_confirmation: valid_user_password()]
        )
        |> render_change()

      assert change_with_errors =~ "is not valid"

      submitted_form =
        settings_live
        |> form("#form-update-password",
          current_password: valid_user_password(),
          user: [password: valid_user_password(), password_confirmation: valid_user_password()]
        )
        |> render_submit()

      refute submitted_form =~ "invalid_feedback"
    end
  end
end
