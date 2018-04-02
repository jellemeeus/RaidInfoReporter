local InstanceShortNamesDungeons = {["Utgarde Keep"] = "UK", ["The Nexus"] = "Nexus", ["Azjol-Nerub"] = "AN", ["Ahn'kahet: The Old Kingdom"] = "AK:TOK", ["Drak'Tharon Keep"] = "DTK", ["The Violet Hold"] = "VH", ["Gundrak"] = "GD", ["Halls of Stone"] = "HoS", ["Halls of Lightning"] = "HoL", ["Utgarde Pinnacle"] = "UP", ["The Oculus"] = "Oculus", ["Crusaders' Coliseum: Trial of the Champion"] = "TOC", ["The Culling of Stratholme"] = "CoS", ["Pit of Saron"] = "PoS", ["The Forge of Souls"] = "FoS", ["Halls of Reflection"] = "HoS"}
local InstanceShortNamesRaids = {["Icecrown Citadel"] = "ICC", ["Vault of Archavon"] = "VOA", ["Trial of the Crusader"] = "TOC", ["Naxxramas"] = "NAXX", ["The Ruby Sanctum"] = "RS", ["The Obsidian Sanctum"] = "OS"}

local RaidDifficulty = {[1] = "10n",[2] = "25n",[3] = "10h",[4] = "25h"}


local function MyAddonCommands(msg, editbox)
  -- pattern matching that skips leading whitespace and whitespace between cmd and args
  -- any whitespace at end of args is retained
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  local Locks = {}
  local isReportRaid = true
  local isReportHC = true
   
  if cmd == "hc" then
    --print("hc")
    isReportRaid = false
  elseif cmd == "raid" then
    --print("raid")
    isReportHC = false
    -- Handle removing of the contents of rest... to something.   
  elseif cmd == "any" then
    --print("any")       
  else
    print("usage: /rir [hc, raid, any] [guild, party, test]")
    do return end  
  end

  for i=1,GetNumSavedInstances() do
    local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)
    if isRaid and isReportRaid then
      table.insert(Locks, string.format("%s %s", InstanceShortNamesRaids[name], RaidDifficulty[difficulty]))
    elseif difficulty == 2 and not isRaid and isReportHC then
      table.insert(Locks, string.format("%s", InstanceShortNamesDungeons[name]))
    end    
  end

  if args == "guild" then
    --print("to guild") 
    if #Locks > 0 then
      SendChatMessage(string.format("Locks for " .. cmd .. " : %s",table.concat(Locks,", ")),"GUILD")
    else
      SendChatMessage("No locks for " .. cmd, "GUILD", "Common")
    end  
  elseif args == "party" then
    --print("to party") 
    if #Locks > 0 then
      SendChatMessage(string.format("Locks for " .. cmd .. " : %s",table.concat(Locks,", ")),"PARTY")
    else
      SendChatMessage("No locks for " .. cmd, "PARTY", "Common")
    end 
  elseif args == "test" then
    --print("default: to whisper self")   
    if #Locks > 0 then
        SendChatMessage(string.format("Locks for " .. cmd .. " : %s",table.concat(Locks,", ")), "WHISPER", nil, UnitName("player"))
    else
        SendChatMessage("No locks for " .. cmd, "WHISPER", "Common", UnitName("player"))
    end
  else
    print("usage: /rir [hc, raid, any] [guild, party, test]")
    do return end  
  end
end

SLASH_RIR1, SLASH_RIR2 = '/rir', '/locks'
SlashCmdList["RIR"] = MyAddonCommands   -- add /hiw and /hellow to command list
