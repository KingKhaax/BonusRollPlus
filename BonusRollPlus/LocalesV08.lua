local ADDON, ns = ...

local NEW = {
    enUS = {
        USE_BLIZZARD = "Use the game's own loot window and keep only the rolls list next to it",
        AUTO_RECIPE = "Auto-Need recipes of my professions that I have not learned",
        AUTO_RECIPE_MSG = "Auto-Need on %s: you have not learned this %s recipe.",
        AUTO_NOTE = "Automatic rules are off by default. They always tell you in the chat what they did. Only the recipe rule ever rolls Need.",
    },
    esES = {
        USE_BLIZZARD = "Usar la ventana de tirada del propio juego y dejar solo la lista de tiradas a su lado",
        AUTO_RECIPE = "Necesidad automática en recetas de mis profesiones que no he aprendido",
        AUTO_RECIPE_MSG = "Necesidad automática en %s: no tienes aprendida esta receta de %s.",
        AUTO_NOTE = "Las reglas automáticas vienen apagadas. Siempre te dicen en el chat lo que han hecho. Solo la regla de recetas pide Necesidad.",
    },
    deDE = {
        USE_BLIZZARD = "Das Beutefenster des Spiels verwenden und nur die Liste der Würfe daneben behalten",
        AUTO_RECIPE = "Automatisch Bedarf auf Rezepte meiner Berufe, die ich noch nicht gelernt habe",
        AUTO_RECIPE_MSG = "Automatisch Bedarf bei %s: Du hast dieses Rezept (%s) noch nicht gelernt.",
        AUTO_NOTE = "Automatische Regeln sind standardmäßig aus. Sie melden im Chat immer, was sie getan haben. Nur die Rezeptregel würfelt Bedarf.",
    },
    frFR = {
        USE_BLIZZARD = "Utiliser la fenêtre de butin du jeu et ne garder que la liste des jets à côté",
        AUTO_RECIPE = "Besoin automatique pour les recettes de mes métiers que je n'ai pas apprises",
        AUTO_RECIPE_MSG = "Besoin automatique sur %s : vous n'avez pas appris cette recette de %s.",
        AUTO_NOTE = "Les règles automatiques sont désactivées par défaut. Elles disent toujours dans le chat ce qu'elles ont fait. Seule la règle des recettes choisit Besoin.",
    },
    itIT = {
        USE_BLIZZARD = "Usa la finestra del bottino del gioco e mantieni solo l'elenco dei tiri accanto",
        AUTO_RECIPE = "Necessità automatica per le ricette delle mie professioni che non ho imparato",
        AUTO_RECIPE_MSG = "Necessità automatica su %s: non hai imparato questa ricetta di %s.",
        AUTO_NOTE = "Le regole automatiche sono disattivate di default. Dicono sempre in chat cosa hanno fatto. Solo la regola delle ricette tira Necessità.",
    },
    ptBR = {
        USE_BLIZZARD = "Usar a janela de saque do próprio jogo e manter apenas a lista de rolagens ao lado",
        AUTO_RECIPE = "Necessidade automática em receitas das minhas profissões que não aprendi",
        AUTO_RECIPE_MSG = "Necessidade automática em %s: você não aprendeu esta receita de %s.",
        AUTO_NOTE = "As regras automáticas vêm desligadas. Elas sempre dizem no chat o que fizeram. Só a regra de receitas rola Necessidade.",
    },
    ruRU = {
        USE_BLIZZARD = "Использовать окно добычи самой игры и оставить рядом только список бросков",
        AUTO_RECIPE = "Автоматически выбирать «Мне нужно» для рецептов моих профессий, которые я не изучил",
        AUTO_RECIPE_MSG = "Авто «Мне нужно» на %s: вы не изучили этот рецепт (%s).",
        AUTO_NOTE = "Автоматические правила по умолчанию выключены. Они всегда сообщают в чате, что сделали. «Мне нужно» выбирает только правило рецептов.",
    },
    koKR = {
        USE_BLIZZARD = "게임 기본 전리품 창을 사용하고 옆에 굴림 목록만 유지",
        AUTO_RECIPE = "아직 배우지 않은 내 전문 기술 제작법에 자동으로 필요 선택",
        AUTO_RECIPE_MSG = "%s 자동 필요 선택: 이 %s 제작법을 아직 배우지 않았습니다.",
        AUTO_NOTE = "자동 규칙은 기본적으로 꺼져 있습니다. 무엇을 했는지 항상 채팅으로 알려 줍니다. 필요를 선택하는 것은 제작법 규칙뿐입니다.",
    },
    zhCN = {
        USE_BLIZZARD = "使用游戏自带的拾取窗口，仅在旁边保留掷骰列表",
        AUTO_RECIPE = "对我尚未学会的专业配方自动选择需求",
        AUTO_RECIPE_MSG = "已自动需求 %s：你还没有学会这个%s配方。",
        AUTO_NOTE = "自动规则默认关闭。它们每次都会在聊天中告诉你做了什么。只有配方规则会选择需求。",
    },
    zhTW = {
        USE_BLIZZARD = "使用遊戲內建的拾取視窗，只在旁邊保留擲骰清單",
        AUTO_RECIPE = "對我尚未學會的專業配方自動選擇需求",
        AUTO_RECIPE_MSG = "已自動需求 %s：你還沒有學會這個%s配方。",
        AUTO_NOTE = "自動規則預設為關閉。它們每次都會在聊天中告訴你做了什麼。只有配方規則會選擇需求。",
    },
}
NEW.esMX = NEW.esES

for loc, strings in pairs(NEW) do
    local target = ns.Strings[loc]
    if target then
        for k, v in pairs(strings) do target[k] = v end
    end
end

ns.ChangelogL = ns.ChangelogL or {}
ns.ChangelogL["0.8.0"] = {
    deDE = {
        "Neue Option, das Beutefenster des Spiels zu verwenden: BonusRoll Plus behält die Liste mit den Würfen aller und zeigt sie rechts daneben an.",
        "Neue automatische Regel (standardmäßig aus): Bedarf auf Rezepte deiner Berufe, die du noch nicht gelernt hast. Sie meldet im Chat, was sie getan hat.",
    },
    frFR = {
        "Nouvelle option pour utiliser la fenêtre de butin du jeu : BonusRoll Plus garde la liste des jets de tout le monde et l'affiche à sa droite.",
        "Nouvelle règle automatique (désactivée par défaut) : choisir Besoin pour les recettes de vos métiers que vous n'avez pas encore apprises. Elle dit dans le chat ce qu'elle a fait.",
    },
    itIT = {
        "Nuova opzione per usare la finestra del bottino del gioco: BonusRoll Plus mantiene l'elenco dei tiri di tutti e lo mostra alla sua destra.",
        "Nuova regola automatica (disattivata di default): tira Necessità sulle ricette delle tue professioni che non hai ancora imparato. Dice in chat cosa ha fatto.",
    },
    ptBR = {
        "Nova opção para usar a janela de saque do próprio jogo: o BonusRoll Plus mantém a lista com as rolagens de todos e a mostra à direita dela.",
        "Nova regra automática (desligada por padrão): rolar Necessidade em receitas das suas profissões que você ainda não aprendeu. Ela diz no chat o que fez.",
    },
    ruRU = {
        "Новая настройка: использовать окно добычи самой игры. BonusRoll Plus сохраняет список бросков всех игроков и показывает его справа от окна.",
        "Новое автоматическое правило (по умолчанию выключено): выбирать «Мне нужно» для рецептов ваших профессий, которые вы ещё не изучили. Оно сообщает в чате, что сделало.",
    },
    koKR = {
        "게임 기본 전리품 창을 사용하는 새 옵션: BonusRoll Plus는 모든 사람의 굴림 목록을 유지하고 창 오른쪽에 표시합니다.",
        "새 자동 규칙(기본 꺼짐): 아직 배우지 않은 내 전문 기술 제작법에 필요를 선택합니다. 무엇을 했는지 채팅으로 알려 줍니다.",
    },
    zhCN = {
        "新增选项：使用游戏自带的拾取窗口，BonusRoll Plus 会保留所有人的掷骰列表并显示在其右侧。",
        "新增自动规则（默认关闭）：对你尚未学会的专业配方自动选择需求，并在聊天中告诉你做了什么。",
    },
    zhTW = {
        "新增選項：使用遊戲內建的拾取視窗，BonusRoll Plus 會保留所有人的擲骰清單並顯示在其右側。",
        "新增自動規則（預設關閉）：對你尚未學會的專業配方自動選擇需求，並在聊天中告訴你做了什麼。",
    },
}
