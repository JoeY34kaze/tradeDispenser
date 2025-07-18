-- autoTradeSand - Minimal sand trading addon
-- Author: Feraline@Spineshatter
-- Based on working WaterDispenser pattern

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
        print("|cFFFFFF00Trade window opened - autoTradeSand triggered|r")
        -- Simple delay then trade
        C_Timer.After(0.2, function()
            SimpleTradeSand()
        end)
    end
end)

function SimpleTradeSand()
    if not ATS_Config.enabled then 
        print("|cFFFF0000SimpleTradeSand: Not enabled|r")
        return 
    end
    
    print("|cFFFFFF00Searching for Hourglass Sand...|r")
    
    -- Find Hourglass Sand in bags
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink and string.find(itemLink, "Hourglass Sand") then
                print("|cFF00FF00Found Hourglass Sand in bag " .. bag .. " slot " .. slot .. "|r")
                local _, itemCount = GetContainerItemInfo(bag, slot)
                print("|cFFFFFF00Item count: " .. itemCount .. "|r")
                
                if itemCount >= ATS_Config.sandCount then
                    print("|cFF00FF00Attempting to trade " .. ATS_Config.sandCount .. " sand...|r")
                    
                    -- Simple approach: just pick up and click
                    PickupContainerItem(bag, slot)
                    
                    -- Wait a moment then click trade button
                    C_Timer.After(0.1, function()
                        if CursorHasItem() then
                            print("|cFF00FF00Item on cursor, clicking trade button...|r")
                            ClickTradeButton(1)
                            print("|cFF00FF00Successfully traded " .. ATS_Config.sandCount .. " Hourglass Sand|r")
                        else
                            print("|cFFFF0000Item not on cursor, trying again...|r")
                            -- Try one more time
                            C_Timer.After(0.1, function()
                                PickupContainerItem(bag, slot)
                                C_Timer.After(0.1, function()
                                    if CursorHasItem() then
                                        ClickTradeButton(1)
                                        print("|cFF00FF00Successfully traded " .. ATS_Config.sandCount .. " Hourglass Sand (retry)|r")
                                    else
                                        print("|cFFFF0000Failed to pick up Hourglass Sand|r")
                                    end
                                end)
                            end)
                        end
                    end)
                    return
                else
                    print("|cFFFF0000Not enough sand (need " .. ATS_Config.sandCount .. ", have " .. itemCount .. ")|r")
                end
            end
        end
    end
    
    print("|cFFFF0000No Hourglass Sand found in bags!|r")
end

-- Manual trade function
function ManualTradeSand()
    if not TradeFrame:IsVisible() then
        print("|cFFFF0000Trade window is not open!|r")
        return
    end
    
    print("|cFFFFFF00Manual trade: Searching for Hourglass Sand...|r")
    
    -- Find Hourglass Sand in bags
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink and string.find(itemLink, "Hourglass Sand") then
                print("|cFF00FF00Manual trade: Found Hourglass Sand!|r")
                local _, itemCount = GetContainerItemInfo(bag, slot)
                if itemCount >= ATS_Config.sandCount then
                    print("|cFF00FF00Manual trade: Picking up sand...|r")
                    -- Pick up the sand
                    PickupContainerItem(bag, slot)
                    
                    -- Wait a moment then click trade button
                    C_Timer.After(0.1, function()
                        if CursorHasItem() then
                            print("|cFF00FF00Manual trade: Item on cursor, clicking trade button...|r")
                            ClickTradeButton(1)
                            print("|cFF00FF00Manually traded " .. ATS_Config.sandCount .. " Hourglass Sand|r")
                        else
                            print("|cFFFF0000Manual trade: Failed to pick up Hourglass Sand|r")
                        end
                    end)
                    return
                else
                    print("|cFFFF0000Manual trade: Not enough sand (need " .. ATS_Config.sandCount .. ", have " .. itemCount .. ")|r")
                end
            end
        end
    end
    
    print("|cFFFF0000Manual trade: No Hourglass Sand found in bags!|r")
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
    elseif command == "trade" then
        -- Manual trade command - works even if auto is disabled
        ManualTradeSand()
    elseif command == "debug" then
        -- Debug command to check what's in bags
        print("|cFFFFFF00=== DEBUG: Checking bags for Hourglass Sand ===|r")
        local found = false
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local itemLink = GetContainerItemLink(bag, slot)
                if itemLink and string.find(itemLink, "Hourglass Sand") then
                    local _, itemCount = GetContainerItemInfo(bag, slot)
                    print("|cFF00FF00Found Hourglass Sand in bag " .. bag .. " slot " .. slot .. " (count: " .. itemCount .. ")|r")
                    found = true
                end
            end
        end
        if not found then
            print("|cFFFF0000No Hourglass Sand found in any bags!|r")
        end
        print("|cFFFFFF00=== END DEBUG ===|r")
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
        print("|cFFFFFF00/ats trade|r - Manually trade sand (if window is open)")
        print("|cFFFFFF00/ats debug|r - Check bags for Hourglass Sand")
        print("|cFFFFFF00/ats status|r - Show current status")
    end
end 