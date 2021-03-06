local K, C, L = unpack(select(2, ...))
local Module = K:NewModule("ExtraActionButtons", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local unpack = unpack

local CreateFrame = CreateFrame
local GetActionCooldown = GetActionCooldown
local HasExtraActionBar = HasExtraActionBar

local ExtraActionBarHolder, ZoneAbilityHolder


local function DisableExtraButtonTexture(self, texture, loop)
	if loop then
		return
	end

	self:SetTexture("", true)
end


local function FixExtraActionCD(cd)
	local start, duration = GetActionCooldown(cd:GetParent().action)
	K.Timer_Start(cd, start, duration, 0, 0)
end

function Module:SetupExtraButton()
	ExtraActionBarHolder = CreateFrame("Frame", "ExtraActionBarHolder", UIParent)
	ExtraActionBarHolder:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 150)
	ExtraActionBarHolder:SetSize(ExtraActionBarFrame:GetSize())

	ExtraActionBarFrame:SetParent(ExtraActionBarHolder)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", ExtraActionBarHolder, "CENTER")
	ExtraActionBarFrame.ignoreFramePositionManager = true

	ZoneAbilityHolder = CreateFrame("Frame", "ZoneAbilityHolder", UIParent)
	ZoneAbilityHolder:SetPoint("BOTTOM", ExtraActionBarFrame, "TOP", 0, 2)
	ZoneAbilityHolder:SetSize(ExtraActionBarFrame:GetSize())

	ZoneAbilityFrame:SetParent(ZoneAbilityHolder)
	ZoneAbilityFrame:ClearAllPoints()
	ZoneAbilityFrame:SetPoint("CENTER", ZoneAbilityHolder, "CENTER")
	ZoneAbilityFrame.ignoreFramePositionManager = true

	for i = 1, ExtraActionBarFrame:GetNumChildren() do
		local button = _G["ExtraActionButton" .. i]
		if button then
			button.noResize = true
			button.pushed = true
			button.checked = true

			button:StyleButton(button, true)
			button:CreateBorder()
			_G["ExtraActionButton" .. i .. "Icon"]:SetDrawLayer("ARTWORK")
			local tex = button:CreateTexture(nil, "OVERLAY")
			tex:SetColorTexture(0.9, 0.8, 0.1, 0.3)
			tex:SetAllPoints()
			button:SetCheckedTexture(tex)

			if button.cooldown then
				button.cooldown:HookScript("OnShow", FixExtraActionCD)
			end
		end
	end

	local button = ZoneAbilityFrame.SpellButton
	if button then
		button:SetNormalTexture("")
		button:StyleButton(nil, nil, nil, true)
		button:CreateBorder()
		button.Icon:SetDrawLayer("ARTWORK")
		button.Icon:SetTexCoord(unpack(K.TexCoords))
		button.Icon:SetAllPoints()
	end

	if HasExtraActionBar() then
		ExtraActionBarFrame:Show()
	end

	K.Movers:RegisterFrame(ExtraActionBarHolder)
	K.Movers:RegisterFrame(ZoneAbilityHolder)
end

function Module:OnInitialize()
	self:SetupExtraButton()

	hooksecurefunc(ExtraActionButton1.style, "SetTexture", DisableExtraButtonTexture)
	hooksecurefunc(ZoneAbilityFrame.SpellButton.Style, "SetTexture", DisableExtraButtonTexture)
end