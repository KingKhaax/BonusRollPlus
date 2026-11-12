local ADDON, ns = ...

local STRINGS = {
    enUS = {
        TITLE = "Rolls",
        NO_ITEMS = "no equipped items were found to preview.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | lock | reset | version. Drag a window to move it; the padlock fixes it.",
        UNLOCKED_TIP = "Window unlocked: drag to move it. Click to lock it.",
        LOCKED_TIP = "Window locked. Click to unlock it.",
        VERSION_OUTDATED = "You have version %s and version %s is available on CurseForge.",
    },
    esES = {
        TITLE = "Tiradas",
        NO_ITEMS = "no se encontraron objetos equipados para la vista previa.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | lock | reset | version. Arrastra una ventana para moverla; el candado la fija.",
        UNLOCKED_TIP = "Ventana desbloqueada: arrástrala para moverla. Clic para fijarla.",
        LOCKED_TIP = "Ventana fija. Clic para desbloquearla.",
        VERSION_OUTDATED = "Tienes la versión %s y está disponible la versión %s en CurseForge.",
    },
    esMX = {
        TITLE = "Tiradas",
        NO_ITEMS = "no se encontraron objetos equipados para la vista previa.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | lock | reset | version. Arrastra una ventana para moverla; el candado la fija.",
        UNLOCKED_TIP = "Ventana desbloqueada: arrástrala para moverla. Clic para fijarla.",
        LOCKED_TIP = "Ventana fija. Clic para desbloquearla.",
        VERSION_OUTDATED = "Tienes la versión %s y está disponible la versión %s en CurseForge.",
    },
    deDE = {
        TITLE = "Würfe",
        NO_ITEMS = "Keine angelegten Gegenstände für die Vorschau gefunden.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | lock | reset | version. Ziehe ein Fenster, um es zu verschieben; das Schloss fixiert es.",
        UNLOCKED_TIP = "Fenster entsperrt: zum Verschieben ziehen. Klicken zum Sperren.",
        LOCKED_TIP = "Fenster gesperrt. Klicken zum Entsperren.",
        VERSION_OUTDATED = "Du hast Version %s, und Version %s ist auf CurseForge verfügbar.",
    },
    frFR = {
        TITLE = "Jets",
        NO_ITEMS = "aucun objet équipé trouvé pour l'aperçu.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | lock | reset | version. Faites glisser une fenêtre pour la déplacer ; le cadenas la fixe.",
        UNLOCKED_TIP = "Fenêtre déverrouillée : faites-la glisser pour la déplacer. Clic pour la verrouiller.",
        LOCKED_TIP = "Fenêtre verrouillée. Clic pour la déverrouiller.",
        VERSION_OUTDATED = "Vous avez la version %s et la version %s est disponible sur CurseForge.",
    },
    itIT = {
        TITLE = "Tiri",
        NO_ITEMS = "nessun oggetto equipaggiato trovato per l'anteprima.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | lock | reset | version. Trascina una finestra per spostarla; il lucchetto la blocca.",
        UNLOCKED_TIP = "Finestra sbloccata: trascinala per spostarla. Clic per bloccarla.",
        LOCKED_TIP = "Finestra bloccata. Clic per sbloccarla.",
        VERSION_OUTDATED = "Hai la versione %s e la versione %s è disponibile su CurseForge.",
    },
    ptBR = {
        TITLE = "Rolagens",
        NO_ITEMS = "nenhum item equipado foi encontrado para a pré-visualização.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | lock | reset | version. Arraste uma janela para movê-la; o cadeado a fixa.",
        UNLOCKED_TIP = "Janela desbloqueada: arraste para movê-la. Clique para fixá-la.",
        LOCKED_TIP = "Janela fixa. Clique para desbloqueá-la.",
        VERSION_OUTDATED = "Você está com a versão %s e a versão %s está disponível no CurseForge.",
    },
    ruRU = {
        TITLE = "Броски",
        NO_ITEMS = "для предпросмотра не найдено экипированных предметов.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | lock | reset | version. Перетащите окно, чтобы переместить его; замок закрепляет его.",
        UNLOCKED_TIP = "Окно разблокировано: перетащите его. Нажмите, чтобы закрепить.",
        LOCKED_TIP = "Окно закреплено. Нажмите, чтобы открепить.",
        VERSION_OUTDATED = "У вас версия %s, а на CurseForge доступна версия %s.",
    },
    koKR = {
        TITLE = "주사위",
        NO_ITEMS = "미리 볼 장착 아이템을 찾을 수 없습니다.",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | lock | reset | version. 창을 드래그해 이동하고, 자물쇠로 고정합니다.",
        UNLOCKED_TIP = "창 잠금 해제됨: 드래그해서 이동하세요. 클릭하면 고정됩니다.",
        LOCKED_TIP = "창이 고정되었습니다. 클릭하면 잠금이 해제됩니다.",
        VERSION_OUTDATED = "현재 버전은 %s이며, CurseForge에서 %s 버전을 사용할 수 있습니다.",
    },
    zhCN = {
        TITLE = "掷骰",
        NO_ITEMS = "未找到可用于预览的已装备物品。",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | lock | reset | version。拖动窗口可移动它，挂锁可将其固定。",
        UNLOCKED_TIP = "窗口已解锁：拖动即可移动。点击锁定。",
        LOCKED_TIP = "窗口已锁定。点击解锁。",
        VERSION_OUTDATED = "你当前的版本是 %s，CurseForge 上有新版本 %s 可用。",
    },
    zhTW = {
        TITLE = "擲骰",
        NO_ITEMS = "找不到可預覽的已裝備物品。",
        SCALE_USAGE = "/br scale 0.5 - 1.5",
        HELP = "/br test | scale <0.5-1.5> | rolls | lock | reset | version。拖曳視窗可移動它，掛鎖可將其固定。",
        UNLOCKED_TIP = "視窗已解鎖：拖曳即可移動。點擊鎖定。",
        LOCKED_TIP = "視窗已鎖定。點擊解鎖。",
        VERSION_OUTDATED = "你目前的版本是 %s，CurseForge 上有新版本 %s 可用。",
    },
}

local locale = GetLocale and GetLocale() or "enUS"
local base = STRINGS.enUS
local chosen = STRINGS[locale] or base

ns.L = setmetatable({}, { __index = function(_, key) return chosen[key] or base[key] or key end })
ns.locale = STRINGS[locale] and locale or "enUS"
ns.Strings = STRINGS
