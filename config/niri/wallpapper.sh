#!/usr/bin/env bash

set -euo pipefail

# --- Configuration ---
WALLDIR="${WALLDIR:-$HOME/Pictures/wallpapers}"
DELAY="${DELAY:-10}"
TRANSITION="${TRANSITION:-random}"
TRANSITION_DURATION="${TRANSITION_DURATION:-0.2}"
TRANSITION_FPS="${TRANSITION_FPS:-60}"

# --- Logging ---
log()  { printf '[wallpapper] %s\n' "$*" >&2; }
die()  { log "ERROR: $*"; exit 1; }
warn() { log "WARN:  $*"; }

# --- Usage ---
usage() {
  cat >&2 <<EOF
Usage: $(basename "$0") [OPTIONS]

Randomly rotate wallpapers across all connected outputs using swww.

Options:
  -d DIR     Wallpaper directory (default: ~/Pictures/wallpapers)
  -s SECS    Rotation interval in seconds (default: 10)
  -t TYPE    swww transition type (default: random)
  -D SECS    Transition duration in seconds (default: 0.2)
  -f FPS     Transition FPS (default: 60)
  -h         Show this help

Environment variables:
  WALLDIR, DELAY, TRANSITION, TRANSITION_DURATION, TRANSITION_FPS
EOF
  exit 0
}

# --- Parse arguments ---
while getopts ':d:s:t:D:f:h' opt; do
  case "$opt" in
    d) WALLDIR="$OPTARG" ;;
    s) DELAY="$OPTARG" ;;
    t) TRANSITION="$OPTARG" ;;
    D) TRANSITION_DURATION="$OPTARG" ;;
    f) TRANSITION_FPS="$OPTARG" ;;
    h) usage ;;
    :) die "Option -$OPTARG requires an argument" ;;
    \?) die "Unknown option: -$OPTARG" ;;
  esac
done

# --- Validation ---
command -v swww >/dev/null 2>&1   || die "'swww' not found in PATH"
command -v swww-daemon >/dev/null || die "'swww-daemon' not found in PATH"
[[ -d "$WALLDIR" ]]               || die "Wallpaper directory not found: $WALLDIR"

# --- Start swww-daemon if not already running ---
if ! swww query &>/dev/null; then
  log "Starting swww-daemon..."
  swww-daemon &
  for _ in {1..10}; do
    swww query &>/dev/null && break
    sleep 0.2
  done
  swww query &>/dev/null || die "swww-daemon failed to start"
fi

# --- Named pipe for inotifywait events ---
PIPE=$(mktemp -u)
mkfifo "$PIPE"
INOTIFY_PID=""

cleanup() {
  log "Exiting, stopping swww-daemon..."
  [[ -n "$INOTIFY_PID" ]] && kill "$INOTIFY_PID" 2>/dev/null || true
  rm -f "$PIPE"
  pkill -x swww-daemon 2>/dev/null || true
  exit 0
}
trap cleanup SIGINT SIGTERM

# --- Start inotifywait if available ---
if command -v inotifywait &>/dev/null; then
  inotifywait -m -q -e create,moved_to,delete,moved_from \
    --format '%f' "$WALLDIR" > "$PIPE" 2>/dev/null &
  INOTIFY_PID=$!
  log "Watching $WALLDIR for changes (inotifywait)"
else
  warn "inotifywait not found — install inotify-tools for instant file detection"
fi

log "Wallpaper dir : $WALLDIR"
log "Interval      : ${DELAY}s"
log "Transition    : $TRANSITION (${TRANSITION_DURATION}s @ ${TRANSITION_FPS}fps)"

rotate() {
  mapfile -t FILES < <(find "$WALLDIR" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \
       -o -iname '*.webp' -o -iname '*.gif' -o -iname '*.bmp' \) \
    | sort)

  if [[ ${#FILES[@]} -eq 0 ]]; then
    warn "No images found in $WALLDIR"
    return
  fi

  mapfile -t OUTPUTS < <(swww query | awk '{print $2}' | tr -d ':')

  log "Detected outputs: ${OUTPUTS[*]:-<none>}"

  if [[ ${#OUTPUTS[@]} -eq 0 ]]; then
    warn "No outputs detected"
    return
  fi

  mapfile -t SHUFFLED < <(shuf -e "${FILES[@]}")

  if [[ ${#FILES[@]} -lt ${#OUTPUTS[@]} ]]; then
    warn "Only ${#FILES[@]} image(s) for ${#OUTPUTS[@]} output(s) — some wallpapers will repeat"
  fi

  log "Rotating across ${#OUTPUTS[@]} output(s) from ${#FILES[@]} image(s)"

  for i in "${!OUTPUTS[@]}"; do
    OUT="${OUTPUTS[$i]}"
    IMG="${SHUFFLED[$(( i % ${#SHUFFLED[@]} ))]}"
    log "  $OUT -> $(basename "$IMG")"
    swww img \
      --outputs "$OUT" \
      --transition-type "$TRANSITION" \
      --transition-duration "$TRANSITION_DURATION" \
      --transition-fps "$TRANSITION_FPS" \
      -- "$IMG"
  done
}

# --- Main loop ---
while true; do
  rotate

  if [[ -n "$INOTIFY_PID" ]]; then
    # Wait DELAY seconds, but wake up early if inotifywait reports a change
    if read -t "$DELAY" -r EVENT < "$PIPE" 2>/dev/null; then
      log "Directory change detected ($EVENT), rescanning..."
      # Drain any further pending events to avoid rapid-fire rotations
      while read -t 0.5 -r _ < "$PIPE" 2>/dev/null; do :; done
    fi
  else
    sleep "$DELAY"
  fi
done
