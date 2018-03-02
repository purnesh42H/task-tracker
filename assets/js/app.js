// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import $ from "jquery";

function update_manage_buttons() {
  $('.manage-button').each( (_, bb) => {
    let user_id = $(bb).data('user-id')
    let manage = $(bb).data('manage');
    if (manage != "") {
      $(bb).text("Unmanage");
    }
    else {
      $(bb).text("Manage");
    }
  });
}

function update_timeblock_buttons() {
  $('.timeblock-button').each( (_, bb) => {
    let task_id = $(bb).data('task-id')
    let running_time_id = $(bb).data('running-time-id');
    let has_blocks = $(bb).data('has-blocks');
    if (running_time_id) {
      $(bb).text("Stop Timer");
    }
    else {
      $(bb).text("Start Timer");
    }
  });
}

function set_button(user_id, value) {
  $('.manage-button').each( (_, bb) => {
    if (user_id == $(bb).data('user-id')) {
      $(bb).data('manage', value);
    }
  });
  update_timeblock_buttons();
}

function set_timeblock_button(task_id, value) {
  $('.timeblock-button').each( (_, bb) => {
    if (task_id == $(bb).data('task-id')) {
      $(bb).data('running-time-id', value);
    }
  });
  update_timeblock_buttons();
}

function manage(user_id) {
  let text = JSON.stringify({
    manage: {
        manager_id: current_user_id,
        user_id: user_id
      },
  });

  $.ajax(manage_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => {
      set_button(user_id, resp.data.id); 
      window.location.reload(); },
  });
}

function unmanage(user_id, manager_id) {
  $.ajax(manage_path + "/" + manager_id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: () => {
       set_button(user_id, "");
       window.location.reload(); },
  });
}

function start_timeblock(task_id, cur_time) {
  let text = JSON.stringify({
    timeblock: {
      start: cur_time,
      task_id: task_id,
    },
  });

  $.ajax(timeblock_path, {
    method: "POST",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => {
      set_timeblock_button(task_id, resp.data.id);
      window.location.reload(); },
   });
}

function stop_timeblock(task_id, time_id, cur_time) {
  let text = JSON.stringify({
    timeblock: {
      id: time_id,
      end: cur_time
    },
  });

  $.ajax(timeblock_path + "/" + time_id, {
    method: "PUT",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: () => {
      set_timeblock_button(task_id, null);
      window.location.reload(); },
  });
}

function manage_click(ev) {
  let btn = $(ev.target);
  let manager_id = btn.data('manage');
  let user_id = btn.data('user-id');

  if (manager_id != "") {
    unmanage(user_id, manager_id);
  }
  else {
    manage(user_id);
  }
}

function manage_timeblock_click(ev) {
  let btn = $(ev.target)
  let task_id = btn.data('task-id');
  let cur_time = btn.data('time');
  let running_time_id = btn.data('running-time-id');
  if (running_time_id) {
    stop_timeblock(task_id, running_time_id, cur_time);
  } else {
    start_timeblock(task_id, cur_time);
  }
}

function update_timeblock(ev) {
  console.log("hi");
  let btn = $(ev.target);
  let time_id = btn.data('time-id');
  let start_time = $('#start_'+time_id).val();
  let end_time = $('#end_'+time_id).val();
  
  let text = JSON.stringify({
    timeblock: {
      id: time_id,
      start: start_time,
      end: end_time
    },
  });

  $.ajax(timeblock_path + "/" + time_id, {
    method: "PUT",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { window.location.reload(); },
  });
}

function delete_timeblock(ev) {
  let btn = $(ev.target);
  let time_id = btn.data('time-id');
  
  $.ajax(timeblock_path + "/" + time_id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: (resp) => { window.location.reload(); },
  });
}

function init_manage() {
  if (!$('.manage-button') || !$('.timeblock-button') ||
    !$('timeblock-update') || !$('timeblock-delete')) {
    return;
  }

  $('.timeblock-button').click(manage_timeblock_click)

  $(".manage-button").click(manage_click);

  update_manage_buttons();
  update_timeblock_buttons();
  
  $('.timeblock-update').click(update_timeblock)
  $('.timeblock-delete').click(delete_timeblock)
}

$(init_manage);
