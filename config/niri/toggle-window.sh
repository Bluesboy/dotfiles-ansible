#! /usr/bin/env bash

set -euo pipefail

usage() {
  cat >&2 <<EOF
Usage: $(basename "$0") -a APP_ID -w WORKSPACE

Toggle an application between a home workspace and the current one.

Options:
  -a APP_ID    app_id of the target window (as shown by 'niri msg -j windows')
  -w WORKSPACE Workspace name/index to send the window back to when hiding
  -h           Show this help
EOF
  exit 1
}

APP_ID=""
HOME_WORKSPACE=""

while getopts ':a:w:h' opt; do
  case "$opt" in
  a) APP_ID="$OPTARG" ;;
  w) HOME_WORKSPACE="$OPTARG" ;;
  h) usage ;;
  :)
    echo "Option -$OPTARG requires an argument" >&2
    usage
    ;;
  \?)
    echo "Unknown option: -$OPTARG" >&2
    usage
    ;;
  esac
done

[[ -z "$APP_ID" ]] && {
  echo "Error: -a APP_ID is required" >&2
  usage
}
[[ -z "$HOME_WORKSPACE" ]] && {
  echo "Error: -w WORKSPACE is required" >&2
  usage
}

# --- Cached niri queries ---
_win_data=""
_ws_data=""

win_data() {
  [[ -z "$_win_data" ]] && _win_data=$(niri msg -j windows)
  echo "$_win_data"
}

ws_data() {
  [[ -z "$_ws_data" ]] && _ws_data=$(niri msg -j workspaces)
  echo "$_ws_data"
}

app_window() { win_data | jq ".[] | select(.app_id == \"${APP_ID}\")"; }
focused_workspace() { ws_data | jq '.[] | select(.is_focused == true)'; }

is_running() { [[ -n $(app_window) ]]; }
is_focused() { [[ $(app_window | jq .is_focused) == "true" ]]; }
on_current_workspace() { [[ $(focused_workspace | jq -r .id) == $(app_window | jq -r .workspace_id) ]]; }

window_id() { app_window | jq .id; }

current_workspace_reference() {
  focused_workspace |
    jq -r 'if .name == null then (.idx | tostring) else .name end'
}

send_home() {
  local id
  id=$(window_id)
  niri msg action focus-window --id "$id"
  niri msg action move-window-to-tiling --id "$id"
  niri msg action move-window-to-workspace \
    --window-id "$id" \
    "$HOME_WORKSPACE" \
    --focus=false
}

bring_here() {
  local id
  id=$(window_id)
  niri msg action move-window-to-workspace --window-id "$id" "$(current_workspace_reference)"
  niri msg action move-window-to-floating --id "$id"
  niri msg action focus-window --id "$id"
}

main() {
  if ! is_running; then
    echo "Error: no window with app_id '${APP_ID}' found" >&2
    exit 1
  fi

  if is_focused || on_current_workspace; then
    send_home
  else
    bring_here
  fi
}

main
