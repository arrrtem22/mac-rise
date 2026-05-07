# Wake Alarm

A simple macOS alarm script that wakes the Mac, chooses a random file from `music/`, raises system volume, plays for 10 locked minutes, then stops automatically.

## Install

```bash
./install-alarm.sh
```

That installs a LaunchAgent for 8:00 AM and asks `pmset` to wake or power on the Mac at 7:59 AM. The LaunchAgent is installed in `~/Library/LaunchAgents`, so macOS loads the schedule again after restart/login.

## Test Now

```bash
LOCK_SECONDS=20 ./wake-alarm.sh
```

During the locked period, `Ctrl-C` and normal termination are ignored. The script also checks volume every 2 seconds and raises it if it drops below `MIN_VOLUME`.

This is intentionally simple and cannot defend against force quit, `kill -9`, deleting the LaunchAgent, muting external hardware, disconnecting speakers, or powering the Mac off.

## Uninstall

```bash
launchctl unload "$HOME/Library/LaunchAgents/local.wake-alarm.plist"
rm "$HOME/Library/LaunchAgents/local.wake-alarm.plist"
sudo pmset repeat cancel
```

## Configuration

- Put audio files in `music/`.
- Set `LOCK_SECONDS` to change the forced play duration.
- Set `TARGET_VOLUME` from `0` to `100`.
- Set `MIN_VOLUME` from `0` to `100`; default is `50`.
- Set `MUSIC_DIR` to use a different folder.
