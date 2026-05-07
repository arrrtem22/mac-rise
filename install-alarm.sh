#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LABEL="local.mac-rise"
OLD_LABEL="local.wake-alarm"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
OLD_PLIST="$HOME/Library/LaunchAgents/$OLD_LABEL.plist"
HOUR="${1:-8}"
MINUTE="${2:-0}"

if [[ "$OSTYPE" != darwin* ]]; then
  echo "This installer is for macOS only." >&2
  exit 1
fi

if ! [[ "$HOUR" =~ ^[0-9]+$ && "$MINUTE" =~ ^[0-9]+$ ]]; then
  echo "Usage: ./install-alarm.sh [hour] [minute]" >&2
  exit 1
fi

if (( HOUR < 0 || HOUR > 23 || MINUTE < 0 || MINUTE > 59 )); then
  echo "Hour must be 0-23 and minute must be 0-59." >&2
  exit 1
fi

WAKE_MINUTE=$((MINUTE == 0 ? 59 : MINUTE - 1))
WAKE_HOUR=$((MINUTE == 0 ? (HOUR + 23) % 24 : HOUR))

chmod +x "$APP_DIR/wake-alarm.sh"
mkdir -p "$HOME/Library/LaunchAgents"

if [[ -f "$OLD_PLIST" ]]; then
  launchctl unload "$OLD_PLIST" >/dev/null 2>&1 || true
  rm "$OLD_PLIST"
fi

cat > "$PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>$APP_DIR/wake-alarm.sh</string>
  </array>
  <key>RunAtLoad</key>
  <false/>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key>
    <integer>$HOUR</integer>
    <key>Minute</key>
    <integer>$MINUTE</integer>
  </dict>
  <key>StandardOutPath</key>
  <string>$APP_DIR/mac-rise.log</string>
  <key>StandardErrorPath</key>
  <string>$APP_DIR/mac-rise.err.log</string>
</dict>
</plist>
PLIST

launchctl unload "$PLIST" >/dev/null 2>&1 || true
launchctl load "$PLIST"

echo "Installed LaunchAgent: $PLIST"
echo "Alarm will run daily at $(printf '%02d:%02d' "$HOUR" "$MINUTE")."

if command -v pmset >/dev/null 2>&1; then
  echo "Configuring macOS wake/power-on one minute before alarm."
  WAKE_TIME="$(printf '%02d:%02d:00' "$WAKE_HOUR" "$WAKE_MINUTE")"
  if sudo -n true 2>/dev/null; then
    sudo pmset repeat wakeorpoweron MTWRFSU "$WAKE_TIME"
  else
    echo "Run this once to allow macOS to wake before the alarm:"
    echo "sudo pmset repeat wakeorpoweron MTWRFSU $WAKE_TIME"
  fi
fi

echo "Done. Keep the laptop plugged in and do not fully shut it down."
