--[[
autoTradeSand - Automatic Hourglass Sand trading for WoW Classic
Based on WaterDispenser by GPI / Erytheia-Razorfen / Junsa
Modified for Hourglass Sand by Feraline@Spineshatter

Features:
- Automatic Hourglass Sand trading
- Simple console commands
- Combat safe
- Smart slot detection
]]

local TOCNAME,ADDON=...
local L = setmetatable({}, {__index = function (t, k)
	if ADDON.L and ADDON.L[k] then
		return ADDON.L[k]
	else
		return "["..k.."]"
	end
end})
AUTOTRADESAND_ADDON=ADDON
ADDON.Version=GetAddOnMetadata(TOCNAME, "Version")
ADDON.SettingsVersion=1
ADDON.Title=GetAddOnMetadata(TOCNAME, "Title")
ADDON.PREFIX="[ATS]: "

local T=":0:0:0:0:64:64:4:60:4:60"

-- Hourglass Sand item IDs for different levels
ADDON.SandItems = {
    [6948] = "Hourglass Sand",  -- Basic Hourglass Sand
}

ADDON.SpellList = {
    Sand = {
        [6948] = 6948,  -- Hourglass Sand
    }
}

function ADDON.ClearInventory()
	ADDON.Inventory=nil
end

function ADDON.GetInventory()
	OldInventory=ADDON.Inventory

	ADDON.Inventory={}

	-- Check for Hourglass Sand in bags
	for bag=BACKPACK_CONTAINER , NUM_BAG_SLOTS do
		for slot=1,C_Container.GetContainerNumSlots(bag) do
			local containerInfo = C_Container.GetContainerItemInfo(bag, slot)
			if containerInfo then
				local itemCount = containerInfo.stackCount
				local itemLink = containerInfo.hyperlink
				local itemID = containerInfo.itemID

				if itemID and ADDON.SandItems[itemID] then
					local itemName, _, _, _, itemMinLevel, _, _, itemStackCount, _, itemIcon = GetItemInfo(itemID)
					
					if not ADDON.Inventory[itemID] then
						ADDON.Inventory[itemID]={
							link=itemLink,
							name=itemName,
							icon=itemIcon,
							id=itemID,
							stack=itemStackCount,
							level=itemMinLevel or 0,
							bag={},
						}
					end
					
					tinsert(ADDON.Inventory[itemID].bag,{
						["bag"]=bag,
						["slot"]=slot,
						["full"]=itemStackCount==itemCount,
					})
				end
			end
		end
	end

	if OldInventory then
		for id,item in pairs(ADDON.Inventory) do
			if #item.bag ~= (OldInventory[id] and #OldInventory[id].bag or 0) then
				return true
			end
		end
		return false
	end
	return true
end

function ADDON.ClearTrade()
	if not ADDON.TradeClass then
		print(ADDON.PREFIX,"No trade in progress")
		return
	end

	for i=1,MAX_TRADABLE_ITEMS do
		ClearCursor()
		ClickTradeButton(i)
	end
	ClearCursor()
end

function ADDON.FillTrade(forced)
	if not ADDON.TradeClass then
		print(ADDON.PREFIX,"No trade in progress")
		return
	end

	if not ADDON.GetInventory() and not forced then
		return true
	end

	-- Get sand count from config
	local sandCount = ADDON.DB.SandCount or 1
	
	if not ADDON.DontClear then
		ADDON.ClearTrade()
	else
		ADDON.DontClear=false
	end

	local inventory=ADDON.Inventory
	local tradePos

	-- Trade Hourglass Sand
	for id,item in pairs(inventory) do
		if ADDON.SandItems[id] then
			local count = sandCount
			
			if count > 0 then
				for ibag,bagItem in ipairs(item.bag) do
					if bagItem.full then
						ClearCursor()
						C_Container.PickupContainerItem(bagItem.bag, bagItem.slot)
						tradePos=TradeFrame_GetAvailableSlot()
						if tradePos==nil then
							return
						end
						ClickTradeButton(tradePos)
						count=count-1
						if count<=0 then
							break
						end
					end
				end
				
				-- Use partial stacks if needed
				if count>0 then
					for ibag,bagItem in ipairs(item.bag) do
						if not bagItem.full then
							ClearCursor()
							C_Container.PickupContainerItem(bagItem.bag, bagItem.slot)
							tradePos=TradeFrame_GetAvailableSlot()
							if tradePos==nil then
								return
							end
							ClickTradeButton(tradePos)
							count=count-1
							if count<=0 then
								break
							end
						end
					end
				end

				if count>0 then
					print(ADDON.PREFIX,"Not enough Hourglass Sand! Need", sandCount, "have", sandCount-count)
				else
					print(ADDON.PREFIX,"Traded", sandCount, "Hourglass Sand")
				end
			end
		end
	end
end

-- Slash commands
local function doDBSet(DB,var,value)
	if value==nil then
		DB[var]= not DB[var]
	elseif tContains({"true","1","enable"},value) then
		DB[var]=true
	elseif tContains({"false","0","disable"},value) then
		DB[var]=false
	end
	print(ADDON.PREFIX,"Set "..var.." to "..tostring(DB[var]))
end

local function Event_ADDON_LOADED(arg1)
	if arg1 == TOCNAME then
		if not autoTradeSandDB then autoTradeSandDB = {} end

		ADDON.DB=autoTradeSandDB

		-- Initialize default settings
		if not ADDON.DB.SandCount then
			ADDON.DB.SandCount = 1
		end
		if ADDON.DB.AutoFill == nil then
			ADDON.DB.AutoFill = true
		end

		print("|cFFFF1C1C Loaded: "..GetAddOnMetadata(TOCNAME, "Title") .." ".. GetAddOnMetadata(TOCNAME, "Version") .." by "..GetAddOnMetadata(TOCNAME, "Author"))
		print(ADDON.PREFIX,"Use /ats help for commands")
	end
end

local function Event_TRADE_SHOW()
	if InCombatLockdown() then
		return
	end

	ADDON.TradeName=GetUnitName("NPC")
	_,ADDON.TradeClass,_=UnitClass("NPC")
	ADDON.TradeLevel=UnitLevel("NPC")
	if ADDON.TradeLevel==nil or ADDON.TradeLevel==-1 then
		ADDON.TradeLevel=UnitLevel("player")+10
	end
	ADDON.TradeParty=UnitInParty("NPC") or UnitInRaid("NPC")

	ADDON.ClearInventory()

	if ADDON.DB.AutoFill then
		ADDON.DontClear=true
		ADDON.FillTrade(false)
	end
end

local function Event_TRADE_CLOSED()
	ADDON.TradeName=nil
	ADDON.TradeClass=nil
	ADDON.TradeLevel=nil
	ADDON.TradeParty=nil
	ADDON.ClearInventory()
end

local function Event_BAG_UPDATE()
	if ADDON.TradeClass then
		ADDON.FillTrade()
	end
end

-- Slash command handler
local function SlashCommand(msg)
	local command = string.lower(msg)
	
	if command == "help" or command == "" then
		print("|cFFFFFF00autoTradeSand commands:|r")
		print("|cFFFFFF00/ats fill|r - Manually fill trade with sand")
		print("|cFFFFFF00/ats clear|r - Clear trade window")
		print("|cFFFFFF00/ats auto|r - Toggle automatic filling")
		print("|cFFFFFF00/ats 1|r - Set sand count to 1")
		print("|cFFFFFF00/ats 2|r - Set sand count to 2")
		print("|cFFFFFF00/ats status|r - Show current settings")
	elseif command == "fill" then
		if TradeFrame:IsVisible() then
			ADDON.FillTrade(true)
		else
			print(ADDON.PREFIX,"Trade window is not open")
		end
	elseif command == "clear" then
		if TradeFrame:IsVisible() then
			ADDON.ClearTrade()
			print(ADDON.PREFIX,"Trade window cleared")
		else
			print(ADDON.PREFIX,"Trade window is not open")
		end
	elseif command == "auto" then
		doDBSet(ADDON.DB,"AutoFill")
	elseif command == "1" then
		ADDON.DB.SandCount = 1
		print(ADDON.PREFIX,"Sand count set to 1")
	elseif command == "2" then
		ADDON.DB.SandCount = 2
		print(ADDON.PREFIX,"Sand count set to 2")
	elseif command == "status" then
		print(ADDON.PREFIX,"Auto fill:", ADDON.DB.AutoFill and "ON" or "OFF")
		print(ADDON.PREFIX,"Sand count:", ADDON.DB.SandCount)
	else
		print(ADDON.PREFIX,"Unknown command. Use /ats help for commands")
	end
end

-- Register slash commands
SLASH_AUTOTRADESAND1 = "/ats"
SLASH_AUTOTRADESAND2 = "/autotradesand"
SlashCmdList["AUTOTRADESAND"] = SlashCommand

-- Register events
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("TRADE_SHOW")
frame:RegisterEvent("TRADE_CLOSED")
frame:RegisterEvent("BAG_UPDATE")

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		Event_ADDON_LOADED(...)
	elseif event == "TRADE_SHOW" then
		Event_TRADE_SHOW()
	elseif event == "TRADE_CLOSED" then
		Event_TRADE_CLOSED()
	elseif event == "BAG_UPDATE" then
		Event_BAG_UPDATE()
	end
end) 