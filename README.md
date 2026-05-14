# MacRise

MacRise is a macOS menu bar alarm app. Keep the app running, and it will schedule the next alarm, configure macOS to wake one minute before the alarm, play music, raise volume until activity is detected, and keep the Mac awake while the alarm is ringing.

## Start

1. Open `mac-rise/mac-rise.xcodeproj` in Xcode.
2. Run the `mac-rise` scheme.
3. Finish setup in the app, or use the menu bar alarm icon to adjust settings.
4. Leave the app running.

The app configures `pmset repeat wakeorpoweron` automatically when Auto-wake is enabled. For a 6:45 AM alarm, macOS should show a repeating wake event at 6:44 AM.

Check the current wake schedule:

```bash
pmset -g sched
```

## Changing Alarm Time

Change the alarm time in the app and save the settings. The app reschedules both:

- The in-app alarm timer.
- The macOS wake event one minute before the alarm.

For example, changing the alarm to 8:00 AM should configure macOS to wake at 7:59 AM.

## Requirements

- The app must stay running. If you quit the app, there is no running alarm process to play music after wake.
- Auto-wake must be enabled in the app.
- The Mac must be asleep, not fully shut down.
- The MacBook should be plugged in for reliable wake behavior.
- The app may ask for administrator permission when it updates the macOS wake schedule.

## Stop Using The Old Script

The app no longer needs the script-backed LaunchAgent. If an old installation exists, remove it:

```bash
launchctl bootout "gui/$(id -u)" "$HOME/Library/LaunchAgents/local.mac-rise.plist" 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/local.mac-rise.plist"
```

Do not run `wake-alarm.sh` for normal use.
