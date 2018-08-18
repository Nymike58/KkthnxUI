local K, C = unpack(select(2, ...))
local Module = K:NewModule("DataBars", "AceEvent-3.0")
K.DataBars = Module

local _G = _G
local select = select

local CreateFrame = _G.CreateFrame
local GetExpansionLevel = _G.GetExpansionLevel
local MAX_PLAYER_LEVEL_TABLE = _G.MAX_PLAYER_LEVEL_TABLE
local UIParent = _G.UIParent

function Module:OnLeave()
	if (self == KkthnxUI_ExperienceBar and C["DataBars"].MouseOver)
	or (self == KkthnxUI_ReputationBar and C["DataBars"].MouseOver)
	or (self == KkthnxUI_AzeriteBar and C["DataBars"].MouseOver) then
		K.UIFrameFadeOut(self, 1, self:GetAlpha(), 0)
	end

	GameTooltip:Hide()
end

function Module:CreateBar(name, onEnter, onClick, ...)
	local bar = CreateFrame("Button", name, UIParent)

	bar.font = K.GetFont(C["DataBars"].Font)
	bar.texture = K.GetTexture(C["DataBars"].Texture)
	bar:SetPoint(...)
	bar:SetScript("OnEnter", onEnter)
	bar:SetScript("OnLeave", Module.OnLeave)
	bar:SetScript("OnClick", onClick)
	bar:SetFrameStrata("LOW")
	bar:CreateBorder()
	bar:Hide()

	bar.statusBar = CreateFrame("StatusBar", nil, bar)
	bar.statusBar:SetInside()
	bar.statusBar:SetStatusBarTexture(bar.texture)
	bar.text = bar.statusBar:CreateFontString(nil, "OVERLAY")
	bar.text:FontTemplate()

	bar.text:SetFontObject(bar.font)
	bar.text:SetFont(select(1, bar.text:GetFont()), 11, select(3, bar.text:GetFont()))
	bar.text:SetPoint("CENTER")

	return bar
end

function Module:UpdateDataBarDimensions()
	self:UpdateExperienceDimensions()
	self:UpdateReputationDimensions()
	self:UpdateAzeriteDimensions()
end

function Module:PLAYER_LEVEL_UP(level)
	local maxLevel = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]
	if (level ~= maxLevel or not C["DataBars"].XPHideAtMaxLevel) and C["DataBars"].ExperienceEnable then
		self:UpdateExperience("PLAYER_LEVEL_UP", level)
	else
		self.expBar:Hide()
	end
end

--function Module:OnEnable()
--	self:LoadExperienceBar()
--	self:LoadReputationBar()
--	self:LoadAzeriteBar()

--	self:RegisterEvent("PLAYER_LEVEL_UP")
--end