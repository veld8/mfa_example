defmodule MfaExampleWeb.UserSettingsLive.ChangePasswordComponent do
  use MfaExampleWeb, :live_component

  alias MfaExample.Accounts

  @impl true
  def render(assigns) do
    ~H"""
      <div>
        <.form let={f} for={@password_changeset} action={Routes.user_settings_path(@socket, :update_password)}
        id="form-update-password"
        phx_change="validate_password"
        phx_submit="update_password"
        phx_trigger_action={@password_trigger_action}
        phx_target={@myself}>
          <%= if @password_changeset.action do %>
            <div class="alert alert-danger">
              <p>Oops, something went wrong! Please check the errors below.</p>
            </div>
          <% end %>

          <%= label f, :password, "New password" %>
          <%= password_input f, :password, required: true, phx_debounce: "blur", value: input_value(f, :password) %>
          <%= error_tag f, :password %>

          <%= label f, :password_confirmation, "Confirm new password" %>
          <%= password_input f, :password_confirmation, required: true, phx_debounce: "blur", value: input_value(f, :password_confirmation) %>
          <%= error_tag f, :password_confirmation %>

          <%= label f, :current_password, for: "current_password_for_password" %>
          <%= password_input f, :current_password, required: true, name: "current_password", id: "current_password_for_password", phx_debounce: "blur", value: @current_password %>
          <%= error_tag f, :current_password %>

          <div>
            <%= submit "Change password", phx_disable_with: "Saving..." %>
          </div>
        </.form>
      </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    if socket.assigns[:current_user] do
      {:ok, socket}
    else
      {:ok,
       socket
       |> assign(:current_user, assigns.current_user)
       |> assign(:password_changeset, Accounts.change_user_password(assigns.current_user))
       |> assign(:current_password, nil)
       |> assign(:password_trigger_action, false)}
    end
  end

  @impl true
  def handle_event(
        "validate_password",
        %{"current_password" => current_password, "user" => user_params},
        socket
      ) do
    password_changeset =
      Accounts.change_user_password(socket.assigns.current_user, current_password, user_params)

    socket =
      socket
      |> assign(:current_password, current_password)
      |> assign(:password_changeset, password_changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "update_password",
        %{"current_password" => current_password, "user" => user_params},
        socket
      ) do
    socket = assign(socket, :current_password, current_password)

    case Accounts.apply_user_password(socket.assigns.current_user, current_password, user_params) do
      {:ok, _} ->
        {:noreply, assign(socket, :password_trigger_action, true)}

      {:error, password_changeset} ->
        {:noreply, assign(socket, :password_changeset, password_changeset)}
    end
  end
end
