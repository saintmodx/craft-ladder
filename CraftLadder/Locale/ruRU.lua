-- Craft Ladder in Russian. The key is the English string as it stands in the code; what's missing here is shown in
-- English. Item, recipe and zone names come from the game itself, so they are not here.
-- The %s and %d of a line must stay in the same order as in the English one: the game fills them in that order.
local _, ns = ...

ns.Locales = ns.Locales or {}
ns.Locales.ruRU = {
    -- the auction house tab
    ["The items' names are still loading: click again."] = "Названия предметов ещё грузятся: нажмите ещё раз.",
    ["Stop"] = "Стоп",
    ["Full Rescan"] = "Пересканировать всё",
    ["Scanning %s: %d of %d items."] = "Сканирую %s: %d из %d предметов.",
    ["the auction house"] = "аукцион",
    ["Scan done: %d of %d items searched."] = "Сканирование готово: найдено %d из %d предметов.",
    ["A scan is already running: stop it first."] = "Сканирование уже идёт: сначала остановите его.",
    ["Nothing to scan here."] = "Здесь нечего сканировать.",
    ["Scanning %s: 0 of %d items."] = "Сканирую %s: 0 из %d предметов.",
    ["this step"] = "этот шаг",
    ["Confirm %s"] = "Купить за %s",
    ["Asking..."] = "Запрос...",
    ["Buying %d %s..."] = "Покупаю %d %s...",
    ["The auction house is busy: try again in a moment."] = "Аукцион занят: попробуйте через мгновение.",
    ["Asking the price of %d %s..."] = "Узнаю цену %d %s...",
    ["Scan"] = "Скан",
    ["Asks the auction house what this one goes for now, and puts that price in the ladder. However fresh the" ..
        " price already is."] = "Спрашивает у аукциона цену этого предмета сейчас и ставит её в лестницу. Даже" ..
        " если цена уже свежая.",
    ["Asks the auction house about what this step makes and everything it takes, then puts those prices in the" ..
        " ladder."] = "Спрашивает у аукциона цену того, что делает шаг, и всех его реагентов, и ставит их в" ..
        " лестницу.",
    ["Search"] = "Поиск",
    ["Auctionator's Shopping tab with what this step buys, and how many."] = "Вкладка покупок Auctionator с" ..
        " тем, что покупает шаг, и в каком количестве.",
    ["Learn %s"] = "Выучить %s",
    ["at %d, raises your cap to %d"] = "на %d, поднимает предел до %d",
    ["%s%s|r a craft, %s"] = "%s%s|r за крафт, %s",
    ["sold to a vendor"] = "продаётся торговцу",
    ["%d listed"] = "выставлено: %d",
    ["%d - %d, ~%d %s%s"] = "%d - %d, ~%d %s%s",
    [", %d listed"] = ", выставлено: %d",
    ["at %d, make one and keep it"] = "на %d, сделайте один и оставьте себе",
    ["nothing to buy"] = "покупать нечего",
    ["need %d, you have %d"] = "нужно %d, у вас %d",
    ["%s each"] = "%s за штуку",
    ["not listed"] = "не выставлено",
    ["No crafting profession: nothing to buy for one."] = "Нет ремесленной профессии: покупать не для чего.",
    ["%s: nothing to buy"] = "%s: покупать нечего",
    ["Scan stopped: the prices it had got are in."] = "Сканирование остановлено: найденные цены сохранены.",
    ["Nothing here to rescan."] = "Здесь нечего пересканировать.",
    ["Every price here was searched in the last two minutes: nothing to ask again."] =
        "Все цены здесь искали меньше двух минут назад: спрашивать нечего.",
    ["Scanning the auction house: 0 of %d items."] = "Сканирую аукцион: 0 из %d предметов.",
    ["Searches the auction house for everything this list buys and sells, then puts the prices in the ladder." ..
        " It goes one item at a time, as the server allows: watch the line below. An item searched in the last" ..
        " two minutes is left alone."] = "Ищет на аукционе всё, что список покупает и продаёт, и ставит цены в" ..
        " лестницу. Идёт по одному предмету, как позволяет сервер: следите за строкой ниже. Предмет, который" ..
        " искали меньше двух минут назад, пропускается.",
    ["Crafts"] = "Крафтов",
    ["A click on a step or a reagent searches it in Auctionator's Shopping tab."] = "Клик по шагу или реагенту" ..
        " ищет его во вкладке покупок Auctionator.",
    ["Craft Ladder"] = "Craft Ladder",
    ["%d %s for %s (%s each): click Confirm to buy."] = "%d %s за %s (%s за штуку): нажмите «Купить за», чтобы" ..
        " купить.",
    ["No price for %s: not enough listed, or not sold that way (try the Buy tab)."] =
        "Нет цены для %s: мало выставлено или так не продаётся (попробуйте вкладку покупки).",
    ["Bought %d %s."] = "Куплено: %d %s.",
    ["The purchase failed (the price may have changed): ask again."] = "Покупка не прошла (цена могла" ..
        " измениться): спросите цену снова.",

    -- the camp view
    ["No profession"] = "Нет профессии",
    [" (skill %d)"] = " (навык %d)",
    ["you know it"] = "вы это знаете",
    ["you can learn it"] = "можно выучить",
    ["not your profession"] = "не ваша профессия",
    ["%d in your bags"] = "%d в сумках",
    ["needs %s"] = "нужно: %s",
    ["make %s"] = "сделать %s",
    ["no price"] = "нет цены",
    ["AH %s"] = "аукцион %s",
    ["  (not with %s)"] = "  (не вместе с %s)",
    ["Or, the same buff and more: %s"] = "Или то же и лучше: %s",
    ["Camp: the buffs a campfire gives, for a level %d %s"] = "Лагерь: что даёт костёр - %d уровень, %s",
    ["Holds %d camp features. %s; %s."] = "Вмещает %d предметов лагеря. %s; %s.",
    ["A %s holds %d: the ones above. Then:"] = "%s вмещает %d: те, что выше. Дальше:",
    ["Doesn't help a %s"] = "Не нужно для роли «%s»",
    ["Camp features with no buff"] = "Предметы лагеря без бонуса",
    ["Build a campfire, place camp features around it and sit or craft nearby for a while: each feature gives" ..
        " everyone there its buff. A campfire holds only so many: here they are in the order your role wants" ..
        " them."] = "Разведите костёр, расставьте вокруг предметы лагеря и посидите или покрафтите рядом:" ..
        " каждый предмет даёт свой бонус всем вокруг. Костёр вмещает ограниченное число предметов: здесь они в" ..
        " том порядке, в каком нужны вашей роли.",
    ["Campfire:"] = "Костёр:",

    -- the characters' buttons
    ["Level %d %s"] = "Уровень %d, %s",
    ["Playing now"] = "Играете сейчас",
    ["Last seen %s"] = "Последний раз: %s",

    -- the menu
    ["Show the %s ladder."] = "Показать лестницу: %s.",
    ["not learned"] = "не изучено",
    ["Disenchant"] = "Распыление",
    ["Camp"] = "Лагерь",
    ["What's worth disenchanting on your whole account: what every character's bags and bank hold, what the" ..
        " auction house lists for less than disenchanting it brings, and what your crafting professions make" ..
        " that's worth more disenchanted than sold."] = "Что стоит распылить на всём аккаунте: что лежит в" ..
        " сумках и банке каждого персонажа, что на аукционе стоит дешевле, чем даёт распыление, и что ваши" ..
        " ремёсла делают выгоднее распылить, чем продать.",
    ["What each camp feature gives around a campfire, in the order your role wants them, and how to get it."] =
        "Что даёт каждый предмет лагеря у костра, в порядке, нужном вашей роли, и где его взять.",

    -- the minimap button
    ["Earns most"] = "Больше всего даёт",
    ["%s, %s an hour"] = "%s, %s в час",
    ["Now"] = "Сейчас",
    ["%s in %s to %d"] = "%s в зоне %s до %d",
    ["fish"] = "рыбачить",
    ["mine"] = "добывать",
    ["catches"] = "уловов",
    ["nodes"] = "жил",
    ["%s to %d"] = "%s до %d",
    ["~%d crafts, %s"] = "~%d крафтов, %s",
    ["Eat"] = "Съесть",
    ["%s, +%s a craft"] = "%s, +%s за крафт",
    ["reach level %d"] = "достичь %d уровня",
    ["learn %s"] = "выучить %s",
    ["Up to %d"] = "До %d",
    ["Prices"] = "Цены",
    ["Click: open or close the window"] = "Клик: открыть или закрыть окно",
    ["Drag: move the button"] = "Перетаскивание: передвинуть кнопку",
    ["minimap button hidden - /craft minimap shows it again."] = "кнопка у миникарты скрыта - /craft minimap" ..
        " вернёт её.",
    ["minimap button shown."] = "кнопка у миникарты показана.",

    -- the Settings menu
    ["Auction house prices from"] = "Цены аукциона из",
    ["Its last full scan of your faction's auction house: the lowest price, the median and how many are" ..
        " listed."] = "Его последнее полное сканирование аукциона вашей фракции: самая низкая цена, медиана и" ..
        " сколько выставлено.",
    ["Its last scan. It gives one price per item, so the median is that price."] = "Его последнее" ..
        " сканирование. Он даёт одну цену на предмет, поэтому медиана равна ей.",
    ["An ingredient costs"] = "Реагент стоит",
    ["The median listed price"] = "Медианную цену лота",
    ["Half of what's listed costs less. The cheapest listing is one auction, often gone minutes after the" ..
        " scan."] = "Половина лотов стоит дешевле. Самый дешёвый лот - это один аукцион, часто его уже нет" ..
        " через несколько минут после сканирования.",
    ["The cheapest listing"] = "Цену самого дешёвого лота",
    ["What the ladder cost before: the lowest price of the scan. Cheaper than what you will really pay, unless" ..
        " you are quick."] = "Как лестница считала раньше: самая низкая цена сканирования. Дешевле того, что" ..
        " вы заплатите на самом деле, если не успеете первым.",
    ["Language"] = "Язык",
    ["Craft Ladder's own words. Item, recipe and zone names come from your game client, in its language. A few" ..
        " buttons take a /reload to change."] = "Собственные надписи Craft Ladder. Названия предметов," ..
        " рецептов и зон приходят из клиента игры, на его языке. Несколько кнопок меняются после /reload.",
    ["What you sell is always priced at the cheapest listing, the one you undercut."] =
        "То, что вы продаёте, всегда считается по цене самого дешёвого лота - того, который вы перебиваете.",
    ["%s isn't installed: %s is read."] = "%s не установлен: читается %s.",
    ["Neither addon is installed: no auction house prices."] = "Ни один аддон не установлен: цен аукциона нет.",

    -- the Specialization view
    ["%s%d / %d|r  %s"] = "%s%d / %d|r  %s",
    ["level %d (you're %d)"] = "уровень %d (у вас %d)",
    ["%s %d (you have %d)"] = "%s %d (у вас %d)",
    ["Needs %s."] = "Нужно: %s.",
    [" and "] = " и ",
    ["Or take it here instead:"] = "Или возьмите здесь:",
    ["Take the quest:"] = "Взять задание:",
    ["Take and hand in the quest:"] = "Взять и сдать задание:",
    ["Hand it in:"] = "Сдать здесь:",
    ["you have them all"] = "у вас есть все",
    ["auction house %s"] = "аукцион %s",
    ["none at the auction house"] = "на аукционе нет",
    ["Make %d; some of its ingredients have no price; %s"] = "Сделать %d; у части реагентов нет цены; %s",
    ["Make %d for %s; %s"] = "Сделать %d за %s; %s",
    ["Buy %d: %s%s"] = "Купить %d: %s%s",
    [", making them costs %s"] = ", сделать их стоит %s",
    ["Drops from %s"] = "Падает с: %s",
    ["Drops from %d kinds of creatures; "] = "Падает с %d видов существ; ",
    ["none at the auction house now"] = "сейчас на аукционе нет",
    [", learned at %d"] = ", изучается на %d",
    ["its recipe drops from %d kinds of creatures, none at the auction house now"] = "его рецепт падает с %d" ..
        " видов существ, на аукционе сейчас нет",
    ["no way to learn it for you now"] = "вам его сейчас негде выучить",
    ["Buy the recipe:"] = "Купить рецепт:",
    ["Learn it from the trainer:"] = "Выучить у тренера:",
    ["Bring to %s:"] = "Принести: %s:",
    ["the quest giver"] = "тот, кто даёт задание",
    ["%s%d %s%s"] = "%s%d %s%s",
    ["smelt "] = "переплавить ",
    [" (besides the %d you have)"] = " (сверх тех %d, что у вас есть)",
    ["Make: %s"] = "Сделать: %s",
    ["Ingredients:"] = "Реагенты:",
    ["buy %d: "] = "купить %d: ",
    ["the smith"] = "кузнец",
    ["%d. Talk to %s"] = "%d. Поговорить: %s",
    ["Talk to:"] = "Поговорить:",
    ["%d. Master a weapon: one of them"] = "%d. Освоить оружие: одно из них",
    ["%s: the quest %s"] = "%s: задание %s",
    ["The recipes"] = "Рецепты",
    ["  %d to learn"] = "  выучить: %d",
    ["Click to fold or open."] = "Клик сворачивает и разворачивает.",
    ["Show the steps to %s."] = "Показать шаги к специализации: %s.",
    ["You have this specialization."] = "У вас есть эта специализация.",
    ["Needs level %d and %s %d; you're level %d with %d."] = "Нужен %d уровень и %s %d; у вас %d уровень и %d.",
    ["Unlocks %d recipes only this specialization can learn."] = "Открывает %d рецептов, доступных только этой" ..
        " специализации.",
    ["You have %s: a character can have only one %s specialization."] = "У вас есть %s: у персонажа может быть" ..
        " только одна специализация (%s).",
    ["Still to spend: %s, each item made or bought, whichever costs less%s."] = "Ещё потратить: %s, каждый" ..
        " предмет сделан или куплен - как дешевле%s.",
    ["; some have no price"] = "; у части нет цены",
    ["You have %s"] = "У вас есть %s",
    ["To %s: about %s%s"] = "До «%s»: около %s%s",
    [", some items unpriced"] = ", у части предметов нет цены",

    -- the window: the list, its rows and their tooltips
    [" - %s%s %d|r"] = " - %s%s %d|r",
    ["%d days"] = "%d дней",
    ["%d hours"] = "%d часов",
    ["~%d min"] = "~%d мин",
    ["All locks"] = "Все замки",
    ["Every lock a rogue picks, by the skill it needs, and its colour for you."] = "Все замки, которые" ..
        " вскрывает разбойник, по нужному навыку и их цвету для вас.",
    ["At %d your cap is the level x 5: %d at level %d."] = "На %d ваш предел - уровень x 5: %d на %d уровне.",
    ["at %d, cap %d"] = "на %d, предел %d",
    ["Skill"] = "Навык",
    ["Smelt on the way"] = "Переплавить по пути",
    ["Trainer"] = "Тренер",
    ["Catches"] = "Уловы",
    ["Lure"] = "Наживка",
    ["none"] = "нет",
    ["Cost"] = "Стоимость",
    ["In your bags"] = "В сумках",
    [", soulbound"] = ", персональный",
    ["One craft"] = "Один крафт",
    ["Disenchanted"] = "Распылить",
    ["Sold"] = "Продать",
    [" at the auction house"] = " на аукционе",
    [" at a vendor"] = " торговцу",
    ["nobody buys it"] = "никто не покупает",
    ["Best"] = "Лучше всего",
    ["Disenchanting one craft"] = "Распылить один крафт",
    ["Cheapest listing"] = "Самый дешёвый лот",
    ["Gains"] = "Выгода",
    [", more %d%% of the time"] = ", выгоднее в %d%% случаев",
    ["Raises"] = "Повышает",
    ["Cook one"] = "Приготовить один",
    ["Buy one"] = "Купить один",
    ["Sells for"] = "Продаётся за",
    ["Profit"] = "Прибыль",
    ["Listed"] = "Выставлено",
    ["%d - %d, ~%d %s"] = "%d - %d, ~%d %s",
    ["%s of ~%d, from what you have (vendor reagents aside)"] = "%s из ~%d, из того, что у вас есть (реагенты" ..
        " торговцев не в счёт)",
    ["%slvl %d|r - "] = "%sур. %d|r - ",
    ["known, make %d now"] = "известно, сейчас можно сделать %d",
    ["learn now (skill %d)"] = "можно выучить (навык %d)",
    ["skill %d (you %d)"] = "навык %d (у вас %d)",
    ["level %d (you %d)"] = "уровень %d (у вас %d)",
    ["%s ready"] = "готово: %s",
    ["chests, boxes and doors by skill"] = "сундуки, ящики и двери по навыку",
    ["Reach level %d"] = "Достичь %d ур.",
    ["at %d, raises your cap to %d%s"] = "на %d, поднимает предел до %d%s",
    ["Fish in %s"] = "Ловить рыбу в %s",
    ["your pick"] = "ваш выбор",
    ["an hour: ~%d catches, %s each%s%s"] = "в час: ~%d уловов, %s за штуку%s%s",
    ["%d - %d, ~%d catches%s"] = "%d - %d, ~%d уловов%s",
    ["%s%s, %s%s%s%s%s%s"] = "%s%s, %s%s%s%s%s%s",
    ["%s, %s, disenchanted ~%s, sold %s"] = "%s, %s, распыление ~%s, продажа %s",
    ["%s's %s - %s: ~%s disenchanted, %s sold%s"] = "%s, %s - %s: ~%s распылением, %s продажей%s",
    ["buy %s, ~%s disenchanted, pays %d%% of the time"] = "купить за %s, ~%s распылением, выгодно в %d%%" ..
        " случаев",
    ["%d - %d%s: %s"] = "%d - %d%s: %s",
    ["keep them"] = "оставьте себе",
    ["unconfirmed"] = "не подтверждено",
    ["after %d%s, %sneeded for %s|r"] = "после %d%s, %sнужен для: %s|r",
    ["%s%s, %smake one and keep it|r"] = "%s%s, %sсделайте один и оставьте себе|r",
    ["%d favor"] = "%d благосклонности",
    ["? favor"] = "? благосклонности",
    ["Open your %s window once so Craft Ladder knows which recipes you have."] = "Откройте окно «%s» один раз," ..
        " чтобы Craft Ladder узнал ваши рецепты.",
    ["No %s found past %d with what Craft Ladder knows."] = "%s: после %d Craft Ladder больше ничего не знает.",
    ["zone"] = "зона",
    ["recipe"] = "рецепт",
    ["Back to your ladder"] = "Назад к лестнице",
    ["Merchant's Favor recipes (%d)"] = "Рецепты за благосклонность (%d)",
    ["Dishes for this role, by what eating one raises. Click to fold or open."] = "Блюда для этой роли, по" ..
        " тому, что они повышают. Клик сворачивает и разворачивает.",
    ["Nothing here"] = "Здесь пусто",
    ["Nothing earns this way at today's prices."] = "Так ничего не зарабатывает при нынешних ценах.",
    ["Sell to a vendor"] = "Продать торговцу",
    ["These cost less to make than a vendor pays: vendors buy any number, no auction house needed. Click to" ..
        " fold or open."] = "Их дешевле сделать, чем платит торговец: торговцы берут любое количество, аукцион" ..
        " не нужен. Клик сворачивает и разворачивает.",
    ["Sell at the auction house"] = "Продать на аукционе",
    ["These earn more at the auction house: 5 or more listed (or however few when you searched it yourself)," ..
        " and it pays 1.5 times what a vendor does. How many sell, the auction house doesn't say."] =
        "Эти выгоднее на аукционе: выставлено 5 и больше (или сколько угодно, если вы искали сами), и платят в" ..
        " 1.5 раза больше торговца. Сколько продастся, аукцион не говорит.",
    ["nothing at today's prices"] = "ничего при нынешних ценах",
    ["Disenchant, your whole account: no Enchanting needed"] = "Распыление, весь ваш аккаунт: чары не нужны",
    ["the ladder from %d to %d"] = "лестница с %d до %d",
    ["the ladder to %d"] = "лестница до %d",
    ["%s%s %d / %d, %s%s"] = "%s%s %d / %d, %s%s",
    ["as of %s"] = "по состоянию на %s",
    ["%s has no %s yet"] = "у персонажа %s ещё нет: %s",
    ["No %s yet"] = "Профессии %s ещё нет",
    ["Specialization"] = "Специализация",
    ["Skill %d"] = "Навык %d",
    ["No auction house prices: AuctionDB or Auctionator needed"] = "Нет цен аукциона: нужен AuctionDB или" ..
        " Auctionator",
    [" %s prices scanned %s, costs may be off: scan at the auction house|r"] = " цены %s сканированы %s," ..
        " стоимость может быть неверной: просканируйте на аукционе|r",
    ["%s prices scanned %s: scan at the auction house|r"] = "цены %s сканированы %s: просканируйте на" ..
        " аукционе|r",
    ["Prices: %s, scanned %s (%s)|r"] = "Цены: %s, сканированы %s (%s)|r",
    ["today"] = "сегодня",
    ["yesterday"] = "вчера",
    ["%d days ago"] = "%d дней назад",
    ["Prices: Auctionator, newest prices from %s|r"] = "Цены: Auctionator, самые свежие от %s|r",
    ["Prices: %s"] = "Цены: %s",
    ["%d Merchant's Favor recipes, %d you can learn now%s"] = "%d рецептов за благосклонность, %d можно" ..
        " выучить сейчас%s",
    ["; you have %d favor"] = "; у вас %d благосклонности",
    ["%d dishes for your class; the cost is one dish from bought ingredients"] = "%d блюд для вашего класса;" ..
        " стоимость - одно блюдо из купленных реагентов",
    ["%d zones at skill %d; the best about %s an hour"] = "%d зон на навыке %d; лучшая даёт около %s в час",
    ["Spend %s, catch about %s worth (%s, %s an hour)"] = "Потратить %s, наловить примерно на %s (%s, %s в" ..
        " час)",
    ["Spend %s, %s about %s worth (%s an hour), about %d %s"] = "Потратить %s, %s примерно на %s (%s в час)," ..
        " около %d %s",
    ["%s%d at the auction house; the best +%s a craft"] = "%s%d на аукционе; лучший даёт +%s за крафт",
    ["Total %s, about %d %s%s"] = "Всего %s, около %d %s%s",
    ["Total %s, about %d catches (%s)"] = "Всего %s, около %d уловов (%s)",
    ["Spend %s, about %s back from sales, about %d crafts"] = "Потратить %s, вернётся с продаж около %s, около" ..
        " %d крафтов",
    ["Total %s, about %d crafts"] = "Всего %s, около %d крафтов",
    ["Plan the ladder to %d."] = "Планировать лестницу до %d.",
    ["Window size"] = "Размер окна",
    ["Drag: make the window bigger."] = "Перетаскивание: увеличить окно.",
    ["Ctrl + mouse wheel: bigger or smaller text (now %d%%)."] = "Ctrl + колесо мыши: крупнее или мельче текст" ..
        " (сейчас %d%%).",
    ["Right-click: back to the normal size."] = "Правый клик: вернуть обычный размер.",
    ["Close"] = "Закрыть",
    ["Escape closes it too."] = "Escape тоже закрывает.",
    ["Settings"] = "Настройки",
    ["Which auction house addon the prices are read from, and which of its listed prices an ingredient costs."] =
        "Из какого аддона аукциона читаются цены и по какой из его цен считается реагент.",
    ["Your hands are idle, adventurer."] = "Ваши руки без дела, искатель приключений.",
    ["The trainers are waiting: learn a profession."] = "Тренеры ждут: выучите профессию.",
    ["The steps to each of its specializations: the quests, what they ask for and what you have of it, the" ..
        " recipes, and what's still to make or buy."] = "Шаги к каждой специализации: задания, что они просят" ..
        " и что у вас есть, рецепты и что ещё сделать или купить.",
    ["Merchant's Favor recipes"] = "Рецепты за благосклонность торговца",
    ["What the supply camps' quartermaster sells for Merchant's Favor: its price and level (seen at a" ..
        " quartermaster), your skill, what you know and can make."] = "Что интендант лагеря снабжения продаёт" ..
        " за благосклонность торговца: цена и уровень (увиденные у интенданта), ваш навык, что вы знаете и" ..
        " можете сделать.",
    ["Back to cheapest"] = "Назад к самому дешёвому",
    ["Use the cheapest recipe for this step again."] = "Снова использовать самый дешёвый рецепт для этого" ..
        " шага.",
    ["Search the auction house"] = "Искать на аукционе",
    ["Auctionator's Shopping tab with this item. The auction house must be open."] = "Вкладка покупок" ..
        " Auctionator с этим предметом. Аукцион должен быть открыт.",
    ["Also use recipes bought with Merchant's Favor."] = "Использовать и рецепты за благосклонность торговца.",
    ["Reset"] = "Сброс",
    ["The ladder from your skill to 300 again."] = "Лестница снова от вашего навыка до 300.",
    ["No profession yet"] = "Профессии пока нет",

    -- the menu's group headings
    ["PROFESSIONS"] = "ПРОФЕССИИ",
    ["SECONDARY"] = "ВТОРОСТЕПЕННЫЕ",
    ["CLASS"] = "КЛАССОВЫЕ",

    -- the modes over the list, and what each one plans (the names the tooltips use)
    ["Vendor sales"] = "Торговцу",
    ["AH sales"] = "Аукцион",
    ["Food"] = "Еда",
    ["Favor"] = "Благосклонность",
    ["done"] = "готово",
    ["in your quest log"] = "в журнале заданий",

    -- one option's tooltip and its row
    ["Click: put a map pin and the arrow on it."] = "Клик: поставить метку на карте и стрелку к ней.",
    ["%s that give points"] = "%s, дающих очки",
    ["%s for this step"] = "%s на этот шаг",
    ["A %s is worth"] = "%s стоит",
    ["Gold an hour"] = "Золота в час",
    ["Click to %s here for this step."] = "Клик: %s здесь на этом шаге.",
    ["Fish that land"] = "Доходит до берега",
    ["all of them"] = "вся",
    ["none needed"] = "не нужна",
    ["A catch is worth"] = "Улов стоит",
    ["Lures for this step"] = "Наживка на этот шаг",
    ["Click to fish here for this step."] = "Клик: ловить здесь на этом шаге.",
    ["%s the %d you can make from what you have."] = "%s %d из того, что уже есть.",
    ["Ingredients"] = "Реагенты",
    ["Learn"] = "Изучение",
    ["Recipe"] = "Рецепт",
    ["Selling them brings back"] = "Продажа вернёт",
    ["Per skill point"] = "За очко навыка",
    ["Click to use this recipe for this step."] = "Клик: взять этот рецепт на этот шаг.",
    ["~%d %s, %s a %s"] = "~%d %s, %s за %s",
    ["%s at the trainer"] = "%s у учителя",
    ["no fish get away"] = "рыба не срывается",
    ["%d%% of casts land a fish"] = "%d%% забросов дают рыбу",
    [", with %s"] = ", с %s",
    ["%s a catch%s"] = "%s за улов%s",
    [", lures %s"] = ", наживка %s",
    [" / catch"] = " / улов",
    ["%s for lures"] = "%s на наживку",
    ["  with what you have"] = "  из того, что есть",
    ["from your bags"] = "из сумок",
    ["bought at the auction house"] = "куплено на аукционе",
    ["learn: %s"] = "изучить: %s",
    [" / point"] = " / очко",
    ["%s in all%s"] = "%s всего%s",
    [", %s back"] = ", %s обратно",
    [" / hour"] = " / час",

    -- a folded list, the ingredients, the colours
    ["all %d %s"] = "все %d %s",
    ["and %d more %s"] = "и ещё %d %s",
    ["and %d more"] = "и ещё %d",
    ["vendors"] = "торговцев",
    ["trainers"] = "учителей",
    [" (you have them)"] = " (они у вас есть)",
    ["  (you have %d%s)"] = "  (у вас %d%s)",
    [", in the bank"] = ", в банке",
    [", %d in the bank"] = ", %d в банке",
    ["smelt"] = "переплавить",
    ["%s %d yourself from %s%s"] = "%s %d самому из %s%s",
    [", buy the other %d"] = ", остальные %d купить",
    ["you have enough"] = "у вас достаточно",
    ["only %d listed - you need %d"] = "выставлено только %d - нужно %d",
    ["  your Cooking uses it"] = "  ваша Кулинария это использует",
    ["%d%% of catches%s"] = "%d%% улова%s",
    [" each"] = " за штуку",
    ["  creatures level %d+|r"] = "  существа %d+ ур.|r",
    ["at the auction house, after its cut"] = "на аукционе, после его сбора",
    ["at a vendor"] = "у торговца",
    ["what's inside, on average"] = "что внутри, в среднем",
    ["orange"] = "оранжевый",
    ["yellow"] = "жёлтый",
    ["green"] = "зелёный",
    ["grey"] = "серый",
    ["from %d"] = "с %d",
    ["Your pick."] = "Ваш выбор.",

    -- the Craft bar
    ["An enchantment: enchant from the profession window, on the item."] = "Это чары: накладывайте их из окна" ..
        " профессии, на предмет.",
    ["Learn the recipe first."] = "Сначала изучите рецепт.",
    ["Not in combat."] = "Не в бою.",
    ["Not enough reagents in your bags."] = "В сумках не хватает реагентов.",
    ["Craft"] = "Создать",
    ["Crafts as many as the box says; opens your profession window first if it's closed (the game crafts only" ..
        " with it open)."] = "Создаёт столько, сколько указано в поле; сначала откроет окно профессии, если" ..
        " оно закрыто (игра создаёт предметы только с открытым окном).",
    [" Cooking needs a fire nearby."] = " Кулинарии нужен огонь рядом.",
    ["Your bags allow %d"] = "Из сумок хватит на %d",
    ["; the step needs %d."] = "; шагу нужно %d.",
    ["Opening your %s window: crafting once it's ready."] = "Открываю окно профессии %s: создам, как только" ..
        " оно будет готово.",

    -- how to learn a recipe
    ["Learn it"] = "Как изучить",
    ["Buy the recipe from %s:"] = "Купите рецепт у %s:",
    ["one of these vendors"] = "одного из этих торговцев",
    ["this vendor"] = "этого торговца",
    ["%s Favor"] = "Благосклонность %s",
    ["Merchant's"] = "торговцев",
    ["Quest reward: %s%s"] = "Награда за задание: %s%s",
    ["(needs level %d)"] = "(нужен %d ур.)",
    ["quest giver"] = "выдаёт задание",
    ["Only these trainers teach it, for %s:"] = "Этому учат только эти учителя, за %s:",
    ["trainer"] = "учитель",
    ["None of them is of your faction."] = "Ни один из них не вашей фракции.",
    ["Or buy it at the auction house: %s."] = "Или купите на аукционе: %s.",
    ["Or %s."] = "Или %s.",
    ["During %s: %s."] = "Во время %s: %s.",
    ["The price is an estimate: Craft Ladder learns the real one when you visit the %s."] =
        "Цена примерная: Craft Ladder узнает настоящую, когда вы туда зайдёте (%s).",
    ["vendor"] = "торговец",

    -- what it sells for, and one craft
    ["An enchantment: nothing to sell."] = "Это чары: продавать нечего.",
    ["%s%s at the auction house (after its cut%s)."] = "%s%s на аукционе (после его сбора%s).",
    ["Not on the auction house."] = "На аукционе нет.",
    ["%s%s at a vendor."] = "%s%s у торговца.",
    ["Vendors don't buy it."] = "Торговцы это не покупают.",
    ["One craft%s: %s"] = "Одно создание%s: %s",
    ["One craft: %s"] = "Одно создание: %s",
    [" (makes %d)"] = " (даёт %d)",
    ["auction house"] = "аукцион",
    ["%s yourself%s"] = "%s самому%s",
    [" and %s"] = " и %s",
    ["%s each, %s"] = "%s за штуку, %s",
    ["Each sells for "] = "Каждый продаётся за ",
    ["Sells for "] = "Продаётся за ",
    ["%d sell for "] = "%d продаются за ",

    -- a Merchant's Favor recipe
    ["You know it."] = "Вы это знаете.",
    ["You can learn it now."] = "Можно изучить прямо сейчас.",
    ["It needs %d %s (you: %d)."] = "Нужно %d %s (у вас: %d).",
    ["It needs level %d (you: %d)."] = "Нужен %d ур. (у вас: %d).",
    ["Merchant's Favor"] = "благосклонность торговцев",
    ["Costs %d Merchant's Favor%s."] = "Стоит %d благосклонности торговцев%s.",
    [" (you have %d)"] = " (у вас %d)",
    ["Its price: open a quartermaster once and Craft Ladder remembers it."] = "Цена: загляните к интенданту" ..
        " один раз, и Craft Ladder её запомнит.",
    ["From level %d (you: %d)."] = "С %d ур. (у вас: %d).",
    ["Its level: open a quartermaster once and Craft Ladder remembers it."] = "Уровень: загляните к интенданту" ..
        " один раз, и Craft Ladder его запомнит.",
    ["From %d %s (you: %d)."] = "С %d %s (у вас: %d).",
    ["%s is %s from level %d (you: %d)."] = "%s %s с %d ур. (у вас: %d).",
    ["worn"] = "надевается",
    ["used"] = "используется",
    ["Quartermaster"] = "Интендант",
    ["The plan needs %s with %s."] = "Нужна репутация %s с %s.",
    ["Only for %s."] = "Только для %s.",
    ["Hated"] = "Ненависть",
    ["Hostile"] = "Враждебность",
    ["Unfriendly"] = "Неприязнь",
    ["Neutral"] = "Равнодушие",
    ["Friendly"] = "Дружелюбие",
    ["Honored"] = "Уважение",
    ["Revered"] = "Почтение",
    ["Exalted"] = "Превознесение",

    -- a crafting step
    ["Skill %d - %d, about %d crafts, %s%s"] = "Навык %d - %d, около %d созданий, %s%s",
    ["some prices missing"] = "часть цен неизвестна",
    ["%s %s what you already have: %d crafts%s."] = "%s %s из того, что уже есть: %d созданий%s.",
    [", plus a few vendor ingredients"] = ", плюс немного реагентов у торговца",
    [", nothing to buy"] = ", покупать нечего",
    ["You can %s %d now with what you have."] = "Сейчас можно %s %d из того, что есть.",
    ["You have the reagents for %d."] = "Реагентов хватит на %d.",
    ["You have the main ingredients for %d; the rest is sold by vendors."] = "Главных реагентов хватит на %d;" ..
        " остальное продают торговцы.",
    ["The cheapest here is %s."] = "Самое дешёвое здесь - %s.",
    ["Needed for %s: %d recipes (%s, ...), and no vendor sells it. None of them is for leveling (a cooldown," ..
        " or learned at 300): make it once you're done."] = "Нужен для %s: %d рецептов (%s, ...), и ни один" ..
        " торговец его не продаёт. Ни один из них не для прокачки (кулдаун или изучается на 300): сделайте" ..
        " его, когда закончите.",
    ["A tool: %d %s recipes need it, and no vendor sells it. Make one and keep it in your bags%s."] =
        "Инструмент: он нужен %d рецептам профессии %s, и ни один торговец его не продаёт. Сделайте один и" ..
        " держите в сумках%s.",
    [" (it gives no skill point any more)"] = " (очко навыка он больше не даёт)",
    ["You have %s: the step takes them from your bags, so it pays less than that."] =
        "У вас есть %s: шаг возьмёт их из сумок, так что обойдётся дешевле.",
    ["Keep for later"] = "Оставить на потом",
    ["Keep %d %s: the steps at %d - %d use them."] = "Оставьте %d %s: шаги на %d - %d их используют.",
    ["Batch: %s"] = "Партия: %s",
    ["Craft counts are estimates: skill-ups are luck once a recipe is yellow."] = "Число созданий примерное: с" ..
        " жёлтого рецепта очки навыка выпадают случайно.",
    ["Sell the rest"] = "Продать остальное",
    ["Sell what you make"] = "Продать то, что сделали",
    ["%d at the auction house, about %s each after its cut."] = "%d на аукционе, примерно %s за штуку после" ..
        " его сбора.",
    ["%d to a vendor, %s each."] = "%d торговцу, %s за штуку.",
    ["About %s back, so this step %s %s."] = "Примерно %s обратно, так что шаг %s %s.",
    ["earns"] = "принесёт",
    ["costs"] = "обойдётся в",
    ["Vendor sales counts only what vendors pay: that money is sure. AH sales counts the auction house too."] =
        "«Продажа торговцу» считает только то, что платят торговцы: эти деньги верные. «Продажа на аукционе»" ..
        " считает и аукцион.",
    ["The auction house counts only when it pays 1.5 times a vendor and 5 or more are listed, and for at most" ..
        " a quarter of what's listed."] = "Аукцион считается, только если платит в 1,5 раза больше торговца и" ..
        " выставлено 5 и более, и не больше четверти от выставленного.",
    ["Or %s, from %d"] = "Или %s, с %d",
    ["Recipes you could use from %d"] = "Рецепты, которые подойдут с %d",
    ["No other recipe is open to you here."] = "Других рецептов здесь вам не доступно.",

    -- Gold: one recipe's profit
    ["One craft%s costs about %s and sells for about %s: %s+%s|r"] = "Одно создание%s стоит около %s и" ..
        " продаётся примерно за %s: %s+%s|r",
    ["Sold to a vendor: vendors buy any number."] = "Продажа торговцу: торговцы берут любое количество.",
    ["%d listed at the auction house now: sell a few at a time."] = "Сейчас на аукционе выставлено %d:" ..
        " продавайте по чуть-чуть.",
    ["Making it needs %s %d, and yours is %d%s. It's here to level towards."] = "Для создания нужен навык %s" ..
        " %d, а у вас %d%s. Он здесь как цель.",
    ["; the rank that lifts your cap to it asks level %d, and you're %d"] = "; ранг, поднимающий предел," ..
        " требует %d ур., а у вас %d",
    ["Learning it pays back after %d %s."] = "Изучение окупится за %d %s.",
    ["craft"] = "создание",
    ["crafts"] = "созданий",
    ["Once in %s: the recipe has a cooldown."] = "Раз в %s: у рецепта кулдаун.",
    ["You have %s: counted at their price too, since you could sell them."] = "У вас есть %s: они тоже" ..
        " посчитаны по цене, ведь их можно продать.",
    ["Profit: what a vendor pays, less the ingredients at today's prices. How many you can make, the auction" ..
        " house's ingredients decide."] = "Прибыль: сколько платит торговец, минус реагенты по сегодняшним" ..
        " ценам. Сколько можно сделать, решают реагенты на аукционе.",
    ["Profit: at the lowest listing after the auction house's cut, with 5 or more listed, or however few when" ..
        " you searched it yourself; it counts only when it pays 1.5 times what a vendor does. How many sell," ..
        " the auction house doesn't say. Prices change: look again before buying."] =
        "Прибыль: по самому дешёвому лоту после сбора аукциона, если выставлено 5 и более, или сколько угодно," ..
        " если вы искали сами; считается, только если платит в 1,5 раза больше торговца. Сколько продастся," ..
        " аукцион не говорит. Цены меняются: посмотрите ещё раз перед покупкой.",

    -- Disenchant
    ["Disenchant one: about %s"] = "Распылить один: около %s",
    ["%d%% of disenchants, %s each"] = "%d%% распылений, %s за штуку",
    ["%s%d disenchanted: about %s, at least %s 9 times out of 10."] = "%s%d распылено: около %s, не меньше %s" ..
        " в 9 случаях из 10.",
    ["Your "] = "Ваши ",
    ["What it gives: from your %d disenchants of this item, recorded in game: it breaks unlike items of its" ..
        " kind."] = "Что даёт: по вашим %d распылениям этого предмета, записанным в игре: он распадается не" ..
        " так, как предметы его вида.",
    ["What it gives: from %d disenchants of items like it, recorded in game."] = "Что даёт: по %d распылениям" ..
        " похожих предметов, записанным в игре.",
    ["You've disenchanted %d like it: %s in all. From %d, what you got replaces the table."] =
        "Вы распылили %d похожих: всего %s. С %d ваши результаты заменят таблицу.",
    ["Forever added this kind of item: what it gives is a guess, checked for one item: a green's of its level," ..
        " one more of each."] = "Forever добавил этот вид предметов: что он даёт - догадка, проверенная на" ..
        " одном предмете: как у зелёного его уровня, по одному больше каждого.",
    ["What a disenchant gives is luck%s. Materials at the auction house after its cut; 3 lesser essences make" ..
        " a greater one."] = "Что даст распыление - дело случая%s. Материалы по аукциону после его сбора; 3" ..
        " малые сущности дают одну большую.",
    [", from Classic's table (not checked in Forever yet): from %d of your disenchants of items like it, what" ..
        " you got replaces it"] = ", по таблице Classic (в Forever ещё не проверено): с %d ваших распылений" ..
        " похожих предметов её заменят ваши результаты",
    ["One craft%s costs about %s; disenchanted, about %s on average: %s"] = "Одно создание%s стоит около %s;" ..
        " распылённое, в среднем около %s: %s",
    ["A %s recipe %s knows."] = "Рецепт профессии %s, который знает %s.",
    ["you"] = "вы",
    ["Making it costs more than disenchanting brings: disenchant it when you make it anyway, for skill."] =
        "Создание стоит дороже, чем даёт распыление: распыляйте, когда делаете его ради навыка.",
    ["Best: %s. %d in %s's %s: disenchanted, about %s on average; sold, %s."] = "Лучше: %s. %d у %s, %s:" ..
        " распылённое, в среднем около %s; проданное, %s.",
    ["your"] = "вас",
    ["bags"] = "сумки",
    ["Soulbound: no auction house."] = "Персональный: на аукцион не выставить.",
    ["Or sell it"] = "Или продать",
    ["Soulbound: the auction house won't take it."] = "Персональный: аукцион его не примет.",
    ["%s each at the auction house (after its cut%s)."] = "%s за штуку на аукционе (после его сбора%s).",
    ["%s each at a vendor."] = "%s за штуку у торговца.",
    ["The auction house counts with 5 or more listed, or however few when you searched it yourself. What made" ..
        " it doesn't count: it's made."] = "Аукцион считается, если выставлено 5 и более, или сколько угодно," ..
        " если вы искали сами. Из чего он сделан, не считается: он уже сделан.",
    ["Buy one for %s; disenchanted, about %s on average: %s"] = "Купить за %s; распылённое, в среднем около" ..
        " %s: %s",
    ["One disenchant brings more than it cost %d%% of the time."] = "Одно распыление приносит больше, чем" ..
        " стоило, в %d%% случаев.",
    ["Buy it"] = "Купить",
    ["The cheapest listing: %s. %s."] = "Самый дешёвый лот: %s. %s.",
    ["Its level and quality are Classic's: Forever's client doesn't list it. "] = "Его уровень и качество" ..
        " взяты из Classic: клиент Forever их не даёт. ",
    ["A random suffix (\"of the Monkey\") doesn't change what it breaks into. The listing may have sold since" ..
        " the scan."] = "Случайный суффикс («Обезьяны») не меняет то, во что он распадается. Лот мог быть" ..
        " продан после сканирования.",
    ["Nothing to disenchant"] = "Нечего распылять",
    ["No character of yours holds anything to disenchant, and "] = "Ни у одного вашего персонажа нет ничего" ..
        " для распыления, и ",
    ["none of the recipes they know makes something to disenchant: open a crafting profession's window once so" ..
        " Craft Ladder knows its recipes."] = "ни один известный им рецепт не делает то, что можно распылить:" ..
        " откройте окно ремесленной профессии один раз, чтобы Craft Ladder узнал её рецепты.",
    ["nothing they can make is worth more disenchanted than sold at today's prices."] =
        "ничто из того, что они могут сделать, не стоит распылённым больше, чем проданным по сегодняшним" ..
        " ценам.",

    -- Cooking's Food
    [" (Well Fed). "] = " (Сыт). ",
    ["Needs level %d; you're %d."] = "Нужен %d ур.; у вас %d.",
    ["Level %d: you can eat it."] = "%d ур.: вы можете это есть.",
    ["Any level can eat it."] = "Есть можно на любом уровне.",
    ["Nobody sells its recipe now: look for it at the auction house."] = "Рецепт сейчас никто не продаёт:" ..
        " ищите его на аукционе.",
    ["No way to learn it for you now (a holiday's, or the other side's)."] = "Сейчас изучить его нельзя" ..
        " (праздничный или чужой стороны).",
    ["Learned at %s %d; you have %d."] = "Изучается при навыке %s %d; у вас %d.",
    ["You have %s: cooking it takes them from your bags, so it costs you less than that."] =
        "У вас есть %s: готовка возьмёт их из сумок, так что обойдётся дешевле.",
    ["Or buy it"] = "Или купить",
    ["One at the auction house: %s."] = "Одна штука на аукционе: %s.",
    ["None listed at the auction house now."] = "Сейчас на аукционе нет.",
    ["What it raises is read from the game's files, not checked in game yet."] = "Что оно повышает, прочитано" ..
        " из файлов игры, в игре ещё не проверено.",

    -- a rank step
    ["At skill %d. Your cap is your level x 5: %d at level %d."] = "При навыке %d. Ваш предел - уровень x 5:" ..
        " %d на %d ур.",
    ["You're level %d."] = "У вас %d ур.",
    ["Your level allows it already."] = "Ваш уровень это уже позволяет.",
    ["Lockpicking can't go past your level x 5: level up before you go on."] = "Взлом не поднять выше уровня x" ..
        " 5: сначала повысьте уровень.",
    ["Learn %s%s"] = "Изучить %s%s",
    ["At skill %d, raises your cap to %d. %s"] = "При навыке %d, поднимает предел до %d. %s",
    ["Needs character level %d."] = "Нужен %d ур. персонажа.",
    ["How"] = "Как",
    ["Only these trainers teach it%s:"] = "Этому учат только эти учителя%s:",
    [", for %s"] = ", за %s",
    ["Any %s trainer teaches it%s."] = "Этому учит любой учитель (%s)%s.",
    [" for %s"] = " за %s",
    ["Buy the %s and read it:"] = "Купите %s и прочтите:",
    ["At the auction house: %s."] = "На аукционе: %s.",
    ["Or buy it at the auction house: %s.%s"] = "Или купите на аукционе: %s.%s",
    [" Cheaper than the vendor, so the ladder counts this one."] = " Дешевле, чем у торговца, так что лестница" ..
        " считает этот вариант.",
    ["1. Take the quest %s:"] = "1. Возьмите задание %s:",
    ["start"] = "начало",
    ["2. Bring the ingredients below to %s for %s:"] = "2. Принесите реагенты ниже к %s за %s:",
    ["hand in"] = "сдать",
    ["Do the quest %s for %s:"] = "Выполните задание %s у %s:",
    ["What to bring"] = "Что принести",
    ["Any %s trainer teaches Apprentice %s."] = "Любой учитель (%s) обучает ученическому уровню (%s).",

    -- fishing
    ["Fish to catch"] = "Какую рыбу ловить",
    ["%s: %s, %s (fish bite from %d)"] = "%s: %s, %s (клюёт с %d)",
    ["seen by GatherMate2"] = "найдено GatherMate2",
    ["place known"] = "место известно",
    ["places known"] = "мест известно",
    [" a catch"] = " за улов",
    ["%d - %d catches before it's gone"] = "%d - %d уловов, пока не исчезнет",
    ["No fish get away here."] = "Здесь рыба не срывается.",
    ["About %d%% of casts land a fish here."] = "Здесь примерно %d%% забросов дают рыбу.",
    ["An hour at skill %d: about %d catches, %s each"] = "Час при навыке %d: около %d уловов, %s за штуку",
    [" An hour's catches are worth about %s%s."] = " Улов за час стоит около %s%s.",
    [", lures paid"] = ", наживка оплачена",
    ["Skill %d - %d, about %d catches (%s), %s"] = "Навык %d - %d, около %d уловов (%s), %s",
    [" Catches worth about %s (%s an hour)."] = " Улов стоит около %s (%s в час).",
    ["Craft Ladder's choice here is %s."] = "Выбор Craft Ladder здесь - %s.",
    ["Its creatures are level %d - %d."] = "Существа здесь %d - %d ур.",
    ["Bring"] = "Взять с собой",
    ["Put %s on your pole: +%d fishing for %d minutes, so no fish get away."] = "Наденьте %s на удочку: +%d к" ..
        " рыбной ловле на %d минут, и рыба не срывается.",
    ["Fishing supplies vendors sell lures, in every capital."] = "Наживку продают торговцы рыболовными" ..
        " товарами, в каждой столице.",
    ["No lure needed: your skill keeps the fish from getting away."] = "Наживка не нужна: ваш навык и так не" ..
        " даёт рыбе сорваться.",
    ["What you catch here"] = "Что здесь ловится",
    ["Fishing pools here"] = "Косяки рыбы здесь",
    ["Fish pools when you see them: Craft Ladder counts a third of your catches here from pools. That makes a" ..
        " catch worth %s on average (%s in open water)."] = "Ловите в косяках, когда видите их: Craft Ladder" ..
        " считает, что треть уловов здесь из косяков. Тогда улов стоит в среднем %s (%s в открытой воде).",
    ["No fishing pools known here yet. GatherMate2 adds the ones you fish, and Craft Ladder counts them."] =
        "Косяков здесь пока не известно. GatherMate2 добавляет те, в которых вы ловите, а Craft Ladder их" ..
        " учитывает.",
    ["Catches per point: from your %d catches, skill-ups come %d%% as often as Classic's rule says."] =
        "Уловов на очко: по вашим %d уловам очки навыка выпадают в %d%% от того, как часто говорит правило" ..
        " Classic.",
    ["Catches per point follow Classic's rule (at 150, one point in about 4 catches) until Craft Ladder has" ..
        " counted 50 of your catches (%d so far)."] = "Уловы на очко идут по правилу Classic (на 150 - одно" ..
        " очко примерно за 4 улова), пока Craft Ladder не насчитает 50 ваших уловов (пока %d).",
    ["Zones and their fish come from Classic's world: Forever may differ."] = "Зоны и их рыба взяты из мира" ..
        " Classic: в Forever может быть иначе.",
    ["Other zones from %d"] = "Другие зоны с %d",
    ["No other zone is open to you here."] = "Других зон здесь вам не доступно.",

    -- skinning and mining
    ["about %d in the zone, %s %s each%s"] = "около %d в зоне, %s %s за штуку%s",
    [", worth %s"] = ", стоит %s",
    ["needs %d"] = "нужно %d",
    ["%s  %slevel %d%s|r"] = "%s  %s%d ур.%s|r",
    [", seen skinned"] = ", снимали шкуру",
    ["about %d in the zone, needs %d%s"] = "около %d в зоне, нужно %d%s",
    [", %s a skin"] = ", %s за шкуру",
    ["Skin in %s"] = "Снимать шкуры в %s",
    ["An hour at skill %d: about %d creatures, %s each"] = "Час при навыке %d: около %d существ, %s за штуку",
    ["An hour's skins are worth about %s. Every creature you can skin counts, grey ones too."] =
        "Шкуры за час стоят около %s. Считается каждое существо, с которого можно снять шкуру, в том числе" ..
        " серое.",
    ["Skill %d - %d, about %d creatures%s"] = "Навык %d - %d, около %d существ%s",
    [", trainer %s"] = ", учитель %s",
    ["Worth about %s skinned (%s an hour)."] = "Шкуры стоят около %s (%s в час).",
    ["Skin every creature that still gives a point, of your level or below."] = "Снимайте шкуру с каждого" ..
        " существа, которое ещё даёт очко, своего уровня или ниже.",
    ["Its creatures are well above your level."] = "Существа здесь сильно выше вашего уровня.",
    ["Creatures to skin here"] = "С кого снимать шкуры здесь",
    ["Which creatures can be skinned and what one gives come from Classic; where they are and their levels" ..
        " from QuestieDB's Forever data. The skill one needs is Classic's rule from its level (level x 5 past" ..
        " 20), the colours Mining's (yellow 25, green 50, grey 100 above it). A creature new in Forever counts" ..
        " once you've skinned one."] = "С кого можно снять шкуру и что это даёт, взято из Classic; где они и" ..
        " какого уровня - из данных QuestieDB по Forever. Нужный навык - правило Classic от уровня (уровень x" ..
        " 5 после 20), цвета - как у Горного дела (жёлтый 25, зелёный 50, серый 100 выше). Новое существо" ..
        " Forever считается, когда вы снимете с него шкуру.",
    ["Gold an hour assumes %d s a creature (kill, loot, skin) and a 60%% mount between them: about %d an hour" ..
        " here."] = "Золото в час считает %d с на существо (убить, обобрать, снять шкуру) и 60%% маунта между" ..
        " ними: около %d в час здесь.",
    ["Other zones, from %d"] = "Другие зоны, с %d",
    ["%s in %s"] = "%s в %s",
    ["An hour at skill %d: about %d %s, %s each"] = "Час при навыке %d: около %d %s, %s за штуку",
    ["An hour's worth about %s. Every %s you can reach counts, grey ones too. Creatures level %d - %d."] =
        "За час около %s. Считается каждый %s, до которого можно добраться, в том числе серый. Существа %d -" ..
        " %d ур.",
    ["Skill %d - %d, about %d %s%s"] = "Навык %d - %d, около %d %s%s",
    ["Worth about %s (%s an hour). Creatures level %d - %d."] = "Около %s (%s в час). Существа %d - %d ур.",
    ["Creatures level %d - %d. %s every %s that still gives a point."] = "Существа %d - %d ур. %s каждый %s," ..
        " который ещё даёт очко.",
    ["%s places come from GatherMate2's Forever data; what one gives and how often a rarer kind takes a place," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what one" ..
        " needs): Forever may differ."] = "Места (%s) взяты из данных GatherMate2 по Forever; что даёт одно и" ..
        " как часто место занимает более редкий вид - из Classic. Очки навыка идут по цветам Classic (жёлтый" ..
        " 25, зелёный 50, серый 100 выше нужного): в Forever может быть иначе.",
    ["Gold an hour assumes 15 s a %s, a third of the zone's places with one up and a 60%% mount: about %d an" ..
        " hour here."] = "Золото в час считает 15 с на %s, треть мест зоны занятыми и 60%% маунта: около %d в" ..
        " час здесь.",
    ["%s: about %d bars%s"] = "%s: около %d слитков%s",
    [", learn it from a Mining trainer for %s"] = ", изучите у учителя Горного дела за %s",
    ["Nothing you mine here still gives points when smelted."] = "Ничто из добытого здесь уже не даёт очков" ..
        " при переплавке.",
    ["Sell ore or bars"] = "Продать руду или слитки",
    ["%s: %s each. Smelting it needs more skill."] = "%s: %s за штуку. Для переплавки нужен навык выше.",
    ["sell the ore, smelt it only for the skill-ups"] = "продавайте руду, плавьте только ради очков навыка",
    ["smelt it and sell the bars"] = "переплавляйте и продавайте слитки",
    [", %s as %s"] = ", %s как %s",
    ["make %s and sell it"] = "делайте %s и продавайте",
    ["%s: %s as ore, %s as %s%s - %s."] = "%s: %s как руда, %s как %s%s - %s.",
    ["%s: %s make %d %s, so per ore it's worth one of them; it takes both ores, as much as the scarcer one" ..
        " allows."] = "%s: %s дают %d %s, так что на руду это стоит как один из них; нужны обе руды, сколько" ..
        " позволит более редкая.",
    ["Nothing mined here can be smelted."] = "Ничто добытое здесь нельзя переплавить.",
    ["Per ore, after the auction house's cut (only what's listed at least 5 times), or what a vendor pays."] =
        "На руду, после сбора аукциона (только то, что выставлено 5 раз и больше), или сколько платит" ..
        " торговец.",
    ["Smelting gives skill-ups too: Craft Ladder counts the ore you mine as smelted, so you mine fewer nodes."] =
        "Переплавка тоже даёт очки навыка: Craft Ladder считает добытую руду переплавленной, так что жил нужно" ..
        " меньше.",
    ["Node places come from GatherMate2's Forever data; how often rare veins appear and the ore a node gives," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what a node" ..
        " needs): Forever may differ."] = "Места жил взяты из данных GatherMate2 по Forever; как часто" ..
        " попадаются редкие жилы и сколько руды даёт жила - из Classic. Очки навыка идут по цветам Classic" ..
        " (жёлтый 25, зелёный 50, серый 100 выше нужного жиле): в Forever может быть иначе.",
    ["Gold an hour assumes 15 s a node, a third of the zone's node places with a node up and a 60%% mount:" ..
        " about %d nodes an hour here."] = "Золото в час считает 15 с на жилу, треть мест зоны с жилой и 60%%" ..
        " маунта: около %d жил в час здесь.",
    ["Other zones, or smelting, from %d"] = "Другие зоны или переплавка, с %d",

    -- Lockpicking
    ["%d a run, needs %d"] = "%d за заход, нужно %d",
    ["about %d in the zone, needs %d"] = "около %d в зоне, нужно %d",
    ["Humanoids drop it; the auction house sells it."] = "Падает с гуманоидов; продаётся на аукционе.",
    ["Fished up from pools."] = "Вылавливается из косяков.",
    ["Engineers make it."] = "Делают инженеры.",
    ["Pick Pocket humanoids of level %d - %d."] = "Обкрадывайте гуманоидов %d - %d ур.",
    ["Pick Pocket humanoids."] = "Обкрадывайте гуманоидов.",
    ["Pick locks in %s"] = "Взламывать замки в %s",
    ["Skill %d - %d, about %d locks"] = "Навык %d - %d, около %d замков",
    ["Creatures level %d - %d. Pick every lock that still gives a point: a chest gives one chance, and one" ..
        " more once it's back."] = "Существа %d - %d ур. Взламывайте каждый замок, который ещё даёт очко:" ..
        " сундук даёт одну попытку и ещё одну, когда появится снова.",
    ["The door round"] = "Круг по дверям",
    ["1. Go into Blackrock Depths (Blackrock Mountain, between Searing Gorge and Burning Steppes)."] =
        "1. Зайдите в Глубины Черной горы (Черная гора, между Тлеющим ущельем и Пылающими степями).",
    ["2. Pick the locked doors on the way: the first on the left, through it the next on the right, then the" ..
        " first on the left again; the Shadowforge Lock under the big gear too, if nothing would pull."] =
        "2. Взламывайте запертые двери по пути: первую слева, за ней следующую справа, потом снова первую" ..
        " слева; и Сумрачный замок под большой шестернёй, если никого не притянет.",
    ["3. Leave, right-click your portrait, Reset all instances and go in again: the game lets you in 5 times" ..
        " an hour."] = "3. Выйдите, правый клик по портрету, «Сбросить все подземелья» и зайдите снова: игра" ..
        " пускает 5 раз в час.",
    ["The round is zockify's Forever guide's: about 4 doors a run."] = "Круг взят из гайда zockify по Forever:" ..
        " около 4 дверей за заход.",
    ["Where"] = "Где",
    ["Most %ss are around here"] = "Больше всего (%s) примерно здесь",
    ["Chest places: GatherMate2's and QuestieDB's Forever data. Which lock a chest needs, and the colours" ..
        " (yellow 25, green 50, grey 100 above it), are Classic's: Forever may differ."] =
        "Места сундуков: данные GatherMate2 и QuestieDB по Forever. Какой замок нужен сундуку и цвета (жёлтый" ..
        " 25, зелёный 50, серый 100 выше) - из Classic: в Forever может быть иначе.",
    ["Other zones, or boxes, from %d"] = "Другие зоны или ящики, с %d",
    ["Pick %s"] = "Взломать %s",
    ["Skill %d - %d, about %d boxes, %s"] = "Навык %d - %d, около %d ящиков, %s",
    ["Pick the ones in your bags: you have %d."] = "Взламывайте те, что в сумках: у вас %d.",
    ["Boxes to buy: %s"] = "Ящики к покупке: %s",
    ["A box gives one chance at a point, and what's inside is yours."] = "Ящик даёт одну попытку на очко, и" ..
        " то, что внутри, ваше.",
    ["Or pick locks in a zone, from %d"] = "Или взламывать замки в зоне, с %d",
    ["Every lock a rogue picks, by the skill it needs; its colour at your %d."] = "Все замки, которые" ..
        " взламывает разбойник, по нужному навыку; цвет при вашем %d.",
    ["Orange always gives a point, yellow mostly, green sometimes, grey never."] = "Оранжевый всегда даёт" ..
        " очко, жёлтый почти всегда, зелёный иногда, серый никогда.",
    ["Chests in the world"] = "Сундуки в мире",
    ["Boxes from your bags"] = "Ящики из сумок",
    ["You have %d."] = "У вас %d.",
    [" %s at the auction house."] = " %s на аукционе.",
    ["Dungeon doors"] = "Двери подземелий",
    ["%s: %d locked doors, from %d (%s)."] = "%s: %d запертых дверей, с %d (%s).",
    ["Getting started"] = "С чего начать",
    ["Pick Lock: any rogue trainer, from level 16, for %s. It needs Thieves' Tools in your bags (rogue" ..
        " supplies vendors, 15s). Your cap is your level x 5."] = "Взлом замков: любой учитель разбойников, с" ..
        " 16 ур., за %s. Нужны «Воровские инструменты» в сумках (торговцы товарами для разбойников, 15с). Ваш" ..
        " предел - уровень x 5.",

    -- the cards with nothing to show, and the rest
    ["Nothing earns now"] = "Сейчас ничего не приносит",
    ["Nothing you can make sells for more than it costs at today's prices."] = "Ничто из того, что вы можете" ..
        " сделать, не продаётся дороже, чем стоит по сегодняшним ценам.",
    ["Nothing you can get here has a price yet: Craft Ladder needs auction house prices."] =
        "Ни у чего из добываемого здесь пока нет цены: Craft Ladder нужны цены аукциона.",
    ["Nothing to do here"] = "Здесь делать нечего",
    ["You've reached %d %s."] = "Вы достигли %d в навыке %s.",
    ["No recipe found for your skill."] = "Для вашего навыка рецепт не найден.",
    [", Working Overtime %d/5: +%d%%"] = ", «Сверхурочная работа» %d/5: +%d%%",

    -- what the data itself says on a rank card (Professions.lua, Data/*.lua)
    ["Your class quests at 16"] = "Ваши классовые задания на 16 ур.",
    ["They lead to the first practice chests and give you Thieves' Tools. Pick Lock itself is learned from any" ..
        " rogue trainer, quest or not."] = "Они ведут к первым тренировочным сундукам и дают «Воровские" ..
        " инструменты». Сам Взлом замков изучается у любого учителя разбойников, с заданиями или без.",
    ["Your class quests at 20"] = "Ваши классовые задания на 20 ур.",
    ["The last one teaches Poisons (and Recipe: Thistle Tea). On the way you pick a lock: Lockpicking 70 for" ..
        " the Alliance's Duskwood Chest, 80 for the Horde's Gallywix's Lockbox (Classic's numbers, not" ..
        " confirmed in Forever)."] = "Последнее обучает Ядам (и рецепту чая из чертополоха). По пути нужно" ..
        " взломать замок: Взлом 70 для сундука Сумеречного леса у Альянса, 80 для сейфа Галливикса у Орды" ..
        " (числа Classic, в Forever не подтверждены).",
    ["Bring 12 Giant Egg, 10 Zesty Clam Meat and 20 Alterac Swiss to Dirge Quikcleave in Gadgetzan."] =
        "Принесите 12 гигантских яиц, 10 кусков пряного мяса моллюска и 20 альтеракских сыров Дирджу" ..
        " Быстроруму в Прибамбасске.",
    ["Catch the four fish below and bring them to Nat Pagle; he then teaches Artisan Fishing for 1g."] =
        "Поймайте четыре рыбы ниже и принесите их Нату Пэглу; он обучит умелой рыбной ловле за 1з.",
    ["Hank the Hammer's (Alliance) or Aturk the Anvil's (Horde) quests lead to Galvan the Ancient and Trenton" ..
        " Lighthammer, whose quests teach the Ornate Mithril recipes the last quest asks for. Buy those 7" ..
        " items at the auction house and you can skip them."] = "Задания Ханка Молота (Альянс) или Атурка" ..
        " Наковальни (Орда) ведут к Гальвану Древнему и Трентону Легкому Молоту, чьи задания обучают рецептам" ..
        " узорчатого мифрила, которые просит последнее задание. Купите эти 7 предметов на аукционе, и их можно" ..
        " пропустить.",
    ["It gives you a letter to hand in."] = "Оно даёт письмо, которое нужно сдать.",
    ["Right-click the pledge it gives you: that completes it."] = "Щёлкните правой кнопкой по обету, который" ..
        " оно даёт: этим оно и завершается.",
    ["Save 15 wounded soldiers with the Triage Bandages the doctor gives you, before 6 of them die."] =
        "Спасите 15 раненых солдат бинтами, которые даёт врач, пока 6 из них не умрут.",
    ["Then learn the mastery from the trainer who gave you the quest."] = "Потом изучите мастерство у учителя," ..
        " который дал задание.",
}
