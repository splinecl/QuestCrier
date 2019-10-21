print("Quest Crier @project-version@");

local debug = false;
local frame = CreateFrame("FRAME", "QuestCrierAddonFrame");

frame:RegisterEvent("UI_INFO_MESSAGE");
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

    --287 Killed quest mob/Picked up quest item
    --288 ?
    --289 Picked up quest item
    if (event == "UI_INFO_MESSAGE") then
        if(debug) then
            print("[QuestCrier arg1] " .. arg1);
            print("[QuestCrier arg2] " .. arg2);
        end

        if(isEnabled and isPlayerInParty and (arg1 == 287 or arg1 == 288 or arg1 == 289)) then
            SendChatMessage(arg2, "PARTY");
        end
    end
end
