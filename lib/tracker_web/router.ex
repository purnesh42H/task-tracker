defmodule TrackerWeb.Router do
  use TrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
   #  plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :get_current_user
   
  end

  
   # Below the pipeline
  def get_current_user(conn, _params) do
    # TODO: Move this function out of the router module.
    user_id = get_session(conn, :user_id)
    user = Tracker.Accounts.get_user(user_id || -1)
    assign(conn, :current_user, user)
  end

  pipeline :csrf do
    plug :protect_from_forgery # to here
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/task", PageController, :task    

    resources "/users", UserController
    resources "/tasks", TaskController
    
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete

    pipe_through :api
   
    resources "/manages", ManageController, except: [:new, :edit]
    resources "/timeblocks", TimeblockController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrackerWeb do
  #   pipe_through :api
  # end
end
