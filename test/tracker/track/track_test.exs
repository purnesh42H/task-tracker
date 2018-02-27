defmodule Tracker.TrackTest do
  use Tracker.DataCase

  alias Tracker.Track

  describe "tasks" do
    alias Tracker.Track.Task

    @valid_attrs %{description: "some description", is_completed: true, minutes: 42, title: "some title"}
    @update_attrs %{description: "some updated description", is_completed: false, minutes: 43, title: "some updated title"}
    @invalid_attrs %{description: nil, is_completed: nil, minutes: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Track.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Track.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Track.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Track.create_task(@valid_attrs)
      assert task.description == "some description"
      assert task.is_completed == true
      assert task.minutes == 42
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Track.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = Track.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.description == "some updated description"
      assert task.is_completed == false
      assert task.minutes == 43
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Track.update_task(task, @invalid_attrs)
      assert task == Track.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Track.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Track.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Track.change_task(task)
    end
  end
end
