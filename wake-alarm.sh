#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MUSIC_DIR="${MUSIC_DIR:-$APP_DIR/music}"
LOCK_SECONDS="${LOCK_SECONDS:-600}"
TARGET_VOLUME="${TARGET_VOLUME:-100}"
MIN_VOLUME="${MIN_VOLUME:-50}"
VOLUME_CHECK_SECONDS="${VOLUME_CHECK_SECONDS:-2}"

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

TRACK="${TRACKS[$((RANDOM % ${#TRACKS[@]}))]}"
ENDS_AT=$((SECONDS + LOCK_SECONDS))

echo "Wake alarm started at $(date)"
echo "Playing: $TRACK"
echo "Locked play time: $LOCK_SECONDS seconds"

set_volume_at_least_minimum() {
  osascript <<APPLESCRIPT >/dev/null 2>&1 || true
set minimumVolume to $MIN_VOLUME
set targetVolume to $TARGET_VOLUME
if targetVolume < minimumVolume then
  set targetVolume to minimumVolume
end if
set currentVolume to output volume of (get volume settings)
if currentVolume < minimumVolume then
  set volume output volume targetVolume
end if
APPLESCRIPT
}

set_volume_at_least_minimum

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
  caffeinate -dimsu afplay "$TRACK" &
  PLAYER_PID=$!
  while kill -0 "$PLAYER_PID" >/dev/null 2>&1 && (( SECONDS < ENDS_AT )); do
    set_volume_at_least_minimum
    sleep "$VOLUME_CHECK_SECONDS"
  done

  if kill -0 "$PLAYER_PID" >/dev/null 2>&1; then
    kill "$PLAYER_PID" >/dev/null 2>&1 || true
    wait "$PLAYER_PID" >/dev/null 2>&1 || true
  fi
done

echo "Locked play time finished. Alarm stopped automatically."
