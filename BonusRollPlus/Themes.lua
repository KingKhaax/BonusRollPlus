local ADDON, ns = ...

local F_FRIZ = "Fonts\\FRIZQT__.TTF"
local F_MORPH = "Fonts\\MORPHEUS.TTF"
local F_ARIAL = "Fonts\\ARIALN.TTF"

local function Cells(layout)
    local c, h, timerY, bindY = {}, 250, 208, 226
    if layout == "grid" then
        c = { { 18, 96, 126, 44 }, { 156, 96, 126, 44 }, { 18, 148, 126, 44 }, { 156, 148, 126, 44 } }
    elseif layout == "split" then
        c = { { 18, 92, 126, 60 }, { 156, 92, 126, 60 }, { 18, 160, 126, 32 }, { 156, 160, 126, 32 } }
    elseif layout == "row" then
        c = { { 18, 94, 60, 62 }, { 86, 94, 60, 62 }, { 154, 94, 60, 62 }, { 222, 94, 60, 62 } }
        h, timerY, bindY = 214, 176, 192
    elseif layout == "stack" then
        c = { { 18, 92, 264, 28 }, { 18, 123, 264, 28 }, { 18, 154, 264, 28 }, { 18, 185, 264, 28 } }
        h, timerY, bindY = 262, 226, 242
    elseif layout == "ring" then
        c = { { 27, 94, 48, 48 }, { 93, 94, 48, 48 }, { 159, 94, 48, 48 }, { 225, 94, 48, 48 } }
        h, timerY, bindY = 220, 182, 198
    else
        c = { { 18, 94, 60, 44 }, { 86, 94, 60, 44 }, { 154, 94, 60, 44 }, { 222, 94, 60, 44 } }
        h, timerY, bindY = 198, 160, 176
    end
    return c, h, timerY, bindY
end

local function Make(id, title, titleES, p)
    local cells, h, timerY, bindY = Cells(p.layout)
    local ops = {
        { op = "rect", c = p.bg, a = p.bgA or 1 },
        { op = "grad", w = 300, h = 90, dir = "VERTICAL", c1 = "#FFFFFF", a1 = 0, c2 = p.shineC or "#FFFFFF", a2 = p.shine or 0.1 },
        { op = "outline", w = 300, h = h, th = p.bth or 1, c = p.border, a = p.borderA or 1 },
    }
    if p.orn then
        for _, o in ipairs(p.orn(300, h)) do ops[#ops + 1] = o end
    end
    local label, labelSize = "inside", 13
    if p.layout == "row" then label, labelSize = "stack", 9
    elseif p.layout == "ring" then label, labelSize = "below", 10
    elseif p.layout == "rail" then label = "none" end
    local fill = {}
    for _, k in ipairs({ "need", "greed", "de", "pass" }) do fill[k] = p.bfill end
    local btn = {
        shape = p.layout == "ring" and "circle" or "rect", label = label, iconSize = p.layout == "ring" and 26 or 24,
        labelFont = p.font, labelSize = labelSize, ink = p.ink, upper = p.upper,
        cells = cells, fill = fill, fillA = p.bfa, border = p.bborder, borderA = p.bba, th = p.layout == "ring" and 2 or (p.bbth or 1),
        sel = p.sel, selA = p.sela, selInk = p.selInk, shade = p.shade,
    }
    local timer
    if p.blocks then
        timer = { kind = "blocks", x = 18, y = timerY, w = 264, h = 6, n = 22, gap = 3, fill = p.bar, dim = p.track }
    else
        timer = { kind = "bar", x = 18, y = timerY, w = 264, h = 6, fill = p.bar, track = p.track, trackA = p.tracka or 0.4, spark = p.spark }
    end
    return {
        id = id, title = title, titleES = titleES, w = 300, h = h, ops = ops,
        icon = { x = 18, y = 18, size = 56, ring = 2, bgA = 0.4 },
        name = { x = 86, y = 20, w = 196, font = p.font, size = p.nameSize or 16, color = "q", flags = "OUTLINE", lines = 2, upper = p.upper },
        piece = { x = 86, y = 58, w = 196, font = p.font, size = 12, color = p.sub },
        bind = { x = 18, y = bindY, w = 264, font = p.font, size = 11, color = p.sub },
        btn = btn, timer = timer,
        panel = { style = "flat", bg = p.bg, bgA = 0.88, border = p.border, borderA = p.borderA or 1, th = 1, ink = p.ink, hi = p.sel, title = p.sub, titleBg = p.border, titleBgA = 0.16, font = p.font, dx = 8, y = 0 },
    }
end

local D = {}
local function Add(...) D[#D + 1] = Make(...) end

Add("parchment", "Arcane Parchment", "Pergamino arcano", {
    layout = "grid", font = F_MORPH, bg = "#D4BC88", border = "#6B4A1D", bth = 2, ink = "#2B1A07", sub = "#5A3F17",
    bfill = "#6B4A1D", bfa = 0.14, bborder = "#8A6A30", bba = 0.9, sel = "#7A2E1C", sela = 0.92, selInk = "#FFE7B8",
    bar = "#7A2E1C", track = "#3C280A", tracka = 0.3, shine = 0.22,
    orn = function(w, h) return { { op = "outline", x = 5, y = 5, w = w - 10, h = h - 10, th = 1, c = "#6B4A1D", a = 0.6 } } end,
})
Add("forge", "Steel Forge", "Forja de acero", {
    layout = "split", font = F_ARIAL, bg = "#2E3036", border = "#6C7078", bth = 2, ink = "#E8E8EC", sub = "#B6BAC2", upper = true,
    bfill = "#454851", bfa = 0.9, bborder = "#555A63", bba = 1, sel = "#D9731C", sela = 0.88, selInk = "#FFFFFF",
    bar = "#FF8A2A", track = "#14161A", tracka = 0.9, shine = 0.08,
    orn = function(w, h) return {
        { op = "outline", x = 3, y = 3, w = w - 6, h = h - 6, th = 1, c = "#555A63", a = 1 },
        { op = "circle", x = 9, y = 9, size = 7, c = "#B6BAC2", a = 0.95 }, { op = "circle", x = w - 9, y = 9, size = 7, c = "#B6BAC2", a = 0.95 },
        { op = "circle", x = 9, y = h - 9, size = 7, c = "#B6BAC2", a = 0.95 }, { op = "circle", x = w - 9, y = h - 9, size = 7, c = "#B6BAC2", a = 0.95 },
    } end,
})
Add("void", "Violet Void", "Vacío violeta", {
    layout = "row", font = F_FRIZ, bg = "#1A0A38", border = "#8F4BFF", borderA = 0.9, ink = "#FFFFFF", sub = "#CBB2FF",
    bfill = "#8F4BFF", bfa = 0.14, bborder = "#B478FF", bba = 0.45, sel = "#8F4BFF", sela = 0.85, selInk = "#FFFFFF",
    bar = "#A45CFF", track = "#8F4BFF", tracka = 0.2, shine = 0.06, spark = true,
    orn = function(w, h) return {
        { op = "circle", x = 262, y = 28, size = 150, c = "#C88CFF", a = 0.16 }, { op = "circle", x = 30, y = h - 20, size = 100, c = "#6A2CD8", a = 0.2 },
    } end,
})
Add("goldchest", "Gold Chest", "Cofre dorado", {
    layout = "split", font = F_MORPH, bg = "#2A1D0B", border = "#E3B341", bth = 2, ink = "#F4E3B0", sub = "#E8CF8F",
    bfill = "#E3B341", bfa = 0.09, bborder = "#E3B341", bba = 0.45, sel = "#E3B341", sela = 0.88, selInk = "#2A1B02",
    bar = "#E3B341", track = "#000000", tracka = 0.5, shine = 0.07,
    orn = function(w, h) return { { op = "outline", x = 4, y = 4, w = w - 8, h = h - 8, th = 1, c = "#8A6513", a = 1 } } end,
})
Add("runestone", "Runic Stone", "Piedra rúnica", {
    layout = "grid", font = F_FRIZ, bg = "#3A3A3E", border = "#18181A", bth = 2, ink = "#E6E6EA", sub = "#B8B8BE",
    bfill = "#55555B", bfa = 0.9, bborder = "#1D1D20", bba = 1, bbth = 2, shade = true, sel = "#2FB2D6", sela = 0.6, selInk = "#D9FBFF",
    bar = "#2FB2D6", track = "#17171A", tracka = 0.9, shine = 0.08,
    orn = function(w, h) return { { op = "grain", n = 140, c = "#FFFFFF", a = 0.035 } } end,
})
Add("frost", "Frost", "Escarcha", {
    layout = "ring", font = F_FRIZ, bg = "#2D5A92", bgA = 0.88, border = "#D6F1FF", borderA = 0.85, ink = "#FFFFFF", sub = "#DDF3FF",
    bfill = "#FFFFFF", bfa = 0.2, bborder = "#FFFFFF", bba = 0.6, sel = "#E9F9FF", sela = 0.9, selInk = "#FFFFFF",
    bar = "#E9F9FF", track = "#FFFFFF", tracka = 0.25, shine = 0.22,
    orn = function(w, h) return { { op = "circle", x = w - 20, y = h - 20, size = 70, c = "#FFFFFF", a = 0.12 } } end,
})
Add("minimal", "Dark Minimal", "Minimal oscuro", {
    layout = "row", font = F_ARIAL, bg = "#0E0E12", bgA = 0.94, border = "#2A2A33", ink = "#FFFFFF", sub = "#8A8A96",
    bfill = "#FFFFFF", bfa = 0.03, bborder = "#2A2A33", bba = 1, sel = "#FFFFFF", sela = 0.14, selInk = "#FFFFFF",
    bar = "#FFFFFF", track = "#2A2A33", tracka = 1, shine = 0,
})
Add("alliance", "Alliance", "Alianza", {
    layout = "split", font = F_MORPH, bg = "#122A5C", border = "#E6C35A", bth = 2, ink = "#EEF3FF", sub = "#C8D6FF",
    bfill = "#FFFFFF", bfa = 0.08, bborder = "#E6C35A", bba = 0.5, sel = "#F0D067", sela = 0.92, selInk = "#10224A",
    bar = "#E6C35A", track = "#000000", tracka = 0.5, shine = 0.1,
    orn = function(w, h) return {
        { op = "outline", x = 4, y = 4, w = w - 8, h = h - 8, th = 1, c = "#E6C35A", a = 0.4 },
        { op = "rect", x = 120, y = 0, w = 60, h = 3, c = "#E6C35A", a = 1 },
    } end,
})
Add("horde", "Horde", "Horda", {
    layout = "stack", font = F_ARIAL, bg = "#1C0A0A", border = "#7A1313", ink = "#FFE6D8", sub = "#D9A88F", upper = true,
    bfill = "#FFFFFF", bfa = 0.04, bborder = "#4A1A1A", bba = 1, sel = "#B81D1D", sela = 0.92, selInk = "#FFFFFF",
    bar = "#FF6B3D", track = "#000000", tracka = 0.5, shine = 0.04,
    orn = function(w, h) return { { op = "rect", x = 0, y = 0, w = 6, h = h, c = "#B81D1D", a = 1 }, { op = "rect", x = w - 6, y = 0, w = 6, h = h, c = "#B81D1D", a = 1 } } end,
})

ns.ThemeDefs = D
