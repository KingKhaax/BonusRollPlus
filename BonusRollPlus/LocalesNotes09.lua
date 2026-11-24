local _, ns = ...

ns.ChangelogL = ns.ChangelogL or {}
ns.ChangelogL["0.9.0"] = {
    deDE = {
        "Strg + Klick auf das Gegenstandssymbol öffnet die Anprobe des Spiels, damit du das Aussehen (Transmog) siehst.",
        "Neue Option (standardmäßig aus), um das Spiel-Popup „Du hast erhalten“ beim Gewinnen eines Gegenstands auszublenden.",
        "Sauberere Optik: Die dekorativen Kreise in „Violette Leere“ und „Frost“ sind weg, und Münzen und Symbole der Wertzeile stehen auf einer Höhe.",
    },
    frFR = {
        "Ctrl + clic sur l'icône de l'objet ouvre la cabine d'essayage du jeu pour voir l'apparence (transmog).",
        "Nouvelle option (désactivée par défaut) pour masquer l'alerte du jeu « Vous avez reçu » quand vous gagnez un objet.",
        "Aspect plus net : les cercles décoratifs de « Vide violet » et « Givre » ont disparu, et les pièces et icônes de la ligne de valeur sont alignées.",
    },
    itIT = {
        "Ctrl + clic sull'icona dell'oggetto apre il camerino del gioco per vedere l'aspetto (trasmogrificazione).",
        "Nuova opzione (disattivata di default) per nascondere l'avviso del gioco «Hai ricevuto» quando vinci un oggetto.",
        "Aspetto più pulito: i cerchi decorativi di «Vuoto viola» e «Gelo» sono spariti, e monete e icone della riga del valore sono allineate.",
    },
    ptBR = {
        "Ctrl + clique no ícone do item abre o provador do jogo para ver a aparência (transmog).",
        "Nova opção (desligada por padrão) para ocultar o aviso do jogo «Você recebeu» ao ganhar um item.",
        "Visual mais limpo: os círculos decorativos de «Vazio violeta» e «Gelo» foram removidos, e as moedas e os ícones da linha de valor ficam alinhados.",
    },
    ruRU = {
        "Ctrl + щелчок по значку предмета открывает примерочную игры, чтобы увидеть внешний вид (трансмогрификацию).",
        "Новая настройка (по умолчанию выключена): скрывать всплывающее окно игры «Вы получили» при выигрыше предмета.",
        "Более чистый вид: декоративные круги в темах «Фиолетовая пустота» и «Иней» убраны, а монеты и значки в строке стоимости выровнены.",
    },
    koKR = {
        "아이템 아이콘을 Ctrl + 클릭하면 게임의 피팅룸이 열려 외형(형상변환)을 볼 수 있습니다.",
        "아이템을 획득했을 때 게임의 '획득' 알림을 숨기는 새 옵션(기본 꺼짐)이 추가되었습니다.",
        "더 깔끔한 모습: '보라색 공허'와 '서리' 디자인의 장식 원을 없애고, 가치 줄의 동전과 아이콘 높이를 맞췄습니다.",
    },
    zhCN = {
        "按住 Ctrl 点击物品图标会打开游戏的试衣间，查看外观（幻化）。",
        "新增选项（默认关闭）：赢得物品时隐藏游戏自带的“你获得了”弹窗。",
        "界面更清爽：移除了“紫色虚空”和“冰霜”样式的装饰圆圈，价值行中的货币和图标也对齐了。",
    },
    zhTW = {
        "按住 Ctrl 點擊物品圖示會開啟遊戲的試衣間，查看外觀（塑形）。",
        "新增選項（預設關閉）：贏得物品時隱藏遊戲內建的「你獲得了」彈窗。",
        "介面更清爽：移除了「紫色虛空」和「冰霜」樣式的裝飾圓圈，價值行中的貨幣和圖示也對齊了。",
    },
}

ns.ChangelogL["0.9.1"] = {
    deDE = {
        "Wenn derselbe Gegenstand mehrmals fällt, zeigt jedes Fenster nur die Würfe seiner eigenen Verteilung, ohne die früherer Verteilungen.",
        "Wenn die Zeit eines Wurfs abläuft und das Spiel keinen Gewinner meldet, schließt sich das Fenster nach 12 Sekunden selbst, statt hängen zu bleiben.",
        "Sauberere Wertzeile: Das violette Sternchen für unbekannte Aussehen ist weg, und die Münzen stehen auf der Höhe der Zahlen.",
    },
    frFR = {
        "Quand le même objet tombe plusieurs fois, chaque fenêtre n'affiche que les jets de son propre tirage, sans ceux des tirages précédents.",
        "Si le temps d'un jet s'écoule et que le jeu n'annonce aucun gagnant, la fenêtre se ferme toute seule après 12 secondes au lieu de rester bloquée.",
        "Ligne de valeur plus nette : l'astérisque violet des apparences inconnues a disparu et les pièces sont alignées avec les chiffres.",
    },
    itIT = {
        "Quando lo stesso oggetto cade più volte, ogni finestra mostra solo i tiri della sua distribuzione, senza quelli delle precedenti.",
        "Se il tempo di un tiro finisce e il gioco non annuncia un vincitore, la finestra si chiude da sola dopo 12 secondi invece di restare bloccata.",
        "Riga del valore più pulita: l'asterisco viola degli aspetti sconosciuti non c'è più e le monete sono allineate ai numeri.",
    },
    ptBR = {
        "Quando o mesmo item cai várias vezes, cada janela mostra só as rolagens da sua própria distribuição, sem as de distribuições anteriores.",
        "Se o tempo de uma rolagem acaba e o jogo não anuncia o vencedor, a janela fecha sozinha após 12 segundos em vez de ficar travada.",
        "Linha de valor mais limpa: o asterisco roxo de aparências desconhecidas sumiu e as moedas ficam alinhadas com os números.",
    },
    ruRU = {
        "Если один и тот же предмет выпадает несколько раз, каждое окно показывает только броски своего розыгрыша, без бросков предыдущих.",
        "Если время броска истекло, а игра не объявила победителя, окно само закрывается через 12 секунд, а не зависает.",
        "Более аккуратная строка стоимости: фиолетовая звёздочка неизвестного облика убрана, а монеты выровнены по цифрам.",
    },
    koKR = {
        "같은 아이템이 여러 번 나오면 각 창은 이전 분배의 굴림이 아닌 자신의 분배 굴림만 표시합니다.",
        "굴림 시간이 끝났는데 게임이 승자를 알리지 않으면 창이 멈춰 있지 않고 12초 뒤에 저절로 닫힙니다.",
        "더 깔끔한 가치 줄: 수집하지 않은 외형을 나타내던 보라색 별표가 사라지고 동전이 숫자와 같은 높이에 맞춰졌습니다.",
    },
    zhCN = {
        "同一件物品多次掉落时，每个窗口只显示自己那次分配的掷骰，不再混入之前分配的结果。",
        "掷骰时间结束而游戏没有公布赢家时，窗口会在 12 秒后自动关闭，不再卡住。",
        "价值行更清爽：未收藏外观的紫色星号已移除，货币图标与数字对齐。",
    },
    zhTW = {
        "同一件物品多次掉落時，每個視窗只顯示自己那次分配的擲骰，不再混入先前分配的結果。",
        "擲骰時間結束而遊戲沒有公布贏家時，視窗會在 12 秒後自動關閉，不再卡住。",
        "價值行更清爽：未收藏外觀的紫色星號已移除，貨幣圖示與數字對齊。",
    },
}

ns.ChangelogL["0.9.2"] = {
    deDE = {
        "Behoben: Würfe und Gewinner erscheinen wieder im Fenster. Der Beute-Chat kommt ohne Link und mit dem Präfix [Beute] an, das wird jetzt richtig gelesen.",
        "Die Wurfliste wird nur noch aus dem Chat gefüllt und beginnt für jeden Gegenstand leer, sodass keine Würfe früherer Verteilungen desselben Gegenstands auftauchen.",
        "Fenster bleiben nach der Verteilung nicht mehr hängen.",
    },
    frFR = {
        "Corrigé : les jets et le gagnant s'affichent de nouveau dans la fenêtre. Le chat de butin arrive sans lien et avec le préfixe [Butin], ce qui est maintenant lu correctement.",
        "La liste des jets est remplie uniquement par le chat et commence vide pour chaque objet, sans jets de tirages précédents du même objet.",
        "Les fenêtres ne restent plus bloquées après l'attribution.",
    },
    itIT = {
        "Corretto: i tiri e il vincitore tornano a comparire nella finestra. La chat del bottino arriva senza link e con il prefisso [Bottino], ora letto correttamente.",
        "L'elenco dei tiri si riempie solo dalla chat e parte vuoto per ogni oggetto, senza tiri di distribuzioni precedenti dello stesso oggetto.",
        "Le finestre non restano più bloccate dopo l'assegnazione.",
    },
    ptBR = {
        "Corrigido: as rolagens e o vencedor voltam a aparecer na janela. O chat de saque chega sem link e com o prefixo [Saque], agora lido corretamente.",
        "A lista de rolagens é preenchida só pelo chat e começa vazia em cada item, sem rolagens de distribuições anteriores do mesmo item.",
        "As janelas não ficam mais travadas depois da entrega.",
    },
    ruRU = {
        "Исправлено: броски и победитель снова появляются в окне. Чат добычи приходит без ссылки и с префиксом [Добыча], теперь он читается правильно.",
        "Список бросков заполняется только из чата и для каждого предмета начинается пустым, без бросков прошлых розыгрышей того же предмета.",
        "Окна больше не зависают после розыгрыша.",
    },
    koKR = {
        "수정: 굴림과 승자가 다시 창에 표시됩니다. 전리품 채팅이 링크 없이 [전리품] 접두어와 함께 오는 것을 올바르게 읽습니다.",
        "굴림 목록은 채팅으로만 채워지며 아이템마다 비어 있는 상태로 시작해 같은 아이템의 이전 분배 굴림이 섞이지 않습니다.",
        "분배 후 창이 멈춰 있지 않습니다.",
    },
    zhCN = {
        "修复：掷骰结果和赢家重新显示在窗口中。战利品聊天不带链接且带有 [战利品] 前缀，现在可以正确读取。",
        "掷骰列表只由聊天填充，并且每件物品都从空列表开始，不再混入同一物品之前分配的结果。",
        "分配后窗口不再卡住。",
    },
    zhTW = {
        "修復：擲骰結果和贏家重新顯示在視窗中。戰利品聊天不帶連結且帶有 [戰利品] 前綴，現在可以正確讀取。",
        "擲骰列表只由聊天填入，且每件物品都從空列表開始，不再混入同一物品先前分配的結果。",
        "分配後視窗不再卡住。",
    },
}
