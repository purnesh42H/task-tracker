defmodule TrackerWeb.PageController do
  use TrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
 
  def task(conn, _params) do
    tasks = Tracker.Track.list_tasks()
    changeset = Tracker.Track.change_task(%Tracker.Track.Task{})
    render conn, "task.html", tasks: tasks, changeset: changeset
  end
end
