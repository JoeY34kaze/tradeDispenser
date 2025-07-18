# autoTradeSand

A minimal WoW Classic addon that automatically trades Hourglass Sand when someone opens a trade window with you.

## Features

- **Simple console commands** - No GUI needed
- **Automatic sand trading** - Just enable and forget
- **Manual trading** - Use `/ats trade` when you start a trade
- **Configurable amount** - Trade 1 or 2 sand
- **Lightweight** - Only 2 files, minimal code
- **Vanilla Classic compatible** - Works on Classic Era servers

## Installation

1. Download the `autoTradeSand` folder
2. Copy it to `World of Warcraft\_classic_\Interface\AddOns\`
3. Enable the addon in-game

## Usage

### Commands

- `/ats start` - Enable automatic trading of 1 sand
- `/ats 2` - Enable automatic trading of 2 sand  
- `/ats stop` - Disable automatic trading
- `/ats trade` - Manually trade sand (if trade window is open)
- `/ats status` - Show current status

### How it works

**Automatic Mode:**
1. Type `/ats start` or `/ats 2` to enable
2. When someone trades with you, it automatically puts sand in the trade window

**Manual Mode:**
1. Start a trade with someone (or have them trade you)
2. Type `/ats trade` to manually put sand in the trade window

## Requirements

- WoW Classic (Vanilla)
- Hourglass Sand in your bags

## Author

Feraline@Spineshatter

## License

Free to use and modify