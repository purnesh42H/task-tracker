defmodule TrackerWeb.UserController do
  use TrackerWeb, :controller

  alias Tracker.Accounts
  alias Tracker.Accounts.User
  
  def underlings_helper(managees, n, underlings, user) when n == 0 do
    underlings
  end
  
  def underlings_helper(managees, n, underlings, user) when n > 0 do
    managee = (hd managees)
    new = %{manager_id: user.id, managee_id: managee.user_id, manager_name: user.name, managee_name: 
      Tracker.Accounts.get_user(managee.user_id).name}
    underlings_helper((tl managees), n - 1, (underlings ++ [new]), user)
  end

  def list_underlings(manager) do
    managees = Tracker.Accounts.list_manage_by_user(manager.id)
    underlings_helper(managees, length(managees), [], manager)
  end
  
  def managers_helper(managers, n, l_managers, user) when n == 0 do
    l_managers
  end

  def managers_helper(managers, n, l_managers, user) when n > 0 do
    manager = (hd managers)
    new = %{manager_id: manager.manager_id, managee_id: user.id, managee_name: user.name, manager_name:
      Tracker.Accounts.get_user(manager.manager_id).name}
    managers_helper((tl managers), n - 1, (l_managers ++ [new]), user)
  end

  def list_managers(underling) do
    managers = Tracker.Accounts.list_manage_by_underling(underling.id)
    managers_helper(managers, length(managers), [], underling)
  end

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    users = Accounts.list_users()
    manages = Tracker.Accounts.list_underlings(current_user.id)
    render(conn, "index.html", users: users, manages: manages)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    underlings = list_underlings(user)
    managers = list_managers(user)
    render(conn, "show.html", user: user, underlings: underlings, managers: managers)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
