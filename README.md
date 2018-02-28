# Tracker
You can initially think of a "Task Tracker" as being kind of like the "Issues" feature on Github. Visit the sample app [here](http://tasks1.purneshdixit.stream)

Users of your app should be able to:

Register an account
- Log in / Log out
- Create Tasks, entering a title and a description
- Assign tasks to themselves or other users
- Track how long they've worked on a task they're assigned to, in 15-minute increments.
- Mark a task as completed.

To log in, it's sufficient for a user to enter their name (or email - address). Passwords are a complex topic for later, and it's better to leave them out than to practice doing them wrong.

Managers
- Some users would be managers, who supervise many other users.
- Only a users's manager can assign them a task.
- A user's profile page should show both their manager and a list of people that they manage (underlings).
- Managers would be able to see a task report, which shows a table of tasks assigned to their underlings and the status of those tasks.

Detailed Time Spent
- Rather than entering time spent on a task as a single value, users would be able to enter time spent as multiple pairs of (start, end) timestamps. Users would be able to edit and delete these time blocks if they're wrong.

- Additionally, there would be direct time tracker feature, where a user can press a "start working" and "stop working" button on the task page, and this should create a block of time spent working on the task. The "stop working" button should be implemented using jQuery's AJAX function.

- Tracking time only in 15-minute increments is no longer required.

## Design Choices
- I have created following tables
  - Users (See [here](priv/repo/migrations/20180219072958_create_users.exs))
  - Tasks (See [here](priv/repo/migrations/20180219075410_create_tasks.exs))
  - Manages (See [here](priv/repo/migrations/20180227073756_create_manages.exs))
  - Timeblocks (See [here](priv/repo/migrations/20180228061747_create_timeblocks.exs))

- Users table is a simple table to store the user's details like name, email

- Tasks table stores the tasks assigned to each user and hence there is foreign key constraint on user_id field of tasks
- All the fields for now are mandatory and does not allow null
- is_completed has a default value set to false which means task has not been completed yet.

- Manages table is an association table that stores the records with two user id fields to identify who manages who and who is managed by whom. I have two fields referencing to user tables to suffice this many to many cardinality.

- Timeblock table is another association table between tasks and timeblocks associated with that task. I have foreign key field referencing to task along with start and end fields of type "Time". This suffice my requirement to keep track of multiple timeblocks.

- Another important design choice was to not allow a user who has an assigned task and hence deleting a user who has a task will be an error. This is important from the functional point of view as unless the task is not removed its owner cannot be removed. The ideal way of achieving this should be assigning the task to some other user and then deleting the user.

- Only managers are allowed to create tasks and assign to others. You can start managing anybody by clicking on button next to user and unmanage anytime.

- Normal users are only allowed to update their tasks i.e. update minutes and mark the task complete.

## Layout Information
- Landing page is a login page. You have to register using an email and then login
- If you are logged in, your landing page has three options
  - All Users
  - All Tasks(Only for Managers)
  - Task Manager
    - The Task Manager shows the tasks which are assigned to you as a user.
    - For Managers, the upper half of the page is to create a new task.
    - For Managers, there will be a list of task assigned to their underlings shown below.
    - For normal users, there will be links to update task information assigned to them.
    - On All users, you can manage/unmanage other users.
    - To update time, just start the time block and stop once finished. Duration will be automatically calculated.

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
