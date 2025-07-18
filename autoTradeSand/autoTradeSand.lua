-- autoTradeSand - Minimal sand trading addon
-- Author: Feraline@Spineshatter

local ATS_Config = ATS_Config or {
    enabled = false,
    sandCount = 1
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("TRADE_SHOW")
frame:RegisterEvent("VARIABLES_LOADED")

local tradeState = nil
local tradeData = {}

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "VARIABLES_LOADED" then
        print("|cFF00FF00autoTradeSand loaded! Use /ats start or /ats 2|r")
    elseif event == "TRADE_SHOW" and ATS_Config.enabled then
        -- Reset trade state
        tradeState = "populate"
        tradeData.slotID = 1
        tradeData.numAttempts = 0
        tradeData.containerLocation = nil
        
        -- Start the trade process
        C_Timer.After(0.1, function()
            TradeSand()
        end)
    end
end)

function TradeSand()
    if not ATS_Config.enabled or tradeState ~= "populate" then return end
    
    -- Find Hourglass Sand in bags
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink and string.find(itemLink, "Hourglass Sand") then
                local _, itemCount = GetContainerItemInfo(bag, slot)
                if itemCount >= ATS_Config.sandCount then
                    -- Pick up the sand
                    PickupContainerItem(bag, slot)
                    
                    -- Wait a frame to ensure the item is on cursor
                    C_Timer.After(0.05, function()
                        if CursorHasItem() then
                            -- Put it in the first trade slot
                            ClickTradeButton(1)
                            print("|cFF00FF00Traded " .. ATS_Config.sandCount .. " Hourglass Sand|r")
                            tradeState = nil
                        else
                            -- Try again if item didn't get picked up
                            tradeData.numAttempts = tradeData.numAttempts + 1
                            if tradeData.numAttempts < 10 then
                                C_Timer.After(0.1, TradeSand)
                            else
                                print("|cFFFF0000Failed to pick up Hourglass Sand|r")
                                tradeState = nil
                            end
                        end
                    end)
                    return
                end
            end
        end
    end
    
    print("|cFFFF0000No Hourglass Sand found in bags!|r")
    tradeState = nil
end

-- Manual trade function
function ManualTradeSand()
    if not TradeFrame:IsVisible() then
        print("|cFFFF0000Trade window is not open!|r")
        return
    end
    
    -- Find Hourglass Sand in bags
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink and string.find(itemLink, "Hourglass Sand") then
                local _, itemCount = GetContainerItemInfo(bag, slot)
                if itemCount >= ATS_Config.sandCount then
                    -- Pick up the sand
                    PickupContainerItem(bag, slot)
                    
                    -- Wait a frame to ensure the item is on cursor
                    C_Timer.After(0.05, function()
                        if CursorHasItem() then
                            -- Put it in the first trade slot
                            ClickTradeButton(1)
                            print("|cFF00FF00Manually traded " .. ATS_Config.sandCount .. " Hourglass Sand|r")
                        else
                            print("|cFFFF0000Failed to pick up Hourglass Sand|r")
                        end
                    end)
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
        tradeState = nil
        print("|cFFFF0000autoTradeSand disabled!|r")
    elseif command == "trade" then
        -- Manual trade command - works even if auto is disabled
        ManualTradeSand()
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
        print("|cFFFFFF00/ats status|r - Show current status")
    end
end 