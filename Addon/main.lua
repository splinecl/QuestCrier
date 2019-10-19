print("Quest Cryer");

local frame = CreateFrame("FRAME", "FooAddonFrame");
frame:RegisterEvent("UI_INFO_MESSAGE");

function eventHandler(self, event, ...)
    local arg1, arg2 = ...;
    print("eventHandler called");

    if (event == "UI_INFO_MESSAGE") then
        SendChatMessage(arg2, "PARTY");
    end
end

frame:SetScript("OnEvent", eventHandler);