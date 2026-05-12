#!/usr/bin/env bash
# mac-rise alarm script
set -uo pipefail # Removed -e to prevent accidental exits, we will handle critical errors manually

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MUSIC_DIR="${MUSIC_DIR:-$APP_DIR/music}"
LOCK_SECONDS="${LOCK_SECONDS:-300}"
MAX_VOLUME_LEVEL="${MAX_VOLUME_LEVEL:-16}"
MIN_VOLUME_LEVEL="${MIN_VOLUME_LEVEL:-3}"
TARGET_VOLUME_LEVEL="${TARGET_VOLUME_LEVEL:-16}"
VOLUME_CHECK_SECONDS="${VOLUME_CHECK_SECONDS:-0.5}"
VOLUME_INCREASE_INTERVAL="${VOLUME_INCREASE_INTERVAL:-30}" # Default is 30 seconds

volume_level_to_percent() {
  local level="$1"
  echo $(((level * 100 + MAX_VOLUME_LEVEL - 1) / MAX_VOLUME_LEVEL))
}

if [[ ! -d "$MUSIC_DIR" ]]; then
  echo "Error: Music directory not found: $MUSIC_DIR" >&2
  exit 1
fi

TRACKS=()
while IFS= read -r -d '' FILE; do
  TRACKS+=("$FILE")
done < <(
  find "$MUSIC_DIR" -type f \( \
    -iname '*.mp3' -o -iname '*.m4a' -o -iname '*.aac' -o \
    -iname '*.wav' -o -iname '*.aiff' -o -iname '*.flac' \
  \) -print0
)

if [[ "${#TRACKS[@]}" -eq 0 ]]; then
  echo "Error: No supported music files found in: $MUSIC_DIR" >&2
  exit 1
fi

# Shuffle tracks
for i in "${!TRACKS[@]}"; do
  j=$((RANDOM % ${#TRACKS[@]}))
  tmp="${TRACKS[i]}"
  TRACKS[i]="${TRACKS[j]}"
  TRACKS[j]="$tmp"
done

CURRENT_VOLUME_LEVEL=$MIN_VOLUME_LEVEL
MOVEMENT_DETECTED=0
LAST_VOLUME_INCREASE_TIME=$SECONDS
TRACK_INDEX=0
START_TIME=$SECONDS
ENDS_AT=$((START_TIME + LOCK_SECONDS))

echo "Wake alarm started at $(date)"
echo "Locked duration: $LOCK_SECONDS seconds (Ends at approx. SECONDS=$ENDS_AT)"

# Initial volume set
osascript -e "set volume output volume $(volume_level_to_percent "$CURRENT_VOLUME_LEVEL")" >/dev/null 2>&1 || true

update_volume() {
  if [[ $MOVEMENT_DETECTED -eq 0 ]]; then
    # Ignore activity for the first 10 seconds (grace period) to allow manual starting
    if (( SECONDS < 10 )); then
      return 0
    fi

    local idle_time_int
    idle_time_int=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}' 2>/dev/null)
    
    if [[ -n "$idle_time_int" ]] && (( idle_time_int < 5 )); then
      MOVEMENT_DETECTED=1
      echo "[$(date +%T)] Activity detected! Volume will stay at level $CURRENT_VOLUME_LEVEL."
    else
      if (( SECONDS - LAST_VOLUME_INCREASE_TIME >= VOLUME_INCREASE_INTERVAL )); then
        if (( CURRENT_VOLUME_LEVEL < TARGET_VOLUME_LEVEL )); then
          CURRENT_VOLUME_LEVEL=$((CURRENT_VOLUME_LEVEL + 1))
          echo "[$(date +%T)] No activity. Increasing volume to level $CURRENT_VOLUME_LEVEL."
        fi
        LAST_VOLUME_INCREASE_TIME=$SECONDS
      fi
    fi
  fi

  local target_percent
  target_percent=$(volume_level_to_percent "$CURRENT_VOLUME_LEVEL")

  osascript <<APPLESCRIPT >/dev/null 2>&1 || true
set targetVolume to $target_percent
set currentVolume to output volume of (get volume settings)
if currentVolume < targetVolume then
  set volume output volume targetVolume
end if
APPLESCRIPT
}

stop_after_lock() {
  local now=$SECONDS
  if (( now < ENDS_AT )); then
    echo "[$(date +%T)] Termination signal ignored. Alarm is locked for $((ENDS_AT - now)) more seconds."
    return 0
  fi

  echo "[$(date +%T)] Stopping alarm..."
  [[ -n "${PLAYER_PID:-}" ]] && kill "$PLAYER_PID" >/dev/null 2>&1 || true
  exit 0
}

trap stop_after_lock INT TERM

while (( SECONDS < ENDS_AT )); do
  TRACK="${TRACKS[TRACK_INDEX]}"
  TRACK_INDEX=$(( (TRACK_INDEX + 1) % ${#TRACKS[@]} ))
  
  echo "[$(date +%T)] Playing: $(basename "$TRACK")"
  caffeinate -dimsu afplay "$TRACK" &
  PLAYER_PID=$!
  
  while kill -0 "$PLAYER_PID" >/dev/null 2>&1; do
    if (( SECONDS >= ENDS_AT )); then
      echo "[$(date +%T)] Lock duration reached. Terminating player."
      kill "$PLAYER_PID" >/dev/null 2>&1 || true
      break
    fi
    update_volume
    sleep "$VOLUME_CHECK_SECONDS"
  done

  wait "$PLAYER_PID" >/dev/null 2>&1 || true
  
  if (( SECONDS < ENDS_AT )); then
    echo "[$(date +%T)] Track finished early. Switching to next track."
  fi
done

echo "[$(date +%T)] Alarm finished successfully."

