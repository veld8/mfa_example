defmodule MfaExampleWeb.UserSettingsLive.ChangeEmailComponent do
  use MfaExampleWeb, :live_component

  alias MfaExample.Accounts

  @impl true
  def render(assigns) do
    ~H"""
      <div>
        <.form let={f} for={@email_changeset}
          id="form-update-email"
          phx_change="validate_email"
          phx_submit="update_email"
          phx_target={@myself} %>
          <%= if @email_changeset.action do %>
            <div class="alert alert-danger">
              <p>Oops, something went wrong! Please check the errors below.</p>
            </div>
          <% end %>

          <%= label f, :email %>
          <%= email_input f, :email, required: true, phx_debounce: "blur" %>
          <%= error_tag f, :email %>

          <%= label f, :current_password, for: "current_password_for_email" %>
          <%= password_input f, :current_password, required: true, name: "current_password", id: "current_password_for_email", phx_debounce: "blur", value: @current_password %>
          <%= error_tag f, :current_password %>

          <div>
            <%= submit "Change email", phx_disable_with: "Saving ..." %>
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
       |> assign(:email_changeset, Accounts.change_user_email(assigns.current_user))
       |> assign(:current_password, nil)}
    end
  end

  @impl true
  def handle_event(
        "validate_email",
        %{"user" => user_params, "current_password" => current_password},
        socket
      ) do
    email_changeset =
      Accounts.change_user_email(socket.assigns.current_user, current_password, user_params)

    socket =
      socket
      |> assign(:current_password, current_password)
      |> assign(:email_changeset, email_changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "update_email",
        %{"current_password" => current_password, "user" => user_params},
        socket
      ) do
    case Accounts.apply_user_email(socket.assigns.current_user, current_password, user_params) do
      {:ok, applied_user} ->
        _ =
          Accounts.deliver_update_email_instructions(
            applied_user,
            socket.assigns.current_user.email,
            &Routes.user_settings_url(socket, :confirm_email, &1)
          )

        send(
          self(),
          {:flash, :info,
           "A link to confirm your e-mail change has been sent to the new address."}
        )

        {:noreply, assign(socket, :current_password, "")}

      {:error, email_changeset} ->
        socket =
          socket
          |> assign(:current_password, current_password)
          |> assign(:email_changeset, email_changeset)

        {:noreply, socket}
    end
  end
end
