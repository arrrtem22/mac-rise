# MacRise — Design Prompt

## App Overview

MacRise is a macOS menu bar alarm clock app. It wakes users up by playing motivational music at a scheduled time, gradually increasing system volume until activity is detected, then locks playback for a set duration so it cannot be dismissed. The app lives in the macOS top menu bar — no Dock icon, no main window. All interaction happens through a dropdown panel from the menu bar icon and a multi-step onboarding flow on first launch.

**App name**: MacRise
**Tagline**: "No snooze. No escape. Rise."

## Design Style

Copy the exact design of the **LookAway — Break Reminder** macOS app (https://apps.apple.com/app/lookaway-break-reminder/id1671569769). Use the same layout, spacing, typography, components, and overall visual feel for both the menu bar dropdown panel and the onboarding flow. Just adapt the content to MacRise's alarm functionality.

---

## Screen 1 — Menu Bar Icon

3 states of a menu bar icon:

- **Idle** (alarm scheduled, not ringing) — outline icon
- **Active** (alarm ringing) — filled icon with pulsing dot
- **Disabled** (no alarm set) — dimmed icon

When active, show a countdown badge next to the icon (e.g. "4:32") like LookAway shows "12m".

---

## Screen 2 — Dropdown Panel: Ringing State

The panel when the alarm is actively playing. Layout top to bottom:

1. **Header**: Segmented control — "Status" / "Settings" tabs. Gear icon top-right.
2. **Hero countdown**: Alarm icon, label "Alarm ends in", large bold **"4:32"**
3. **Action buttons**: "Stop" (primary — only works after lock expires), "+1m", "+5m" (secondary pills)
4. **Info cards** (rows):
   - 🎵 **Now Playing** → `DAVID_GOGGINS_GYM_MOT…` with progress bar
   - 🔊 **Volume** → `Level 5 / 16` with segmented volume bar
   - ⏱️ **Next increase** → `in 18 seconds`
   - 👁️ **Activity** → `No movement detected` or `✅ Movement detected — volume locked`

---

## Screen 3 — Dropdown Panel: Scheduled/Idle State

The panel when no alarm is ringing. Layout:

1. **Header**: Same segmented control + gear icon
2. **Hero time**: Alarm icon, label "Next alarm", large bold **"06:45 AM"**
3. **Info cards**:
   - 🎵 **Music** → `~/mac-rise/music (40 tracks)`
   - 🔒 **Lock duration** → `5 minutes`
   - 🔊 **Volume** → `3 → 16, +1 every 30s`
   - 💻 **Auto-wake** → `Enabled (06:44 AM) ✅`
4. **Footer**: "Test Alarm" button, "Quit MacRise" link

---

## Screen 4 — Onboarding: Welcome

- Large centered MacRise app icon
- Headline: **"Rise. No excuses."**
- Subtext: "MacRise wakes you up with motivational music and won't let you go back to sleep."
- Single **"Get Started"** button at bottom

---

## Screen 5 — Onboarding: Music Source

- Headline: **"Choose your alarm music"**
- Three selectable cards:
  1. **Download from GitHub** — "Get the default motivational music pack" with URL `github.com/arrrtem22/mac-rise-music`
  2. **Choose a folder** — "Select any folder with MP3, M4A, AAC, WAV, AIFF, or FLAC files"
  3. **Use default location** — "Place files in `~/mac-rise/music/`"
- Validation: "✅ 40 tracks found"
- Info: "Supported formats: MP3, M4A, AAC, WAV, AIFF, FLAC"
- Navigation: Back, dots, Next

---

## Screen 6 — Onboarding: Alarm Time

- Headline: **"When should MacRise wake you?"**
- Time picker for Hour and Minute, default 06:45
- Toggle: **"Wake Mac from sleep automatically"** — on by default
- Helper: "Your Mac will wake 1 minute before the alarm. Requires admin permission."
- Navigation: Back, dots, Next

---

## Screen 7 — Onboarding: Volume Configuration

- Headline: **"Set volume behavior"**
- Two side-by-side cards (same layout as LookAway's "Time between breaks" / "Break length"):
  - **Starting volume**: selectable buttons — `1` / `3 ✓` / `5` / `8`
  - **Target volume**: selectable buttons — `10` / `12` / `14` / `16 ✓`
- Below: **Increase interval** — `15s` / `30s ✓` / `45s` / `60s`
- Summary: "Volume reaches max in ~6 min 30 sec if no activity detected"
- Navigation: Back, dots, Next

---

## Screen 8 — Onboarding: Lock Duration

- Headline: **"How long should the alarm play?"**
- Selectable buttons: `3 min` / `5 min ✓` / `10 min` / `15 min`
- Warning: "During the lock period, the alarm cannot be stopped. Only Force Quit or shutting down the Mac will stop it."
- Subtitle: "This is intentional. No snooze. Rise."
- Navigation: Back, dots, Next

---

## Screen 9 — Onboarding: Review & Install

- Headline: **"You're all set"**
- Summary card:
  - 🎵 Music: `~/mac-rise/music (40 tracks)`
  - ⏰ Alarm: `06:45 AM daily`
  - 🔊 Volume: `3 → 16, +1 every 30s`
  - 🔒 Lock: `5 minutes`
  - 💻 Auto-wake: `Enabled (06:44 AM)`
- Primary button: **"Install & Activate"**
- Helper: "You can change these anytime from the menu bar."

---

## Screen 10 — Settings Panel

Accessible from gear icon in dropdown.

| Setting | Control | Default |
|---|---|---|
| Music Directory | Folder picker + path | `./music` |
| Lock Duration | Stepper (minutes) | 5 min |
| Starting Volume | Slider (0–16) | 3 |
| Target Volume | Slider (0–16) | 16 |
| Volume Increase Interval | Segmented: 15s / 30s / 45s / 60s | 30s |
| Alarm Time | Hour:Minute picker | 06:45 |
| Auto-wake Mac | Toggle | On |
| Launch at Login | Toggle | Off |

---

## All Configurable Variables

| # | Variable | Purpose | Default | Type |
|---|---|---|---|---|
| 1 | `MUSIC_DIR` | Folder with alarm music files | `./music` | Directory path |
| 2 | `LOCK_SECONDS` | Locked play duration | `300` (5 min) | Integer (seconds) |
| 3 | `MAX_VOLUME_LEVEL` | Max macOS volume level | `16` | Integer (0–16) |
| 4 | `MIN_VOLUME_LEVEL` | Starting volume | `3` | Integer (0–16) |
| 5 | `TARGET_VOLUME_LEVEL` | Volume ramp target | `16` | Integer (0–16) |
| 6 | `VOLUME_CHECK_SECONDS` | Volume check frequency | `0.5` | Float (seconds) |
| 7 | `VOLUME_INCREASE_INTERVAL` | Time between +1 increases | `30` | Integer (seconds) |
| 8 | `HOUR` | Alarm hour (24h) | `8` | Integer (0–23) |
| 9 | `MINUTE` | Alarm minute | `0` | Integer (0–59) |
| 10 | `pmset wakeorpoweron` | Wake Mac before alarm | Enabled | Boolean |
| 11 | `RunAtLoad` | Launch at login | `false` | Boolean |

---

## Technical Notes

- Native macOS app (Swift/SwiftUI, NSStatusItem)
- Local-only, no accounts, no cloud, no subscription — free utility
- Local music files (MP3, M4A, AAC, WAV, AIFF, FLAC), not streamed
- Permissions needed: Accessibility, folder access, admin (pmset)
