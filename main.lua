local isDebugEnabled = false;
local frame = CreateFrame("FRAME", "QuestCrierAddonFrame");

frame:RegisterEvent("UI_INFO_MESSAGE");
frame:RegisterEvent("ADDON_LOADED");

SLASH_QUEST_CRIER1 = "/qc";
SlashCmdList["QUEST_CRIER"] = function(msg)
    local msgNumber = tonumber(msg);

    if(msgNumber ~= nil and msgNumber >= 0) then
        throttle = tonumber(msg);
        DEFAULT_CHAT_FRAME:AddMessage("Quest Crier throttle set to "..throttle, 1.0, 1.0, 0.0);
    else
        isEnabled = not isEnabled;
        DEFAULT_CHAT_FRAME:AddMessage("Quest Crier status:"..(isEnabled and 'on' or 'off').." throttle:"..throttle, 1.0, 1.0, 0.0);
    end
end 

function eventHandler(self, event, ...)
    local arg1, arg2 = ...;

    if event == "UI_INFO_MESSAGE" then
        local isPlayerInParty = UnitInParty("player");

        printDebug("[QuestCrier arg1] " .. arg1);
        printDebug("[QuestCrier arg2] " .. arg2);
        
        --285 Scout/investigate area
        --286 ?
        --287 Killed quest mob/Picked up quest item
        --288 ?
        --289 Picked up quest item
        if(isEnabled and isPlayerInParty and (arg1 == 285 or arg1 == 286 or arg1 == 287 or arg1 == 288 or arg1 == 289)) then
            handleQuestMessage(arg2);
        end
    elseif event == "ADDON_LOADED" and arg1 == "QuestCrier" then
         --We want to default to true if this is a first time load
        if(isEnabled == nil) then
            isEnabled = true;
            printDebug("[QuestCrier Initializing isEnalbed to true]");
        end
        --We want to default to 1 in throttle if this is a first time load
        if(throttle == nil) then
            throttle = 1;
            printDebug("[QuestCrier Initializing throttle to 1]");
        end
        DEFAULT_CHAT_FRAME:AddMessage("Quest Crier @project-version@ toggle on/off using /qc, status:"..(isEnabled and 'on' or 'off').." throttle:"..throttle, 1.0, 1.0, 0.0, true);
        frame:UnregisterEvent("ADDON_LOADED");
    end

end

frame:SetScript("OnEvent", eventHandler);

function handleQuestMessage(message)
    local current, total = string.match(message, ": (%d+)/(%d+)");
    local activeThrottle = throttle;
    
    printDebug("[QuestCrier current] "..current);
    printDebug("[QuestCrier total] "..total);
    printDebug("[QuestCrier activeThrottle] "..activeThrottle);
    
    if current and total then
        -- Calulate dynamic throttling, so that we send ~4 messages
        if activeThrottle == 0 and total > 4 then
            activeThrottle = math.ceil(total / 4);
            printDebug("[QuestCrier Calculated activeThrottle] "..activeThrottle);
        end
        
        if((current % activeThrottle) == 0 or current == 1 or current == total) then
            SendChatMessage(message, "PARTY");
            printDebug("[QuestCrier Sending throttled message] "..message);
        end
    else
        SendChatMessage(message, "PARTY");
        printDebug("[QuestCrier Sending normal message] "..message);
    end
end

function printDebug(message)
    if(isDebugEnabled) then
         DEFAULT_CHAT_FRAME:AddMessage(message, 1.0, 0.0, 0.0);
    end
end
