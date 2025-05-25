if CLIENT then
    hook.Add("InitPostEntity", "ESP_CreateMaterials", function()
      ESP:CreateMaterials()
    end)
  end

local ESP = {}
ESP.Config = {
    -- Original config
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

    -- New config options
    Enabled          = true,
    MaxDistance      = 5000,
    FadeDistance     = 3000,
    ShowTeammates    = false,
    ShowTracers      = true,
    ShowSkeleton     = true,
    ShowBarrels      = true,
    ShowArmor        = true,
    ShowSnapLines    = false,
    
    TracerColor      = Color(255, 255, 0, 100),     -- yellow
    SkeletonColor    = Color(255, 255, 255, 150),   -- white
    BarrelColor      = Color(255, 0, 0, 200),       -- red
    ArmorColor       = Color(100, 100, 255, 200),   -- blue
    SnapLineColor    = Color(255, 255, 0, 50),      -- faded yellow
    
    TeamColor        = Color(50, 200, 50, 200),     -- green for teammates
    EnemyColor       = Color(255, 50, 50, 200),     -- red for enemies
    VisibleColor     = Color(255, 255, 0, 200),     -- yellow when visible

    -- Chams settings
    ChamsEnabled = true,
    ChamsStyle = "glass", -- "glass", "flat", "wireframe", "pulse"
    ChamsColor = Color(100, 150, 255, 50),
    ChamsColorVisible = Color(255, 100, 100, 50),
    ChamsPulseSpeed = 2,

    -- World modifications
    SkyboxOverride = false,
    SkyboxColor = Color(20, 30, 50, 255),
    FogOverride = true,
    FogColor = Color(50, 60, 80, 255),
    FogStart = 500,
    FogEnd = 8000,
    FogDensity = 0.8,

    -- Lighting
    AmbientLightOverride = true,
    AmbientLightColor = Color(150, 150, 200, 255),
    AmbientLightIntensity = 0.3,
    
    -- World colors
    WorldColorModulation = true,
    WorldColorTint = Color(200, 200, 255, 255),
    PropColorTint = Color(180, 180, 220, 255),
    
    -- Atmosphere
    AtmosphereEnabled = true,
    Brightness = 1.2,
    Contrast = 1.1,
    Saturation = 0.8,
    ColorTemperature = 6500, -- Kelvin
    
    -- Bullet trajectory
    BulletPrediction = false,
    BulletPredictionTime = 2, -- seconds
    BulletPredictionColor = Color(255, 200, 0, 100),
    BulletPredictionSteps = 20,
    
    -- Additional effects
    RainbowMode = false,
    RainbowSpeed = 1,
    ChromaticAberration = false,
    ChromaticStrength = 0.5,
    Vignette = true,
    VignetteStrength = 0.3,
    BloomEffect = true,
    BloomIntensity = 0.5,
}

-- Materials for chams
ESP.Materials = {}

-- Bone connections for skeleton ESP
ESP.BoneConnections = {
    -- Head to spine
    {"ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Neck1"},
    {"ValveBiped.Bip01_Neck1", "ValveBiped.Bip01_Spine4"},
    {"ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Spine2"},
    {"ValveBiped.Bip01_Spine2", "ValveBiped.Bip01_Spine1"},
    {"ValveBiped.Bip01_Spine1", "ValveBiped.Bip01_Spine"},
    {"ValveBiped.Bip01_Spine", "ValveBiped.Bip01_Pelvis"},
    
    -- Left arm
    {"ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_L_Clavicle"},
    {"ValveBiped.Bip01_L_Clavicle", "ValveBiped.Bip01_L_UpperArm"},
    {"ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm"},
    {"ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Hand"},
    
    -- Right arm
    {"ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_R_Clavicle"},
    {"ValveBiped.Bip01_R_Clavicle", "ValveBiped.Bip01_R_UpperArm"},
    {"ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm"},
    {"ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Hand"},
    
    -- Left leg
    {"ValveBiped.Bip01_Pelvis", "ValveBiped.Bip01_L_Thigh"},
    {"ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf"},
    {"ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot"},
    
    -- Right leg
    {"ValveBiped.Bip01_Pelvis", "ValveBiped.Bip01_R_Thigh"},
    {"ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf"},
    {"ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot"},
}

-- Create materials
function ESP:CreateMaterials()
    -- Glass material
    self.Materials.glass = CreateMaterial("ESPGlassMaterial", "VertexLitGeneric", {
        ["$basetexture"] = "models/debug/debugwhite",
        ["$model"] = 1,
        ["$translucent"] = 1,
        ["$alpha"] = 0.3,
        ["$nocull"] = 1,
        ["$ignorez"] = 1,
    })
    
    -- Flat material
    self.Materials.flat = CreateMaterial("ESPFlatMaterial", "UnlitGeneric", {
        ["$basetexture"] = "models/debug/debugwhite",
        ["$model"] = 1,
        ["$translucent"] = 1,
        ["$alpha"] = 0.5,
        ["$nocull"] = 1,
        ["$ignorez"] = 1,
    })
    
    -- Wireframe material
    self.Materials.wireframe = CreateMaterial("ESPWireframeMaterial", "VertexLitGeneric", {
        ["$basetexture"] = "models/debug/debugwhite",
        ["$wireframe"]    = 1,
        ["$ignorez"]      = 1,
    })
end

-- Initialize materials
ESP:CreateMaterials()


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

function ESP:DrawTextOutline(text, font, x, y, col, outlineCol, ax, ay)
    for _, offset in ipairs({{-1,-1},{1,-1},{1,1},{-1,1}}) do
        draw.SimpleText(text, font, x + offset[1], y + offset[2], outlineCol, ax, ay)
    end
    draw.SimpleText(text, font, x, y, col, ax, ay)
end

function ESP:GetPlayerColor(ent)
    local localPlayer = LocalPlayer()
    
    -- Check if visible
    local trace = util.TraceLine({
        start = localPlayer:EyePos(),
        endpos = ent:EyePos(),
        filter = {localPlayer, ent}
    })
    
    if trace.Fraction == 1 then
        return self.Config.VisibleColor
    end
    
    -- Check team
    if ent:Team() == localPlayer:Team() then
        return self.Config.TeamColor
    end
    
    return self.Config.EnemyColor
end

function ESP:CalculateFade(distance)
    if distance < self.Config.FadeDistance then
        return 1
    end
    
    local fadeRange = self.Config.MaxDistance - self.Config.FadeDistance
    local fadeAmount = (distance - self.Config.FadeDistance) / fadeRange
    return math.Clamp(1 - fadeAmount, 0, 1)
end

function ESP:DrawTracer(ent)
    if not self.Config.ShowTracers then return end
    
    local localPlayer = LocalPlayer()
    local startPos = localPlayer:EyePos():ToScreen()
    local endPos = ent:EyePos():ToScreen()
    
    if not endPos.visible then return end
    
    surface.SetDrawColor(self.Config.TracerColor)
    surface.DrawLine(startPos.x, startPos.y, endPos.x, endPos.y)
end

function ESP:DrawSkeleton(ent)
    if not self.Config.ShowSkeleton then return end
    
    for _, connection in ipairs(self.BoneConnections) do
        local bone1 = ent:LookupBone(connection[1])
        local bone2 = ent:LookupBone(connection[2])
        
        if not bone1 or not bone2 then continue end
        
        local pos1 = ent:GetBonePosition(bone1)
        local pos2 = ent:GetBonePosition(bone2)
        
        if not pos1 or not pos2 then continue end
        
        local screen1 = pos1:ToScreen()
        local screen2 = pos2:ToScreen()
        
        if screen1.visible and screen2.visible then
            surface.SetDrawColor(self.Config.SkeletonColor)
            surface.DrawLine(screen1.x, screen1.y, screen2.x, screen2.y)
        end
    end
end

-- Chams rendering
function ESP:DrawChams()
    if not self.Config.ChamsEnabled then return end
    
    for _, ply in ipairs(player.GetAll()) do
        if not self:ShouldDrawPlayer(ply) then continue end
        
        local color = self.Config.ChamsColor
        
        -- Check visibility for different colors
        local trace = util.TraceLine({
            start = LocalPlayer():EyePos(),
            endpos = ply:EyePos(),
            filter = {LocalPlayer(), ply}
        })
        
        if trace.Fraction == 1 then
            color = self.Config.ChamsColorVisible
        end
        
        -- Pulse effect
        if self.Config.ChamsStyle == "pulse" then
            local pulse = math.sin(CurTime() * self.Config.ChamsPulseSpeed) * 0.5 + 0.5
            color = Color(color.r, color.g, color.b, color.a * pulse)
        end
        
        -- Rainbow mode
        if self.Config.RainbowMode then
            local hue = (CurTime() * self.Config.RainbowSpeed * 50) % 360
            local rainbow = HSVToColor(hue, 1, 1)
            color = Color(rainbow.r, rainbow.g, rainbow.b, color.a)
        end
        
        -- Apply chams
        render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)
        render.SetBlend(color.a / 255)
        
        local material = self.Materials[self.Config.ChamsStyle] or self.Materials.glass
        render.MaterialOverride(material)
        
        ply:DrawModel()
        
        render.MaterialOverride()
        render.SetColorModulation(1, 1, 1)
        render.SetBlend(1)
    end
end

-- Skybox override
function ESP:ModifySkybox()
    if not self.Config.SkyboxOverride then return end
    
    local col = self.Config.SkyboxColor
    render.Clear(col.r, col.g, col.b, col.a, true, true)
end

-- Fog control
function ESP:ModifyFog()
    if not self.Config.FogOverride then return end
    
    render.FogMode(MATERIAL_FOG_LINEAR)
    render.FogStart(self.Config.FogStart)
    render.FogEnd(self.Config.FogEnd)
    render.FogMaxDensity(self.Config.FogDensity)
    
    local col = self.Config.FogColor
    render.FogColor(col.r, col.g, col.b)
end

-- Ambient lighting
function ESP:ModifyAmbientLight()
    if not self.Config.AmbientLightOverride then return end
    
    local col = self.Config.AmbientLightColor
    local intensity = self.Config.AmbientLightIntensity
    
    render.SetAmbientLight(
        col.r / 255 * intensity,
        col.g / 255 * intensity,
        col.b / 255 * intensity
    )
end

-- World color modulation
function ESP:ModifyWorldColors()
    if not self.Config.WorldColorModulation then return end
    
    local worldTint = self.Config.WorldColorTint
    local propTint = self.Config.PropColorTint
    
    return worldTint, propTint
end

-- Color temperature to RGB
function ESP:KelvinToRGB(kelvin)
    local temp = kelvin / 100
    local red, green, blue
    
    if temp <= 66 then
        red = 255
    else
        red = temp - 60
        red = 329.698727446 * (red ^ -0.1332047592)
        red = math.Clamp(red, 0, 255)
    end
    
    if temp <= 66 then
        green = temp
        green = 99.4708025861 * math.log(green) - 161.1195681661
    else
        green = temp - 60
        green = 288.1221695283 * (green ^ -0.0755148492)
    end
    green = math.Clamp(green, 0, 255)
    
    if temp >= 66 then
        blue = 255
    elseif temp <= 19 then
        blue = 0
    else
        blue = temp - 10
        blue = 138.5177312231 * math.log(blue) - 305.0447927307
        blue = math.Clamp(blue, 0, 255)
    end
    
    return Color(red, green, blue)
end

-- Atmosphere post-processing
function ESP:ApplyAtmosphere()
    if not self.Config.AtmosphereEnabled then return end
    
    local tab = {
        ["$pp_colour_brightness"] = self.Config.Brightness - 1,
        ["$pp_colour_contrast"] = self.Config.Contrast,
        ["$pp_colour_colour"] = self.Config.Saturation,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0,
    }
    
    -- Apply color temperature
    local tempColor = self:KelvinToRGB(self.Config.ColorTemperature)
    tab["$pp_colour_mulr"] = (tempColor.r / 255 - 1) * 0.2
    tab["$pp_colour_mulg"] = (tempColor.g / 255 - 1) * 0.2
    tab["$pp_colour_mulb"] = (tempColor.b / 255 - 1) * 0.2
    
    -- Vignette effect
    if self.Config.Vignette then
        tab["$pp_colour_fadein"] = 1 - self.Config.VignetteStrength
        tab["$pp_colour_fadeout"] = 0.5
    end
    
    DrawColorModify(tab)
    
    -- Bloom effect
    if self.Config.BloomEffect then
        DrawBloom(
            0.5,
            self.Config.BloomIntensity,
            9,
            9,
            1,
            1,
            1,
            1,
            1
        )
    end
    
    -- Chromatic aberration
    if self.Config.ChromaticAberration then
        local strength = self.Config.ChromaticStrength
        local offset = math.sin(CurTime()) * strength
        
        render.SetMaterial(Material("pp/stereoscopy"))
        render.DrawScreenQuadEx(
            -offset, 0,
            ScrW() + offset * 2, ScrH()
        )
    end
end

-- Bullet trajectory prediction
function ESP:DrawBulletPrediction(weapon)
    if not self.Config.BulletPrediction then return end
    if not IsValid(weapon) then return end
    
    local owner = weapon:GetOwner()
    if not IsValid(owner) then return end
    
    -- Get muzzle position
    local attachment = weapon:GetAttachment(1)
    if not attachment then return end
    
    local startPos = attachment.Pos
    local direction = owner:GetAimVector()
    
    -- Physics constants
    local gravity = Vector(0, 0, -600)
    local velocity = direction * 3000
    
    -- Draw predicted path
    local lastPos = startPos
    local timeStep = self.Config.BulletPredictionTime / self.Config.BulletPredictionSteps
    
    for i = 1, self.Config.BulletPredictionSteps do
        local t = i * timeStep
        local newPos = startPos + velocity * t + 0.5 * gravity * t * t
        
        local screen1 = lastPos:ToScreen()
        local screen2 = newPos:ToScreen()
        
        if screen1.visible and screen2.visible then
            -- Fade the line over distance
            local alpha = (1 - i / self.Config.BulletPredictionSteps) * self.Config.BulletPredictionColor.a
            surface.SetDrawColor(
                self.Config.BulletPredictionColor.r,
                self.Config.BulletPredictionColor.g,
                self.Config.BulletPredictionColor.b,
                alpha
            )
            surface.DrawLine(screen1.x, screen1.y, screen2.x, screen2.y)
        end
        
        lastPos = newPos
    end
end

function ESP:DrawBarrel(ent)
    if not self.Config.ShowBarrels then return end
    
    local weapon = ent:GetActiveWeapon()
    if not IsValid(weapon) then return end
    
    local attachment = weapon:GetAttachment(1)
    if not attachment then return end
    
    local startPos = attachment.Pos:ToScreen()
    local endPos = (attachment.Pos + attachment.Ang:Forward() * 50):ToScreen()
    
    if startPos.visible and endPos.visible then
        surface.SetDrawColor(self.Config.BarrelColor)
        surface.DrawLine(startPos.x, startPos.y, endPos.x, endPos.y)
    end
end

function ESP:DrawSnapLine(ent)
    if not self.Config.ShowSnapLines then return end
    
    local pos = ent:EyePos():ToScreen()
    if not pos.visible then return end
    
    local screenW = ScrW()
    local screenH = ScrH()
    
    surface.SetDrawColor(self.Config.SnapLineColor)
    surface.DrawLine(pos.x, pos.y, screenW / 2, screenH)
end

function ESP:ShouldDrawPlayer(ent)
    if not ent:IsPlayer() then return false end
    if not ent:Alive() then return false end
    if ent == LocalPlayer() then return false end
    if ent:IsDormant() then return false end
    
    local distance = LocalPlayer():GetPos():Distance(ent:GetPos())
    if distance > self.Config.MaxDistance then return false end
    
    if not self.Config.ShowTeammates and ent:Team() == LocalPlayer():Team() then
        return false
    end
    
    return true
end

function ESP:DrawTarget(ent)
    if not self:ShouldDrawPlayer(ent) then return end

    local x,y,w,h = self:GetOBBBounds(ent)
    if not x then return end
    
    local distance = LocalPlayer():GetPos():Distance(ent:GetPos())
    local fade = self:CalculateFade(distance)
    
    -- Get dynamic color
    local boxColor = self:GetPlayerColor(ent)
    boxColor.a = boxColor.a * fade

    -- Expand bounds
    local m  = self.Config.BoxMargin
    local bx, by, bw, bh = x - m, y - m, w + 2*m, h + 2*m

    -- Fill interior
    local fillColor = Color(
        self.Config.BoxFillColor.r,
        self.Config.BoxFillColor.g,
        self.Config.BoxFillColor.b,
        self.Config.BoxFillColor.a * fade
    )
    surface.SetDrawColor(fillColor)
    surface.DrawRect(bx, by, bw, bh)

    -- Outer outline
    local outlineColor = Color(
        self.Config.OutlineColor.r,
        self.Config.OutlineColor.g,
        self.Config.OutlineColor.b,
        self.Config.OutlineColor.a * fade
    )
    surface.SetDrawColor(outlineColor)
    for i = 0, self.Config.OutlineThickness - 1 do
        surface.DrawOutlinedRect(bx - i, by - i, bw + 2*i, bh + 2*i)
    end

    -- Main box stroke
    surface.SetDrawColor(boxColor)
    surface.DrawOutlinedRect(bx, by, bw, bh)

    -- Health bar background
    local hbX = bx - self.Config.HealthBarWidth - self.Config.Padding
    local healthBgColor = Color(
        self.Config.HealthBgColor.r,
        self.Config.HealthBgColor.g,
        self.Config.HealthBgColor.b,
        self.Config.HealthBgColor.a * fade
    )
    surface.SetDrawColor(healthBgColor)
    surface.DrawRect(hbX, by, self.Config.HealthBarWidth, bh)

    -- Health fill
    local frac  = math.Clamp(ent:Health() / ent:GetMaxHealth(), 0, 1)
    local fillH = bh * frac
    local fillY = by + (bh - fillH)
    local healthColor = Color(
        self.Config.HealthColor.r,
        self.Config.HealthColor.g,
        self.Config.HealthColor.b,
        self.Config.HealthColor.a * fade
    )
    surface.SetDrawColor(healthColor)
    surface.DrawRect(hbX, fillY, self.Config.HealthBarWidth, fillH)

    -- Armor bar (if enabled)
    if self.Config.ShowArmor and ent:Armor() > 0 then
        local abX = bx + bw + self.Config.Padding
        surface.SetDrawColor(healthBgColor)
        surface.DrawRect(abX, by, self.Config.HealthBarWidth, bh)
        
        local armorFrac = math.Clamp(ent:Armor() / 100, 0, 1)
        local armorFillH = bh * armorFrac
        local armorFillY = by + (bh - armorFillH)
        local armorColor = Color(
            self.Config.ArmorColor.r,
            self.Config.ArmorColor.g,
            self.Config.ArmorColor.b,
            self.Config.ArmorColor.a * fade
        )
        surface.SetDrawColor(armorColor)
        surface.DrawRect(abX, armorFillY, self.Config.HealthBarWidth, armorFillH)
    end

    -- Text with fade
    local textColor = Color(
        self.Config.TextColor.r,
        self.Config.TextColor.g,
        self.Config.TextColor.b,
        self.Config.TextColor.a * fade
    )
    local textOutlineColor = Color(
        self.Config.TextOutlineColor.r,
        self.Config.TextOutlineColor.g,
        self.Config.TextOutlineColor.b,
        self.Config.TextOutlineColor.a * fade
    )

    -- Health number
    local healthTextX = hbX + self.Config.HealthBarWidth + self.Config.Padding
    local healthTextY = fillY - self.Config.Padding
    self:DrawTextOutline(
        tostring(ent:Health()),
        self.Config.FontName,
        healthTextX,
        healthTextY,
        textColor,
        textOutlineColor,
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_BOTTOM
    )

    -- Name
    self:DrawTextOutline(
        ent:Nick(),
        self.Config.FontName,
        bx + bw * 0.5,
        by - self.Config.FontSize - self.Config.Padding,
        textColor,
        textOutlineColor,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_TOP
    )

    -- Distance
    local dist = math.floor(distance / 52)
    self:DrawTextOutline(
        dist .. "m",
        self.Config.FontName,
        bx + bw + self.Config.Padding,
        by,
        textColor,
        textOutlineColor,
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
            textColor,
            textOutlineColor,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_TOP
        )
    end
    
    -- Draw additional features
    self:DrawTracer(ent)
    self:DrawSkeleton(ent)
    self:DrawBarrel(ent)
    self:DrawSnapLine(ent)
end

-- Console commands for toggling features
concommand.Add("esp_toggle", function()
    ESP.Config.Enabled = not ESP.Config.Enabled
    print("ESP " .. (ESP.Config.Enabled and "enabled" or "disabled"))
end)

concommand.Add("esp_tracers", function()
    ESP.Config.ShowTracers = not ESP.Config.ShowTracers
    print("Tracers " .. (ESP.Config.ShowTracers and "enabled" or "disabled"))
end)

concommand.Add("esp_skeleton", function()
    ESP.Config.ShowSkeleton = not ESP.Config.ShowSkeleton
    print("Skeleton " .. (ESP.Config.ShowSkeleton and "enabled" or "disabled"))
end)

concommand.Add("esp_teammates", function()
    ESP.Config.ShowTeammates = not ESP.Config.ShowTeammates
    print("Teammates " .. (ESP.Config.ShowTeammates and "enabled" or "disabled"))
end)

concommand.Add("esp_snaplines", function()
    ESP.Config.ShowSnapLines = not ESP.Config.ShowSnapLines
    print("Snap lines " .. (ESP.Config.ShowSnapLines and "enabled" or "disabled"))
end)

concommand.Add("esp_chams", function()
    ESP.Config.ChamsEnabled = not ESP.Config.ChamsEnabled
    print("Chams " .. (ESP.Config.ChamsEnabled and "enabled" or "disabled"))
end)

concommand.Add("esp_chams_style", function(ply, cmd, args)
    local style = args[1] or "glass"
    if ESP.Materials[style] then
        ESP.Config.ChamsStyle = style
        print("Chams style set to: " .. style)
    else
        print("Available styles: glass, flat, wireframe, pulse")
    end
end)

concommand.Add("esp_atmosphere", function()
    ESP.Config.AtmosphereEnabled = not ESP.Config.AtmosphereEnabled
    print("Atmosphere effects " .. (ESP.Config.AtmosphereEnabled and "enabled" or "disabled"))
end)

concommand.Add("esp_rainbow", function()
    ESP.Config.RainbowMode = not ESP.Config.RainbowMode
    print("Rainbow mode " .. (ESP.Config.RainbowMode and "enabled" or "disabled"))
end)

concommand.Add("esp_brightness", function(ply, cmd, args)
    local val = tonumber(args[1]) or 1
    ESP.Config.Brightness = math.Clamp(val, 0.5, 2)
    print("Brightness set to: " .. ESP.Config.Brightness)
end)

concommand.Add("esp_temp", function(ply, cmd, args)
    local val = tonumber(args[1]) or 6500
    ESP.Config.ColorTemperature = math.Clamp(val, 1000, 12000)
    print("Color temperature set to: " .. ESP.Config.ColorTemperature .. "K")
end)

-- Hooks for rendering
hook.Add("PreDrawHUD", "ESPVisualEffects", function()
    ESP:ModifySkybox()
    ESP:ModifyFog()
    ESP:ModifyAmbientLight()
end)

hook.Add("PreDrawTranslucentRenderables", "ESPChams", function()
    ESP:DrawChams()
end)

hook.Add("RenderScreenspaceEffects", "ESPAtmosphere", function()
    ESP:ApplyAtmosphere()
end)

-- Bullet prediction in its own hook
hook.Add("HUDPaint", "ESP_BulletPrediction", function()
    local wep = LocalPlayer():GetActiveWeapon()
    ESP:DrawBulletPrediction(wep)
end)

-- Main ESP draw (boxes, skeleton, tracers, etc.)
hook.Add("HUDPaint", "ESP_MainDraw", function()
    if not ESP.Config.Enabled then return end
    for _, p in ipairs(player.GetAll()) do
        ESP:DrawTarget(p)
    end
end)

-- Entity color modulation
hook.Add("PreDrawOpaqueRenderables", "ESPWorldColors", function()
    if not ESP.Config.WorldColorModulation then return end
    
    local worldTint, propTint = ESP:ModifyWorldColors()
    
    for _, ent in ipairs(ents.GetAll()) do
        if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_dynamic" then
            local col = propTint
            ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
            ent:SetColor(Color(col.r, col.g, col.b, 255))
        end
    end
end)
