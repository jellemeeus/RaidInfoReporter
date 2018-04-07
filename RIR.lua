local RIR = CreateFrame("Frame")
local InstanceShortNamesDungeons = {["Utgarde Keep"] = "UK", ["The Nexus"] = "Nexus", ["Azjol-Nerub"] = "AN", ["Ahn'kahet: The Old Kingdom"] = "AK:TOK", ["Drak'Tharon Keep"] = "DTK", ["The Violet Hold"] = "VH", ["Gundrak"] = "GD", ["Halls of Stone"] = "HoS", ["Halls of Lightning"] = "HoL", ["Utgarde Pinnacle"] = "UP", ["The Oculus"] = "Oculus", ["Crusaders' Coliseum: Trial of the Champion"] = "TOC", ["The Culling of Stratholme"] = "CoS", ["Pit of Saron"] = "PoS", ["The Forge of Souls"] = "FoS", ["Halls of Reflection"] = "HoS"}
local InstanceShortNamesRaids = {["Icecrown Citadel"] = "ICC", ["Vault of Archavon"] = "VOA", ["Trial of the Crusader"] = "TOC", ["Naxxramas"] = "NAXX", ["The Ruby Sanctum"] = "RS", ["The Obsidian Sanctum"] = "OS", ["The Eye of Eternity"] = "EoE", ["Ulduar"] = "Ulduar"}
local RaidDifficulty = {[1] = "10",[2] = "25",[3] = "10h",[4] = "25h"}

local function ReportLocks(cmd, args, Player)
  local Locks = {}
  local isReportRaid
  local isReportHC
  Player = player or UnitName("player")

  if cmd == "hc" then
    isReportRaid = false
    isReportHC = true
  elseif cmd == "raid" then
    isReportHC = false  
    isReportRaid = true  
  elseif cmd == "any" then
    isReportRaid = true
    isReportHC = true
  else 
    print("usage: /rir [hc, raid, any] [guild, party, raid, test]")
    do return end  
  end

  for i=1,GetNumSavedInstances() do
    local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)
    if isRaid and isReportRaid then
      table.insert(Locks, string.format("%s%s (%i)", InstanceShortNamesRaids[name], RaidDifficulty[difficulty], id))
    elseif difficulty == 2 and not isRaid and isReportHC then
      table.insert(Locks, string.format("%s", InstanceShortNamesDungeons[name]))
    end    
  end

  if args == "guild" then
    if #Locks > 0 then
      SendChatMessage(string.format("Locks for " .. cmd .. " : %s",table.concat(Locks,", ")),"GUILD")
    else
      SendChatMessage("No locks for " .. cmd, "GUILD", "Common")
    end  
  elseif args == "party" then
    if #Locks > 0 then
      SendChatMessage(string.format("Locks for " .. cmd .. " : %s",table.concat(Locks,", ")),"PARTY")
    else
      SendChatMessage("No locks for " .. cmd, "PARTY", "Common")
    end 
 elseif args == "raid" then
    if #Locks > 0 then
      SendChatMessage(string.format("Locks for " .. cmd .. " : %s",table.concat(Locks,", ")),"RAID")
    else
      SendChatMessage("No locks for " .. cmd, "RAID", "Common")
    end 
  elseif args == "w" or args == "test" then
    if #Locks > 0 then
        SendChatMessage(string.format("Locks for " .. cmd .. " : %s",table.concat(Locks,", ")), "WHISPER", nil, Player)
    else
        SendChatMessage("No locks for " .. cmd, "WHISPER", "Common", UPlayer)
    end
  else
    print("usage: /rir [hc, raid, any] [guild, party, test]")
    do return end  
  end
end

RIR:RegisterEvent("CHAT_MSG_WHISPER")
RIR:SetScript("OnEvent", 
  function(self, event, Message, Player)
    if event == "CHAT_MSG_WHISPER" then
      Message = strlower(Message)
    if Message == "raidlocks" or Message == "raid locks" then
      ReportLocks("raid", "w", Player)
    elseif Message == "hclocks" or Message == "hc locks" then
      ReportLocks("hc", "w", Player)
    elseif Message == "locks" or Message == "saved" or Message == "saved?" then
      ReportLocks("any", "w", Player)
    end
  end
end)

local function MyAddonCommands(msg, editbox)
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  ReportLocks(cmd, args)  
end

SLASH_RIR1, SLASH_RIR2 = '/rir', '/locks'
SlashCmdList["RIR"] = MyAddonCommands   
