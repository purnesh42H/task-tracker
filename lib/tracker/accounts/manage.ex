defmodule Tracker.Accounts.Manage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tracker.Accounts.User
  alias Tracker.Accounts.Manage


  schema "manages" do
    belongs_to :manager, User
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Manage{} = manage, attrs) do
    manage
    |> cast(attrs, [:manager_id, :user_id])
    |> validate_required([:manager_id, :user_id])
  end
end
