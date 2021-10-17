defmodule MfaExampleWeb.UserSettingsLive.Edit do
  use MfaExampleWeb, :live_view

  alias MfaExample.Accounts

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    {:ok, socket}
  end

  @impl true
  def handle_info({:flash, key, message}, socket) do
    {:noreply, put_flash(socket, key, message)}
  end

  defp assign_current_user(socket, session) do
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(session["user_token"])
    end)
  end
end
