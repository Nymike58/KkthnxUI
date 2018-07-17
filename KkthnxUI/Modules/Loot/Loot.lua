local K, C, L = unpack(select(2, ...))
local Module = K:NewModule("Loot", "AceEvent-3.0", "AceTimer-3.0")

local _G = _G
local pairs = pairs
local tinsert = table.insert
local max = math.max

local CloseLoot = _G.CloseLoot
local CreateFrame = _G.CreateFrame
local CursorOnUpdate = _G.CursorOnUpdate
local CursorUpdate = _G.CursorUpdate
local DoMasterLootRoll = _G.DoMasterLootRoll
local GetCursorPosition = _G.GetCursorPosition
local GetCVar = _G.GetCVar
local GetLootSlotInfo = _G.GetLootSlotInfo
local GetLootSlotLink = _G.GetLootSlotLink
local GetNumLootItems = _G.GetNumLootItems
local GiveMasterLoot = _G.GiveMasterLoot
local IsFishingLoot = _G.IsFishingLoot
local IsModifiedClick = _G.IsModifiedClick
local ITEM_QUALITY_COLORS = _G.ITEM_QUALITY_COLORS
local ToggleDropDownMenu = _G.ToggleDropDownMenu
local UIDropDownMenu_AddButton = _G.UIDropDownMenu_AddButton
local UIDropDownMenu_CreateInfo = _G.UIDropDownMenu_CreateInfo
local LOOT = _G.LOOT
local LootSlotHasItem = _G.LootSlotHasItem
local MasterLooterFrame_UpdatePlayers = _G.MasterLooterFrame_UpdatePlayers
local ResetCursor = _G.ResetCursor
local StaticPopup_Hide = _G.StaticPopup_Hide
local TEXTURE_ITEM_QUEST_BANG = _G.TEXTURE_ITEM_QUEST_BANG
local UnitIsDead = _G.UnitIsDead
local UnitIsFriend = _G.UnitIsFriend
local UnitName = _G.UnitName
local REQUEST_ROLL = _G.REQUEST_ROLL
local ASSIGN_LOOT = _G.ASSIGN_LOOT
local MASTER_LOOTER = _G.MASTER_LOOTER

local coinTextureIDs = {
	[133784] = true,
	[133785] = true,
	[133786] = true,
	[133787] = true,
	[133788] = true,
	[133789] = true
}

-- Credit Haste
local iconSize, lootFrame, lootFrameHolder = 30

local OnEnter = function(self)
	local slot = self:GetID()
	if LootSlotHasItem(slot) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end
	
	self.drop:Show()
	self.drop:SetVertexColor(1, 1, 0)
end

local OnLeave = function(self)
	if self.quality and (self.quality > 1) then
		local color = ITEM_QUALITY_COLORS[self.quality]
		self.drop:SetVertexColor(color.r, color.g, color.b)
	else
		self.drop:Hide()
	end
	
	GameTooltip:Hide()
	ResetCursor()
end

local function OnClick(self)
	LootFrame.selectedQuality = self.quality
	LootFrame.selectedItemName = self.name:GetText()
	LootFrame.selectedSlot = self:GetID()
	LootFrame.selectedLootButton = self:GetName()
	LootFrame.selectedTexture = self.icon:GetTexture()
	
	if IsModifiedClick() then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
		LootSlot(self:GetID())
	end
end

local function OnShow(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end
end

local function anchorSlots(self)
	local shownSlots = 0
	for i = 1, #self.slots do
		local frame = self.slots[i]
		if frame:IsShown() then
			shownSlots = shownSlots + 1
			
			frame:SetPoint("TOP", lootFrame, 4, (-8 + iconSize) - (shownSlots * iconSize))
		end
	end
	
	self:SetHeight(max(shownSlots * iconSize + 16, 20))
end

local function createSlot(id)
	local iconsize = (iconSize - 2)
	
	local frame = CreateFrame("Button", "KkthnxLootSlot"..id, lootFrame)
	frame:SetPoint("LEFT", 8, 0)
	frame:SetPoint("RIGHT", -8, 0)
	frame:SetHeight(iconsize)
	frame:SetID(id)
	
	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnShow", OnShow)
	
	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:SetHeight(iconsize)
	iconFrame:SetWidth(iconsize)
	iconFrame:SetPoint("RIGHT", frame)
	
	iconFrame.Backgrounds = iconFrame:CreateTexture(nil, "BACKGROUND", -1)
	iconFrame.Backgrounds:SetAllPoints()
	iconFrame.Backgrounds:SetColorTexture(C["Media"].BackdropColor[1], C["Media"].BackdropColor[2], C["Media"].BackdropColor[3], C["Media"].BackdropColor[4])
	
	iconFrame.Borders = CreateFrame("Frame", nil, iconFrame)
	iconFrame.Borders:SetAllPoints()
	K.CreateBorder(iconFrame.Borders)
	
	frame.iconFrame = iconFrame
	
	local icon = iconFrame:CreateTexture(nil, "ARTWORK")
	icon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])
	icon:SetAllPoints()
	frame.icon = icon
	
	local count = iconFrame:CreateFontString(nil, "OVERLAY")
	count:SetJustifyH("RIGHT")
	count:SetPoint("BOTTOMRIGHT", iconFrame, -2, 2)
	count:FontTemplate(nil, nil, "OUTLINE")
	count:SetText(1)
	frame.count = count
	
	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH("LEFT")
	name:SetPoint("LEFT", frame)
	name:SetPoint("RIGHT", icon, "LEFT")
	name:SetNonSpaceWrap(true)
	name:FontTemplate(nil, nil, "OUTLINE")
	frame.name = name
	
	local drop = frame:CreateTexture(nil, "ARTWORK")
	drop:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
	drop:SetPoint("LEFT", icon, "RIGHT", 0, 0)
	drop:SetPoint("RIGHT", frame)
	drop:SetAllPoints(frame)
	drop:SetAlpha(.3)
	frame.drop = drop
	
	local questTexture = iconFrame:CreateTexture(nil, "OVERLAY")
	questTexture:SetAllPoints()
	questTexture:SetTexture(TEXTURE_ITEM_QUEST_BANG)
	questTexture:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])
	frame.questTexture = questTexture
	
	lootFrame.slots[id] = frame
	return frame
end

function Module:LOOT_SLOT_CLEARED(_, slot)
	if not lootFrame:IsShown() then
		return
	end
	
	lootFrame.slots[slot]:Hide()
	anchorSlots(lootFrame)
end

function Module:LOOT_CLOSED()
	StaticPopup_Hide("LOOT_BIND")
	lootFrame:Hide()
	
	for _, v in pairs(lootFrame.slots) do
		v:Hide()
	end
end

function Module:LOOT_OPENED(_, autoloot)
	lootFrame:Show()
	
	if (not lootFrame:IsShown()) then
		CloseLoot(not autoloot)
	end
	
	local items = GetNumLootItems()
	
	if IsFishingLoot() then
		lootFrame.title:SetText(L["Loot"].Fishy_Loot)
	elseif not UnitIsFriend("player", "target") and UnitIsDead("target") then
		lootFrame.title:SetText(UnitName("target"))
	else
		lootFrame.title:SetText(LOOT)
	end
	
	-- Blizzard uses strings here
	if GetCVarBool("lootUnderMouse") then
		local x, y = GetCursorPosition()
		x = x / lootFrame:GetEffectiveScale()
		y = y / lootFrame:GetEffectiveScale()
		
		lootFrame:ClearAllPoints()
		lootFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x - 40, y + 20)
		lootFrame:GetCenter()
		lootFrame:Raise()
	else
		lootFrame:ClearAllPoints()
		lootFrame:SetPoint("TOPLEFT", lootFrameHolder, "TOPLEFT")
	end
	
	local m, w, t = 0, 0, lootFrame.title:GetStringWidth()
	if items > 0 then
		for i = 1, items do
			local slot = lootFrame.slots[i] or createSlot(i)
			local textureID, item, quantity, _, quality, _, isQuestItem, questId, isActive = GetLootSlotInfo(i)
			local color = ITEM_QUALITY_COLORS[quality]
			
			if coinTextureIDs[textureID] then
				item = item:gsub("\n", ", ")
			end
			
			if quantity and (quantity > 1) then
				slot.count:SetText(quantity)
				slot.count:Show()
			else
				slot.count:Hide()
			end
			
			if quality and (quality > 1) then
				slot.drop:SetVertexColor(color.r, color.g, color.b)
				slot.drop:Show()
			else
				slot.drop:Hide()
			end
			
			slot.quality = quality
			slot.name:SetText(item)
			if color then
				slot.name:SetTextColor(color.r, color.g, color.b)
				slot.iconFrame.Borders:SetBackdropBorderColor(color.r, color.g, color.b)
			end
			slot.icon:SetTexture(textureID)
			
			if quality then
				m = max(m, quality)
			end
			w = max(w, slot.name:GetStringWidth())
			
			local questTexture = slot.questTexture
			if (questId and not isActive) then
				questTexture:Show()
				slot.iconFrame.Borders:SetBackdropBorderColor(1, 1, 0)
				slot.name:SetTextColor(1, 1, 0)
			elseif (questId or isQuestItem) then
				questTexture:Hide()
				slot.iconFrame.Borders:SetBackdropBorderColor(1, 1, 0)
				slot.name:SetTextColor(1, 1, 0)
			else
				questTexture:Hide()
				slot.iconFrame.Borders:SetBackdropBorderColor(C["Media"].BorderColor[1], C["Media"].BorderColor[2], C["Media"].BorderColor[3])
			end
			
			slot:Enable()
			slot:Show()
		end
	else
		local slot = lootFrame.slots[1] or createSlot(1)
		local color = ITEM_QUALITY_COLORS[0]
		
		slot.name:SetText(L["Loot"].Empty_Slot)
		if color then
			slot.name:SetTextColor(color.r, color.g, color.b)
		end
		slot.icon:SetTexture([[Interface\Icons\INV_Misc_Herb_AncientLichen]])
		
		w = max(w, slot.name:GetStringWidth())
		
		slot.count:Hide()
		slot.drop:Hide()
		slot:Disable()
		slot:Show()
	end
	anchorSlots(lootFrame)
	
	w = w + 60
	t = t + 5
	
	local color = ITEM_QUALITY_COLORS[m]
	lootFrame:SetBackdropBorderColor(color.r, color.g, color.b, .8)
	lootFrame:SetWidth(max(w, t))
end

function Module:OnEnable()
	if C["Loot"].Enable ~= true then
		return
	end
	
	lootFrameHolder = CreateFrame("Frame", "KkthnxLootFrameHolder", UIParent)
	lootFrameHolder:SetPoint("TOPLEFT", 36, -195)
	lootFrameHolder:SetWidth(150)
	lootFrameHolder:SetHeight(22)
	
	lootFrame = CreateFrame("Button", "KkthnxLootFrame", lootFrameHolder)
	lootFrame:SetClampedToScreen(true)
	lootFrame:SetPoint("TOPLEFT")
	lootFrame:SetSize(256, 64)
	
	lootFrame.Backgrounds = lootFrame:CreateTexture(nil, "BACKGROUND", -1)
	lootFrame.Backgrounds:SetAllPoints()
	lootFrame.Backgrounds:SetColorTexture(C["Media"].BackdropColor[1], C["Media"].BackdropColor[2], C["Media"].BackdropColor[3], C["Media"].BackdropColor[4])
	
	lootFrame.Borders = CreateFrame("Frame", nil, lootFrame)
	lootFrame.Borders:SetAllPoints()
	K.CreateBorder(lootFrame.Borders)
	
	lootFrame:SetFrameStrata(LootFrame:GetFrameStrata())
	lootFrame:SetToplevel(true)
	lootFrame.title = lootFrame:CreateFontString(nil, "OVERLAY")
	lootFrame.title:FontTemplate(nil, nil, "OUTLINE")
	lootFrame.title:SetPoint("BOTTOMLEFT", lootFrame, "TOPLEFT", 0, 4)
	lootFrame.slots = {}
	lootFrame:SetScript("OnHide", function()
		StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
		CloseLoot()
	end)
	
	self:RegisterEvent("LOOT_OPENED")
	self:RegisterEvent("LOOT_SLOT_CLEARED")
	self:RegisterEvent("LOOT_CLOSED")
	
	if (GetCVar("lootUnderMouse") == "0") then
		K.Movers:RegisterFrame(lootFrameHolder)
	end
	
	LootFrame:UnregisterAllEvents()
	tinsert(UISpecialFrames, "KkthnxLootFrame")
end