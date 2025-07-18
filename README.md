# autoTradeSand

A robust WoW Classic Era addon for automatic Hourglass Sand trading, based on the proven WaterDispenser pattern.

## Features

- **Automatic sand trading** - Automatically fills trade window with Hourglass Sand
- **Smart slot detection** - Uses `TradeFrame_GetAvailableSlot()` for reliable placement
- **Combat safe** - Won't trade during combat lockdown
- **Configurable amount** - Trade 1 or 2 sand
- **Simple console commands** - Easy to use slash commands
- **Proven reliability** - Based on WaterDispenser's battle-tested code

## Installation

1. Download the `autoTradeSand.lua` and `autoTradeSand.toc` files
2. Create a folder named `autoTradeSand` in `World of Warcraft\_classic_\Interface\AddOns\`
3. Place both files in the `autoTradeSand` folder
4. Enable the addon in-game

**Folder structure should be:**
```
World of Warcraft\_classic_\Interface\AddOns\autoTradeSand\
├── autoTradeSand.lua
└── autoTradeSand.toc
```

## Usage

### Commands

- `/ats help` - Show all commands
- `/ats fill` - Manually fill trade window with sand
- `/ats clear` - Clear all items from trade window
- `/ats auto` - Toggle automatic filling on/off
- `/ats 1` - Set sand count to 1
- `/ats 2` - Set sand count to 2
- `/ats status` - Show current settings

### How it works

1. **Automatic Mode** (default):
   - When someone trades with you, automatically puts sand in the trade window
   - Uses smart slot detection to avoid conflicts
   - Won't trade during combat

2. **Manual Mode**:
   - Use `/ats fill` to manually add sand to an open trade window
   - Use `/ats clear` to remove all items from trade window

3. **Configuration**:
   - `/ats 1` or `/ats 2` to set how much sand to trade
   - `/ats auto` to enable/disable automatic trading
   - `/ats status` to see current settings

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