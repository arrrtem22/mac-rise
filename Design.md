# MacRise — Design Specification for Stitch AI

## App Overview

MacRise is a macOS menu bar alarm clock app. It wakes users up by playing motivational music at a scheduled time, gradually increasing system volume until activity is detected, then locks playback for a set duration so it cannot be dismissed. The app lives in the macOS top menu bar with no Dock icon and no main window. All interaction happens through a dropdown panel from the menu bar icon and a multi-step onboarding flow on first launch.

**App name**: MacRise
**Tagline**: "No snooze. No escape. Rise."
**Platform**: Native macOS menu bar app (Swift/SwiftUI, NSStatusItem)

---

## Design Style

Follow the exact design language of the **LookAway — Break Reminder** macOS app:

**Menu bar dropdown panel:**
- Dark frosted-glass panel with native macOS vibrancy/blur, ~320pt wide, generously rounded corners (~16pt)
- Segmented control at top for tab switching — pill-shaped, subtle gray fill on the active tab
- Small gear icon (⚙️) top-right for settings
- Large, bold hero countdown number centered (SF Pro Rounded, heavy weight, white)
- Small SF Symbol icon and muted gray subtitle above the countdown
- Horizontal row of pill-shaped action buttons below — one primary (filled lighter gray), rest secondary (outlined, dark fill)
- Info rows at the bottom as rounded rectangle cards (~#2A2A2A fill on ~#1A1A1A background), each with a colored icon left, white label, right-aligned value

**Onboarding window:**
- Centered macOS window (~720×480pt), rounded corners, traffic light buttons top-left, no toolbar
- Very dark near-black background (#0D0D0D–#1A1A1A) with atmospheric gradient glows bleeding softly from corners — cinematic, moody
- Subtle particle/grain texture in background
- Welcome screen: large centered app icon, centered headline (~28pt SF Pro Display), single understated pill button at bottom
- Config screens: centered icon at top, headline, side-by-side rounded rectangle cards with bold title, muted description, and 2×2 selectable pill buttons inside. Selected = accent color border + checkmark. Unselected = dark fill, no border
- Navigation: "Back" pill bottom-left, dot indicators centered, "Next" pill bottom-right

---

## Color Palette — "Twilight Ember"

Chosen from 2025–2026 trending dark UI palettes. Combines deep warm charcoal with a sunrise-inspired amber-to-coral gradient accent — evoking dawn, energy, and waking up. This replaces LookAway's pink/magenta with a warm palette that matches the alarm/sunrise theme.

### Core Colors

| Role | Color | Hex | Usage |
|---|---|---|---|
| **Background** | Deep Charcoal | `#0D0D0D` | Main window and panel backgrounds |
| **Surface** | Warm Dark Gray | `#1C1C1E` | Panel fill, dropdown body |
| **Elevated Surface** | Soft Charcoal | `#2A2A2C` | Cards, info rows, input fields |
| **Border / Divider** | Subtle Gray | `#3A3A3C` | Card borders, separators (very subtle) |

### Text Colors

| Role | Color | Hex |
|---|---|---|
| **Primary Text** | Off-White | `#E5E5E7` |
| **Secondary Text** | Muted Gray | `#8E8E93` |
| **Tertiary / Hint** | Dim Gray | `#636366` |

### Accent Colors

| Role | Color | Hex | Usage |
|---|---|---|---|
| **Primary Accent** | Warm Amber | `#FF9F0A` | Selected borders, active toggle, progress bars, alarm-active icon glow |
| **Secondary Accent** | Soft Coral | `#FF6B6B` | Hover states, secondary highlights, destructive/warning hints |
| **Gradient Start** | Deep Amber | `#FF9F0A` | Onboarding atmospheric glow (top-right, ~15% opacity) |
| **Gradient End** | Twilight Indigo | `#1B1464` | Onboarding atmospheric glow (bottom-left, ~15% opacity) |
| **Success** | Soft Green | `#30D158` | Confirmation states (e.g., "40 tracks found ✅") |

### Gradient Usage

- **Onboarding background glow**: Deep amber (#FF9F0A at 12–15% opacity) radiating from top-right corner, twilight indigo (#1B1464 at 12–15% opacity) from bottom-left — creates a warm dawn-like ambiance
- **Active alarm indicator**: Subtle #FF9F0A to #FF6B6B gradient on progress bars and the ringing status badge
- **Buttons (primary CTA)**: Solid #FF9F0A fill with white text for primary actions like "Install & Activate"

---

## Screen 1 — Menu Bar Icon

Design 3 states of a 16×16pt SF Symbol-style menu bar icon:

| State | Visual | Indicator |
|---|---|---|
| **Idle** (alarm scheduled) | Sunrise/alarm bell outline | No extra indicator |
| **Active** (alarm ringing) | Filled sunrise/alarm bell | Pulsing amber (#FF9F0A) dot |
| **Disabled** (no alarm set) | Dimmed gray icon | None |

When active, the menu bar can also show a countdown like "4:32" next to the icon in a pill-shaped badge (similar to how LookAway shows "12m").

---

## Screen 2 — Dropdown Panel: Ringing State

The panel the user sees when they click the menu bar icon while the alarm is actively playing. This is the most important screen.

**Layout (top to bottom):**

1. **Header**: Segmented control — "Status" (active) / "Settings" tabs. Gear icon top-right.
2. **Hero section**: SF Symbol alarm icon, muted label "Alarm ends in", large bold countdown **"4:32"** in white
3. **Action buttons row**: "Stop" (primary, amber filled — only works after lock expires), "+1m", "+5m" (secondary, outlined pills)
4. **Info cards** (rounded rectangle rows, #2A2A2C fill):
   - 🎵 **Now Playing** → `DAVID_GOGGINS_GYM_MOT…` (with thin progress bar below, amber color)
   - 🔊 **Volume** → `Level 5 / 16` (with segmented volume bar visualization)
   - ⏱️ **Next increase** → `in 18 seconds`
   - 👁️ **Activity** → `No movement detected` or `✅ Movement detected — volume locked`

---

## Screen 3 — Dropdown Panel: Scheduled/Idle State

The panel shown when no alarm is currently ringing.

**Layout:**

1. **Header**: Same segmented control + gear icon
2. **Hero section**: Alarm icon, label "Next alarm", large bold **"06:45 AM"**
3. **Info cards**:
   - 🎵 **Music** → `~/mac-rise/music (40 tracks)`
   - 🔒 **Lock duration** → `5 minutes`
   - 🔊 **Volume** → `3 → 16, +1 every 30s`
   - 💻 **Auto-wake** → `Enabled (06:44 AM) ✅`
4. **Footer**: "Test Alarm" button (outlined pill), "Quit MacRise" (text link, muted)

---

## Screen 4 — Onboarding: Welcome

- Dark background with atmospheric gradient glow (amber top-right, indigo bottom-left, subtle grain)
- Large centered MacRise app icon (rounded square, sunrise/alarm motif in amber-to-coral gradient on dark background)
- Headline: **"Rise. No excuses."**
- Subtext: "MacRise wakes you up with motivational music and won't let you go back to sleep."
- Single **"Get Started"** pill button at bottom (outlined, understated)
- Traffic light buttons top-left

---

## Screen 5 — Onboarding: Music Source

- Same dark background + gradient
- Centered music note icon (amber)
- Headline: **"Choose your alarm music"**
- Three selectable cards (rounded rectangles, side by side or stacked):
  1. **Download from GitHub** — "Get the default motivational music pack" with GitHub icon and URL `github.com/arrrtem22/mac-rise-music`. Selected = amber border + ✓
  2. **Choose a folder** — "Select any folder with MP3, M4A, AAC, WAV, AIFF, or FLAC files" with folder picker button
  3. **Use default location** — "Place files in `~/mac-rise/music/`"
- Validation feedback: "✅ 40 tracks found" in green (#30D158)
- Small info text: "Supported formats: MP3, M4A, AAC, WAV, AIFF, FLAC"
- Navigation: Back (left), dots (center), Next (right)

---

## Screen 6 — Onboarding: Alarm Time

- Centered clock icon (amber)
- Headline: **"When should MacRise wake you?"**
- Native-style time picker (scroll wheels or large digital input) for Hour and Minute, default 06:45
- Toggle row: **"Wake Mac from sleep automatically"** — on by default, amber toggle color
- Helper text: "Your Mac will wake 1 minute before the alarm. Requires admin permission."
- Navigation: Back, dots, Next

---

## Screen 7 — Onboarding: Volume Configuration

- Centered speaker icon (amber)
- Headline: **"Set volume behavior"**
- Two side-by-side cards (like LookAway's "Time between breaks" / "Break length" layout):
  - **Starting volume** card: 2×2 pill buttons — `1` / `3 ✓` / `5` / `8`, default Level 3
  - **Target volume** card: 2×2 pill buttons — `10` / `12` / `14` / `16 ✓`, default Level 16
- Below cards: **Increase interval** — single row of pills: `15s` / `30s ✓` / `45s` / `60s`
- Calculated summary: "Volume reaches max in ~6 min 30 sec if no activity detected"
- Navigation: Back, dots, Next

---

## Screen 8 — Onboarding: Lock Duration

- Centered lock icon (amber)
- Headline: **"How long should the alarm play?"**
- 2×2 grid of large selectable pill buttons: `3 min` / `5 min ✓` / `10 min` / `15 min`
- Warning card below (slightly different background): "During the lock period, the alarm cannot be stopped. Only Force Quit or shutting down the Mac will stop it."
- Motivational subtitle: "This is intentional. No snooze. Rise."
- Navigation: Back, dots, Next

---

## Screen 9 — Onboarding: Review & Install

- Centered checkmark icon (green #30D158)
- Headline: **"You're all set"**
- Summary card (rounded rectangle, elevated surface) listing all configured values:
  - 🎵 Music: `~/mac-rise/music (40 tracks)`
  - ⏰ Alarm: `06:45 AM daily`
  - 🔊 Volume: `3 → 16, +1 every 30s`
  - 🔒 Lock: `5 minutes`
  - 💻 Auto-wake: `Enabled (06:44 AM)`
- Primary CTA: **"Install & Activate"** — amber filled pill button (#FF9F0A with white text)
- Helper text: "You can change these anytime from the menu bar."
- Back button (outlined)

---

## Screen 10 — Settings Panel

Accessible from gear icon in dropdown. Either a tabbed macOS preferences window or an expanded panel within the dropdown.

| Setting | Control | Default |
|---|---|---|
| Music Directory | Folder picker + path display | `./music` |
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
| 2 | `LOCK_SECONDS` | Locked play duration (cannot dismiss) | `300` (5 min) | Integer (seconds) |
| 3 | `MAX_VOLUME_LEVEL` | Max macOS volume level | `16` | Integer (0–16) |
| 4 | `MIN_VOLUME_LEVEL` | Starting volume when alarm begins | `3` | Integer (0–16) |
| 5 | `TARGET_VOLUME_LEVEL` | Volume the alarm ramps up to | `16` | Integer (0–16) |
| 6 | `VOLUME_CHECK_SECONDS` | How often volume is checked/enforced | `0.5` | Float (seconds) |
| 7 | `VOLUME_INCREASE_INTERVAL` | Time between each +1 volume increase | `30` | Integer (seconds) |
| 8 | `HOUR` | Alarm hour (24h format) | `8` | Integer (0–23) |
| 9 | `MINUTE` | Alarm minute | `0` | Integer (0–59) |
| 10 | `pmset wakeorpoweron` | Wake Mac from sleep before alarm | Enabled | Boolean |
| 11 | `RunAtLoad` | Launch at login | `false` | Boolean |

---

## Technical Notes

- Native macOS app using Swift/SwiftUI with `NSStatusItem` for menu bar
- Local-only, no accounts, no cloud, no subscription — free utility
- Music files are local (MP3, M4A, AAC, WAV, AIFF, FLAC), not streamed
- Required permissions: Accessibility (idle detection), folder access (music directory), admin (pmset)
- Replaces a bash script using `afplay`, `osascript`, `ioreg`, `caffeinate`
