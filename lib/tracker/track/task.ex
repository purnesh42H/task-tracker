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
 
  def validate_minutes(changeset) do
    min = get_field(changeset, :minutes)
    IO.inspect min
    if min && rem(min, 15) == 0 do
      changeset
    else
      add_error(changeset, :minutes, "Minutes should be multiple of 15")
    end
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :minutes, :is_completed, :user_id])
    |> validate_required([:title, :description, :minutes, :is_completed, :user_id]) |> validate_minutes()
  end
end
