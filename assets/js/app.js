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

function update_timeblocks_buttons() {
  $('.timeblock-button').each( (_, bb) => {
    let task_id = $(bb).data('task-id')
    let start = $(bb).data('start');
    if (start != "") {
      $(bb).text("Stop");
    }
    else {
      $(bb).text("Start");
    }
  });
}

function set_button(user_id, value) {
  $('.manage-button').each( (_, bb) => {
    if (user_id == $(bb).data('user-id')) {
      $(bb).data('manage', value);
    }
  });
  update_manage_buttons();
}

function set_timeblock_button(task_id, value) {
  $('.timeblock-button').each( (_, bb) => {
    if (task_id == $(bb).data('task-id')) {
      $(bb).data('start', value);
    }
  });
  update_timeblocks_buttons();
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
    success: (resp) => { set_button(user_id, resp.data.id); },
  });
}

function unmanage(user_id, manager_id) {
  $.ajax(manage_path + "/" + manager_id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: () => { set_button(user_id, ""); },
  });
}

function start_timeblock(task_id) {
  let cur_time = Date.now();
  $.ajax(manage_path + "/" + manager_id, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: {
      start: cur_time, task_id: task_id
    },
    success: () => { set_timeblock_button(task_id, cur_time.toString()); },
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
  let has_blocks = btn.data('has-blocks');
  if (has_blocks == "N") {
    start_timeblock(task_id);
  }
}

function init_manage() {
  if (!$('.manage-button') || !$('.timeblock-button')) {
    return;
  }

  $('.timeblock-button').click(manage_timeblock_click)

  $(".manage-button").click(manage_click);

  update_manage_buttons();
}

$(init_manage);
