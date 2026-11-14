local ADDON, ns = ...

ns.ChangelogL = ns.ChangelogL or {}
ns.ChangelogL["0.7.0"] = {
    deDE = {
        "Automatische Regeln (standardmäßig aus): Gegenstände automatisch passen, die deine Gegenstandsstufe senken, und billige BoE-Gegenstände automatisch mit Gier würfeln. Sie melden alles im Chat und würfeln nie Bedarf.",
        "Die Wertzeile zeigt jetzt Händlerpreis, Auktionshauspreis und Entzauberwert (TradeSkillMaster), jeweils mit Symbol, dazu die Münzsymbole des Spiels, „Nicht verkaufbar“ und ein goldenes BiS-Etikett, wenn NaowhForever_BiS installiert ist.",
        "Verbleibende Sekunden auf der Zeitleiste mit Farben, Stapelrichtung und Abstand der Fenster, Textgröße und immer kompakte einzeilige Zeilen.",
        "Profile lassen sich auch in Schlachtzügen, Dungeons und der offenen Welt automatisch laden.",
        "Verlauf: Sitzungsübersicht mit Gesamtwert, Filter nach Qualität und Export als Text.",
        "Das Einstellungsfenster ist in Abschnitte gegliedert und scrollbar.",
    },
    frFR = {
        "Règles automatiques (désactivées par défaut) : passer automatiquement les objets qui baissent votre niveau d'objet et choisir Cupidité pour les objets liés à l'équipement bon marché. Elles le disent toujours dans le chat et ne choisissent jamais Besoin.",
        "La ligne de valeur affiche désormais le prix chez le marchand, le prix à l'hôtel des ventes et la valeur de désenchantement (TradeSkillMaster), chacun avec son icône, avec les pièces du jeu, « Invendable » et une étiquette BiS dorée si NaowhForever_BiS est installé.",
        "Secondes restantes sur la barre de temps avec des couleurs, sens d'empilement et espacement des fenêtres, taille du texte et lignes compactes permanentes.",
        "Les profils peuvent aussi se charger automatiquement en raid, en donjon et en monde ouvert.",
        "Historique : résumé de la session avec la valeur totale, filtre par qualité et export en texte.",
        "La fenêtre de réglages est organisée en sections et défile.",
    },
    itIT = {
        "Regole automatiche (disattivate di default): passa automaticamente gli oggetti che abbassano il tuo livello oggetto e cupidigia automatica sugli oggetti BoE economici. Lo dicono sempre in chat e non tirano mai Necessità.",
        "La riga del valore ora mostra il prezzo al venditore, il prezzo alla casa d'aste e il valore di disincanto (TradeSkillMaster), ciascuno con la sua icona, con le monete del gioco, «Non vendibile» e un'etichetta BiS dorata se NaowhForever_BiS è installato.",
        "Secondi rimasti sulla barra del tempo con i colori, direzione di impilamento e spazio tra le finestre, dimensione del testo e righe compatte sempre attive.",
        "I profili si possono caricare automaticamente anche nelle incursioni, nelle spedizioni e nel mondo aperto.",
        "Cronologia: riepilogo della sessione con il valore totale, filtro per qualità ed esportazione come testo.",
        "La finestra delle impostazioni è organizzata in sezioni e scorre.",
    },
    ptBR = {
        "Regras automáticas (desligadas por padrão): passar automaticamente itens que reduzem seu nível de item e ganância automática em itens BoE baratos. Elas sempre avisam no chat e nunca rolam Necessidade.",
        "A linha de valor agora mostra o preço no vendedor, o preço na casa de leilões e o valor de desencantamento (TradeSkillMaster), cada um com seu ícone, com as moedas do jogo, «Não pode ser vendido» e uma etiqueta BiS dourada se NaowhForever_BiS estiver instalado.",
        "Segundos restantes na barra de tempo com cores, direção da pilha e espaço entre janelas, tamanho do texto e linhas compactas sempre ativas.",
        "Os perfis também podem ser carregados automaticamente em raides, masmorras e no mundo aberto.",
        "Histórico: resumo da sessão com o valor total, filtro por qualidade e exportação como texto.",
        "A janela de configurações é organizada em seções e rola.",
    },
    ruRU = {
        "Автоматические правила (по умолчанию выключены): автопас предметов, снижающих ваш уровень предмета, и автоматический «Не откажусь» для дешёвых предметов с привязкой при экипировке. Они всегда сообщают об этом в чате и никогда не выбирают «Мне нужно».",
        "Строка стоимости теперь показывает цену у торговца, цену на аукционе и стоимость распыления (TradeSkillMaster), каждую со своим значком, с монетами игры, «Нельзя продать» и золотой меткой BiS, если установлен NaowhForever_BiS.",
        "Оставшиеся секунды на полосе времени с цветами, направление стопки и расстояние между окнами, размер текста и постоянные компактные строки.",
        "Профили теперь можно загружать автоматически в рейдах, подземельях и открытом мире.",
        "История: сводка сессии с общей стоимостью, фильтр по качеству и экспорт в текст.",
        "Окно настроек разделено на секции и прокручивается.",
    },
    koKR = {
        "자동 규칙(기본값 꺼짐): 아이템 레벨이 낮아지는 아이템 자동 포기와 저렴한 착용 시 귀속 아이템 자동 욕심. 항상 채팅으로 알려 주며 절대 필요를 선택하지 않습니다.",
        "가치 줄에 상점 가격, 경매장 가격, 마법부여 분해 가치(TradeSkillMaster)가 각각 아이콘과 함께 표시되고, 게임 동전 아이콘, “판매 불가”, NaowhForever_BiS가 설치된 경우 금색 BiS 표시가 나옵니다.",
        "시간 막대에 남은 초가 색상과 함께 표시되며, 쌓는 방향과 창 간격, 글자 크기, 항상 간략한 한 줄 표시를 설정할 수 있습니다.",
        "프로필을 공격대, 던전, 오픈 월드에서도 자동으로 불러올 수 있습니다.",
        "기록: 총 가치가 포함된 접속 요약, 품질 필터, 텍스트로 내보내기.",
        "설정 창이 섹션으로 나뉘고 스크롤됩니다.",
    },
    zhCN = {
        "自动规则（默认关闭）：自动放弃会降低物品等级的物品，并对廉价的装备绑定物品自动选择贪婪。它们每次都会在聊天中告知，并且绝不选择需求。",
        "价值行现在显示商店价、拍卖行价和分解价值（TradeSkillMaster），各带图标，使用游戏的金币图标，显示“无法出售”，并在安装 NaowhForever_BiS 时显示金色 BiS 标记。",
        "时间条上显示剩余秒数并带颜色，可选择堆叠方向和窗口间距、文字大小，以及始终使用单行紧凑条目。",
        "配置现在也可以在团队副本、地下城和开放世界中自动加载。",
        "记录：包含总价值的本次登录摘要、按品质筛选以及导出为文本。",
        "设置窗口按分区组织并可滚动。",
    },
    zhTW = {
        "自動規則（預設關閉）：自動放棄會降低物品等級的物品，並對廉價的裝備綁定物品自動選擇貪婪。它們每次都會在聊天中告知，而且絕不選擇需求。",
        "價值行現在顯示商店價、拍賣場價和分解價值（TradeSkillMaster），各帶圖示，使用遊戲的金幣圖示，顯示「無法出售」，並在安裝 NaowhForever_BiS 時顯示金色 BiS 標記。",
        "時間條上顯示剩餘秒數並帶顏色，可選擇堆疊方向和視窗間距、文字大小，以及一律使用單行精簡項目。",
        "設定檔現在也可以在團隊副本、地城和開放世界中自動載入。",
        "記錄：包含總價值的本次登入摘要、依品質篩選以及匯出為文字。",
        "設定視窗依區塊組織並可捲動。",
    },
}
