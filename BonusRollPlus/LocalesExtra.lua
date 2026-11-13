local ADDON, ns = ...

local NEW = {
    enUS = {
        SHOW_UPGRADE = "Show the item level difference against what you wear", COMPACT_ROWS = "Compact rows for rolls waiting their turn",
        HISTORY_BTN = "Show roll history", HISTORY_TITLE = "last rolls won:", HISTORY_EMPTY = "No rolls recorded yet.", HISTORY_CLEARED = "History cleared.",
        TAB_PROFILES = "Profiles", PROFILE_LABEL = "Profile", PROFILE_NONE = "Current settings (no profile)", PROFILE_NEW = "Save as new profile",
        PROFILE_UPDATE = "Update profile", PROFILE_DELETE = "Delete", PROFILE_THISCHAR = "Load this profile automatically on this character",
        PROFILE_EXPORT = "Export", PROFILE_IMPORT = "Import", PROFILE_NAME = "Profile %d", EXPORT_HELP = "Copy this text with Ctrl+C:",
        IMPORT_HELP = "Paste the text below and press Import:", IMPORT_OK = "Profile imported.", IMPORT_BAD = "That text is not a valid profile.",
        CANT_USE = "You cannot use this item, but you can still roll Need to sell it.", CLOSE = "Close", PROFILE_SAVED = "Profile saved: %s", PROFILE_LOADED = "Profile loaded: %s", PROFILE_DELETED = "Profile deleted: %s",
    },
    esES = {
        SHOW_UPGRADE = "Mostrar la diferencia de nivel de objeto con lo que llevas puesto", COMPACT_ROWS = "Filas compactas para las tiradas que esperan turno",
        HISTORY_BTN = "Mostrar historial de tiradas", HISTORY_TITLE = "últimas tiradas ganadas:", HISTORY_EMPTY = "Todavía no hay tiradas registradas.", HISTORY_CLEARED = "Historial borrado.",
        TAB_PROFILES = "Perfiles", PROFILE_LABEL = "Perfil", PROFILE_NONE = "Ajustes actuales (sin perfil)", PROFILE_NEW = "Guardar como perfil nuevo",
        PROFILE_UPDATE = "Actualizar perfil", PROFILE_DELETE = "Eliminar", PROFILE_THISCHAR = "Cargar este perfil automáticamente en este personaje",
        PROFILE_EXPORT = "Exportar", PROFILE_IMPORT = "Importar", PROFILE_NAME = "Perfil %d", EXPORT_HELP = "Copia este texto con Ctrl+C:",
        IMPORT_HELP = "Pega el texto abajo y pulsa Importar:", IMPORT_OK = "Perfil importado.", IMPORT_BAD = "Ese texto no es un perfil válido.",
        CANT_USE = "No puedes usar este objeto, pero puedes pedir Necesidad para venderlo.", CLOSE = "Cerrar", PROFILE_SAVED = "Perfil guardado: %s", PROFILE_LOADED = "Perfil cargado: %s", PROFILE_DELETED = "Perfil eliminado: %s",
    },
    deDE = {
        SHOW_UPGRADE = "Gegenstandsstufen-Unterschied zu deiner Ausrüstung anzeigen", COMPACT_ROWS = "Kompakte Zeilen für wartende Würfe",
        HISTORY_BTN = "Wurfverlauf anzeigen", HISTORY_TITLE = "zuletzt gewonnene Würfe:", HISTORY_EMPTY = "Noch keine Würfe aufgezeichnet.", HISTORY_CLEARED = "Verlauf gelöscht.",
        TAB_PROFILES = "Profile", PROFILE_LABEL = "Profil", PROFILE_NONE = "Aktuelle Einstellungen (kein Profil)", PROFILE_NEW = "Als neues Profil speichern",
        PROFILE_UPDATE = "Profil aktualisieren", PROFILE_DELETE = "Löschen", PROFILE_THISCHAR = "Dieses Profil bei diesem Charakter automatisch laden",
        PROFILE_EXPORT = "Exportieren", PROFILE_IMPORT = "Importieren", PROFILE_NAME = "Profil %d", EXPORT_HELP = "Kopiere diesen Text mit Strg+C:",
        IMPORT_HELP = "Füge den Text unten ein und klicke auf Importieren:", IMPORT_OK = "Profil importiert.", IMPORT_BAD = "Dieser Text ist kein gültiges Profil.",
        CANT_USE = "Du kannst diesen Gegenstand nicht benutzen, darfst aber trotzdem Bedarf würfeln, um ihn zu verkaufen.", CLOSE = "Schließen", PROFILE_SAVED = "Profil gespeichert: %s", PROFILE_LOADED = "Profil geladen: %s", PROFILE_DELETED = "Profil gelöscht: %s",
    },
    frFR = {
        SHOW_UPGRADE = "Afficher la différence de niveau d'objet avec votre équipement", COMPACT_ROWS = "Lignes compactes pour les jets en attente",
        HISTORY_BTN = "Afficher l'historique des jets", HISTORY_TITLE = "derniers jets remportés :", HISTORY_EMPTY = "Aucun jet enregistré pour l'instant.", HISTORY_CLEARED = "Historique effacé.",
        TAB_PROFILES = "Profils", PROFILE_LABEL = "Profil", PROFILE_NONE = "Réglages actuels (sans profil)", PROFILE_NEW = "Enregistrer comme nouveau profil",
        PROFILE_UPDATE = "Mettre à jour le profil", PROFILE_DELETE = "Supprimer", PROFILE_THISCHAR = "Charger ce profil automatiquement sur ce personnage",
        PROFILE_EXPORT = "Exporter", PROFILE_IMPORT = "Importer", PROFILE_NAME = "Profil %d", EXPORT_HELP = "Copiez ce texte avec Ctrl+C :",
        IMPORT_HELP = "Collez le texte ci-dessous et cliquez sur Importer :", IMPORT_OK = "Profil importé.", IMPORT_BAD = "Ce texte n'est pas un profil valide.",
        CANT_USE = "Vous ne pouvez pas utiliser cet objet, mais vous pouvez quand même choisir Besoin pour le revendre.", CLOSE = "Fermer", PROFILE_SAVED = "Profil enregistré : %s", PROFILE_LOADED = "Profil chargé : %s", PROFILE_DELETED = "Profil supprimé : %s",
    },
    itIT = {
        SHOW_UPGRADE = "Mostra la differenza di livello oggetto rispetto a ciò che indossi", COMPACT_ROWS = "Righe compatte per i tiri in attesa",
        HISTORY_BTN = "Mostra cronologia dei tiri", HISTORY_TITLE = "ultimi tiri vinti:", HISTORY_EMPTY = "Ancora nessun tiro registrato.", HISTORY_CLEARED = "Cronologia cancellata.",
        TAB_PROFILES = "Profili", PROFILE_LABEL = "Profilo", PROFILE_NONE = "Impostazioni attuali (nessun profilo)", PROFILE_NEW = "Salva come nuovo profilo",
        PROFILE_UPDATE = "Aggiorna profilo", PROFILE_DELETE = "Elimina", PROFILE_THISCHAR = "Carica automaticamente questo profilo su questo personaggio",
        PROFILE_EXPORT = "Esporta", PROFILE_IMPORT = "Importa", PROFILE_NAME = "Profilo %d", EXPORT_HELP = "Copia questo testo con Ctrl+C:",
        IMPORT_HELP = "Incolla il testo qui sotto e premi Importa:", IMPORT_OK = "Profilo importato.", IMPORT_BAD = "Quel testo non è un profilo valido.",
        CANT_USE = "Non puoi usare questo oggetto, ma puoi comunque tirare Necessità per venderlo.", CLOSE = "Chiudi", PROFILE_SAVED = "Profilo salvato: %s", PROFILE_LOADED = "Profilo caricato: %s", PROFILE_DELETED = "Profilo eliminato: %s",
    },
    ptBR = {
        SHOW_UPGRADE = "Mostrar a diferença de nível do item em relação ao que você veste", COMPACT_ROWS = "Linhas compactas para rolagens aguardando a vez",
        HISTORY_BTN = "Mostrar histórico de rolagens", HISTORY_TITLE = "últimas rolagens vencidas:", HISTORY_EMPTY = "Nenhuma rolagem registrada ainda.", HISTORY_CLEARED = "Histórico apagado.",
        TAB_PROFILES = "Perfis", PROFILE_LABEL = "Perfil", PROFILE_NONE = "Configurações atuais (sem perfil)", PROFILE_NEW = "Salvar como novo perfil",
        PROFILE_UPDATE = "Atualizar perfil", PROFILE_DELETE = "Excluir", PROFILE_THISCHAR = "Carregar este perfil automaticamente neste personagem",
        PROFILE_EXPORT = "Exportar", PROFILE_IMPORT = "Importar", PROFILE_NAME = "Perfil %d", EXPORT_HELP = "Copie este texto com Ctrl+C:",
        IMPORT_HELP = "Cole o texto abaixo e clique em Importar:", IMPORT_OK = "Perfil importado.", IMPORT_BAD = "Esse texto não é um perfil válido.",
        CANT_USE = "Você não pode usar este item, mas ainda pode rolar Necessidade para vendê-lo.", CLOSE = "Fechar", PROFILE_SAVED = "Perfil salvo: %s", PROFILE_LOADED = "Perfil carregado: %s", PROFILE_DELETED = "Perfil excluído: %s",
    },
    ruRU = {
        SHOW_UPGRADE = "Показывать разницу уровня предмета с вашей экипировкой", COMPACT_ROWS = "Компактные строки для ожидающих бросков",
        HISTORY_BTN = "Показать историю бросков", HISTORY_TITLE = "последние выигранные броски:", HISTORY_EMPTY = "Пока нет записанных бросков.", HISTORY_CLEARED = "История очищена.",
        TAB_PROFILES = "Профили", PROFILE_LABEL = "Профиль", PROFILE_NONE = "Текущие настройки (без профиля)", PROFILE_NEW = "Сохранить как новый профиль",
        PROFILE_UPDATE = "Обновить профиль", PROFILE_DELETE = "Удалить", PROFILE_THISCHAR = "Автоматически загружать этот профиль на этом персонаже",
        PROFILE_EXPORT = "Экспорт", PROFILE_IMPORT = "Импорт", PROFILE_NAME = "Профиль %d", EXPORT_HELP = "Скопируйте этот текст с помощью Ctrl+C:",
        IMPORT_HELP = "Вставьте текст ниже и нажмите «Импорт»:", IMPORT_OK = "Профиль импортирован.", IMPORT_BAD = "Этот текст не является допустимым профилем.",
        CANT_USE = "Вы не можете использовать этот предмет, но всё равно можете выбрать «Мне нужно», чтобы продать его.", CLOSE = "Закрыть", PROFILE_SAVED = "Профиль сохранён: %s", PROFILE_LOADED = "Профиль загружен: %s", PROFILE_DELETED = "Профиль удалён: %s",
    },
    koKR = {
        SHOW_UPGRADE = "착용 중인 장비와의 아이템 레벨 차이 표시", COMPACT_ROWS = "순서를 기다리는 주사위를 간략한 줄로 표시",
        HISTORY_BTN = "주사위 기록 보기", HISTORY_TITLE = "최근 획득한 주사위:", HISTORY_EMPTY = "아직 기록된 주사위가 없습니다.", HISTORY_CLEARED = "기록을 지웠습니다.",
        TAB_PROFILES = "프로필", PROFILE_LABEL = "프로필", PROFILE_NONE = "현재 설정(프로필 없음)", PROFILE_NEW = "새 프로필로 저장",
        PROFILE_UPDATE = "프로필 갱신", PROFILE_DELETE = "삭제", PROFILE_THISCHAR = "이 캐릭터에서 이 프로필을 자동으로 불러오기",
        PROFILE_EXPORT = "내보내기", PROFILE_IMPORT = "가져오기", PROFILE_NAME = "프로필 %d", EXPORT_HELP = "Ctrl+C로 이 텍스트를 복사하세요:",
        IMPORT_HELP = "아래에 텍스트를 붙여넣고 가져오기를 누르세요:", IMPORT_OK = "프로필을 가져왔습니다.", IMPORT_BAD = "올바른 프로필 텍스트가 아닙니다.",
        CANT_USE = "이 아이템은 사용할 수 없지만, 판매하려고 필요를 선택할 수는 있습니다.", CLOSE = "닫기", PROFILE_SAVED = "프로필 저장됨: %s", PROFILE_LOADED = "프로필 불러옴: %s", PROFILE_DELETED = "프로필 삭제됨: %s",
    },
    zhCN = {
        SHOW_UPGRADE = "显示与你当前装备的物品等级差", COMPACT_ROWS = "为等待中的掷骰使用紧凑行",
        HISTORY_BTN = "显示掷骰记录", HISTORY_TITLE = "最近赢得的掷骰：", HISTORY_EMPTY = "还没有掷骰记录。", HISTORY_CLEARED = "记录已清除。",
        TAB_PROFILES = "配置", PROFILE_LABEL = "配置", PROFILE_NONE = "当前设置（无配置）", PROFILE_NEW = "另存为新配置",
        PROFILE_UPDATE = "更新配置", PROFILE_DELETE = "删除", PROFILE_THISCHAR = "在此角色上自动加载此配置",
        PROFILE_EXPORT = "导出", PROFILE_IMPORT = "导入", PROFILE_NAME = "配置 %d", EXPORT_HELP = "按 Ctrl+C 复制此文本：",
        IMPORT_HELP = "将文本粘贴到下方并点击导入：", IMPORT_OK = "配置已导入。", IMPORT_BAD = "该文本不是有效的配置。",
        CANT_USE = "你无法使用此物品，但仍可选择需求以便出售。", CLOSE = "关闭", PROFILE_SAVED = "配置已保存：%s", PROFILE_LOADED = "配置已加载：%s", PROFILE_DELETED = "配置已删除：%s",
    },
    zhTW = {
        SHOW_UPGRADE = "顯示與你目前裝備的物品等級差", COMPACT_ROWS = "為等待中的擲骰使用精簡列",
        HISTORY_BTN = "顯示擲骰記錄", HISTORY_TITLE = "最近贏得的擲骰：", HISTORY_EMPTY = "還沒有擲骰記錄。", HISTORY_CLEARED = "記錄已清除。",
        TAB_PROFILES = "設定檔", PROFILE_LABEL = "設定檔", PROFILE_NONE = "目前設定（無設定檔）", PROFILE_NEW = "另存為新設定檔",
        PROFILE_UPDATE = "更新設定檔", PROFILE_DELETE = "刪除", PROFILE_THISCHAR = "在此角色上自動載入此設定檔",
        PROFILE_EXPORT = "匯出", PROFILE_IMPORT = "匯入", PROFILE_NAME = "設定檔 %d", EXPORT_HELP = "按 Ctrl+C 複製此文字：",
        IMPORT_HELP = "將文字貼到下方並按匯入：", IMPORT_OK = "設定檔已匯入。", IMPORT_BAD = "該文字不是有效的設定檔。",
        CANT_USE = "你無法使用此物品，但仍可選擇需求以便出售。", CLOSE = "關閉", PROFILE_SAVED = "設定檔已儲存：%s", PROFILE_LOADED = "設定檔已載入：%s", PROFILE_DELETED = "設定檔已刪除：%s",
    },
}
NEW.esMX = NEW.esES

for loc, strings in pairs(NEW) do
    local target = ns.Strings[loc]
    if target then
        for k, v in pairs(strings) do target[k] = v end
    end
end

for _, target in pairs(ns.Strings) do
    if target.HELP then target.HELP = target.HELP:gsub(" | reset", " | history | reset", 1) end
end

local BULLET = {
    deDE = "Gegenstandsstufen-Unterschied zu deiner Ausrüstung, Warnung bei unbenutzbaren Gegenständen, kompakte Zeilen für wartende Würfe, Wurfverlauf (/br history) und Profile mit Export und Import.",
    frFR = "Différence de niveau d'objet avec votre équipement, avertissement quand vous ne pouvez pas utiliser un objet, lignes compactes pour les jets en attente, historique des jets (/br history) et profils avec export et import.",
    itIT = "Differenza di livello oggetto rispetto al tuo equipaggiamento, avviso quando non puoi usare un oggetto, righe compatte per i tiri in attesa, cronologia dei tiri (/br history) e profili con esportazione e importazione.",
    ptBR = "Diferença de nível do item em relação ao seu equipamento, aviso quando você não pode usar um item, linhas compactas para rolagens em espera, histórico de rolagens (/br history) e perfis com exportação e importação.",
    ruRU = "Разница уровня предмета с вашей экипировкой, предупреждение, если предмет нельзя использовать, компактные строки для ожидающих бросков, история бросков (/br history) и профили с экспортом и импортом.",
    koKR = "착용 장비와의 아이템 레벨 차이, 사용할 수 없는 아이템 경고, 대기 중인 주사위의 간략한 줄, 주사위 기록(/br history), 내보내기/가져오기가 있는 프로필.",
    zhCN = "显示与当前装备的物品等级差，无法使用物品时给出警告，等待中的掷骰使用紧凑行，掷骰记录（/br history），以及可导出导入的配置。",
    zhTW = "顯示與目前裝備的物品等級差，無法使用物品時給出警告，等待中的擲骰使用精簡列，擲骰記錄（/br history），以及可匯出匯入的設定檔。",
}
for loc, text in pairs(BULLET) do
    local list = ns.ChangelogL and ns.ChangelogL["0.5.0"] and ns.ChangelogL["0.5.0"][loc]
    if list then table.insert(list, 4, text) end
end

local FIRST = {
    deDE = "Erste auf CurseForge veröffentlichte Version.",
    frFR = "Première version publiée sur CurseForge.",
    itIT = "Prima versione pubblicata su CurseForge.",
    ptBR = "Primeira versão publicada no CurseForge.",
    ruRU = "Первая версия, опубликованная на CurseForge.",
    koKR = "CurseForge에 게시된 첫 번째 버전.",
    zhCN = "首个在 CurseForge 上发布的版本。",
    zhTW = "首個在 CurseForge 上發布的版本。",
}
ns.ChangelogL["0.4.0"] = {}
for loc, text in pairs(FIRST) do ns.ChangelogL["0.4.0"][loc] = { text } end
