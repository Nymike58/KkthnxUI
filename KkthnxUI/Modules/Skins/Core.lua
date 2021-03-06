local K, C = unpack(select(2, ...))
local Module = K:NewModule("Skins", "AceEvent-3.0")

local _G = _G
local pairs = pairs
local type = type

local hooksecurefunc = _G.hooksecurefunc
local IsAddOnLoaded = _G.IsAddOnLoaded
local NO = _G.NO

Module.SkinFuncs = {}
Module.SkinFuncs["KkthnxUI"] = {}

function Module:StatusBarColorGradient(bar, value, max)
	local current = (not max and value) or (value and max and max ~= 0 and value / max)

	if not (bar and current) then
		return
	end

	local r, g, b = K.ColorGradient(current, 0.8, 0, 0, 0.8, 0.8, 0, 0, 0.8, 0)
	bar:SetStatusBarColor(r, g, b)
end

function Module:AcceptFrame(MainText, Function)
	if not AcceptFrame then
		AcceptFrame = CreateFrame("Frame", "AcceptFrame", UIParent)

		AcceptFrame.Background = AcceptFrame:CreateTexture(nil, "BACKGROUND", -1)
		AcceptFrame.Background:SetAllPoints()
		AcceptFrame.Background:SetColorTexture(C["Media"].BackdropColor[1], C["Media"].BackdropColor[2], C["Media"].BackdropColor[3], C["Media"].BackdropColor[4])

		K.CreateBorder(AcceptFrame)

		AcceptFrame:SetPoint("CENTER", UIParent, "CENTER")
		AcceptFrame:SetFrameStrata("DIALOG")
		AcceptFrame.Text = AcceptFrame:CreateFontString(nil, "OVERLAY")
		AcceptFrame.Text:SetFont(C["Media"].Font, 14)
		AcceptFrame.Text:SetPoint("TOP", AcceptFrame, "TOP", 0, -10)
		AcceptFrame.Accept = CreateFrame("Button", nil, AcceptFrame, "OptionsButtonTemplate")
		AcceptFrame.Accept:SkinButton()
		AcceptFrame.Accept:SetSize(70, 24)
		AcceptFrame.Accept:SetPoint("RIGHT", AcceptFrame, "BOTTOM", -10, 20)
		AcceptFrame.Accept:SetFormattedText("|cFFFFFFFF%s|r", YES)
		AcceptFrame.Close = CreateFrame("Button", nil, AcceptFrame, "OptionsButtonTemplate")
		AcceptFrame.Close:SkinButton()
		AcceptFrame.Close:SetSize(70, 24)
		AcceptFrame.Close:SetPoint("LEFT", AcceptFrame, "BOTTOM", 10, 20)
		AcceptFrame.Close:SetScript("OnClick", function(self) self:GetParent():Hide() end)
		AcceptFrame.Close:SetFormattedText("|cFFFFFFFF%s|r", NO)
	end

	AcceptFrame.Text:SetText(MainText)
	AcceptFrame:SetSize(AcceptFrame.Text:GetStringWidth() + 100, AcceptFrame.Text:GetStringHeight() + 60)
	AcceptFrame.Accept:SetScript("OnClick", Function)
	AcceptFrame:Show()
end

-- DropDownMenu library support
function Module:SkinLibDropDownMenu(prefix)
	if _G[prefix .. "_UIDropDownMenu_CreateFrames"] and not Module[prefix .. "_UIDropDownMenuSkinned"] then
		local bd = _G[prefix .. "_DropDownList1Backdrop"]
		local mbd = _G[prefix .. "_DropDownList1MenuBackdrop"]

		if bd and not bd.border then
			bd:CreateBorder()
		end

		if mbd and not mbd.border then
			mbd:CreateBorder()
		end

		Module[prefix .. "_UIDropDownMenuSkinned"] = true
		hooksecurefunc(prefix .. "_UIDropDownMenu_CreateFrames", function()
			local lvls = _G[(prefix == "Lib" and "LIB" or prefix) .. "_UIDROPDOWNMENU_MAXLEVELS"]
			local ddbd = lvls and _G[prefix.."_DropDownList" .. lvls .. "Backdrop"]
			local ddmbd = lvls and _G[prefix.."_DropDownList" .. lvls .. "MenuBackdrop"]

			if ddbd and not ddbd.border then
				ddbd:CreateBorder()
			end

			if ddmbd and not ddmbd.border then
				ddmbd:CreateBorder()
			end
		end)
	end
end

function Module:ADDON_LOADED(event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") then
		self:UnregisterEvent("ADDON_LOADED")
		return
	end

	if not Module.L_UIDropDownMenuSkinned then -- LibUIDropDownMenu
		Module:SkinLibDropDownMenu("L")
	end

	if not Module.Lib_UIDropDownMenuSkinned then -- NoTaint_UIDropDownMenu
		Module:SkinLibDropDownMenu("Lib")
	end

	for _addon, skinfunc in pairs(Module.SkinFuncs) do
		if type(skinfunc) == "function" then
			if _addon == addon then
				if skinfunc then
					skinfunc()
				end
			end
		elseif type(skinfunc) == "table" then
			if _addon == addon then
				for _, skinfunc in pairs(Module.SkinFuncs[_addon]) do
					if skinfunc then
						skinfunc()
					end
				end
			end
		end
	end
end

Module:RegisterEvent("ADDON_LOADED")