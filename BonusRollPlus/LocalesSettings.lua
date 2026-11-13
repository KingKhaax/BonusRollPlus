local ADDON, ns = ...

local NEW = {
    enUS = {
        SAMPLE_ITEM = "Sample item", OPEN_SETTINGS = "Open settings", SET_TITLE = "BonusRoll Plus · Settings",
        TAB_DESIGNS = "Designs", TAB_SETTINGS = "Settings", TAB_ABOUT = "About", DEFAULT_TAG = "Default", SELECTED = "In use",
        DESIGN_HINT = "Click a design to use it for future rolls.", SCALE = "Window size", OPACITY = "Opacity",
        MAX_WINDOWS = "Visible windows at once", SHOW_ROLLS = "Show the rolls list next to each window", LOCK = "Lock window position",
        TEST_BTN = "Show test windows", MOVE_HINT = "Drag the test windows to where you want them, then lock the position: they will stay there for future loot.",
        RESET_POS = "Reset position", RESET_ALL = "Restore defaults", ABOUT_BY = "Created by KingKhaax",
        ABOUT_RIGHTS = "© 2026 KingKhaax. All rights reserved.", CHANGELOG_TITLE = "What's new in each version", VERSION_LABEL = "Version",
    },
    esES = {
        SAMPLE_ITEM = "Objeto de ejemplo", OPEN_SETTINGS = "Abrir ajustes", SET_TITLE = "BonusRoll Plus · Ajustes",
        TAB_DESIGNS = "Diseños", TAB_SETTINGS = "Ajustes", TAB_ABOUT = "Acerca de", DEFAULT_TAG = "Predeterminado", SELECTED = "En uso",
        DESIGN_HINT = "Haz clic en un diseño para usarlo en las próximas tiradas.", SCALE = "Tamaño de la ventana", OPACITY = "Opacidad",
        MAX_WINDOWS = "Ventanas visibles a la vez", SHOW_ROLLS = "Mostrar la lista de tiradas junto a cada ventana", LOCK = "Bloquear la posición de la ventana",
        TEST_BTN = "Mostrar ventanas de prueba", MOVE_HINT = "Arrastra las ventanas de prueba a donde quieras y bloquea la posición: se quedarán ahí para el botín futuro.",
        RESET_POS = "Restablecer posición", RESET_ALL = "Restaurar valores", ABOUT_BY = "Creado por KingKhaax",
        ABOUT_RIGHTS = "© 2026 KingKhaax. Todos los derechos reservados.", CHANGELOG_TITLE = "Novedades de cada versión", VERSION_LABEL = "Versión",
    },
    esMX = {
        SAMPLE_ITEM = "Objeto de ejemplo", OPEN_SETTINGS = "Abrir ajustes", SET_TITLE = "BonusRoll Plus · Ajustes",
        TAB_DESIGNS = "Diseños", TAB_SETTINGS = "Ajustes", TAB_ABOUT = "Acerca de", DEFAULT_TAG = "Predeterminado", SELECTED = "En uso",
        DESIGN_HINT = "Haz clic en un diseño para usarlo en las próximas tiradas.", SCALE = "Tamaño de la ventana", OPACITY = "Opacidad",
        MAX_WINDOWS = "Ventanas visibles a la vez", SHOW_ROLLS = "Mostrar la lista de tiradas junto a cada ventana", LOCK = "Bloquear la posición de la ventana",
        TEST_BTN = "Mostrar ventanas de prueba", MOVE_HINT = "Arrastra las ventanas de prueba a donde quieras y bloquea la posición: se quedarán ahí para el botín futuro.",
        RESET_POS = "Restablecer posición", RESET_ALL = "Restaurar valores", ABOUT_BY = "Creado por KingKhaax",
        ABOUT_RIGHTS = "© 2026 KingKhaax. Todos los derechos reservados.", CHANGELOG_TITLE = "Novedades de cada versión", VERSION_LABEL = "Versión",
    },
    deDE = {
        SAMPLE_ITEM = "Beispielgegenstand", OPEN_SETTINGS = "Einstellungen öffnen", SET_TITLE = "BonusRoll Plus · Einstellungen",
        TAB_DESIGNS = "Designs", TAB_SETTINGS = "Einstellungen", TAB_ABOUT = "Über", DEFAULT_TAG = "Standard", SELECTED = "In Benutzung",
        DESIGN_HINT = "Klicke auf ein Design, um es für künftige Würfe zu verwenden.", SCALE = "Fenstergröße", OPACITY = "Deckkraft",
        MAX_WINDOWS = "Gleichzeitig sichtbare Fenster", SHOW_ROLLS = "Würfelliste neben jedem Fenster anzeigen", LOCK = "Fensterposition sperren",
        TEST_BTN = "Testfenster anzeigen", MOVE_HINT = "Ziehe die Testfenster an die gewünschte Stelle und sperre die Position: Sie bleiben für künftige Beute dort.",
        RESET_POS = "Position zurücksetzen", RESET_ALL = "Standardwerte wiederherstellen", ABOUT_BY = "Erstellt von KingKhaax",
        ABOUT_RIGHTS = "© 2026 KingKhaax. Alle Rechte vorbehalten.", CHANGELOG_TITLE = "Neuigkeiten jeder Version", VERSION_LABEL = "Version",
    },
    frFR = {
        SAMPLE_ITEM = "Objet d'exemple", OPEN_SETTINGS = "Ouvrir les réglages", SET_TITLE = "BonusRoll Plus · Réglages",
        TAB_DESIGNS = "Styles", TAB_SETTINGS = "Réglages", TAB_ABOUT = "À propos", DEFAULT_TAG = "Par défaut", SELECTED = "Utilisé",
        DESIGN_HINT = "Cliquez sur un style pour l'utiliser lors des prochains jets.", SCALE = "Taille de la fenêtre", OPACITY = "Opacité",
        MAX_WINDOWS = "Fenêtres visibles en même temps", SHOW_ROLLS = "Afficher la liste des jets à côté de chaque fenêtre", LOCK = "Verrouiller la position de la fenêtre",
        TEST_BTN = "Afficher les fenêtres de test", MOVE_HINT = "Faites glisser les fenêtres de test où vous voulez, puis verrouillez la position : elles y resteront pour le butin futur.",
        RESET_POS = "Réinitialiser la position", RESET_ALL = "Rétablir les valeurs par défaut", ABOUT_BY = "Créé par KingKhaax",
        ABOUT_RIGHTS = "© 2026 KingKhaax. Tous droits réservés.", CHANGELOG_TITLE = "Nouveautés de chaque version", VERSION_LABEL = "Version",
    },
    itIT = {
        SAMPLE_ITEM = "Oggetto di esempio", OPEN_SETTINGS = "Apri impostazioni", SET_TITLE = "BonusRoll Plus · Impostazioni",
        TAB_DESIGNS = "Stili", TAB_SETTINGS = "Impostazioni", TAB_ABOUT = "Informazioni", DEFAULT_TAG = "Predefinito", SELECTED = "In uso",
        DESIGN_HINT = "Fai clic su uno stile per usarlo nei prossimi tiri.", SCALE = "Dimensione della finestra", OPACITY = "Opacità",
        MAX_WINDOWS = "Finestre visibili contemporaneamente", SHOW_ROLLS = "Mostra l'elenco dei tiri accanto a ogni finestra", LOCK = "Blocca la posizione della finestra",
        TEST_BTN = "Mostra finestre di prova", MOVE_HINT = "Trascina le finestre di prova dove vuoi e blocca la posizione: resteranno lì per il bottino futuro.",
        RESET_POS = "Reimposta posizione", RESET_ALL = "Ripristina predefiniti", ABOUT_BY = "Creato da KingKhaax",
        ABOUT_RIGHTS = "© 2026 KingKhaax. Tutti i diritti riservati.", CHANGELOG_TITLE = "Novità di ogni versione", VERSION_LABEL = "Versione",
    },
    ptBR = {
        SAMPLE_ITEM = "Item de exemplo", OPEN_SETTINGS = "Abrir configurações", SET_TITLE = "BonusRoll Plus · Configurações",
        TAB_DESIGNS = "Estilos", TAB_SETTINGS = "Configurações", TAB_ABOUT = "Sobre", DEFAULT_TAG = "Padrão", SELECTED = "Em uso",
        DESIGN_HINT = "Clique em um estilo para usá-lo nas próximas rolagens.", SCALE = "Tamanho da janela", OPACITY = "Opacidade",
        MAX_WINDOWS = "Janelas visíveis ao mesmo tempo", SHOW_ROLLS = "Mostrar a lista de rolagens ao lado de cada janela", LOCK = "Travar a posição da janela",
        TEST_BTN = "Mostrar janelas de teste", MOVE_HINT = "Arraste as janelas de teste para onde quiser e trave a posição: elas ficarão lá para o saque futuro.",
        RESET_POS = "Redefinir posição", RESET_ALL = "Restaurar padrões", ABOUT_BY = "Criado por KingKhaax",
        ABOUT_RIGHTS = "© 2026 KingKhaax. Todos os direitos reservados.", CHANGELOG_TITLE = "Novidades de cada versão", VERSION_LABEL = "Versão",
    },
    ruRU = {
        SAMPLE_ITEM = "Пример предмета", OPEN_SETTINGS = "Открыть настройки", SET_TITLE = "BonusRoll Plus · Настройки",
        TAB_DESIGNS = "Стили", TAB_SETTINGS = "Настройки", TAB_ABOUT = "О программе", DEFAULT_TAG = "По умолчанию", SELECTED = "Используется",
        DESIGN_HINT = "Нажмите на стиль, чтобы использовать его в следующих розыгрышах.", SCALE = "Размер окна", OPACITY = "Прозрачность",
        MAX_WINDOWS = "Одновременно видимых окон", SHOW_ROLLS = "Показывать список бросков рядом с каждым окном", LOCK = "Закрепить положение окна",
        TEST_BTN = "Показать тестовые окна", MOVE_HINT = "Перетащите тестовые окна в нужное место и закрепите положение: они останутся там для будущей добычи.",
        RESET_POS = "Сбросить положение", RESET_ALL = "Восстановить значения", ABOUT_BY = "Создал KingKhaax",
        ABOUT_RIGHTS = "© 2026 KingKhaax. Все права защищены.", CHANGELOG_TITLE = "Что нового в каждой версии", VERSION_LABEL = "Версия",
    },
    koKR = {
        SAMPLE_ITEM = "예시 아이템", OPEN_SETTINGS = "설정 열기", SET_TITLE = "BonusRoll Plus · 설정",
        TAB_DESIGNS = "디자인", TAB_SETTINGS = "설정", TAB_ABOUT = "정보", DEFAULT_TAG = "기본", SELECTED = "사용 중",
        DESIGN_HINT = "디자인을 클릭하면 앞으로의 주사위에 적용됩니다.", SCALE = "창 크기", OPACITY = "투명도",
        MAX_WINDOWS = "동시에 표시할 창 수", SHOW_ROLLS = "각 창 옆에 주사위 목록 표시", LOCK = "창 위치 고정",
        TEST_BTN = "테스트 창 표시", MOVE_HINT = "테스트 창을 원하는 곳으로 끌어다 놓고 위치를 고정하세요. 이후 전리품에도 그 자리에 표시됩니다.",
        RESET_POS = "위치 초기화", RESET_ALL = "기본값 복원", ABOUT_BY = "제작: KingKhaax",
        ABOUT_RIGHTS = "© 2026 KingKhaax. 모든 권리 보유.", CHANGELOG_TITLE = "버전별 변경 사항", VERSION_LABEL = "버전",
    },
    zhCN = {
        SAMPLE_ITEM = "示例物品", OPEN_SETTINGS = "打开设置", SET_TITLE = "BonusRoll Plus · 设置",
        TAB_DESIGNS = "样式", TAB_SETTINGS = "设置", TAB_ABOUT = "关于", DEFAULT_TAG = "默认", SELECTED = "使用中",
        DESIGN_HINT = "点击样式即可用于之后的掷骰。", SCALE = "窗口大小", OPACITY = "不透明度",
        MAX_WINDOWS = "同时显示的窗口数", SHOW_ROLLS = "在每个窗口旁显示掷骰列表", LOCK = "锁定窗口位置",
        TEST_BTN = "显示测试窗口", MOVE_HINT = "将测试窗口拖到想要的位置并锁定位置，之后的战利品窗口会保持在那里。",
        RESET_POS = "重置位置", RESET_ALL = "恢复默认", ABOUT_BY = "作者：KingKhaax",
        ABOUT_RIGHTS = "© 2026 KingKhaax。保留所有权利。", CHANGELOG_TITLE = "各版本更新内容", VERSION_LABEL = "版本",
    },
    zhTW = {
        SAMPLE_ITEM = "範例物品", OPEN_SETTINGS = "開啟設定", SET_TITLE = "BonusRoll Plus · 設定",
        TAB_DESIGNS = "樣式", TAB_SETTINGS = "設定", TAB_ABOUT = "關於", DEFAULT_TAG = "預設", SELECTED = "使用中",
        DESIGN_HINT = "點擊樣式即可用於之後的擲骰。", SCALE = "視窗大小", OPACITY = "不透明度",
        MAX_WINDOWS = "同時顯示的視窗數", SHOW_ROLLS = "在每個視窗旁顯示擲骰清單", LOCK = "鎖定視窗位置",
        TEST_BTN = "顯示測試視窗", MOVE_HINT = "將測試視窗拖到想要的位置並鎖定位置，之後的戰利品視窗會保持在那裡。",
        RESET_POS = "重設位置", RESET_ALL = "還原預設", ABOUT_BY = "作者：KingKhaax",
        ABOUT_RIGHTS = "© 2026 KingKhaax。保留所有權利。", CHANGELOG_TITLE = "各版本更新內容", VERSION_LABEL = "版本",
    },
}

for loc, strings in pairs(NEW) do
    local target = ns.Strings[loc]
    if target then
        for k, v in pairs(strings) do target[k] = v end
    end
end

for _, target in pairs(ns.Strings) do
    if target.HELP then target.HELP = target.HELP:gsub("^/br test |", "/br open | test |", 1) end
end

local FACT = {
    enUS = "Did you know?", esES = "¿Sabías que…?", esMX = "¿Sabías que…?", deDE = "Schon gewusst?", frFR = "Le saviez-vous ?",
    itIT = "Lo sapevi?", ptBR = "Você sabia?", ruRU = "Знаете ли вы?", koKR = "알고 계셨나요?", zhCN = "你知道吗？", zhTW = "你知道嗎？",
}
for loc, text in pairs(FACT) do
    if ns.Strings[loc] then ns.Strings[loc].FACT_PREFIX = text end
end

local HIDE = {
    enUS = "Hide test windows", esES = "Ocultar ventanas de prueba", esMX = "Ocultar ventanas de prueba", deDE = "Testfenster ausblenden",
    frFR = "Masquer les fenêtres de test", itIT = "Nascondi finestre di prova", ptBR = "Ocultar janelas de teste", ruRU = "Скрыть тестовые окна",
    koKR = "테스트 창 숨기기", zhCN = "隐藏测试窗口", zhTW = "隱藏測試視窗",
}
for loc, text in pairs(HIDE) do
    if ns.Strings[loc] then ns.Strings[loc].HIDE_TEST_BTN = text end
end
