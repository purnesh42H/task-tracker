defmodule Tracker.Track.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tracker.Track.Task


  schema "tasks" do
    field :description, :string
    field :is_completed, :boolean, default: false
    field :minutes, :integer
    field :title, :string
    belongs_to :user, Tracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :minutes, :is_completed, :user_id])
    |> validate_required([:title, :description, :minutes, :is_completed, :user_id])
  end
end
