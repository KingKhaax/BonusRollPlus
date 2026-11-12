local ADDON, ns = ...

local STRINGS = {
    enUS = {
        TITLE = "Rolls",
        NO_ITEMS = "no equipped items were found to preview.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | reset | version. Shift+drag a window to move it.",
        VERSION_OUTDATED = "You have version %s and version %s is available on CurseForge.",
    },
    esES = {
        TITLE = "Tiradas",
        NO_ITEMS = "no se encontraron objetos equipados para la vista previa.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | reset | version. Mayús + arrastrar para mover una ventana.",
        VERSION_OUTDATED = "Tienes la versión %s y está disponible la versión %s en CurseForge.",
    },
    esMX = {
        TITLE = "Tiradas",
        NO_ITEMS = "no se encontraron objetos equipados para la vista previa.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | reset | version. Mayús + arrastrar para mover una ventana.",
        VERSION_OUTDATED = "Tienes la versión %s y está disponible la versión %s en CurseForge.",
    },
    deDE = {
        TITLE = "Würfe",
        NO_ITEMS = "Keine angelegten Gegenstände für die Vorschau gefunden.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | reset | version. Umschalt + Ziehen verschiebt ein Fenster.",
        VERSION_OUTDATED = "Du hast Version %s, und Version %s ist auf CurseForge verfügbar.",
    },
    frFR = {
        TITLE = "Jets",
        NO_ITEMS = "aucun objet équipé trouvé pour l'aperçu.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | reset | version. Maj + glisser pour déplacer une fenêtre.",
        VERSION_OUTDATED = "Vous avez la version %s et la version %s est disponible sur CurseForge.",
    },
    itIT = {
        TITLE = "Tiri",
        NO_ITEMS = "nessun oggetto equipaggiato trovato per l'anteprima.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | reset | version. Maiusc + trascina per spostare una finestra.",
        VERSION_OUTDATED = "Hai la versione %s e la versione %s è disponibile su CurseForge.",
    },
    ptBR = {
        TITLE = "Rolagens",
        NO_ITEMS = "nenhum item equipado foi encontrado para a pré-visualização.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | reset | version. Shift + arrastar move uma janela.",
        VERSION_OUTDATED = "Você está com a versão %s e a versão %s está disponível no CurseForge.",
    },
    ruRU = {
        TITLE = "Броски",
        NO_ITEMS = "для предпросмотра не найдено экипированных предметов.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | reset | version. Shift + перетаскивание перемещает окно.",
        VERSION_OUTDATED = "У вас версия %s, а на CurseForge доступна версия %s.",
    },
    koKR = {
        TITLE = "주사위",
        NO_ITEMS = "미리 볼 장착 아이템을 찾을 수 없습니다.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | reset | version. Shift + 드래그로 창을 이동합니다.",
        VERSION_OUTDATED = "현재 버전은 %s이며, CurseForge에서 %s 버전을 사용할 수 있습니다.",
    },
    zhCN = {
        TITLE = "掷骰",
        NO_ITEMS = "未找到可用于预览的已装备物品。",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | reset | version。按住 Shift 并拖动可移动窗口。",
        VERSION_OUTDATED = "你当前的版本是 %s，CurseForge 上有新版本 %s 可用。",
    },
    zhTW = {
        TITLE = "擲骰",
        NO_ITEMS = "找不到可預覽的已裝備物品。",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | reset | version。按住 Shift 並拖曳可移動視窗。",
        VERSION_OUTDATED = "你目前的版本是 %s，CurseForge 上有新版本 %s 可用。",
    },
}

local locale = GetLocale and GetLocale() or "enUS"
local base = STRINGS.enUS
local chosen = STRINGS[locale] or base

ns.L = setmetatable({}, { __index = function(_, key) return chosen[key] or base[key] or key end })
ns.locale = STRINGS[locale] and locale or "enUS"
ns.Strings = STRINGS
