defmodule Tracker.Repo.Migrations.UpdateTimeblocksTable do
  use Ecto.Migration

  def change do
    execute "drop table timeblocks"

    create table(:timeblocks) do
      add :start, :utc_datetime, null: false
      add :end, :utc_datetime
      add :task_id, references(:tasks, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:timeblocks, [:task_id])
  end
end
