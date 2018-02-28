defmodule TrackerWeb.PageController do
   import Ecto.Query, warn: false
   alias Tracker.Repo

   use TrackerWeb, :controller
  
  alias Tracker.Accounts
  alias Tracker.Accounts.User

  defp get_managee(managees) do
    query = from(u in Tracker.Accounts.User, select: {u.name, u.id}, where: u.id in ^managees)
    Repo.all(query)
  end

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      current_user = conn.assigns[:current_user]
      underlings = Tracker.Accounts.list_manage_by_user(current_user.id)
      render conn, "index.html", underlings: underlings
    else
      render conn, "index.html"
    end
  end
 
  def task(conn, _params) do
    tasks = Tracker.Track.list_tasks()
    current_user = conn.assigns[:current_user]
    t_underlings = Tracker.Accounts.list_underlings(current_user.id)
    underlings_list = Map.keys(t_underlings)
    underlings = get_managee(underlings_list)
    IO.inspect underlings
    changeset = Tracker.Track.change_task(%Tracker.Track.Task{})
    render conn, "task.html", tasks: tasks, changeset: changeset, underlings: underlings
  end
end
