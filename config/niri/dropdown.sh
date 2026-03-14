#! /usr/bin/env bash

readonly SCRATCH_WORKSPACE_NAME=scratch
readonly SCRATCH_WIN_NAME=dropdown

# Cache niri state once per invocation
_win_data=""
_ws_data=""

win_data() {
  if [[ -z "$_win_data" ]]; then
    _win_data=$(niri msg -j windows)
  fi
  echo "$_win_data"
}

ws_data() {
  if [[ -z "$_ws_data" ]]; then
    _ws_data=$(niri msg -j workspaces)
  fi
  echo "$_ws_data"
}

app_window() {
  win_data | jq ".[] | select(.app_id == \"${SCRATCH_WIN_NAME}\")"
}

focused_workspace() {
  ws_data | jq '.[] | select(.is_focused == true)'
}

is_running() { [[ -n $(app_window) ]]; }
is_focused() { [[ $(app_window | jq .is_focused) == "true" ]]; }
on_current_workspace() { [[ $(focused_workspace | jq -r .id) == $(app_window | jq -r .workspace_id) ]]; }

workspace_reference() {
  focused_workspace |
    jq -r 'if .name == null then (.idx | tostring) else .name end'
}

window_id() {
  app_window | jq .id
}

run_quake() {
  niri msg action spawn-sh -- "wezterm start --class ${SCRATCH_WIN_NAME}"
  # Poll until window appears (max 2s)
  for _ in {1..20}; do
    _win_data="" # invalidate cache
    is_running && return
    sleep 0.1
  done
}

moveToScratchpad() {
  niri msg action move-window-to-workspace \
    --window-id "$(window_id)" \
    "$SCRATCH_WORKSPACE_NAME" \
    --focus=false
}

bringToFocus() {
  local id
  id=$(window_id)
  niri msg action move-window-to-workspace --window-id "$id" "$(workspace_reference)"
  niri msg action focus-window --id "$id"
}

main() {
  if is_running; then
    if is_focused || on_current_workspace; then
      moveToScratchpad
    else
      bringToFocus
    fi
  else
    run_quake
    bringToFocus
  fi
}

main "$@"
