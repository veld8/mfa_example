defmodule MfaExample.Accounts.UserTOTP do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users_totps" do
    field :secret, :binary
    field :code, :string, virtual: true
    belongs_to :user, MfaExample.Accounts.User

    embeds_many :backup_codes, BackupCode, on_replace: :delete do
      field :code, :string
      field :used_at, :utc_datetime_usec
    end

    timestamps()
  end

  @doc false
  def changeset(totp, attrs) do
    changeset =
      totp
      |> cast(attrs, [:code])
      |> validate_required([:code])
      |> validate_format(:code, ~r/^\d{6}$/, message: "should be a 6 digit number")

    code = Ecto.Changeset.get_field(changeset, :code)

    if changeset.valid? and not valid_totp?(totp, code) do
      Ecto.Changeset.add_error(changeset, :code, "invalid code")
    else
      changeset
    end
  end

  defp valid_totp?(totp, code) do
    is_binary(code) and byte_size(code) == 6 and NimbleTOTP.valid?(totp.secret, code)
  end
end
