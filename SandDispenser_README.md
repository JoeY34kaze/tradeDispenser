# SandDispenser

A robust WoW Classic Era addon for automatic Hourglass Sand trading, based on the proven WaterDispenser pattern.

## Features

- **Automatic sand trading** - Automatically fills trade window with Hourglass Sand
- **Smart slot detection** - Uses `TradeFrame_GetAvailableSlot()` for reliable placement
- **Combat safe** - Won't trade during combat lockdown
- **Configurable amount** - Trade 1 or 2 sand
- **Simple console commands** - Easy to use slash commands
- **Proven reliability** - Based on WaterDispenser's battle-tested code

## Installation

1. Download the `SandDispenser.lua` and `SandDispenser.toc` files
2. Create a folder named `SandDispenser` in `World of Warcraft\_classic_\Interface\AddOns\`
3. Place both files in the `SandDispenser` folder
4. Enable the addon in-game

## Usage

### Commands

- `/sd help` - Show all commands
- `/sd fill` - Manually fill trade window with sand
- `/sd clear` - Clear all items from trade window
- `/sd auto` - Toggle automatic filling on/off
- `/sd 1` - Set sand count to 1
- `/sd 2` - Set sand count to 2
- `/sd status` - Show current settings

### How it works

1. **Automatic Mode** (default):
   - When someone trades with you, automatically puts sand in the trade window
   - Uses smart slot detection to avoid conflicts
   - Won't trade during combat

2. **Manual Mode**:
   - Use `/sd fill` to manually add sand to an open trade window
   - Use `/sd clear` to remove all items from trade window

3. **Configuration**:
   - `/sd 1` or `/sd 2` to set how much sand to trade
   - `/sd auto` to enable/disable automatic trading
   - `/sd status` to see current settings

## Technical Details

Based on WaterDispenser's proven architecture:

- **Inventory Management** - Tracks Hourglass Sand in all bags
- **Smart Slot Detection** - Uses `TradeFrame_GetAvailableSlot()` for reliable placement
- **Combat Safety** - `InCombatLockdown()` checks prevent errors
- **Error Handling** - Robust error checking and user feedback
- **Memory Efficient** - Clears inventory data when not needed

## Requirements

- WoW Classic Era (Interface 11507)
- Hourglass Sand in your bags

## Author

Feraline@Spineshatter
Based on WaterDispenser by GPI / Erytheia-Razorfen / Junsa

## License

Free to use and modify 