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

local MORE = {
    enUS = {
        SHOW_VALUE = "Show the vendor or auction value (a purple * means an appearance you do not own)", SOUND_ALERT = "Play a sound when a roll appears",
        FLASH_ALERT = "Flash the item frame when time is running out", PROFILE_THISSPEC = "Load this profile automatically on this specialization",
        TAB_HISTORY = "History", STATS_ROLLED = "Rolls you took part in: %d", STATS_WON = "Rolls won: %d (%d%%)",
        STATS_KINDS = "Won with Need: %d · won with Greed: %d", STATS_WEEK = "Won in the last 7 days: %d", HISTORY_CLEAR_BTN = "Clear history",
    },
    esES = {
        SHOW_VALUE = "Mostrar el valor de venta o de subasta (un * morado indica una apariencia que no tienes)", SOUND_ALERT = "Reproducir un sonido cuando aparece una tirada",
        FLASH_ALERT = "Parpadear el marco del objeto cuando queda poco tiempo", PROFILE_THISSPEC = "Cargar este perfil automáticamente en esta especialización",
        TAB_HISTORY = "Historial", STATS_ROLLED = "Tiradas en las que has participado: %d", STATS_WON = "Tiradas ganadas: %d (%d%%)",
        STATS_KINDS = "Ganadas con Necesidad: %d · ganadas con Codicia: %d", STATS_WEEK = "Ganadas en los últimos 7 días: %d", HISTORY_CLEAR_BTN = "Borrar historial",
    },
    deDE = {
        SHOW_VALUE = "Händler- oder Auktionswert anzeigen (ein lila * bedeutet ein Aussehen, das du nicht besitzt)", SOUND_ALERT = "Ton abspielen, wenn ein Wurf erscheint",
        FLASH_ALERT = "Gegenstandsrahmen blinken lassen, wenn die Zeit knapp wird", PROFILE_THISSPEC = "Dieses Profil bei dieser Spezialisierung automatisch laden",
        TAB_HISTORY = "Verlauf", STATS_ROLLED = "Würfe, an denen du teilgenommen hast: %d", STATS_WON = "Gewonnene Würfe: %d (%d%%)",
        STATS_KINDS = "Mit Bedarf gewonnen: %d · mit Gier gewonnen: %d", STATS_WEEK = "In den letzten 7 Tagen gewonnen: %d", HISTORY_CLEAR_BTN = "Verlauf löschen",
    },
    frFR = {
        SHOW_VALUE = "Afficher la valeur de vente ou d'enchères (un * violet signale une apparence que vous n'avez pas)", SOUND_ALERT = "Jouer un son quand un jet apparaît",
        FLASH_ALERT = "Faire clignoter le cadre de l'objet quand le temps presse", PROFILE_THISSPEC = "Charger ce profil automatiquement pour cette spécialisation",
        TAB_HISTORY = "Historique", STATS_ROLLED = "Jets auxquels vous avez participé : %d", STATS_WON = "Jets remportés : %d (%d%%)",
        STATS_KINDS = "Remportés avec Besoin : %d · remportés avec Cupidité : %d", STATS_WEEK = "Remportés ces 7 derniers jours : %d", HISTORY_CLEAR_BTN = "Effacer l'historique",
    },
    itIT = {
        SHOW_VALUE = "Mostra il valore di vendita o d'asta (un * viola indica un aspetto che non possiedi)", SOUND_ALERT = "Riproduci un suono quando compare un tiro",
        FLASH_ALERT = "Fai lampeggiare il riquadro dell'oggetto quando il tempo sta finendo", PROFILE_THISSPEC = "Carica automaticamente questo profilo con questa specializzazione",
        TAB_HISTORY = "Cronologia", STATS_ROLLED = "Tiri a cui hai partecipato: %d", STATS_WON = "Tiri vinti: %d (%d%%)",
        STATS_KINDS = "Vinti con Necessità: %d · vinti con Cupidigia: %d", STATS_WEEK = "Vinti negli ultimi 7 giorni: %d", HISTORY_CLEAR_BTN = "Cancella cronologia",
    },
    ptBR = {
        SHOW_VALUE = "Mostrar o valor de venda ou de leilão (um * roxo indica uma aparência que você não possui)", SOUND_ALERT = "Tocar um som quando uma rolagem aparecer",
        FLASH_ALERT = "Piscar a moldura do item quando o tempo estiver acabando", PROFILE_THISSPEC = "Carregar este perfil automaticamente nesta especialização",
        TAB_HISTORY = "Histórico", STATS_ROLLED = "Rolagens de que você participou: %d", STATS_WON = "Rolagens vencidas: %d (%d%%)",
        STATS_KINDS = "Vencidas com Necessidade: %d · vencidas com Ganância: %d", STATS_WEEK = "Vencidas nos últimos 7 dias: %d", HISTORY_CLEAR_BTN = "Limpar histórico",
    },
    ruRU = {
        SHOW_VALUE = "Показывать цену продажи или аукциона (фиолетовая * — внешний вид, которого у вас нет)", SOUND_ALERT = "Проигрывать звук при появлении броска",
        FLASH_ALERT = "Мигать рамкой предмета, когда время на исходе", PROFILE_THISSPEC = "Автоматически загружать этот профиль для этой специализации",
        TAB_HISTORY = "История", STATS_ROLLED = "Бросков, в которых вы участвовали: %d", STATS_WON = "Выиграно бросков: %d (%d%%)",
        STATS_KINDS = "Выиграно по «Мне нужно»: %d · по «Не откажусь»: %d", STATS_WEEK = "Выиграно за последние 7 дней: %d", HISTORY_CLEAR_BTN = "Очистить историю",
    },
    koKR = {
        SHOW_VALUE = "상점 또는 경매장 가치 표시 (보라색 *는 보유하지 않은 외형)", SOUND_ALERT = "주사위가 나타나면 소리 재생",
        FLASH_ALERT = "시간이 얼마 남지 않으면 아이템 테두리 깜빡임", PROFILE_THISSPEC = "이 전문화에서 이 프로필을 자동으로 불러오기",
        TAB_HISTORY = "기록", STATS_ROLLED = "참여한 주사위: %d", STATS_WON = "획득한 주사위: %d (%d%%)",
        STATS_KINDS = "필요로 획득: %d · 욕심으로 획득: %d", STATS_WEEK = "최근 7일간 획득: %d", HISTORY_CLEAR_BTN = "기록 지우기",
    },
    zhCN = {
        SHOW_VALUE = "显示商店或拍卖行价值（紫色 * 表示你尚未拥有的外观）", SOUND_ALERT = "出现掷骰时播放提示音",
        FLASH_ALERT = "时间不多时让物品边框闪烁", PROFILE_THISSPEC = "在此专精下自动加载此配置",
        TAB_HISTORY = "记录", STATS_ROLLED = "参与的掷骰：%d", STATS_WON = "赢得的掷骰：%d（%d%%）",
        STATS_KINDS = "需求赢得：%d · 贪婪赢得：%d", STATS_WEEK = "最近7天赢得：%d", HISTORY_CLEAR_BTN = "清除记录",
    },
    zhTW = {
        SHOW_VALUE = "顯示商店或拍賣場價值（紫色 * 表示你尚未擁有的外觀）", SOUND_ALERT = "出現擲骰時播放提示音",
        FLASH_ALERT = "時間不多時讓物品邊框閃爍", PROFILE_THISSPEC = "在此專精下自動載入此設定檔",
        TAB_HISTORY = "記錄", STATS_ROLLED = "參與的擲骰：%d", STATS_WON = "贏得的擲骰：%d（%d%%）",
        STATS_KINDS = "需求贏得：%d · 貪婪贏得：%d", STATS_WEEK = "最近7天贏得：%d", HISTORY_CLEAR_BTN = "清除記錄",
    },
}
MORE.esMX = MORE.esES
for loc, strings in pairs(MORE) do
    local target = ns.Strings[loc]
    if target then
        for k, v in pairs(strings) do target[k] = v end
    end
end

local DELAY = {
    enUS = "Seconds the window stays after the winner is announced", esES = "Segundos que se queda la ventana tras anunciarse el ganador",
    deDE = "Sekunden, die das Fenster nach der Gewinnerverkündung bleibt", frFR = "Secondes pendant lesquelles la fenêtre reste après l'annonce du gagnant",
    itIT = "Secondi in cui la finestra resta dopo l'annuncio del vincitore", ptBR = "Segundos que a janela permanece após o anúncio do vencedor",
    ruRU = "Секунд, сколько окно остаётся после объявления победителя", koKR = "승자 발표 후 창이 유지되는 시간(초)",
    zhCN = "公布赢家后窗口保留的秒数", zhTW = "公布贏家後視窗保留的秒數",
}
DELAY.esMX = DELAY.esES
for loc, text in pairs(DELAY) do
    if ns.Strings[loc] then ns.Strings[loc].CLOSE_DELAY = text end
end

ns.ChangelogL["0.6.0"] = {
    deDE = {
        "Händler- oder Auktionswert bei jedem Wurf (TradeSkillMaster-Preise, falls vorhanden), mit einem lila *, wenn du das Aussehen noch nicht besitzt.",
        "Neuer Reiter „Verlauf“ mit Statistiken: Teilnahmen, gewonnene Würfe, Siege mit Bedarf und Gier sowie die letzten 7 Tage.",
        "Profile lassen sich auch pro Spezialisierung automatisch laden.",
        "Optionale Hinweise: Ton beim Erscheinen eines Wurfs und blinkender Rahmen, wenn die Zeit knapp wird, sowie eine Einstellung, wie viele Sekunden das Fenster nach der Gewinnerverkündung bleibt.",
        "Fensterdesigns von 20 auf die 10 am besten ausgearbeiteten reduziert; das Einstellungsfenster öffnet schneller.",
        "Behoben: Wenn zwei oder mehr Gegenstände gleichzeitig fielen, konnte ein Würfelfenster fehlen.",
    },
    frFR = {
        "Valeur de vente ou d'enchères sur chaque jet (prix TradeSkillMaster si vous l'avez), avec un * violet quand l'objet a une apparence que vous n'avez pas.",
        "Nouvel onglet Historique avec des statistiques : jets auxquels vous avez participé, jets remportés, victoires avec Besoin et Cupidité, et les 7 derniers jours.",
        "Les profils peuvent aussi se charger automatiquement par spécialisation.",
        "Avis optionnels : un son à l'apparition d'un jet et un cadre clignotant quand le temps presse, plus un réglage du nombre de secondes pendant lesquelles la fenêtre reste après l'annonce du gagnant.",
        "Styles de fenêtre ramenés de 20 aux 10 plus soignés ; la fenêtre de réglages s'ouvre plus vite.",
        "Corrigé : quand deux objets ou plus tombaient en même temps, une des fenêtres de jet pouvait manquer.",
    },
    itIT = {
        "Valore di vendita o d'asta su ogni tiro (prezzi di TradeSkillMaster se li hai), con un * viola quando l'oggetto ha un aspetto che non possiedi.",
        "Nuova scheda Cronologia con statistiche: tiri a cui hai partecipato, tiri vinti, vittorie con Necessità e Cupidigia e gli ultimi 7 giorni.",
        "I profili si possono caricare automaticamente anche per specializzazione.",
        "Avvisi opzionali: un suono quando compare un tiro e un riquadro lampeggiante quando il tempo sta finendo, più un'impostazione per i secondi in cui la finestra resta dopo l'annuncio del vincitore.",
        "Stili di finestra ridotti da 20 ai 10 più curati; la finestra delle impostazioni si apre più velocemente.",
        "Corretto: quando due o più oggetti cadevano insieme, una delle finestre dei tiri poteva mancare.",
    },
    ptBR = {
        "Valor de venda ou de leilão em cada rolagem (preços do TradeSkillMaster, se você o tiver), com um * roxo quando o item tem uma aparência que você não possui.",
        "Nova aba Histórico com estatísticas: rolagens de que participou, rolagens vencidas, vitórias com Necessidade e Ganância e os últimos 7 dias.",
        "Os perfis também podem ser carregados automaticamente por especialização.",
        "Avisos opcionais: um som quando uma rolagem aparece e uma moldura piscando quando o tempo está acabando, além de um ajuste para os segundos que a janela permanece após o anúncio do vencedor.",
        "Estilos de janela reduzidos de 20 para os 10 mais bem acabados; a janela de configurações abre mais rápido.",
        "Corrigido: quando dois ou mais itens caíam ao mesmo tempo, uma das janelas de rolagem podia faltar.",
    },
    ruRU = {
        "Цена продажи или аукциона в каждом броске (цены TradeSkillMaster, если он есть), с фиолетовой * для внешнего вида, которого у вас нет.",
        "Новая вкладка «История» со статистикой: броски, в которых вы участвовали, выигранные, победы по «Мне нужно» и «Не откажусь» и последние 7 дней.",
        "Профили теперь можно загружать автоматически и для каждой специализации.",
        "Необязательные оповещения: звук при появлении броска и мигающая рамка, когда время на исходе, а также настройка длительности показа окна после объявления победителя.",
        "Дизайнов окна стало 10 вместо 20 — самые проработанные; окно настроек открывается быстрее.",
        "Исправлено: когда одновременно выпадало два предмета или больше, одно из окон розыгрыша могло не появиться.",
    },
    koKR = {
        "모든 주사위에 상점 또는 경매장 가치 표시(TradeSkillMaster 가격 사용 가능), 보유하지 않은 외형은 보라색 *로 표시.",
        "통계가 있는 새 기록 탭: 참여한 주사위, 획득한 주사위, 필요/욕심 획득 수, 최근 7일.",
        "프로필을 전문화별로도 자동으로 불러올 수 있습니다.",
        "선택 가능한 알림: 주사위가 나타날 때 소리, 시간이 얼마 남지 않으면 깜빡이는 테두리, 승자 발표 후 창이 유지되는 시간 설정.",
        "창 디자인을 20개에서 가장 잘 다듬은 10개로 줄였고, 설정 창이 더 빨리 열립니다.",
        "수정: 아이템 두 개 이상이 동시에 떨어질 때 주사위 창 하나가 빠질 수 있던 문제.",
    },
    zhCN = {
        "每次掷骰显示商店或拍卖行价值（有 TradeSkillMaster 时使用其价格），尚未拥有的外观用紫色 * 标记。",
        "设置窗口新增“记录”标签页和统计：参与的掷骰、赢得的掷骰、需求与贪婪赢得次数以及最近7天。",
        "配置现在也可以按专精自动加载。",
        "可选提示：出现掷骰时播放声音、时间不多时边框闪烁，并可设置公布赢家后窗口保留的秒数。",
        "窗口样式从20种精简为最精致的10种；设置窗口打开更快。",
        "修复：同时掉落两件或更多物品时，可能缺少其中一个掷骰窗口。",
    },
    zhTW = {
        "每次擲骰顯示商店或拍賣場價值（有 TradeSkillMaster 時使用其價格），尚未擁有的外觀以紫色 * 標記。",
        "設定視窗新增「記錄」分頁和統計：參與的擲骰、贏得的擲骰、需求與貪婪贏得次數以及最近7天。",
        "設定檔現在也可以依專精自動載入。",
        "可選提示：出現擲骰時播放聲音、時間不多時邊框閃爍，並可設定公布贏家後視窗保留的秒數。",
        "視窗樣式從20種精簡為最精緻的10種；設定視窗開啟更快。",
        "修復：同時掉落兩件或更多物品時，可能缺少其中一個擲骰視窗。",
    },
}

local HISTORY_NOTE = {
    deDE = "Im Verlauf zeigen Gegenstände ihre Gegenstandsstufe, folgen der Spielsprache und öffnen beim Überfahren oder Anklicken ihren Tooltip.",
    frFR = "Dans l'historique, les objets affichent leur niveau d'objet, suivent la langue du jeu et ouvrent leur infobulle au survol ou au clic.",
    itIT = "Nella cronologia gli oggetti mostrano il livello oggetto, seguono la lingua del gioco e aprono il suggerimento al passaggio del mouse o al clic.",
    ptBR = "No histórico, os itens mostram o nível do item, seguem o idioma do jogo e abrem a dica ao passar o mouse ou clicar.",
    ruRU = "В истории предметы показывают уровень, следуют языку игры и открывают подсказку при наведении или щелчке.",
    koKR = "기록에서 아이템이 아이템 레벨을 표시하고, 게임 언어를 따르며, 마우스를 올리거나 클릭하면 툴팁이 열립니다.",
    zhCN = "记录中的物品会显示物品等级，跟随游戏语言，鼠标悬停或点击时显示提示信息。",
    zhTW = "記錄中的物品會顯示物品等級，跟隨遊戲語言，滑鼠移上或點擊時顯示提示資訊。",
}
for loc, text in pairs(HISTORY_NOTE) do
    local list = ns.ChangelogL["0.6.0"] and ns.ChangelogL["0.6.0"][loc]
    if list then table.insert(list, 3, text) end
end
