defmodule Tracker.Track.Timeblock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tracker.Track.Timeblock


  schema "timeblocks" do
    field :end, :utc_datetime
    field :start, :utc_datetime
    belongs_to :task, Task

    timestamps()
  end

  @doc false
  def changeset(%Timeblock{} = timeblock, attrs) do
    timeblock
    |> cast(attrs, [:start, :end, :task_id])
    |> validate_required([:start, :task_id])
  end
end
