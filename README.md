# Tracker
You can initially think of a "Task Tracker" as being kind of like the "Issues" feature on Github. Visit the sample app [here](tasks1.purneshdixit.stream)

Users of your app should be able to:

Register an account
- Log in / Log out
- Create Tasks, entering a title and a description
- Assign tasks to themselves or other users
- Track how long they've worked on a task they're assigned to, in 15-minute increments.
- Mark a task as completed.

To log in, it's sufficient for a user to enter their name (or email - address). Passwords are a complex topic for later, and it's better to leave them out than to practice doing them wrong.

## Design Choices
- I have created two tables
  - Users (See [here](priv/repo/migrations/20180219072958_create_users.exs))
  - Tasks (See [here](priv/repo/migrations/20180219075410_create_tasks.exs))

- Users table is a simple table to store the user's details like name, email
- Tasks table stores the tasks assigned to each user and hence there is foreign key constraint on user_id field of tasks
- All the fields for now are mandatory and does not allow null
- minutes field has a default value set to 0 and is validated to be a multiple of 15. For example: minutes spent cannot be 27 but can be 30.
- is_completed has a default value set to false which means task has not been completed yet.

- Another important design choice was to not allow a user who has an assigned task and hence deleting a user who has a task will be an error. This is important from the functional point of view as unless the task is not removed its owner cannot be removed. The ideal way of achieving this should be assigning the task to some other user and then deleting the user.

## Layout Information
- Landing page is a login page. You have to register using an email and then login
- If you are logged in, your landing page has three options
  - All Users
  - All Tasks
  - Task Manager
    - The Task Manager shows the tasks which are assigned to you as a user.
    - The upper half of the page is to create a new task.
    - Since, the intention was to display the working of backend design, the flow is not very intuitive.
    - To create a task, go to "All Users" and note down the id for which you want to assign the task
    - Create a new task and put the user id in the user id box or update a task owner by assigning the user id
    - Similarly, other fields of the task can be updated.

## To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
