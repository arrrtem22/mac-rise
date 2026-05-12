#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MUSIC_DIR="${MUSIC_DIR:-$APP_DIR/music}"
LOCK_SECONDS="${LOCK_SECONDS:-300}"
MAX_VOLUME_LEVEL="${MAX_VOLUME_LEVEL:-16}"
MIN_VOLUME_LEVEL="${MIN_VOLUME_LEVEL:-3}"
TARGET_VOLUME_LEVEL="${TARGET_VOLUME_LEVEL:-16}"
VOLUME_CHECK_SECONDS="${VOLUME_CHECK_SECONDS:-0.5}"

volume_level_to_percent() {
  local level="$1"
  echo $(((level * 100 + MAX_VOLUME_LEVEL - 1) / MAX_VOLUME_LEVEL))
}

if [[ ! -d "$MUSIC_DIR" ]]; then
  echo "Music directory not found: $MUSIC_DIR" >&2
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
  echo "No supported music files found in: $MUSIC_DIR" >&2
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
ENDS_AT=$((SECONDS + LOCK_SECONDS))

echo "Wake alarm started at $(date)"
echo "Locked play time: $LOCK_SECONDS seconds"

osascript -e "set volume output volume $(volume_level_to_percent "$CURRENT_VOLUME_LEVEL")" >/dev/null 2>&1 || true

update_volume() {
  if [[ $MOVEMENT_DETECTED -eq 0 ]]; then
    local idle_time_int
    idle_time_int=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')
    if [[ -n "$idle_time_int" ]] && (( idle_time_int < 5 )); then
      MOVEMENT_DETECTED=1
      echo "Activity detected! Stopping volume increase."
    else
      if (( SECONDS - LAST_VOLUME_INCREASE_TIME >= 60 )); then
        if (( CURRENT_VOLUME_LEVEL < TARGET_VOLUME_LEVEL )); then
          CURRENT_VOLUME_LEVEL=$((CURRENT_VOLUME_LEVEL + 1))
          echo "No activity. Increasing volume to level $CURRENT_VOLUME_LEVEL"
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
  if (( SECONDS < ENDS_AT )); then
    REMAINING=$((ENDS_AT - SECONDS))
    echo "Alarm is locked for another $REMAINING seconds."
    return 0
  fi

  [[ -n "${PLAYER_PID:-}" ]] && kill "$PLAYER_PID" >/dev/null 2>&1 || true
  exit 0
}

trap stop_after_lock INT TERM

while (( SECONDS < ENDS_AT )); do
  TRACK="${TRACKS[TRACK_INDEX]}"
  TRACK_INDEX=$(( (TRACK_INDEX + 1) % ${#TRACKS[@]} ))
  
  echo "Playing: $TRACK"
  caffeinate -dimsu afplay "$TRACK" &
  PLAYER_PID=$!
  
  while kill -0 "$PLAYER_PID" >/dev/null 2>&1 && (( SECONDS < ENDS_AT )); do
    update_volume
    sleep "$VOLUME_CHECK_SECONDS"
  done

  if kill -0 "$PLAYER_PID" >/dev/null 2>&1; then
    kill "$PLAYER_PID" >/dev/null 2>&1 || true
    wait "$PLAYER_PID" >/dev/null 2>&1 || true
  fi
done

echo "Locked play time finished. Alarm stopped automatically."
