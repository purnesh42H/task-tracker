defmodule Tracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tracker.Accounts.User
  alias Tracker.Accounts.Manage


  schema "users" do
    field :email, :string
    field :name, :string
    has_many :manager_manages, Manage, foreign_key: :manager_id
    has_many :user_manages, Manage, foreign_key: :user_id
    has_many :managers, through: [:user_manages, :manager]
    has_many :users, through: [:manager_manages, :user]

    timestamps()
  end
   
  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name])
    |> validate_required([:email, :name])
  end
end
