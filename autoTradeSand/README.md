# autoTradeSand

A minimal WoW Classic Era addon that automatically trades Hourglass Sand when someone opens a trade window with you.

## Features

- **Simple console commands** - No GUI needed
- **Automatic sand trading** - Just enable and forget
- **Configurable amount** - Trade 1 or 2 sand
- **Lightweight** - Only 2 files, minimal code
- **Combat safe** - Won't trade during combat lockdown
- **Smart slot management** - Uses available trade slots automatically
- **Enhanced reliability** - Based on proven WaterDispenser pattern

## Installation

1. Download the `autoTradeSand` folder
2. Copy it to `World of Warcraft\_classic_\Interface\AddOns\`
3. Enable the addon in-game

## Usage

### Commands

- `/ats start` - Enable trading 1 sand
- `/ats 2` - Enable trading 2 sand  
- `/ats stop` - Disable trading
- `/ats trade` - Manually trade sand (if window is open)
- `/ats clear` - Clear all items from trade window
- `/ats debug` - Check bags for Hourglass Sand and trade window status
- `/ats status` - Show current status

### How it works

1. Type `/ats start` or `/ats 2` to enable
2. When someone trades with you, it automatically puts sand in the trade window
3. Uses smart slot detection to avoid conflicts with other items
4. Won't trade during combat for safety
5. That's it!

## Technical Improvements

Based on the proven WaterDispenser addon pattern:

- **`TradeFrame_GetAvailableSlot()`** - Automatically finds the next available trade slot
- **Combat checks** - Prevents trading during combat lockdown
- **Cursor management** - Properly clears cursor before picking up items
- **Error handling** - Better detection of trade window state
- **Debug features** - Enhanced debugging with trade window status

## Requirements

- WoW Classic Era
- Hourglass Sand in your bags

## Author

Feraline@Spineshatter

## License

Free to use and modify