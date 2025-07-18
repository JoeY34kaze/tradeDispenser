-- autoTradeSand - Minimal sand trading addon
-- Author: Feraline@Spineshatter

local ATS_Config = ATS_Config or {
    enabled = false,
    sandCount = 1
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("TRADE_SHOW")
frame:RegisterEvent("VARIABLES_LOADED")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "VARIABLES_LOADED" then
        print("|cFF00FF00autoTradeSand loaded! Use /ats start or /ats 2|r")
    elseif event == "TRADE_SHOW" and ATS_Config.enabled then
        C_Timer.After(0.1, function()
            TradeSand()
        end)
    end
end)

function TradeSand()
    if not ATS_Config.enabled then return end
    
    -- Find Hourglass Sand in bags
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink and string.find(itemLink, "Hourglass Sand") then
                local _, itemCount = GetContainerItemInfo(bag, slot)
                if itemCount >= ATS_Config.sandCount then
                    -- Pick up the sand
                    PickupContainerItem(bag, slot)
                    
                    -- If we need to split the stack
                    if itemCount > ATS_Config.sandCount then
                        SplitContainerItem(bag, slot, ATS_Config.sandCount)
                    end
                    
                    -- Put it in the first trade slot
                    ClickTradeButton(1)
                    print("|cFF00FF00Traded " .. ATS_Config.sandCount .. " Hourglass Sand|r")
                    return
                end
            end
        end
    end
    
    print("|cFFFF0000No Hourglass Sand found in bags!|r")
end

-- Slash commands
SLASH_AUTOTRADESAND1 = "/ats"
SLASH_AUTOTRADESAND2 = "/autotradesand"

SlashCmdList["AUTOTRADESAND"] = function(msg)
    local command = string.lower(msg)
    
    if command == "start" or command == "1" then
        ATS_Config.enabled = true
        ATS_Config.sandCount = 1
        print("|cFF00FF00autoTradeSand enabled! Will trade 1 sand.|r")
    elseif command == "2" then
        ATS_Config.enabled = true
        ATS_Config.sandCount = 2
        print("|cFF00FF00autoTradeSand enabled! Will trade 2 sand.|r")
    elseif command == "stop" or command == "off" then
        ATS_Config.enabled = false
        print("|cFFFF0000autoTradeSand disabled!|r")
    elseif command == "status" then
        if ATS_Config.enabled then
            print("|cFF00FF00autoTradeSand is enabled. Will trade " .. ATS_Config.sandCount .. " sand.|r")
        else
            print("|cFFFF0000autoTradeSand is disabled.|r")
        end
    else
        print("|cFFFFFF00autoTradeSand commands:|r")
        print("|cFFFFFF00/ats start|r - Enable trading 1 sand")
        print("|cFFFFFF00/ats 2|r - Enable trading 2 sand")
        print("|cFFFFFF00/ats stop|r - Disable trading")
        print("|cFFFFFF00/ats status|r - Show current status")
    end
end 