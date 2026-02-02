#! /usr/bin/env bash

readonly SCRATCH_WORKSPACE_NAME=scratch
readonly SCRATCH_WIN_NAME=dropdown

windows() {
  niri msg -j windows
}

app_window() {
  local window_name=${SCRATCH_WIN_NAME}
  windows \
    | jq ".[] | select(.app_id == \"${window_name}\")"
}

run_quake() {
  local window_name=${SCRATCH_WIN_NAME}
  niri msg action spawn-sh -- "wezterm start --class ${window_name}"
  sleep 0.3
}

is_running() {
  [[ -n $(app_window) ]]
}

is_floating() {
  [[ $(app_window | jq .is_floating) == "true" ]]
}

is_focused() {
  [[ $(app_window | jq .is_focused) == "true" ]]
}

window_id() {
  app_window \
    | jq .id
}

window_workspace_id() {
  app_window \
    | jq -r .workspace_id
}

focused_workspace() {
  niri msg -j workspaces \
    | jq '.[] | select(.is_focused == true)'
}

workspace_id() {
  focused_workspace \
    | jq -r .id
}

workspace_reference() {
  focused_workspace \
    | jq -r 'if .name == null then (.idx | tostring) else .name end'
}

on_current_workspace() {
  [[ $(workspace_id) == $(window_workspace_id) ]]
}

moveToScratchpad() {
  niri msg action move-window-to-workspace \
    --window-id $(window_id) \
    "$SCRATCH_WORKSPACE_NAME" \
    --focus=false
}

bringToFocus() {
  niri msg action move-window-to-workspace \
    --window-id $(window_id) "$(workspace_reference)"
  niri msg action focus-window \
    --id $(window_id)
}

main() {
  if is_running; then
    if is_focused; then
      moveToScratchpad
    else
      if on_current_workspace; then
        moveToScratchpad
      else
        bringToFocus
      fi
    fi
  else
    run_quake
    bringToFocus
  fi
}

main "$@"
