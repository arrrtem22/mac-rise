# MacRise

A simple macOS alarm script that wakes the Mac, shuffles and plays files from `music/`, gradually raises system volume until user activity is detected, plays for a locked duration (default 5 minutes), then stops automatically.

## Install

```bash
./install-alarm.sh 6 45
```

That installs a LaunchAgent for 6:45 AM and asks `pmset` to wake or power on the Mac at 6:44 AM. The LaunchAgent is installed in `~/Library/LaunchAgents`, so macOS loads the schedule again after restart/login.

## Test Now

```bash
LOCK_SECONDS=20 MIN_VOLUME_LEVEL=5 TARGET_VOLUME_LEVEL=8 ./wake-alarm.sh
```

During the locked period, `Ctrl-C` and normal termination are ignored. The script gradually increases the volume by 1 level every minute starting from `MIN_VOLUME_LEVEL`. Once you move your mouse or use your keyboard, the volume stops increasing.

This is intentionally simple and cannot defend against force quit, `kill -9`, deleting the LaunchAgent, muting external hardware, disconnecting speakers, or powering the Mac off.

## Uninstall

```bash
launchctl unload "$HOME/Library/LaunchAgents/local.mac-rise.plist"
rm "$HOME/Library/LaunchAgents/local.mac-rise.plist"
sudo pmset repeat cancel
```

## Configuration

- Put audio files in `music/`.
- Set `LOCK_SECONDS` to change the forced play duration.
- Set `MIN_VOLUME_LEVEL` from `0` to `16`; default is `5`, matching the 5th macOS volume bar.
- Set `TARGET_VOLUME_LEVEL` from `0` to `16`; default is `16`.
- Set `MIN_VOLUME` or `TARGET_VOLUME` from `0` to `100` only if you want exact macOS percentage values.
- Set `MUSIC_DIR` to use a different folder.

## Stop a Test

```bash
pkill -9 -f '/Users/artemiioliinyk/projects/mac-rise/wake-alarm.sh'
pkill -9 afplay
pkill -9 caffeinate
```
