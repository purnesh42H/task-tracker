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

  describe "timeblocks" do
    alias Tracker.Track.Timeblock

    @valid_attrs %{end: ~T[14:00:00.000000], start: ~T[14:00:00.000000]}
    @update_attrs %{end: ~T[15:01:01.000000], start: ~T[15:01:01.000000]}
    @invalid_attrs %{end: nil, start: nil}

    def timeblock_fixture(attrs \\ %{}) do
      {:ok, timeblock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Track.create_timeblock()

      timeblock
    end

    test "list_timeblocks/0 returns all timeblocks" do
      timeblock = timeblock_fixture()
      assert Track.list_timeblocks() == [timeblock]
    end

    test "get_timeblock!/1 returns the timeblock with given id" do
      timeblock = timeblock_fixture()
      assert Track.get_timeblock!(timeblock.id) == timeblock
    end

    test "create_timeblock/1 with valid data creates a timeblock" do
      assert {:ok, %Timeblock{} = timeblock} = Track.create_timeblock(@valid_attrs)
      assert timeblock.end == ~T[14:00:00.000000]
      assert timeblock.start == ~T[14:00:00.000000]
    end

    test "create_timeblock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Track.create_timeblock(@invalid_attrs)
    end

    test "update_timeblock/2 with valid data updates the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, timeblock} = Track.update_timeblock(timeblock, @update_attrs)
      assert %Timeblock{} = timeblock
      assert timeblock.end == ~T[15:01:01.000000]
      assert timeblock.start == ~T[15:01:01.000000]
    end

    test "update_timeblock/2 with invalid data returns error changeset" do
      timeblock = timeblock_fixture()
      assert {:error, %Ecto.Changeset{}} = Track.update_timeblock(timeblock, @invalid_attrs)
      assert timeblock == Track.get_timeblock!(timeblock.id)
    end

    test "delete_timeblock/1 deletes the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, %Timeblock{}} = Track.delete_timeblock(timeblock)
      assert_raise Ecto.NoResultsError, fn -> Track.get_timeblock!(timeblock.id) end
    end

    test "change_timeblock/1 returns a timeblock changeset" do
      timeblock = timeblock_fixture()
      assert %Ecto.Changeset{} = Track.change_timeblock(timeblock)
    end
  end
end
