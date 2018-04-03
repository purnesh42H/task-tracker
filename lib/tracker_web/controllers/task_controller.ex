defmodule TrackerWeb.TaskController do
  import Ecto.Query, warn: false
  use TrackerWeb, :controller

  alias Tracker.Repo
  alias Tracker.Track
  alias Tracker.Track.Task
  alias Tracker.Accounts
  alias Tracker.Accounts.User

  defp get_managee(managees) do
    query = from(u in Tracker.Accounts.User, select: {u.name, u.id}, where: u.id in ^managees)
    Repo.all(query)
  end
  
  defp get_current_timeblock(timeblocks) do
    Enum.find(timeblocks,  fn(x) -> 
      {start, end_time, id} = x
      end_time == nil
    end)
  end
  
  defp get_duration(timeblocks) do 
    Enum.reduce(timeblocks, 0, fn(x, acc) ->
       {start, end_time, id} = x
       if end_time do
         t = DateTime.diff(end_time, start)
         t + acc
       else
         acc
       end
     end)
  end
  
  def index(conn, _params) do
    tasks = Track.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Track.change_task(%Task{})
    current_user = conn.assigns[:current_user]
    t_underlings = Tracker.Accounts.list_underlings(current_user.user_id)
    underlings_list = Map.keys(t_underlings)
    underlings = get_managee(underlings_list)
    timeblocks = []
    render(conn, "new.html", changeset: changeset, underlings: underlings, timeblocks: timeblocks)
  end

  def create(conn, %{"task" => task_params}) do
    case Track.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Track.get_task!(id)
    timeblocks = Tracker.Track.list_timeblocks(task.id)
    if timeblocks do
      duration = get_duration(timeblocks)
    else
      duration = 0
    end
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Track.get_task!(id)
    changeset = Track.change_task(task)
    t_underlings = Tracker.Accounts.list_underlings(task.user_id)
    underlings_list = Map.keys(t_underlings)
    underlings = get_managee(underlings_list)
    timeblocks = Tracker.Track.list_timeblocks(task.id)
    if timeblocks do
      running_timeblock = get_current_timeblock(timeblocks)
      if running_timeblock do
        {start, end_time, running_timeblock_id} = running_timeblock
      else 
        running_timeblock_id = nil
      end
    else
      running_timeblock_id = nil
    end
     render(conn, "edit.html", task: task, changeset: changeset, underlings: underlings, 
       timeblocks: Enum.reverse(timeblocks), running_timeblock_id: running_timeblock_id)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Track.get_task!(id)
    timeblocks = Tracker.Track.list_timeblocks(task.id)
    if timeblocks do
      duration = get_duration(timeblocks)
      if task.minutes != duration do
        task_params = Map.put(task_params, "minutes", div(duration, 60))
      end
    end
          
    case Track.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Track.get_task!(id)
    {:ok, _task} = Track.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end
end
