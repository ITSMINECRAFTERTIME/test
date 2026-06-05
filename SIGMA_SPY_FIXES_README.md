# Sigma Spy - FIXED & WORKING BUILD 🔧

This directory contains **working fixes** for Sigma Spy (originally by depso/depthso, reupload by Dexz00).

## 🎯 What Was Fixed

The original Sigma Spy repository had a critical bug:
```
attempt to index nil with 'ForceUseCustomComm'
```

This occurred because the `Config` module could return `nil` if the file didn't exist or loaded improperly.

### Root Causes Fixed:
1. **Config Nil Error** - Config was indexed without nil checks
2. **Missing Defaults** - No fallback configuration if file loading failed
3. **Unsafe File Operations** - No checks before reading files
4. **Improper Initialization** - Modules weren't guaranteed to initialize in the right order

## 📁 Files Provided

### 1. `SigmaSpy_WORKING.lua` ⭐ **RECOMMENDED**
- **Most Complete:** Full uncompiled version with all safety checks
- **Best For:** Direct use in Roblox exploits
- **Features:**
  - Nil-safe Config initialization
  - Default configuration fallback
  - Proper error handling
  - Clean, readable code

### 2. `Sigma-Spy-Fixed.lua`
- **Alternative:** Lighter version with basic fixes
- **Features:**
  - Essential bug fixes only
  - Smaller file size
  - Core functionality preserved

### 3. Original Files (Cloned from GitHub)
- `/Sigma-Spy/` - Full repository clone
- Includes source code and templates
- Build scripts available

## 🚀 How to Use

### Option 1: Direct Loadstring (Recommended)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dexz00/Sigma-Spy/main/Main.lua"))()
```

### Option 2: Use Fixed Version
```lua
-- Copy the contents of SigmaSpy_WORKING.lua and paste into your executor
loadstring(YOUR_COPIED_CODE)()
```

### Option 3: Local File (If using workspace)
```lua
loadstring(readfile("path/to/SigmaSpy_WORKING.lua"))()
```

## ⚙️ Configuration

### Enable Custom Communication
If you're experiencing `comm library` issues, create a config file:

**Path:** `Sigma Spy/Config.lua`

```lua
return {
    ForceUseCustomComm = true,  -- Set to true if getting comm errors
    ReplaceMetaCallFunc = false,
    NoReceiveHooking = false,
    BlackListedServices = {
        "RobloxReplicatedStorage"
    },
    ForceKonstantDecompiler = false,
    
    -- UI Colors
    MethodColors = {
        ["fireserver"] = Color3.fromRGB(242, 255, 0),
        ["invokeserver"] = Color3.fromRGB(99, 86, 245),
        ["onclientevent"] = Color3.fromRGB(77, 245, 105),
        ["onclientinvoke"] = Color3.fromRGB(77, 178, 245),
        ["event"] = Color3.fromRGB(77, 245, 181),
        ["invoke"] = Color3.fromRGB(245, 77, 77),
        ["oninvoke"] = Color3.fromRGB(245, 77, 209),
        ["fire"] = Color3.fromRGB(245, 141, 77),
    }
}
```

## 🔍 What Sigma Spy Does

A complete **Remote Spy** with advanced features:
- ✅ Logs incoming and outgoing remote calls
- ✅ Supports Actor remotes
- ✅ Shows function arguments and return values
- ✅ Can block remotes from firing
- ✅ Spoof return values
- ✅ Decompile large scripts
- ✅ Variable compression in parser
- ✅ Remote stacking/grouping
- ✅ Keybinds for toggling options
- ✅ Dump logs to file

## 🛠️ Troubleshooting

### Issue: "ForceUseCustomComm" Error
**Solution:** Use `SigmaSpy_WORKING.lua` - it has proper defaults

### Issue: Config file not found
**Solution:** The fixed version includes `DefaultConfig` fallback

### Issue: Communication library errors
**Solution:** Set `ForceUseCustomComm = true` in your Config.lua

### Issue: Script times out
**Solution:** 
- Wait longer (some executors are slow)
- Check your internet connection
- Verify the GitHub URL is accessible

## 📊 Version Info

| Version | Creator | Status |
|---------|---------|--------|
| Original | depso (depthso) | ❌ Repo Deleted |
| Reupload | Dexz00 | ✅ Available |
| This Build | Fixed & Enhanced | ✅ **Working** |

## 📝 Credits

- **Original Creator:** depso (depthso)
- **Reupload:** Dexz00
- **Fixes & Working Build:** Enhanced version
- **Original Repo:** https://github.com/depthso (deleted)
- **Current Repo:** https://github.com/Dexz00/Sigma-Spy

## 📜 License

MIT License - See original repository

## ⚠️ Legal Notice

This tool is for educational purposes. Use only on games where:
1. You own/admin the game
2. You have explicit permission from the game owner
3. It complies with game terms of service

Unauthorized use may violate game terms.

## 🔗 Links

- **GitHub (Reupload):** https://github.com/Dexz00/Sigma-Spy
- **Roblox Parser:** https://github.com/depthso/Roblox-parser
- **Discord:** See original repository

---

**Status:** ✅ Fixed and Working
**Last Updated:** 2026-06-05
**Tested On:** Wave, Zenith (11/06/25 recommended)
