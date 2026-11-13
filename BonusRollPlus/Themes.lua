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
Add("fel", "Fel", "Fel angular", {
    layout = "stack", font = F_ARIAL, bg = "#0C1A0A", border = "#7DFF3A", borderA = 0.7, ink = "#E6FFD6", sub = "#A8D98A",
    bfill = "#7DFF3A", bfa = 0.07, bborder = "#7DFF3A", bba = 0.35, sel = "#3BA10F", sela = 0.88, selInk = "#FFFFFF",
    bar = "#5FE01F", track = "#7DFF3A", tracka = 0.15, shine = 0.05,
    orn = function(w, h) return { { op = "rect", x = 0, y = 0, w = 4, h = h, c = "#7DFF3A", a = 0.85 } } end,
})
Add("blood", "Blood", "Sangre", {
    layout = "rail", font = F_MORPH, bg = "#240810", border = "#C4161F", ink = "#FFE4E4", sub = "#E8A9A9",
    bfill = "#C4161F", bfa = 0.16, bborder = "#FF5050", bba = 0.45, sel = "#E0232D", sela = 0.92, selInk = "#FFFFFF",
    bar = "#E0232D", track = "#000000", tracka = 0.5, shine = 0.05,
    orn = function(w, h) return { { op = "rect", x = 0, y = h - 3, w = w, h = 3, c = "#E0232D", a = 1 } } end,
})
Add("tavern", "Tavern", "Taberna", {
    layout = "grid", font = F_FRIZ, bg = "#4F3219", border = "#2A1A0A", bth = 2, ink = "#F4E4C4", sub = "#E8D3A8",
    bfill = "#000000", bfa = 0.28, bborder = "#2A1A0A", bba = 1, sel = "#D9A441", sela = 0.92, selInk = "#2A1A05",
    bar = "#D9A441", track = "#2A1A0A", tracka = 0.9, shine = 0.05,
    orn = function(w, h) return {
        { op = "row", x = 22, y = 0, n = 13, dx = 22, dy = 0, w = 2, h = h, c = "#3A2410", a = 0.7 },
        { op = "outline", x = 2, y = 2, w = w - 4, h = h - 4, th = 2, c = "#8E6319", a = 1 },
        { op = "circle", x = 9, y = h - 9, size = 8, c = "#FFE9B0", a = 0.9 }, { op = "circle", x = w - 9, y = h - 9, size = 8, c = "#FFE9B0", a = 0.9 },
    } end,
})
Add("minimal", "Dark Minimal", "Minimal oscuro", {
    layout = "row", font = F_ARIAL, bg = "#0E0E12", bgA = 0.94, border = "#2A2A33", ink = "#FFFFFF", sub = "#8A8A96",
    bfill = "#FFFFFF", bfa = 0.03, bborder = "#2A2A33", bba = 1, sel = "#FFFFFF", sela = 0.14, selInk = "#FFFFFF",
    bar = "#FFFFFF", track = "#2A2A33", tracka = 1, shine = 0,
})
Add("neon", "Arcane Neon", "Neón arcano", {
    layout = "ring", font = F_ARIAL, bg = "#040C18", bgA = 0.94, border = "#19F0FF", ink = "#CFFBFF", sub = "#7FDFE8",
    bfill = "#19F0FF", bfa = 0.08, bborder = "#19F0FF", bba = 1, sel = "#19F0FF", sela = 0.35, selInk = "#FFFFFF",
    bar = "#19F0FF", track = "#0C2A3A", tracka = 1, shine = 0.04, spark = true,
    orn = function(w, h) return { { op = "outline", x = 3, y = 3, w = w - 6, h = h - 6, th = 1, c = "#19F0FF", a = 0.25 } } end,
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
Add("nature", "Nature", "Naturaleza", {
    layout = "grid", font = F_FRIZ, bg = "#2B3A18", border = "#8FB04A", ink = "#F1FFD6", sub = "#D3E6A8",
    bfill = "#B4DC64", bfa = 0.1, bborder = "#B4DC64", bba = 0.4, sel = "#A6CF4A", sela = 0.88, selInk = "#10200A",
    bar = "#A6CF4A", track = "#000000", tracka = 0.4, shine = 0.06,
    orn = function(w, h) return { { op = "circle", x = w - 30, y = h - 20, size = 90, c = "#A6CF4A", a = 0.11 }, { op = "circle", x = 20, y = 20, size = 60, c = "#B4DC64", a = 0.08 } } end,
})
Add("mist", "Mist", "Bruma", {
    layout = "rail", font = F_MORPH, bg = "#0E0E16", bgA = 0.95, border = "#3A3A4C", ink = "#EDEDF7", sub = "#8C8CA6",
    bfill = "#FFFFFF", bfa = 0.05, bborder = "#FFFFFF", bba = 0.12, sel = "#FFFFFF", sela = 0.18, selInk = "#FFFFFF",
    bar = "#C9C9E6", track = "#1D1D28", tracka = 1, shine = 0.02,
    orn = function(w, h) return { { op = "circle", x = 90, y = 0, size = 240, c = "#5A5A8A", a = 0.16 } } end,
})
Add("hologram", "Hologram", "Holograma", {
    layout = "row", font = F_ARIAL, bg = "#00283C", bgA = 0.82, border = "#3DE8FF", ink = "#D6FBFF", sub = "#8AE8F5",
    bfill = "#3DE8FF", bfa = 0.07, bborder = "#3DE8FF", bba = 0.35, sel = "#3DE8FF", sela = 0.35, selInk = "#FFFFFF",
    bar = "#3DE8FF", track = "#0A4A5A", blocks = true, shine = 0.03,
    orn = function(w, h) return { { op = "row", x = 0, y = 1, n = math.floor(h / 4), dx = 0, dy = 4, w = w, h = 1, c = "#FFFFFF", a = 0.05 } } end,
})
Add("banner", "Banner", "Estandarte", {
    layout = "grid", font = F_FRIZ, bg = "#1F1A28", border = "#4A4158", ink = "#EDE6FA", sub = "#B1A8C6",
    bfill = "#FFFFFF", bfa = 0.06, bborder = "#FFFFFF", bba = 0.16, sel = "#5A8BD6", sela = 0.88, selInk = "#FFFFFF",
    bar = "#5A8BD6", track = "#FFFFFF", tracka = 0.14, shine = 0.06,
    orn = function(w, h) return { { op = "rect", x = 0, y = 0, w = w, h = 4, c = "#5A8BD6", a = 1 } } end,
})
Add("holy", "Holy Light", "Luz sagrada", {
    layout = "ring", font = F_MORPH, bg = "#F3E2AE", border = "#D9A93A", bth = 2, ink = "#4A3205", sub = "#7A5A14",
    bfill = "#D9A93A", bfa = 0.22, bborder = "#D9A93A", bba = 1, sel = "#FFE58A", sela = 0.95, selInk = "#4A3205",
    bar = "#E0A92A", track = "#7A5A14", tracka = 0.25, shine = 0.25,
    orn = function(w, h) return { { op = "circle", x = 150, y = 0, size = 220, c = "#FFFFFF", a = 0.28 } } end,
})
Add("leather", "Stitched Leather", "Cuero cosido", {
    layout = "stack", font = F_MORPH, bg = "#4A3220", border = "#25160A", bth = 2, ink = "#F4E6CE", sub = "#DFC3A0",
    bfill = "#000000", bfa = 0.26, bborder = "#25160A", bba = 1, sel = "#B9672A", sela = 0.92, selInk = "#FFFFFF",
    bar = "#E8A060", track = "#25160A", tracka = 0.9, shine = 0.05,
    orn = function(w, h) return {
        { op = "row", x = 8, y = 7, n = 36, dx = 8, dy = 0, w = 4, h = 1, c = "#C99A62", a = 0.75 },
        { op = "row", x = 8, y = h - 8, n = 36, dx = 8, dy = 0, w = 4, h = 1, c = "#C99A62", a = 0.75 },
        { op = "grain", n = 90, c = "#000000", a = 0.08 },
    } end,
})

ns.ThemeDefs = D
