local ESP = {}
ESP.Config = {

    BoxColor         = Color(255,  50,  50, 200),   -- muted red
    OutlineColor     = Color(0,   0,    0,  200),   -- solid black
    BoxFillColor     = Color(10,  10,  10,   200),   -- gray
    HealthColor      = Color(50,  200, 50,  200),   -- soft green
    HealthBgColor    = Color(0,   0,    0,  150),   -- dark gray

    TextColor        = Color(255, 255, 255, 255),   -- white
    TextOutlineColor = Color(0,   0,    0,  200),   -- black

    FontName         = "ESPFont",
    FontSize         = 16,
    FontWeight       = 500,

    OutlineThickness = 1,
    BoxMargin        = 2,
    HealthBarWidth   = 4,
    Padding          = 2,
}

surface.CreateFont(ESP.Config.FontName, {
    font   = "Roboto",
    size   = ESP.Config.FontSize,
    weight = ESP.Config.FontWeight,
})

function ESP:GetOBBBounds(ent)
    local mins, maxs = ent:OBBMins(), ent:OBBMaxs()

    local corners = {
        Vector(mins.x, mins.y, mins.z), Vector(mins.x, mins.y, maxs.z),
        Vector(mins.x, maxs.y, mins.z), Vector(mins.x, maxs.y, maxs.z),
        Vector(maxs.x, mins.y, mins.z), Vector(maxs.x, mins.y, maxs.z),
        Vector(maxs.x, maxs.y, mins.z), Vector(maxs.x, maxs.y, maxs.z),
    }

    local xs, ys = {}, {}
    for _, c in ipairs(corners) do
        local sc = ent:LocalToWorld(c):ToScreen()
        if sc.visible then
            xs[#xs+1], ys[#ys+1] = sc.x, sc.y
        end
    end
    if #xs == 0 then return end

    local x1, x2 = math.min(unpack(xs)), math.max(unpack(xs))
    local y1, y2 = math.min(unpack(ys)), math.max(unpack(ys))
    return x1, y1, x2 - x1, y2 - y1
end

-- Utility: draw outlined text
function ESP:DrawTextOutline(text, font, x, y, col, outlineCol, ax, ay)
    for _, offset in ipairs({{-1,-1},{1,-1},{1,1},{-1,1}}) do
        draw.SimpleText(text, font, x + offset[1], y + offset[2], outlineCol, ax, ay)
    end
    draw.SimpleText(text, font, x, y, col, ax, ay)
end

-- Draw one player
function ESP:DrawTarget(ent)
    if not ent:IsPlayer() or not ent:Alive() or ent == LocalPlayer() then return end

    local x,y,w,h = self:GetOBBBounds(ent)
    if not x then return end

    -- Expand bounds
    local m  = self.Config.BoxMargin
    local bx, by, bw, bh = x - m, y - m, w + 2*m, h + 2*m

    -- Fill interior
    surface.SetDrawColor(self.Config.BoxFillColor)
    surface.DrawRect(bx, by, bw, bh)

    -- Outer outline
    surface.SetDrawColor(self.Config.OutlineColor)
    for i = 0, self.Config.OutlineThickness - 1 do
        surface.DrawOutlinedRect(bx - i, by - i, bw + 2*i, bh + 2*i)
    end

    -- Main box stroke
    surface.SetDrawColor(self.Config.BoxColor)
    surface.DrawOutlinedRect(bx, by, bw, bh)

    -- Health bar background
    local hbX = bx - self.Config.HealthBarWidth - self.Config.Padding
    surface.SetDrawColor(self.Config.HealthBgColor)
    surface.DrawRect(hbX, by, self.Config.HealthBarWidth, bh)

    -- Health fill
    local frac  = math.Clamp(ent:Health() / ent:GetMaxHealth(), 0, 1)
    local fillH = bh * frac
    local fillY = by + (bh - fillH)
    surface.SetDrawColor(self.Config.HealthColor)
    surface.DrawRect(hbX, fillY, self.Config.HealthBarWidth, fillH)

    -- Health number
    local healthTextX = hbX + self.Config.HealthBarWidth + self.Config.Padding
    local healthTextY = fillY - self.Config.Padding
    self:DrawTextOutline(
        tostring(ent:Health()),
        self.Config.FontName,
        healthTextX,
        healthTextY,
        self.Config.TextColor,
        self.Config.TextOutlineColor,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_BOTTOM
    )

    -- Name
    self:DrawTextOutline(
        ent:Nick(),
        self.Config.FontName,
        bx + bw * 0.5,
        by - self.Config.FontSize - self.Config.Padding,
        self.Config.TextColor,
        self.Config.TextOutlineColor,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_TOP
    )

    -- Distance
    local dist = math.floor(LocalPlayer():GetPos():Distance(ent:GetPos()) / 52)
    self:DrawTextOutline(
        dist .. "m",
        self.Config.FontName,
        bx + bw + self.Config.Padding,
        by,
        self.Config.TextColor,
        self.Config.TextOutlineColor,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_TOP
    )

    -- Weapon
    local wep = ent:GetActiveWeapon()
    if IsValid(wep) then
        local name = wep:GetClass():gsub("^weapon_", "")
        self:DrawTextOutline(
            name,
            self.Config.FontName,
            bx + bw * 0.5,
            by + bh + self.Config.Padding,
            self.Config.TextColor,
            self.Config.TextOutlineColor,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_TOP
        )
    end
end

-- Hook into HUDPaint
hook.Add("HUDPaint", "CustomPlayerESP", function()
    for _, p in ipairs(player.GetAll()) do
        ESP:DrawTarget(p)
    end
end)
