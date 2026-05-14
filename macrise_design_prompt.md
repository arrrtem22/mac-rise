# MacRise — AI Design Studio Prompt

---

## Prompt

> Design a **macOS menu bar (status bar) application** called **MacRise**. MacRise is a smart alarm clock that wakes users up by playing motivational music at a scheduled time, gradually increasing system volume until the user moves their mouse or keyboard, then locks playback for a set duration so the user can't dismiss it. The app lives entirely in the macOS top menu bar — there is no Dock icon and no main window. All interaction happens through a **dropdown panel** that opens when clicking the menu bar icon, plus a **multi-step onboarding flow** shown on first launch.

---

### Brand & Visual Direction

- **App name**: MacRise
- **Tagline**: "No snooze. No escape. Rise."

**Design reference — follow the design language of LookAway (macOS Break Reminder app):**

The design must closely follow the visual style of the LookAway macOS app. Here is a detailed description of that design language:

**Menu bar dropdown panel (the main interface):**
- Dark frosted-glass panel with native macOS vibrancy/blur, approximately 320pt wide, with generously rounded corners (~16pt)
- A segmented control at the top for tab switching (e.g. "Now" / "Stats") — pill-shaped, subtle gray fill on the active tab, sitting inside the panel header
- A small gear icon (⚙️) in the top-right corner for settings access
- The central area features a large, bold countdown number (e.g. "11:29") in white, SF Pro Rounded or SF Pro Display weight, centered and dominant — this is the hero element
- Above the countdown: a small SF Symbol icon (hourglass) and a muted gray subtitle label (e.g. "Break starts in")
- Below the countdown: a horizontal row of pill-shaped action buttons — one primary (filled, slightly lighter gray) and several secondary (outlined/bordered, dark fill). All buttons have generous horizontal padding and rounded-pill shape
- At the bottom: information rows displayed as rounded rectangle cards with a slightly lighter gray fill (~#2a2a2a on ~#1a1a1a background). Each row has a colored icon on the left (small rounded square, e.g. yellow ⚡, pink 🔄), a label in white, and a value aligned to the right in muted gray or white. Rows are separated by subtle spacing, not divider lines

**Onboarding flow (setup wizard window):**
- A centered macOS window (~720×480pt) with rounded corners, no toolbar, just traffic light buttons (close/minimize/maximize) in the top-left
- Background: very dark, near-black (#0d0d0d to #1a1a1a) with an atmospheric gradient glow — soft colored light bleeds from the bottom-left and top-right corners, creating a cinematic, moody ambiance. The glow colors are muted and organic (purple-magenta bottom-left, golden-amber top-right), with subtle star-like particles/grain scattered in the background
- Welcome screen: large centered app icon (rounded square with inner icon), centered headline text in white (SF Pro Display, ~28pt), and a single understated "Let's begin" button at the bottom (outlined/bordered pill button, not bold or colored)
- Configuration screens: centered SF Symbol or app-themed icon at the top, a clear headline below, then content organized in side-by-side rounded rectangle cards (~#2a2a2a fill on dark background). Each card has a bold title, muted gray description text, and a 2×2 grid of selectable pill-shaped buttons inside. Selected buttons have a colored border (accent color) and a checkmark (✓). Unselected buttons have a dark fill with no border
- Navigation: "Back" button bottom-left (outlined pill), dot indicators centered at the bottom (3 dots, active dot filled), "Next" button bottom-right (outlined pill)
- Optional: a decorative image with rounded corners can appear alongside configuration cards (like a nature photo)
- Small helper text below options: muted gray, e.g. "You can adjust these anytime in Settings"

**Accent color for MacRise — use warm sunrise amber/orange instead of LookAway's pink:**
- Primary accent: **#FF9F0A** (macOS system orange) — used for selected state borders, active icons, progress indicators, and the "alarm active" status glow
- Secondary accent: **#FFD60A** (warm golden yellow) — used sparingly for highlights and the onboarding background gradient glow
- The onboarding atmospheric gradient should use deep amber (#FF9F0A at ~15% opacity) bleeding from the top-right and deep indigo/navy (#1B1464 at ~15% opacity) from the bottom-left, replacing LookAway's pink-purple and golden-green
- This warm palette evokes sunrise and morning energy, matching the alarm/wake-up purpose of the app

---

### 1. Menu Bar Icon States

Design the menu bar icon (16×16 pt, SF Symbol style) with **3 visual states**:

| State | Icon Description | Indicator |
|---|---|---|
| **Idle** (alarm scheduled, not ringing) | Sunrise/alarm bell outline | Small dot or no dot |
| **Active** (alarm is currently playing) | Filled sunrise/alarm bell | Pulsing amber dot |
| **Disabled** (no alarm set) | Dimmed/gray icon | No dot |

---

### 2. Menu Bar Dropdown Panel — Live Status View

When the user clicks the menu bar icon, a **dropdown panel** appears (approximately 320pt wide, variable height). This is the primary interface. Design this panel showing all of the following real-time information:

#### Header Section
- **App name** "MacRise" (small, subtle)
- **Status badge**: One of: `Scheduled for 06:45` · `🔔 RINGING` · `Off`

#### Real-Time Status Cards (visible only when alarm is active/ringing)

| Data Point | Description | Example Display |
|---|---|---|
| **Time Remaining** | Countdown of how many minutes and seconds are left in the locked play duration | `4:32 remaining` |
| **Current Track** | Filename of the currently playing music track (truncated) | `♫ DAVID_GOGGINS_GYM_MOT…` |
| **Track Progress** | A thin progress bar showing position within current track | `[████████░░░░] 1:24 / 2:38` |
| **Volume Level** | Current volume level out of max, shown as segmented bar (like macOS volume) | `█ █ █ █ █ ░ ░ ░ ░ ░ ░ ░ ░ ░ ░ ░  5/16` |
| **Next Volume Increase** | Countdown seconds until the next +1 volume step | `Next increase in 18s` |
| **Movement Status** | Whether user activity has been detected | `No activity detected` or `✅ Movement detected — volume locked` |
| **Idle Time** | System idle duration from IOKit | `System idle: 45s` |
| **Tracks Remaining** | How many shuffled tracks are left in queue | `3 of 12 tracks played` |

#### Scheduled (Idle) State Content

When the alarm is not currently ringing, show:

| Data Point | Example Display |
|---|---|
| **Next alarm** | `Tomorrow at 06:45 AM` |
| **Music source** | `~/projects/mac-rise/music (40 tracks)` |
| **Lock duration** | `5 minutes` |
| **Volume range** | `3 → 16 (increase every 30s)` |
| **System wake** | `pmset wake at 06:44 AM ✅` |

#### Footer Actions
- **⏯️ Test Alarm** button (runs alarm immediately with short lock)
- **⚙️ Settings** link
- **Quit MacRise**

---

### 3. Onboarding Flow — Multi-Step Setup Wizard

On first launch, show a **centered macOS window** (480×600pt, rounded corners, native vibrancy) with a multi-step onboarding wizard. Design **6 screens** with a progress indicator (dots or thin progress bar) at the top:

---

#### Screen 1: Welcome
- Large MacRise icon/logo
- Headline: **"Rise. No excuses."**
- Subtext: "MacRise wakes you up with motivational music and won't let you go back to sleep. Set it once and it handles the rest."
- Single **"Get Started"** button

---

#### Screen 2: Music Source
- Headline: **"Choose your alarm music"**
- Three options presented as selectable cards:
  1. **Use built-in music** — "Download the default motivational pack from GitHub" (shows a GitHub link icon and the URL `github.com/arrrtem22/mac-rise-music`). When selected, the app clones/downloads the music pack automatically.
  2. **Choose a folder** — "Select a folder on your Mac with MP3, M4A, AAC, WAV, AIFF, or FLAC files." Shows a native macOS folder picker button.
  3. **Use default location** — "Place files in `~/mac-rise/music/`". Grayed-out path shown.
- Below the cards: small info text: "Supported formats: MP3, M4A, AAC, WAV, AIFF, FLAC"
- **Validation**: Show the count of detected tracks after selection (e.g., "✅ 40 tracks found")
- **Back** / **Next** buttons

---

#### Screen 3: Alarm Time
- Headline: **"When should MacRise wake you?"**
- A **time picker** (native macOS style, scrolling wheels or digital input) for **Hour** (0–23) and **Minute** (0–59)
- Default pre-filled: `06:45`
- Below: explanation text: "MacRise will also configure your Mac to wake from sleep 1 minute before the alarm."
- Toggle: **"Wake Mac from sleep automatically"** (on by default) — maps to `pmset repeat wakeorpoweron`
- Small info: "Requires administrator permission on first setup"
- **Back** / **Next** buttons

---

#### Screen 4: Volume Configuration
- Headline: **"Configure volume behavior"**
- Interactive visual showing a **volume ramp diagram** — a simple line chart that starts at MIN and climbs to TARGET over time, with labeled axes
- Three controls:
  1. **Starting volume** — Slider from 0 to 16, default 3. Label shows macOS volume bar equivalent: `Level 3 of 16 (19%)`
  2. **Target volume** — Slider from 0 to 16, default 16. Label: `Level 16 of 16 (100%)`
  3. **Increase interval** — Stepper or segmented control: `15s / 30s / 45s / 60s`, default 30s
- Below the controls: calculated summary: *"Volume will reach maximum in approximately 6 min 30 sec if no activity is detected."*
- **Back** / **Next** buttons

---

#### Screen 5: Lock Duration
- Headline: **"How long should the alarm play?"**
- **Large number stepper** or scroll wheel for minutes, with preset quick-select buttons: `3 min` · `5 min` · `10 min` · `15 min`
- Default: `5 min` (300 seconds)
- Warning text below: "During the lock period, the alarm cannot be stopped by closing the app or pressing Ctrl+C. Only Force Quit or shutting down the Mac will stop it."
- Subtitle: "This is intentional. No snooze. Rise."
- **Back** / **Next** buttons

---

#### Screen 6: Review & Install
- Headline: **"You're all set"**
- Summary card showing all configured values:
  - 🎵 Music: `~/projects/mac-rise/music (40 tracks)`
  - ⏰ Alarm: `06:45 AM daily`
  - 🔊 Volume: `3 → 16, +1 every 30s`
  - 🔒 Lock: `5 minutes`
  - 💻 Auto-wake: `Enabled (06:44 AM)`
- **"Install & Activate"** primary button (installs LaunchAgent, configures pmset)
- Back button
- Small text: "You can change these settings anytime from the menu bar."

---

### 4. Settings Panel

Accessible from the dropdown's ⚙️ icon. Design as a **tabbed macOS preferences window** (or a single scrollable panel within the dropdown) with all configurable parameters:

| Setting | Control Type | Variable | Default | Range/Options |
|---|---|---|---|---|
| Music Directory | Folder picker + path display | `MUSIC_DIR` | `./music` | Any valid directory |
| Lock Duration | Stepper (seconds) with minute label | `LOCK_SECONDS` | `300` (5 min) | 60–1800 |
| Max Volume Level | Slider | `MAX_VOLUME_LEVEL` | `16` | 1–16 |
| Min Volume Level (Start) | Slider | `MIN_VOLUME_LEVEL` | `3` | 0–16 |
| Target Volume Level | Slider | `TARGET_VOLUME_LEVEL` | `16` | 0–16 |
| Volume Check Interval | Stepper (seconds) | `VOLUME_CHECK_SECONDS` | `0.5` | 0.1–5.0 |
| Volume Increase Interval | Segmented control | `VOLUME_INCREASE_INTERVAL` | `30` | 15, 30, 45, 60, 90 |
| Alarm Hour | Number input | `HOUR` | `6` | 0–23 |
| Alarm Minute | Number input | `MINUTE` | `45` | 0–59 |
| Auto-wake Mac | Toggle | pmset config | `On` | On/Off |
| Launch at Login | Toggle | LaunchAgent `RunAtLoad` | `Off` | On/Off |

---

### 5. Deliverables

Please generate the following screens/frames:

1. **Menu bar icon** — all 3 states (idle, active, disabled) at 1x and 2x
2. **Dropdown panel — Active/Ringing state** — showing all real-time data points
3. **Dropdown panel — Scheduled/Idle state** — showing next alarm info
4. **Onboarding Screen 1** — Welcome
5. **Onboarding Screen 2** — Music Source (with GitHub option)
6. **Onboarding Screen 3** — Alarm Time picker
7. **Onboarding Screen 4** — Volume Configuration with ramp diagram
8. **Onboarding Screen 5** — Lock Duration
9. **Onboarding Screen 6** — Review & Install
10. **Settings panel** — All parameters

---

### 6. Technical Context for the Designer

- The app replaces a bash script; all logic currently runs via `afplay` (macOS CLI audio player), `osascript` (AppleScript for volume), `ioreg` (idle time detection), and `caffeinate` (prevent sleep)
- The native app will use Swift/SwiftUI with `NSStatusItem` for the menu bar
- Music files are local MP3/M4A/AAC/WAV/AIFF/FLAC files, not streaming
- The app needs macOS permissions: Accessibility (for idle time detection), Full Disk Access or folder access (for music directory), and admin privileges (for pmset)
- There is no user account, no cloud sync, no subscription — this is a free, local-only utility

---

### All Configurable Variables Reference

| # | Variable | Purpose | Default | Type |
|---|---|---|---|---|
| 1 | `MUSIC_DIR` | Path to the folder containing alarm music files | `./music` (relative to app) | Directory path |
| 2 | `LOCK_SECONDS` | Duration the alarm plays and cannot be dismissed | `300` (5 minutes) | Integer (seconds) |
| 3 | `MAX_VOLUME_LEVEL` | Maximum macOS volume level (used for percentage calculation) | `16` | Integer (0–16) |
| 4 | `MIN_VOLUME_LEVEL` | Starting volume level when alarm begins | `3` | Integer (0–16) |
| 5 | `TARGET_VOLUME_LEVEL` | Volume level the alarm ramps up to | `16` | Integer (0–16) |
| 6 | `VOLUME_CHECK_SECONDS` | How often the script checks/enforces volume | `0.5` | Float (seconds) |
| 7 | `VOLUME_INCREASE_INTERVAL` | Time between each +1 volume level increase | `30` | Integer (seconds) |
| 8 | `HOUR` | Alarm trigger hour (24h format) | `8` | Integer (0–23) |
| 9 | `MINUTE` | Alarm trigger minute | `0` | Integer (0–59) |
| 10 | `pmset wakeorpoweron` | Whether macOS wakes from sleep before alarm | Enabled | Boolean toggle |
| 11 | `RunAtLoad` (LaunchAgent) | Whether the agent loads at login | `false` | Boolean toggle |
