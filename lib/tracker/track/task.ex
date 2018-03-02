defmodule Tracker.Track.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tracker.Track.Task
  alias Tracker.Track.Timeblock


  schema "tasks" do
    field :description, :string
    field :is_completed, :boolean, default: false
    field :minutes, :integer
    field :title, :string
    belongs_to :user, Tracker.Accounts.User
    has_many :timeblock, Timeblock, foreign_key: :task_id
    has_many :timeblocks, through: [:timeblock, :task]

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :minutes, :is_completed, :user_id])
    |> validate_required([:title, :description, :is_completed, :user_id])
  end
end
