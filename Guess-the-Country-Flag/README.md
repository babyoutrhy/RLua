# Guess the Country Flag Auto-Answer Script

## Features
- Instant submission (competitive play)
- ⚙️ **Automatic game detection** - only activates during rounds
- 🔁 **Self-recovering** - restarts automatically after each game
- 📡 **Remote updating** - flag database updates without script changes

## Installation & Usage

1. **Requires a Roblox executor** (Known ones: Arceus X, Fluxus, Ronix, Delta, etc.)
2. Copy this code into your executor:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/babyoutrhy/RLua/main/Guess-the-Country-Flag/src.lua", true))()
```


## Country Database

The script uses [this flag database](https://raw.githubusercontent.com/babyoutrhy/RLua/main/Guess-the-Country-Flag/Country-Flags-List.lua)

## What NOT To Do

⚠️ **Avoid These Actions While Script is Running**:
- Manually typing in the answer box (will not continue/will type scribbled letters)
- Clicking away from the answer box (will stop typing)
- Pressing Escape during typing (will stop typing)
- Switching windows/tabs during gameplay (not sure about this, but recommended avoiding)

❌ **Script Will NOT Work**:
- On an external executor (come on, this is obvious: it's a client script and not a macro)
- With game UI modifications
- When flag images are not in the database
