# Guess the Country Flag Auto-Answer Script

## Features

- 🚀 **Two response modes**:
    - Instant submission (competitive play)
    - Realistic typing simulation (avoids getting suspicious by players)
- ⚙️ **Automatic game detection** - only activates during rounds
- 🔁 **Self-recovering** - restarts automatically after each game
- 📡 **Remote updating** - flag database updates without script changes

## Installation & Usage

1. **Requires a Roblox executor** (Known ones: Arceus X, Fluxus, Ronix, Delta, etc.)
2. Copy this code into your executor:
```lua
instantSubmit = false -- Set to true for instant answers
loadstring(game:HttpGet("https://raw.githubusercontent.com/babyoutrhy/RLua/main/Guess-the-Country-Flag/src.lua", true))()
```
3. **Configuration**:
   - `instantSubmit = true`: Answers immediately (0.1s response)
   - `instantSubmit = false`: Realistic typing with some fake typos (1.5-5s response)

## Country Database

The script uses [this flag database](https://raw.githubusercontent.com/babyoutrhy/RLua/main/Guess-the-Country-Flag/Country-Flags-List.lua)

## What NOT To Do

⚠️ **Avoid These Actions While Script is Running**:
- Manually typing in the answer box (will not continue/type letters all together))
- Clicking away from the answer box (will stop typing)
- Pressing Escape during typing (will stop typing)
- Switching windows/tabs during gameplay (not sure about this, but recommended avoiding)

❌ **Script Will NOT Work**:
- On an external executor (come on, this is obvious: it's a client script and not a macro)
- With game UI modifications
- When flag images are not in the database
