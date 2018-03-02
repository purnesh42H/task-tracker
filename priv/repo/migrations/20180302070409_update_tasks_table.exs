defmodule Tracker.Repo.Migrations.UpdateTasksTable do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      modify :minutes, :integer, default: 0, null: false
    end
  end
end
