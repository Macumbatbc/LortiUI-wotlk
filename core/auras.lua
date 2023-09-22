--get the addon namespace
local addon, ns = ...
--get the config values
local cfg = ns.cfg

---------------------------------------
-- LOCALS
---------------------------------------

--backdrop
local backdrop = {
    bgFile = nil,
    edgeFile = "Interface\\AddOns\\Lorti-UI-Classic\\textures\\outer_shadow",
    tile = false,
    tileSize = 32,
    edgeSize = 4,
    insets = {
        left = 4,
        right = 4,
        top = 4,
        bottom = 4,
    },
}

---------------------------------------
-- FUNCTIONS
---------------------------------------

--apply aura frame texture func
local function applySkin(b)

    if not b or (b and b.styled) then
        return
    end
    if b:IsForbidden() then
        return
    end

    --button name
    local name = b:GetName()
    if (name:match("Buff")) then
        b.buff = true
    end

    --icon
    local icon = _G[name .. "Icon"]
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    icon:SetDrawLayer("BACKGROUND", -8)
    b.icon = icon

    --border
    local border = _G[name .. "Border"] or b:CreateTexture(name .. "Border", "BACKGROUND", nil, -7)
    border:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\gloss")
    border:SetTexCoord(0, 1, 0, 1)
    border:SetDrawLayer("BACKGROUND", -7)
    if b.buff then
        border:SetVertexColor(0.4, 0.35, 0.35)
    end
    border:ClearAllPoints()
    border:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
    b.border = border

    --shadow
    local back = CreateFrame("Frame", nil, b, BackdropTemplateMixin and "BackdropTemplate")
    back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
    back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
    back:SetFrameLevel(b:GetFrameLevel() - 1)
    back:SetBackdrop(backdrop)
    back:SetBackdropBorderColor(0, 0, 0, 0.9)
    b.bg = back
    --set button styled variable
    b.styled = true
end

--apply castbar texture

local function applycastSkin(b)
    if not b or (b and b.styled) then
        return
    end

    --border
    local border = b:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\AddOns\\Lorti-UI-Classic\\textures\\gloss")
    border:SetTexCoord(0, 1, 0, 1)
    border:SetDrawLayer("BACKGROUND", -7)
    border:SetVertexColor(0.4, 0.35, 0.35)
    border:ClearAllPoints()
    border:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
    b.border = border
    --shadow
    local back = CreateFrame("Frame", nil, b, BackdropTemplateMixin and "BackdropTemplate")
    back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
    back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
    back:SetFrameLevel(b:GetFrameLevel() - 1)
    back:SetBackdrop(backdrop)
    back:SetBackdropBorderColor(0, 0, 0, 0.9)
    b.bg = back
    --set button styled variable
    b.styled = true
end

---------------------------------------
-- INIT
---------------------------------------

local function TargetButton_Update(self)
    for i = 1, MAX_TARGET_BUFFS do
        local b = _G["TargetFrameBuff" .. i]
        applySkin(b)
    end
    for i = 1, MAX_TARGET_DEBUFFS do
        local b = _G["TargetFrameDebuff" .. i]
        applySkin(b)
    end
    for i = 1, MAX_TARGET_BUFFS do
        local b = _G["FocusFrameBuff" .. i]
        applySkin(b)
    end
    for i = 1, MAX_TARGET_DEBUFFS do
        local b = _G["FocusFrameDebuff" .. i]
        applySkin(b)
    end
end
hooksecurefunc("TargetFrame_UpdateAuras", TargetButton_Update);

local cf = CreateFrame("Frame")
cf:RegisterEvent("PLAYER_LOGIN")
cf:SetScript("OnEvent", function(self)
    local tf = CreateFrame("Frame", nil, TargetFrameSpellBar)
    applycastSkin(tf)
    tf:SetAllPoints(TargetFrameSpellBar.Icon)
    TargetFrameSpellBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    local ff = CreateFrame("Frame", nil, FocusFrameSpellBar)
    applycastSkin(ff)
    ff:SetAllPoints(FocusFrameSpellBar.Icon)
    FocusFrameSpellBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)
end)