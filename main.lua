local isDebugEnabled = false;
local frame = CreateFrame("FRAME", "QuestCrierAddonFrame");

frame:RegisterEvent("UI_INFO_MESSAGE");
frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", eventHandler);

SLASH_QUEST_CRIER1 = "/qc"
SlashCmdList["QUEST_CRIER"] = function(msg)
    isEnabled = not isEnabled;
    if(isEnabled) then
        print("Quest Crier on");
    else
        print("Quest Crier off"); 
    end
end 

function eventHandler(self, event, ...)
    local arg1, arg2 = ...;
    local isPlayerInParty = UnitInParty("player");

    if(event == "ADDON_LOADED") then
         --We want to default to true if this is a first time load
        if(isEnabled == nil) then
            printDebug("First time load");
            isEnabled = true;
        end
        print("Quest Crier @project-version@ toggle on/off using /gc");
    end
    
    if (event == "UI_INFO_MESSAGE") then
        printDebug("[QuestCrier arg1] " .. arg1);
        printDebug("[QuestCrier arg2] " .. arg2);
        
        --285 Scout/investigate area
        --286 ?
        --287 Killed quest mob/Picked up quest item
        --288 ?
        --289 Picked up quest item
        if(isEnabled and isPlayerInParty and (arg1 == 287 or arg1 == 288 or arg1 == 289)) then
            SendChatMessage(arg2, "PARTY");
        end
    end
end

function printDebug(message)
    if(isDebugEnabled) then
        print(message);
    end
end
