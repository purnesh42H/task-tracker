defmodule Tracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tracker.Accounts.User
  alias Tracker.Accounts.Manage


  schema "users" do
    field :email, :string
    field :name, :string
    has_many :manager_manages, Manage, foreign_key: :user_id
    has_many :manages_manager, Manage, foreign_key: :manager_id
    has_many :users, through: [:manages_manager, :user]
    has_many :managers, through: [:manager_manages, :manager]

    timestamps()
  end
   
  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name])
    |> validate_required([:email, :name])
  end
end
