-- Craft Ladder in Ukrainian. The key is the English string as it stands in the code; what's missing here is shown in
-- English. Item, recipe and zone names stay English: the Forever client has none in this language.
-- The %s and %d of a line must stay in the same order as in the English one: the game fills them in that order.
local _, ns = ...

ns.Locales = ns.Locales or {}
ns.Locales.ukUA = {
    -- the auction house tab
    ["The items' names are still loading: click again."] = "Назви предметів ще завантажуються: натисніть ще" ..
        " раз.",
    ["Stop"] = "Стоп",
    ["Full Rescan"] = "Пересканувати все",
    ["Scanning %s: %d of %d items."] = "Сканую %s: %d з %d предметів.",
    ["the auction house"] = "аукціон",
    ["Scan done: %d of %d items searched."] = "Сканування завершено: знайдено %d з %d предметів.",
    ["A scan is already running: stop it first."] = "Сканування вже триває: спершу зупиніть його.",
    ["Nothing to scan here."] = "Тут нема чого сканувати.",
    ["Scanning %s: 0 of %d items."] = "Сканую %s: 0 з %d предметів.",
    ["this step"] = "цей крок",
    ["Confirm %s"] = "Купити за %s",
    ["Asking..."] = "Запит...",
    ["Buying %d %s..."] = "Купую %d %s...",
    ["The auction house is busy: try again in a moment."] = "Аукціон зайнятий: спробуйте за мить.",
    ["Asking the price of %d %s..."] = "Дізнаюся ціну %d %s...",
    ["Scan"] = "Скан",
    ["Asks the auction house what this one goes for now, and puts that price in the ladder. However fresh the" ..
        " price already is."] = "Питає в аукціону, скільки цей коштує зараз, і ставить цю ціну в драбину." ..
        " Навіть якщо ціна вже свіжа.",
    ["Asks the auction house about what this step makes and everything it takes, then puts those prices in the" ..
        " ladder."] = "Питає в аукціону ціну того, що робить цей крок, і всіх його реагентів, і ставить ці" ..
        " ціни в драбину.",
    ["Search"] = "Пошук",
    ["Auctionator's Shopping tab with what this step buys, and how many."] = "Вкладка покупок Auctionator із" ..
        " тим, що купує цей крок, і в якій кількості.",
    ["Learn %s"] = "Вивчити %s",
    ["at %d, raises your cap to %d"] = "на %d, підіймає вашу межу до %d",
    ["%s%s|r a craft, %s"] = "%s%s|r за створення, %s",
    ["sold to a vendor"] = "продано торговцю",
    ["%d listed"] = "%d виставлено",
    ["%d - %d, ~%d %s%s"] = "%d - %d, ~%d %s%s",
    [", %d listed"] = ", %d виставлено",
    ["at %d, make one and keep it"] = "на %d, зробіть один і тримайте",
    ["nothing to buy"] = "нічого купувати",
    ["need %d, you have %d"] = "потрібно %d, у вас %d",
    ["%s each"] = "%s за штуку",
    ["not listed"] = "не виставлено",
    ["No crafting profession: nothing to buy for one."] = "Немає ремісничої професії: нічого для неї купувати.",
    ["%s: nothing to buy"] = "%s: нічого купувати",
    ["Scan stopped: the prices it had got are in."] = "Сканування зупинено: ціни, які воно встигло взяти, уже" ..
        " в драбині.",
    ["Nothing here to rescan."] = "Тут нема чого пересканувати.",
    ["Every price here was searched in the last two minutes: nothing to ask again."] =
        "Усі ціни тут шукали за останні дві хвилини: питати нема чого.",
    ["Scanning the auction house: 0 of %d items."] = "Сканую аукціон: 0 з %d предметів.",
    ["Searches the auction house for everything this list buys and sells, then puts the prices in the ladder." ..
        " It goes one item at a time, as the server allows: watch the line below. An item searched in the last" ..
        " two minutes is left alone."] = "Шукає на аукціоні все, що цей список купує й продає, і ставить ціни" ..
        " в драбину. Іде по одному предмету, як дозволяє сервер: дивіться на рядок нижче. Предмет, який шукали" ..
        " за останні дві хвилини, пропускається.",
    ["Crafts"] = "Створень",
    ["A click on a step or a reagent searches it in Auctionator's Shopping tab."] = "Клік по кроку або" ..
        " реагенту шукає його у вкладці покупок Auctionator.",
    ["Craft Ladder"] = "Craft Ladder",
    ["%d %s for %s (%s each): click Confirm to buy."] = "%d %s за %s (%s за штуку): натисніть «Купити».",
    ["No price for %s: not enough listed, or not sold that way (try the Buy tab)."] =
        "Немає ціни для %s: виставлено замало або продається інакше (спробуйте вкладку «Купівля»).",
    ["Bought %d %s."] = "Куплено %d %s.",
    ["The purchase failed (the price may have changed): ask again."] = "Купівля не вдалася (ціна могла" ..
        " змінитися): спитайте ще раз.",

    -- the camp view
    ["No profession"] = "Немає професії",
    [" (skill %d)"] = " (навичка %d)",
    ["you know it"] = "ви знаєте",
    ["you can learn it"] = "можна вивчити",
    ["not your profession"] = "не ваша професія",
    ["%d in your bags"] = "%d у ваших сумках",
    ["needs %s"] = "потрібно %s",
    ["make %s"] = "зробити %s",
    ["no price"] = "немає ціни",
    ["AH %s"] = "АУ %s",
    ["  (not with %s)"] = "  (не з %s)",
    ["Or, the same buff and more: %s"] = "Або те саме й більше: %s",
    ["Camp: the buffs a campfire gives, for a level %d %s"] = "Табір: бонуси багаття, для %d рівня, %s",
    ["Holds %d camp features. %s; %s."] = "Вміщує %d таборових споруд. %s; %s.",
    ["A %s holds %d: the ones above. Then:"] = "%s вміщує %d: ті, що вище. Далі:",
    ["Doesn't help a %s"] = "Не допомагає %s",
    ["Camp features with no buff"] = "Таборові споруди без бонусу",
    ["Build a campfire, place camp features around it and sit or craft nearby for a while: each feature gives" ..
        " everyone there its buff. A campfire holds only so many: here they are in the order your role wants" ..
        " them."] = "Розпаліть багаття, поставте споруди навколо й посидьте або попрацюйте поряд: кожна" ..
        " споруда дає свій бонус усім, хто там є. Багаття вміщує лише кілька: ось вони в порядку, якого хоче" ..
        " ваша роль.",
    ["Campfire:"] = "Багаття:",

    -- the characters' buttons
    ["Level %d %s"] = "%d рівень %s",
    ["Playing now"] = "Грає зараз",
    ["Last seen %s"] = "Востаннє бачили %s",

    -- the menu
    ["Show the %s ladder."] = "Показати драбину %s.",
    ["not learned"] = "не вивчено",
    ["Disenchant"] = "Розпилення",
    ["Camp"] = "Табір",
    ["What's worth disenchanting on your whole account: what every character's bags and bank hold, what the" ..
        " auction house lists for less than disenchanting it brings, and what your crafting professions make" ..
        " that's worth more disenchanted than sold."] = "Що варто розпилити на всьому вашому обліковому" ..
        " записі: що тримають сумки й банк кожного персонажа, що аукціон віддає дешевше, ніж дає розпилення, і" ..
        " що ваші ремесла роблять такого, що коштує більше розпиленим, ніж проданим.",
    ["What each camp feature gives around a campfire, in the order your role wants them, and how to get it."] =
        "Що дає кожна таборова споруда біля багаття, у порядку, якого хоче ваша роль, і як її отримати.",

    -- the minimap button
    ["Earns most"] = "Дає найбільше",
    ["%s, %s an hour"] = "%s, %s за годину",
    ["Now"] = "Зараз",
    ["%s in %s to %d"] = "%s у %s до %d",
    ["fish"] = "ловити рибу",
    ["mine"] = "видобувати",
    ["catches"] = "улови",
    ["nodes"] = "жили",
    ["%s to %d"] = "%s до %d",
    ["~%d crafts, %s"] = "~%d створень, %s",
    ["Eat"] = "Їжа",
    ["%s, +%s a craft"] = "%s, +%s за створення",
    ["reach level %d"] = "досягти %d рівня",
    ["learn %s"] = "вивчити %s",
    ["Up to %d"] = "До %d",
    ["Prices"] = "Ціни",
    ["Click: open or close the window"] = "Клік: відкрити або закрити вікно",
    ["Drag: move the button"] = "Перетягування: пересунути кнопку",
    ["minimap button hidden - /craft minimap shows it again."] = "кнопку мінікарти сховано - /craft minimap" ..
        " покаже її знову.",
    ["minimap button shown."] = "кнопку мінікарти показано.",

    -- the Settings menu
    ["Auction house prices from"] = "Ціни аукціону з",
    ["Its last full scan of your faction's auction house: the lowest price, the median and how many are" ..
        " listed."] = "Його останнє повне сканування аукціону вашої фракції: найнижча ціна, медіана і скільки" ..
        " виставлено.",
    ["Its last scan. It gives one price per item, so the median is that price."] = "Його останнє сканування." ..
        " Воно дає одну ціну на предмет, тож медіана дорівнює їй.",
    ["An ingredient costs"] = "Реагент коштує",
    ["The median listed price"] = "Медіанну виставлену ціну",
    ["Half of what's listed costs less. The cheapest listing is one auction, often gone minutes after the" ..
        " scan."] = "Половина виставленого коштує менше. Найдешевший лот - один аукціон, часто його нема вже" ..
        " за кілька хвилин після сканування.",
    ["The cheapest listing"] = "Найдешевший лот",
    ["What the ladder cost before: the lowest price of the scan. Cheaper than what you will really pay, unless" ..
        " you are quick."] = "Як драбина рахувала раніше: найнижча ціна сканування. Дешевше за те, що ви" ..
        " справді заплатите, якщо не встигнете першим.",
    ["Language"] = "Мова",
    ["Craft Ladder's own words. Item, recipe and zone names come from your game client, in its language. A few" ..
        " buttons take a /reload to change."] = "Власні слова Craft Ladder. Назви предметів, рецептів і зон" ..
        " беруться з вашого клієнта гри, його мовою. Кілька кнопок потребують /reload.",
    ["What you sell is always priced at the cheapest listing, the one you undercut."] =
        "Те, що ви продаєте, завжди рахується за найдешевшим лотом, який ви перебиваєте.",
    ["%s isn't installed: %s is read."] = "%s не встановлено: читається %s.",
    ["Neither addon is installed: no auction house prices."] = "Жодного з аддонів не встановлено: немає цін" ..
        " аукціону.",

    -- the Specialization view
    ["%s%d / %d|r  %s"] = "%s%d / %d|r  %s",
    ["level %d (you're %d)"] = "%d рівень (у вас %d)",
    ["%s %d (you have %d)"] = "%s %d (у вас %d)",
    ["Needs %s."] = "Потрібно %s.",
    [" and "] = " і",
    ["Or take it here instead:"] = "Або візьміть це тут:",
    ["Take the quest:"] = "Візьміть завдання:",
    ["Take and hand in the quest:"] = "Візьміть і здайте завдання:",
    ["Hand it in:"] = "Здайте його:",
    ["you have them all"] = "у вас є всі",
    ["auction house %s"] = "аукціон %s",
    ["none at the auction house"] = "на аукціоні нема",
    ["Make %d; some of its ingredients have no price; %s"] = "Зробіть %d; деякі реагенти без ціни; %s",
    ["Make %d for %s; %s"] = "Зробіть %d за %s; %s",
    ["Buy %d: %s%s"] = "Купіть %d: %s%s",
    [", making them costs %s"] = ", зробити їх коштує %s",
    ["Drops from %s"] = "Випадає з %s",
    ["Drops from %d kinds of creatures; "] = "Випадає з %d видів істот;",
    ["none at the auction house now"] = "зараз на аукціоні нема",
    [", learned at %d"] = ", вивчається на %d",
    ["its recipe drops from %d kinds of creatures, none at the auction house now"] = "його рецепт випадає з %d" ..
        " видів істот, зараз на аукціоні нема",
    ["no way to learn it for you now"] = "зараз вам ніяк його вивчити",
    ["Buy the recipe:"] = "Купіть рецепт:",
    ["Learn it from the trainer:"] = "Вивчіть у вчителя:",
    ["Bring to %s:"] = "Принесіть до %s:",
    ["the quest giver"] = "тому, хто дає завдання",
    ["%s%d %s%s"] = "%s%d %s%s",
    ["smelt "] = "виплавити",
    [" (besides the %d you have)"] = " (окрім тих %d, що у вас є)",
    ["Make: %s"] = "Зробити: %s",
    ["Ingredients:"] = "Реагенти:",
    ["buy %d: "] = "купіть %d:",
    ["the smith"] = "коваля",
    ["%d. Talk to %s"] = "%d. Поговоріть із %s",
    ["Talk to:"] = "Поговоріть із:",
    ["%d. Master a weapon: one of them"] = "%d. Опануйте зброю: одну з них",
    ["%s: the quest %s"] = "%s: завдання %s",
    ["The recipes"] = "Рецепти",
    ["  %d to learn"] = "  %d вивчити",
    ["Click to fold or open."] = "Клік, щоб згорнути або розгорнути.",
    ["Show the steps to %s."] = "Показати кроки до %s.",
    ["You have this specialization."] = "У вас є ця спеціалізація.",
    ["Needs level %d and %s %d; you're level %d with %d."] = "Потрібен %d рівень і %s %d; у вас %d рівень із" ..
        " %d.",
    ["Unlocks %d recipes only this specialization can learn."] = "Відкриває %d рецептів, які може вивчити лише" ..
        " ця спеціалізація.",
    ["You have %s: a character can have only one %s specialization."] = "У вас є %s: персонаж може мати лише" ..
        " одну спеціалізацію в %s.",
    ["Still to spend: %s, each item made or bought, whichever costs less%s."] = "Ще витратити: %s, кожен" ..
        " предмет зроблений або куплений, що дешевше%s.",
    ["; some have no price"] = "; деякі без ціни",
    ["You have %s"] = "У вас є %s",
    ["To %s: about %s%s"] = "До %s: близько %s%s",
    [", some items unpriced"] = ", деякі предмети без ціни",

    -- the window: the list, its rows and their tooltips
    [" - %s%s %d|r"] = " - %s%s %d|r",
    ["%d days"] = "%d днів",
    ["%d hours"] = "%d годин",
    ["~%d min"] = "~%d хв",
    ["All locks"] = "Усі замки",
    ["Every lock a rogue picks, by the skill it needs, and its colour for you."] = "Кожен замок, який зламує" ..
        " розбійник, за потрібною навичкою та його кольором для вас.",
    ["At %d your cap is the level x 5: %d at level %d."] = "На %d ваша межа - рівень x 5: %d на %d рівні.",
    ["at %d, cap %d"] = "на %d, межа %d",
    ["Skill"] = "Навичка",
    ["Smelt on the way"] = "Виплавити дорогою",
    ["Trainer"] = "Учитель",
    ["Catches"] = "Улови",
    ["Lure"] = "Наживка",
    ["none"] = "немає",
    ["Cost"] = "Вартість",
    ["In your bags"] = "У ваших сумках",
    [", soulbound"] = ", персональний",
    ["One craft"] = "Одне створення",
    ["Disenchanted"] = "Розпилено",
    ["Sold"] = "Продано",
    [" at the auction house"] = " на аукціоні",
    [" at a vendor"] = " у торговця",
    ["nobody buys it"] = "ніхто не купує",
    ["Best"] = "Найкраще",
    ["Disenchanting one craft"] = "Розпилити одне створення",
    ["Cheapest listing"] = "Найдешевший лот",
    ["Gains"] = "Дає",
    [", more %d%% of the time"] = ", більше у %d%% випадків",
    ["Raises"] = "Підіймає",
    ["Cook one"] = "Приготувати один",
    ["Buy one"] = "Купити один",
    ["Sells for"] = "Продається за",
    ["Profit"] = "Прибуток",
    ["Listed"] = "Виставлено",
    ["%d - %d, ~%d %s"] = "%d - %d, ~%d %s",
    ["%s of ~%d, from what you have (vendor reagents aside)"] = "%s з ~%d, з того, що у вас є (реагенти" ..
        " торговця окремо)",
    ["%slvl %d|r - "] = "%sрів %d|r -",
    ["known, make %d now"] = "відомо, зробіть %d зараз",
    ["learn now (skill %d)"] = "вивчити зараз (навичка %d)",
    ["skill %d (you %d)"] = "навичка %d (у вас %d)",
    ["level %d (you %d)"] = "рівень %d (у вас %d)",
    ["%s ready"] = "%s готово",
    ["chests, boxes and doors by skill"] = "скрині, ящики й двері за навичкою",
    ["Reach level %d"] = "Досягти %d рівня",
    ["at %d, raises your cap to %d%s"] = "на %d, підіймає вашу межу до %d%s",
    ["Fish in %s"] = "Ловити рибу в %s",
    ["your pick"] = "ваш вибір",
    ["an hour: ~%d catches, %s each%s%s"] = "година: ~%d уловів, %s за штуку%s%s",
    ["%d - %d, ~%d catches%s"] = "%d - %d, ~%d уловів%s",
    ["%s%s, %s%s%s%s%s%s"] = "%s%s, %s%s%s%s%s%s",
    ["%s, %s, disenchanted ~%s, sold %s"] = "%s, %s, розпилено ~%s, продано %s",
    ["%s's %s - %s: ~%s disenchanted, %s sold%s"] = "%s, %s - %s: ~%s розпилено, %s продано%s",
    ["buy %s, ~%s disenchanted, pays %d%% of the time"] = "купіть %s, ~%s розпилено, вигідно у %d%%" ..
        " випадків",
    ["%d - %d%s: %s"] = "%d - %d%s: %s",
    ["keep them"] = "залиште їх",
    ["unconfirmed"] = "не підтверджено",
    ["after %d%s, %sneeded for %s|r"] = "після %d%s, %sпотрібно для %s|r",
    ["%s%s, %smake one and keep it|r"] = "%s%s, %sзробіть один і тримайте|r",
    ["%d favor"] = "%d прихильності",
    ["? favor"] = "? прихильності",
    ["Open your %s window once so Craft Ladder knows which recipes you have."] = "Відкрийте вікно %s один раз," ..
        " щоб Craft Ladder знав, які рецепти у вас є.",
    ["No %s found past %d with what Craft Ladder knows."] = "Не знайдено %s після %d з тим, що знає Craft" ..
        " Ladder.",
    ["zone"] = "зона",
    ["recipe"] = "рецепт",
    ["Back to your ladder"] = "Назад до вашої драбини",
    ["Merchant's Favor recipes (%d)"] = "Рецепти за Прихильність торговців (%d)",
    ["Dishes for this role, by what eating one raises. Click to fold or open."] = "Страви для цієї ролі, за" ..
        " тим, що підіймає з'їдена страва. Клік, щоб згорнути або розгорнути.",
    ["Nothing here"] = "Тут нічого немає",
    ["Nothing earns this way at today's prices."] = "За сьогоднішніми цінами так нічого не приносить.",
    ["Sell to a vendor"] = "Продати торговцю",
    ["These cost less to make than a vendor pays: vendors buy any number, no auction house needed. Click to" ..
        " fold or open."] = "Ці коштують дешевше зробити, ніж платить торговець: торговці купують будь-яку" ..
        " кількість, аукціон не потрібен. Клік, щоб згорнути або розгорнути.",
    ["Sell at the auction house"] = "Продати на аукціоні",
    ["These earn more at the auction house: 5 or more listed (or however few when you searched it yourself)," ..
        " and it pays 1.5 times what a vendor does. How many sell, the auction house doesn't say."] =
        "Ці дають більше на аукціоні: виставлено 5 і більше (або скільки завгодно, якщо ви шукали самі), і він" ..
        " платить у 1,5 раза більше за торговця. Скільки продасться, аукціон не каже.",
    ["nothing at today's prices"] = "нічого за сьогоднішніми цінами",
    ["Disenchant, your whole account: Enchanting 1 disenchants anything"] = "Розпилення, увесь ваш обліковий запис: Накладання чарів 1 розпилює будь-що",
    ["the ladder from %d to %d"] = "драбина від %d до %d",
    ["the ladder to %d"] = "драбина до %d",
    ["%s%s %d / %d, %s%s"] = "%s%s %d / %d, %s%s",
    ["as of %s"] = "станом на %s",
    ["%s has no %s yet"] = "%s ще не має %s",
    ["No %s yet"] = "Ще немає %s",
    ["Specialization"] = "Спеціалізація",
    ["Skill %d"] = "Навичка %d",
    ["No auction house prices: AuctionDB or Auctionator needed"] = "Немає цін аукціону: потрібен AuctionDB або" ..
        " Auctionator",
    [" %s prices scanned %s, costs may be off: scan at the auction house|r"] = " Ціни %s скановано %s, витрати" ..
        " можуть бути неточними: проскануйте на аукціоні|r",
    ["%s prices scanned %s: scan at the auction house|r"] = "Ціни %s скановано %s: проскануйте на аукціоні|r",
    ["Prices: %s, scanned %s (%s)|r"] = "Ціни: %s, скановано %s (%s)|r",
    ["today"] = "сьогодні",
    ["yesterday"] = "учора",
    ["%d days ago"] = "%d днів тому",
    ["Prices: Auctionator, newest prices from %s|r"] = "Ціни: Auctionator, найновіші ціни від %s|r",
    ["Prices: %s"] = "Ціни: %s",
    ["%d Merchant's Favor recipes, %d you can learn now%s"] = "%d рецептів за Прихильність торговців, %d можна" ..
        " вивчити зараз%s",
    ["; you have %d favor"] = "; у вас %d прихильності",
    ["%d dishes for your class; the cost is one dish from bought ingredients"] = "%d страв для вашого класу;" ..
        " вартість - одна страва з куплених реагентів",
    ["%d zones at skill %d; the best about %s an hour"] = "%d зон на навичці %d; найкраща близько %s за годину",
    ["Spend %s, catch about %s worth (%s, %s an hour)"] = "Витратьте %s, зловіть приблизно на %s (%s, %s за" ..
        " годину)",
    ["Spend %s, %s about %s worth (%s an hour), about %d %s"] = "Витратьте %s, %s приблизно на %s (%s за" ..
        " годину), близько %d %s",
    ["%s%d at the auction house; the best +%s a craft"] = "%s%d на аукціоні; найкраще +%s за створення",
    ["Total %s, about %d %s%s"] = "Разом %s, близько %d %s%s",
    ["Total %s, about %d catches (%s)"] = "Разом %s, близько %d уловів (%s)",
    ["Spend %s, about %s back from sales, about %d crafts"] = "Витратьте %s, близько %s назад із продажу," ..
        " близько %d створень",
    ["Total %s, about %d crafts"] = "Разом %s, близько %d створень",
    ["Plan the ladder to %d."] = "Планувати драбину до %d.",
    ["Window size"] = "Розмір вікна",
    ["Drag: make the window bigger."] = "Перетягування: збільшити вікно.",
    ["Ctrl + mouse wheel: bigger or smaller text (now %d%%)."] = "Ctrl + коліщатко: більший або менший текст" ..
        " (зараз %d%%).",
    ["Right-click: back to the normal size."] = "Правий клік: назад до звичайного розміру.",
    ["Close"] = "Закрити",
    ["Escape closes it too."] = "Escape теж закриває.",
    ["Settings"] = "Налаштування",
    ["Which auction house addon the prices are read from, and which of its listed prices an ingredient costs."] =
        "З якого аукціонного аддона читаються ціни і яка з його виставлених цін вважається вартістю реагента.",
    ["Your hands are idle, adventurer."] = "Ваші руки без діла, шукачу пригод.",
    ["The trainers are waiting: learn a profession."] = "Учителі чекають: вивчіть професію.",
    ["The steps to each of its specializations: the quests, what they ask for and what you have of it, the" ..
        " recipes, and what's still to make or buy."] = "Кроки до кожної з її спеціалізацій: завдання, що вони" ..
        " просять і що у вас із цього є, рецепти, і що лишилося зробити або купити.",
    ["Merchant's Favor recipes"] = "Рецепти за Прихильність торговців",
    ["What the supply camps' quartermaster sells for Merchant's Favor: its price and level (seen at a" ..
        " quartermaster), your skill, what you know and can make."] = "Що інтендант таборів постачання продає" ..
        " за Прихильність торговців: ціну й рівень (побачені в інтенданта), вашу навичку, що ви знаєте й" ..
        " можете зробити.",
    ["Back to cheapest"] = "Назад до найдешевшого",
    ["Use the cheapest recipe for this step again."] = "Знову взяти найдешевший рецепт для цього кроку.",
    ["Search the auction house"] = "Шукати на аукціоні",
    ["Auctionator's Shopping tab with this item. The auction house must be open."] = "Вкладка покупок" ..
        " Auctionator із цим предметом. Аукціон має бути відкритий.",
    ["Also use recipes bought with Merchant's Favor."] = "Використовувати й рецепти, куплені за Прихильність" ..
        " торговців.",
    ["Reset"] = "Скинути",
    ["The ladder from your skill to 300 again."] = "Драбина від вашої навички до 300 знову.",
    ["No profession yet"] = "Ще немає професії",

    -- the menu's group headings
    ["PROFESSIONS"] = "ПРОФЕСІЇ",
    ["SECONDARY"] = "ДРУГОРЯДНІ",
    ["CLASS"] = "КЛАСОВІ",

    -- the modes over the list, and what each one plans (the names the tooltips use)
    ["Vendor sales"] = "Торговцю",
    ["AH sales"] = "Аукціон",
    ["Food"] = "Їжа",
    ["Favor"] = "Прихильність",
    ["done"] = "готово",
    ["in your quest log"] = "у журналі завдань",

    -- one option's tooltip and its row
    ["Click: put a map pin and the arrow on it."] = "Клік: поставити мітку на карті та стрілку до неї.",
    ["%s that give points"] = "%s, що дають очки",
    ["%s for this step"] = "%s на цей крок",
    ["A %s is worth"] = "%s коштує",
    ["Gold an hour"] = "Золота за годину",
    ["Click to %s here for this step."] = "Клік: %s тут на цьому кроці.",
    ["Fish that land"] = "Риба доходить",
    ["all of them"] = "уся",
    ["none needed"] = "не потрібна",
    ["A catch is worth"] = "Улов коштує",
    ["Lures for this step"] = "Наживка на цей крок",
    ["Click to fish here for this step."] = "Клік: ловити тут на цьому кроці.",
    ["%s the %d you can make from what you have."] = "%s %d із того, що вже є.",
    ["Ingredients"] = "Реагенти",
    ["Learn"] = "Вивчення",
    ["Recipe"] = "Рецепт",
    ["Selling them brings back"] = "Продаж поверне",
    ["Per skill point"] = "За очко навички",
    ["Click to use this recipe for this step."] = "Клік: узяти цей рецепт на цей крок.",
    ["~%d %s, %s a %s"] = "~%d %s, %s за %s",
    ["%s at the trainer"] = "%s у вчителя",
    ["no fish get away"] = "риба не зривається",
    ["%d%% of casts land a fish"] = "%d%% закидів дають рибу",
    [", with %s"] = ", з %s",
    ["%s a catch%s"] = "%s за улов%s",
    [", lures %s"] = ", наживка %s",
    [" / catch"] = " / улов",
    ["%s for lures"] = "%s на наживку",
    ["  with what you have"] = "  з того, що є",
    ["from your bags"] = "із сумок",
    ["bought at the auction house"] = "куплено на аукціоні",
    ["learn: %s"] = "вивчити: %s",
    [" / point"] = " / очко",
    ["%s in all%s"] = "%s усього%s",
    [", %s back"] = ", %s назад",
    [" / hour"] = " / година",

    -- a folded list, the ingredients, the colours
    ["all %d %s"] = "усі %d %s",
    ["and %d more %s"] = "і ще %d %s",
    ["and %d more"] = "і ще %d",
    ["vendors"] = "торговців",
    ["trainers"] = "учителів",
    [" (you have them)"] = " (вони у вас є)",
    ["  (you have %d%s)"] = "  (у вас %d%s)",
    [", in the bank"] = ", у банку",
    [", %d in the bank"] = ", %d у банку",
    ["smelt"] = "виплавити",
    ["%s %d yourself from %s%s"] = "%s %d самому з %s%s",
    [", buy the other %d"] = ", решту %d купити",
    ["you have enough"] = "у вас достатньо",
    ["only %d listed - you need %d"] = "виставлено лише %d - потрібно %d",
    ["  your Cooking uses it"] = "  ваша Кулінарія це використовує",
    ["%d%% of catches%s"] = "%d%% улову%s",
    [" each"] = " за штуку",
    ["  creatures level %d+|r"] = "  істоти %d+ рів.|r",
    ["at the auction house, after its cut"] = "на аукціоні, після його збору",
    ["at a vendor"] = "у торговця",
    ["what's inside, on average"] = "що всередині, у середньому",
    ["orange"] = "помаранчевий",
    ["yellow"] = "жовтий",
    ["green"] = "зелений",
    ["grey"] = "сірий",
    ["from %d"] = "з %d",
    ["Your pick."] = "Ваш вибір.",

    -- the Craft bar
    ["An enchantment: enchant from the profession window, on the item."] = "Це чари: накладайте їх із вікна" ..
        " професії, на предмет.",
    ["Learn the recipe first."] = "Спершу вивчіть рецепт.",
    ["Not in combat."] = "Не в бою.",
    ["Not enough reagents in your bags."] = "У сумках бракує реагентів.",
    ["Craft"] = "Створити",
    ["Crafts as many as the box says; opens your profession window first if it's closed (the game crafts only" ..
        " with it open)."] = "Створює стільки, скільки вказано в полі; спершу відкриє вікно професії, якщо" ..
        " воно закрите (гра створює предмети лише з відкритим вікном).",
    [" Cooking needs a fire nearby."] = " Кулінарії потрібен вогонь поряд.",
    ["Your bags allow %d"] = "Із сумок вистачить на %d",
    ["; the step needs %d."] = "; кроку потрібно %d.",
    ["Opening your %s window: crafting once it's ready."] = "Відкриваю вікно професії %s: створю, щойно воно" ..
        " буде готове.",

    -- how to learn a recipe
    ["Learn it"] = "Як вивчити",
    ["Buy the recipe from %s:"] = "Купіть рецепт у %s:",
    ["one of these vendors"] = "одного з цих торговців",
    ["this vendor"] = "цього торговця",
    ["%s Favor"] = "Прихильність %s",
    ["Merchant's"] = "торговців",
    ["Quest reward: %s%s"] = "Нагорода за завдання: %s%s",
    ["(needs level %d)"] = "(потрібен %d рівень)",
    ["quest giver"] = "дає завдання",
    ["Only these trainers teach it, for %s:"] = "Цього вчать лише ці вчителі, за %s:",
    ["trainer"] = "учитель",
    ["None of them is of your faction."] = "Жоден із них не вашої фракції.",
    ["Or buy it at the auction house: %s."] = "Або купіть на аукціоні: %s.",
    ["Or %s."] = "Або %s.",
    ["During %s: %s."] = "Під час %s: %s.",
    ["The price is an estimate: Craft Ladder learns the real one when you visit the %s."] =
        "Ціна приблизна: Craft Ladder дізнається справжню, коли ви туди зайдете (%s).",
    ["vendor"] = "торговець",

    -- what it sells for, and one craft
    ["An enchantment: nothing to sell."] = "Це чари: продавати нема чого.",
    ["%s%s at the auction house (after its cut%s)."] = "%s%s на аукціоні (після його збору%s).",
    ["Not on the auction house."] = "На аукціоні нема.",
    ["%s%s at a vendor."] = "%s%s у торговця.",
    ["Vendors don't buy it."] = "Торговці це не купують.",
    ["One craft%s: %s"] = "Одне створення%s: %s",
    ["One craft: %s"] = "Одне створення: %s",
    [" (makes %d)"] = " (дає %d)",
    ["auction house"] = "аукціон",
    ["%s yourself%s"] = "%s самому%s",
    [" and %s"] = " і %s",
    ["%s each, %s"] = "%s за штуку, %s",
    ["Each sells for "] = "Кожен продається за",
    ["Sells for "] = "Продається за",
    ["%d sell for "] = "%d продаються за",

    -- a Merchant's Favor recipe
    ["You know it."] = "Ви це знаєте.",
    ["You can learn it now."] = "Можна вивчити просто зараз.",
    ["It needs %d %s (you: %d)."] = "Потрібно %d %s (у вас: %d).",
    ["It needs level %d (you: %d)."] = "Потрібен %d рівень (у вас: %d).",
    ["Merchant's Favor"] = "Прихильність торговців",
    ["Costs %d Merchant's Favor%s."] = "Коштує %d прихильності торговців%s.",
    [" (you have %d)"] = " (у вас %d)",
    ["Its price: open a quartermaster once and Craft Ladder remembers it."] = "Ціна: загляньте до інтенданта" ..
        " один раз, і Craft Ladder її запам'ятає.",
    ["From level %d (you: %d)."] = "З %d рівня (у вас: %d).",
    ["Its level: open a quartermaster once and Craft Ladder remembers it."] = "Рівень: загляньте до інтенданта" ..
        " один раз, і Craft Ladder його запам'ятає.",
    ["From %d %s (you: %d)."] = "З %d %s (у вас: %d).",
    ["%s is %s from level %d (you: %d)."] = "%s %s з %d рівня (у вас: %d).",
    ["worn"] = "вдягається",
    ["used"] = "використовується",
    ["Quartermaster"] = "Інтендант",
    ["The plan needs %s with %s."] = "План потребує репутації %s з %s.",
    ["Only for %s."] = "Лише для %s.",
    ["Hated"] = "Ненависть",
    ["Hostile"] = "Ворожість",
    ["Unfriendly"] = "Неприязнь",
    ["Neutral"] = "Байдужість",
    ["Friendly"] = "Дружелюбність",
    ["Honored"] = "Шана",
    ["Revered"] = "Пошана",
    ["Exalted"] = "Звеличення",

    -- a crafting step
    ["Skill %d - %d, about %d crafts, %s%s"] = "Навичка %d - %d, близько %d створень, %s%s",
    ["some prices missing"] = "частини цін немає",
    ["%s %s what you already have: %d crafts%s."] = "%s %s з того, що вже є: %d створень%s.",
    [", plus a few vendor ingredients"] = ", плюс трохи реагентів у торговця",
    [", nothing to buy"] = ", купувати нема чого",
    ["You can %s %d now with what you have."] = "%s: зараз %d із того, що є.",
    ["You have the reagents for %d."] = "Реагентів вистачить на %d.",
    ["You have the main ingredients for %d; the rest is sold by vendors."] = "Головних реагентів вистачить на" ..
        " %d; решту продають торговці.",
    ["The cheapest here is %s."] = "Найдешевше тут - %s.",
    ["Needed for %s: %d recipes (%s, ...), and no vendor sells it. None of them is for leveling (a cooldown," ..
        " or learned at 300): make it once you're done."] = "Потрібен для %s: %d рецептів (%s, ...), і жоден" ..
        " торговець його не продає. Жоден із них не для прокачування (відкат або вивчається на 300): зробіть" ..
        " його, коли закінчите.",
    ["A tool: %d %s recipes need it, and no vendor sells it. Make one and keep it in your bags%s."] =
        "Інструмент: він потрібен %d рецептам професії %s, і жоден торговець його не продає. Зробіть один і" ..
        " тримайте в сумках%s.",
    [" (it gives no skill point any more)"] = " (очка навички він більше не дає)",
    ["You have %s: the step takes them from your bags, so it pays less than that."] =
        "У вас є %s: крок візьме їх із сумок, тож обійдеться дешевше.",
    ["Keep for later"] = "Залишити на потім",
    ["Keep %d %s: the steps at %d - %d use them."] = "Залиште %d %s: кроки на %d - %d їх використовують.",
    ["Batch: %s"] = "Партія: %s",
    ["Craft counts are estimates: skill-ups are luck once a recipe is yellow."] = "Кількість створень" ..
        " приблизна: із жовтого рецепта очки навички випадають випадково.",
    ["Sell the rest"] = "Продати решту",
    ["Sell what you make"] = "Продати те, що зробили",
    ["%d at the auction house, about %s each after its cut."] = "%d на аукціоні, приблизно %s за штуку після" ..
        " його збору.",
    ["%d to a vendor, %s each."] = "%d торговцю, %s за штуку.",
    ["About %s back, so this step %s %s."] = "Приблизно %s назад, тож крок %s %s.",
    ["earns"] = "принесе",
    ["costs"] = "обійдеться в",
    ["Vendor sales counts only what vendors pay: that money is sure. AH sales counts the auction house too."] =
        "«Продаж торговцю» рахує лише те, що платять торговці: ці гроші певні. «Продаж на аукціоні» рахує й" ..
        " аукціон.",
    ["The auction house counts only when it pays 1.5 times a vendor and 5 or more are listed, and for at most" ..
        " a quarter of what's listed."] = "Аукціон рахується, лише якщо платить у 1,5 раза більше за торговця" ..
        " і виставлено 5 і більше, і не більш як за чверть виставленого.",
    ["Or %s, from %d"] = "Або %s, з %d",
    ["Recipes you could use from %d"] = "Рецепти, які підійдуть з %d",
    ["No other recipe is open to you here."] = "Інших рецептів тут вам не доступно.",

    -- Gold: one recipe's profit
    ["One craft%s costs about %s and sells for about %s: %s+%s|r"] = "Одне створення%s коштує близько %s і" ..
        " продається приблизно за %s: %s+%s|r",
    ["Sold to a vendor: vendors buy any number."] = "Продаж торговцю: торговці беруть будь-яку кількість.",
    ["%d listed at the auction house now: sell a few at a time."] = "Зараз на аукціоні виставлено %d:" ..
        " продавайте потроху.",
    ["Making it needs %s %d, and yours is %d%s. It's here to level towards."] = "Для створення потрібна" ..
        " навичка %s %d, а у вас %d%s. Він тут як мета.",
    ["; the rank that lifts your cap to it asks level %d, and you're %d"] = "; ранг, що підіймає межу, вимагає" ..
        " %d рівня, а у вас %d",
    ["Learning it pays back after %d %s."] = "Вивчення окупиться за %d %s.",
    ["craft"] = "створення",
    ["crafts"] = "створень",
    ["Once in %s: the recipe has a cooldown."] = "Раз на %s: у рецепта є відкат.",
    ["You have %s: counted at their price too, since you could sell them."] = "У вас є %s: вони теж пораховані" ..
        " за ціною, адже їх можна продати.",
    ["Profit: what a vendor pays, less the ingredients at today's prices. How many you can make, the auction" ..
        " house's ingredients decide."] = "Прибуток: скільки платить торговець, мінус реагенти за" ..
        " сьогоднішніми цінами. Скільки можна зробити, вирішують реагенти на аукціоні.",
    ["Profit: at the lowest listing after the auction house's cut, with 5 or more listed, or however few when" ..
        " you searched it yourself; it counts only when it pays 1.5 times what a vendor does. How many sell," ..
        " the auction house doesn't say. Prices change: look again before buying."] =
        "Прибуток: за найдешевшим лотом після збору аукціону, якщо виставлено 5 і більше, або скільки" ..
        " завгодно, якщо ви шукали самі; рахується, лише якщо платить у 1,5 раза більше за торговця. Скільки" ..
        " продасться, аукціон не каже. Ціни змінюються: подивіться ще раз перед покупкою.",

    -- Disenchant
    ["Disenchant one: about %s"] = "Розпилити один: близько %s",
    ["%d%% of disenchants, %s each"] = "%d%% розпилень, %s за штуку",
    ["%s%d disenchanted: about %s, at least %s 9 times out of 10."] = "%s%d розпилено: близько %s, не менше %s" ..
        " у 9 випадках із 10.",
    ["Your "] = "Ваші",
    ["What it gives: from your %d disenchants of this item, recorded in game: it breaks unlike items of its" ..
        " kind."] = "Що дає: за вашими %d розпиленнями цього предмета, записаними в грі: він розпадається не" ..
        " так, як предмети його виду.",
    ["What it gives: from %d disenchants of items like it, recorded in game."] = "Що дає: за %d розпиленнями" ..
        " схожих предметів, записаними в грі.",
    ["You've disenchanted %d like it: %s in all. From %d, what you got replaces the table."] =
        "Ви розпилили %d схожих: усього %s. З %d ваші результати замінять таблицю.",
    ["Forever added this kind of item: what it gives is a guess, checked for one item: a green's of its level," ..
        " one more of each."] = "Forever додав цей вид предметів: що він дає - здогад, перевірений на одному" ..
        " предметі: як у зеленого його рівня, по одному більше кожного.",
    ["What a disenchant gives is luck%s. Materials at the auction house after its cut; 3 lesser essences make" ..
        " a greater one."] = "Що дасть розпилення - справа випадку%s. Матеріали за аукціоном після його збору;" ..
        " 3 малі сутності дають одну велику.",
    [", from Classic's table (not checked in Forever yet): from %d of your disenchants of items like it, what" ..
        " you got replaces it"] = ", за таблицею Classic (у Forever ще не перевірено): з %d ваших розпилень" ..
        " схожих предметів її замінять ваші результати",
    ["One craft%s costs about %s; disenchanted, about %s on average: %s"] = "Одне створення%s коштує близько" ..
        " %s; розпилене, у середньому близько %s: %s",
    ["A %s recipe %s knows."] = "Рецепт професії %s, який знає %s.",
    ["you"] = "ви",
    ["Making it costs more than disenchanting brings: disenchant it when you make it anyway, for skill."] =
        "Створення коштує дорожче, ніж дає розпилення: розпилюйте, коли робите його заради навички.",
    ["Best: %s. %d in %s's %s: disenchanted, about %s on average; sold, %s."] = "Краще: %s. %d у %s, %s:" ..
        " розпилене, у середньому близько %s; продане, %s.",
    ["your"] = "вас",
    ["bags"] = "сумки",
    ["Soulbound: no auction house."] = "Персональний: на аукціон не виставити.",
    ["Or sell it"] = "Або продати",
    ["Soulbound: the auction house won't take it."] = "Персональний: аукціон його не прийме.",
    ["%s each at the auction house (after its cut%s)."] = "%s за штуку на аукціоні (після його збору%s).",
    ["%s each at a vendor."] = "%s за штуку у торговця.",
    ["The auction house counts with 5 or more listed, or however few when you searched it yourself. What made" ..
        " it doesn't count: it's made."] = "Аукціон рахується, якщо виставлено 5 і більше, або скільки" ..
        " завгодно, якщо ви шукали самі. З чого він зроблений, не рахується: він уже зроблений.",
    ["Buy one for %s; disenchanted, about %s on average: %s"] = "Купити за %s; розпилене, у середньому близько" ..
        " %s: %s",
    ["One disenchant brings more than it cost %d%% of the time."] = "Одне розпилення приносить більше, ніж" ..
        " коштувало, у %d%% випадків.",
    ["Buy it"] = "Купити",
    ["The cheapest listing: %s. %s."] = "Найдешевший лот: %s. %s.",
    ["Its level and quality are Classic's: Forever's client doesn't list it. "] = "Його рівень і якість узяті" ..
        " з Classic: клієнт Forever їх не дає.",
    ["A random suffix (\"of the Monkey\") doesn't change what it breaks into. The listing may have sold since" ..
        " the scan."] = "Випадковий суфікс («мавпи») не змінює того, на що він розпадається. Лот міг бути" ..
        " проданий після сканування.",
    ["Nothing to disenchant"] = "Нема чого розпилювати",
    ["No character of yours holds anything to disenchant, and "] = "Жоден ваш персонаж не має нічого для" ..
        " розпилення, і",
    ["none of the recipes they know makes something to disenchant: open a crafting profession's window once so" ..
        " Craft Ladder knows its recipes."] = "жоден відомий їм рецепт не робить те, що можна розпилити:" ..
        " відкрийте вікно ремісничої професії один раз, щоб Craft Ladder дізнався її рецепти.",
    ["nothing they can make is worth more disenchanted than sold at today's prices."] =
        "ніщо з того, що вони можуть зробити, не коштує розпиленим більше, ніж проданим за сьогоднішніми" ..
        " цінами.",

    -- Cooking's Food
    [" (Well Fed). "] = " (Ситий).",
    ["Needs level %d; you're %d."] = "Потрібен %d рівень; у вас %d.",
    ["Level %d: you can eat it."] = "%d рівень: ви можете це їсти.",
    ["Any level can eat it."] = "Їсти можна на будь-якому рівні.",
    ["Nobody sells its recipe now: look for it at the auction house."] = "Рецепт зараз ніхто не продає:" ..
        " шукайте його на аукціоні.",
    ["No way to learn it for you now (a holiday's, or the other side's)."] = "Зараз вивчити його не можна" ..
        " (святковий або чужої сторони).",
    ["Learned at %s %d; you have %d."] = "Вивчається при навичці %s %d; у вас %d.",
    ["You have %s: cooking it takes them from your bags, so it costs you less than that."] =
        "У вас є %s: готування візьме їх із сумок, тож обійдеться дешевше.",
    ["Or buy it"] = "Або купити",
    ["One at the auction house: %s."] = "Один на аукціоні: %s.",
    ["None listed at the auction house now."] = "Зараз на аукціоні нема.",
    ["What it raises is read from the game's files, not checked in game yet."] = "Що воно підіймає, прочитано" ..
        " з файлів гри, у грі ще не перевірено.",

    -- a rank step
    ["At skill %d. Your cap is your level x 5: %d at level %d."] = "При навичці %d. Ваша межа - рівень x 5: %d" ..
        " на %d рівні.",
    ["You're level %d."] = "У вас %d рівень.",
    ["Your level allows it already."] = "Ваш рівень це вже дозволяє.",
    ["Lockpicking can't go past your level x 5: level up before you go on."] = "Зламування не підняти вище за" ..
        " рівень x 5: спершу підвищте рівень.",
    ["Learn %s%s"] = "Вивчити %s%s",
    ["At skill %d, raises your cap to %d. %s"] = "При навичці %d, підіймає межу до %d. %s",
    ["Needs character level %d."] = "Потрібен %d рівень персонажа.",
    ["How"] = "Як",
    ["Only these trainers teach it%s:"] = "Цього вчать лише ці вчителі%s:",
    [", for %s"] = ", за %s",
    ["Any %s trainer teaches it%s."] = "Цього вчить будь-який учитель (%s)%s.",
    [" for %s"] = " за %s",
    ["Buy the %s and read it:"] = "Купіть %s і прочитайте:",
    ["At the auction house: %s."] = "На аукціоні: %s.",
    ["Or buy it at the auction house: %s.%s"] = "Або купіть на аукціоні: %s.%s",
    [" Cheaper than the vendor, so the ladder counts this one."] = " Дешевше, ніж у торговця, тож драбина" ..
        " рахує цей варіант.",
    ["1. Take the quest %s:"] = "1. Візьміть завдання %s:",
    ["start"] = "початок",
    ["2. Bring the ingredients below to %s for %s:"] = "2. Принесіть реагенти нижче до %s за %s:",
    ["hand in"] = "здати",
    ["Do the quest %s for %s:"] = "Виконайте завдання %s у %s:",
    ["What to bring"] = "Що принести",
    ["Any %s trainer teaches Apprentice %s."] = "Будь-який учитель (%s) навчає учнівського рівня (%s).",

    -- fishing
    ["Fish to catch"] = "Яку рибу ловити",
    ["%s: %s, %s (fish bite from %d)"] = "%s: %s, %s (клює з %d)",
    ["seen by GatherMate2"] = "знайдено GatherMate2",
    ["place known"] = "місце відоме",
    ["places known"] = "місць відомо",
    [" a catch"] = " за улов",
    ["%d - %d catches before it's gone"] = "%d - %d уловів, поки не зникне",
    ["No fish get away here."] = "Тут риба не зривається.",
    ["About %d%% of casts land a fish here."] = "Тут приблизно %d%% закидів дають рибу.",
    ["An hour at skill %d: about %d catches, %s each"] = "Година при навичці %d: близько %d уловів, %s за" ..
        " штуку",
    [" An hour's catches are worth about %s%s."] = " Улов за годину коштує близько %s%s.",
    [", lures paid"] = ", наживку оплачено",
    ["Skill %d - %d, about %d catches (%s), %s"] = "Навичка %d - %d, близько %d уловів (%s), %s",
    [" Catches worth about %s (%s an hour)."] = " Улов коштує близько %s (%s за годину).",
    ["Craft Ladder's choice here is %s."] = "Вибір Craft Ladder тут - %s.",
    ["Its creatures are level %d - %d."] = "Істоти тут %d - %d рівня.",
    ["Bring"] = "Узяти з собою",
    ["Put %s on your pole: +%d fishing for %d minutes, so no fish get away."] = "Надіньте %s на вудку: +%d до" ..
        " рибальства на %d хвилин, і риба не зривається.",
    ["Fishing supplies vendors sell lures, in every capital."] = "Наживку продають торговці рибальськими" ..
        " товарами, у кожній столиці.",
    ["No lure needed: your skill keeps the fish from getting away."] = "Наживка не потрібна: ваша навичка й" ..
        " так не дає рибі зірватися.",
    ["What you catch here"] = "Що тут ловиться",
    ["Fishing pools here"] = "Косяки риби тут",
    ["Fish pools when you see them: Craft Ladder counts a third of your catches here from pools. That makes a" ..
        " catch worth %s on average (%s in open water)."] = "Ловіть у косяках, коли бачите їх: Craft Ladder" ..
        " рахує, що третина уловів тут із косяків. Тоді улов коштує в середньому %s (%s у відкритій воді).",
    ["No fishing pools known here yet. GatherMate2 adds the ones you fish, and Craft Ladder counts them."] =
        "Косяків тут поки не відомо. GatherMate2 додає ті, у яких ви ловите, а Craft Ladder їх враховує.",
    ["Catches per point: from your %d catches, skill-ups come %d%% as often as Classic's rule says."] =
        "Уловів на очко: за вашими %d уловами очки навички випадають на %d%% від того, як часто каже правило" ..
        " Classic.",
    ["Catches per point follow Classic's rule (at 150, one point in about 4 catches) until Craft Ladder has" ..
        " counted 50 of your catches (%d so far)."] = "Улови на очко йдуть за правилом Classic (на 150 - одне" ..
        " очко приблизно за 4 улови), поки Craft Ladder не нарахує 50 ваших уловів (поки %d).",
    ["Zones and their fish come from Classic's world: Forever may differ."] = "Зони та їхня риба взяті зі" ..
        " світу Classic: у Forever може бути інакше.",
    ["Other zones from %d"] = "Інші зони з %d",
    ["No other zone is open to you here."] = "Інших зон тут вам не доступно.",

    -- skinning and mining
    ["about %d in the zone, %s %s each%s"] = "близько %d у зоні, %s %s за штуку%s",
    [", worth %s"] = ", коштує %s",
    ["needs %d"] = "потрібно %d",
    ["%s  %slevel %d%s|r"] = "%s  %s%d рів.%s|r",
    [", seen skinned"] = ", знімали шкуру",
    ["about %d in the zone, needs %d%s"] = "близько %d у зоні, потрібно %d%s",
    [", %s a skin"] = ", %s за шкуру",
    ["Skin in %s"] = "Знімати шкури в %s",
    ["An hour at skill %d: about %d creatures, %s each"] = "Година при навичці %d: близько %d істот, %s за" ..
        " штуку",
    ["An hour's skins are worth about %s. Every creature you can skin counts, grey ones too."] =
        "Шкури за годину коштують близько %s. Рахується кожна істота, з якої можна зняти шкуру, зокрема й" ..
        " сіра.",
    ["Skill %d - %d, about %d creatures%s"] = "Навичка %d - %d, близько %d істот%s",
    [", trainer %s"] = ", учитель %s",
    ["Worth about %s skinned (%s an hour)."] = "Шкури коштують близько %s (%s за годину).",
    ["Skin every creature that still gives a point, of your level or below."] = "Знімайте шкуру з кожної" ..
        " істоти, яка ще дає очко, свого рівня або нижче.",
    ["Its creatures are well above your level."] = "Істоти тут значно вищі за ваш рівень.",
    ["Creatures to skin here"] = "З кого знімати шкури тут",
    ["Which creatures can be skinned and what one gives come from Classic; where they are and their levels" ..
        " from QuestieDB's Forever data. The skill one needs is Classic's rule from its level (level x 5 past" ..
        " 20), the colours Mining's (yellow 25, green 50, grey 100 above it). A creature new in Forever counts" ..
        " once you've skinned one."] = "З кого можна зняти шкуру і що це дає, узято з Classic; де вони і якого" ..
        " рівня - з даних QuestieDB по Forever. Потрібна навичка - правило Classic від рівня (рівень x 5 після" ..
        " 20), кольори - як у Гірничої справи (жовтий 25, зелений 50, сірий 100 вище). Нова істота Forever" ..
        " рахується, коли ви знімете з неї шкуру.",
    ["Gold an hour assumes %d s a creature (kill, loot, skin) and a 60%% mount between them: about %d an hour" ..
        " here."] = "Золото за годину рахує %d с на істоту (вбити, обібрати, зняти шкуру) і 60%% маунта між" ..
        " ними: близько %d за годину тут.",
    ["Other zones, from %d"] = "Інші зони, з %d",
    ["%s in %s"] = "%s у %s",
    ["An hour at skill %d: about %d %s, %s each"] = "Година при навичці %d: близько %d %s, %s за штуку",
    ["An hour's worth about %s. Every %s you can reach counts, grey ones too. Creatures level %d - %d."] =
        "За годину близько %s. Рахується кожен %s, до якого можна дістатися, зокрема й сірий. Істоти %d - %d" ..
        " рівня.",
    ["Skill %d - %d, about %d %s%s"] = "Навичка %d - %d, близько %d %s%s",
    ["Worth about %s (%s an hour). Creatures level %d - %d."] = "Близько %s (%s за годину). Істоти %d - %d" ..
        " рівня.",
    ["Creatures level %d - %d. %s every %s that still gives a point."] = "Істоти %d - %d рівня. %s кожен %s," ..
        " який ще дає очко.",
    ["%s places come from GatherMate2's Forever data; what one gives and how often a rarer kind takes a place," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what one" ..
        " needs): Forever may differ."] = "Місця (%s) узяті з даних GatherMate2 по Forever; що дає одне і як" ..
        " часто місце займає рідкісніший вид - із Classic. Очки навички йдуть за кольорами Classic (жовтий 25," ..
        " зелений 50, сірий 100 вище потрібного): у Forever може бути інакше.",
    ["Gold an hour assumes 15 s a %s, a third of the zone's places with one up and a 60%% mount: about %d an" ..
        " hour here."] = "Золото за годину рахує 15 с на %s, третину місць зони зайнятими і 60%% маунта:" ..
        " близько %d за годину тут.",
    ["%s: about %d bars%s"] = "%s: близько %d зливків%s",
    [", learn it from a Mining trainer for %s"] = ", вивчіть у вчителя Гірничої справи за %s",
    ["Nothing you mine here still gives points when smelted."] = "Ніщо з видобутого тут уже не дає очок при" ..
        " виплавці.",
    ["Sell ore or bars"] = "Продати руду або зливки",
    ["%s: %s each. Smelting it needs more skill."] = "%s: %s за штуку. Для виплавки потрібна вища навичка.",
    ["sell the ore, smelt it only for the skill-ups"] = "продавайте руду, плавте лише заради очок навички",
    ["smelt it and sell the bars"] = "переплавляйте й продавайте зливки",
    [", %s as %s"] = ", %s як %s",
    ["make %s and sell it"] = "робіть %s і продавайте",
    ["%s: %s as ore, %s as %s%s - %s."] = "%s: %s як руда, %s як %s%s - %s.",
    ["%s: %s make %d %s, so per ore it's worth one of them; it takes both ores, as much as the scarcer one" ..
        " allows."] = "%s: %s дають %d %s, тож на руду це коштує як один із них; потрібні обидві руди, скільки" ..
        " дозволить рідкісніша.",
    ["Nothing mined here can be smelted."] = "Ніщо видобуте тут не можна переплавити.",
    ["Per ore, after the auction house's cut (only what's listed at least 5 times), or what a vendor pays."] =
        "На руду, після збору аукціону (лише те, що виставлено 5 разів і більше), або скільки платить" ..
        " торговець.",
    ["Smelting gives skill-ups too: Craft Ladder counts the ore you mine as smelted, so you mine fewer nodes."] =
        "Виплавка теж дає очки навички: Craft Ladder рахує видобуту руду переплавленою, тож жил потрібно" ..
        " менше.",
    ["Node places come from GatherMate2's Forever data; how often rare veins appear and the ore a node gives," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what a node" ..
        " needs): Forever may differ."] = "Місця жил узяті з даних GatherMate2 по Forever; як часто" ..
        " трапляються рідкісні жили і скільки руди дає жила - із Classic. Очки навички йдуть за кольорами" ..
        " Classic (жовтий 25, зелений 50, сірий 100 вище потрібного жилі): у Forever може бути інакше.",
    ["Gold an hour assumes 15 s a node, a third of the zone's node places with a node up and a 60%% mount:" ..
        " about %d nodes an hour here."] = "Золото за годину рахує 15 с на жилу, третину місць зони з жилою і" ..
        " 60%% маунта: близько %d жил за годину тут.",
    ["Other zones, or smelting, from %d"] = "Інші зони або виплавка, з %d",

    -- Lockpicking
    ["%d a run, needs %d"] = "%d за захід, потрібно %d",
    ["about %d in the zone, needs %d"] = "близько %d у зоні, потрібно %d",
    ["Humanoids drop it; the auction house sells it."] = "Випадає з гуманоїдів; аукціон це продає.",
    ["Fished up from pools."] = "Виловлюється з косяків.",
    ["Engineers make it."] = "Роблять інженери.",
    ["Pick Pocket humanoids of level %d - %d."] = "Обкрадайте гуманоїдів %d - %d рівня.",
    ["Pick Pocket humanoids."] = "Обкрадайте гуманоїдів.",
    ["Pick locks in %s"] = "Зламувати замки в %s",
    ["Skill %d - %d, about %d locks"] = "Навичка %d - %d, близько %d замків",
    ["Creatures level %d - %d. Pick every lock that still gives a point: a chest gives one chance, and one" ..
        " more once it's back."] = "Істоти %d - %d рівня. Зламуйте кожен замок, який ще дає очко: скриня дає" ..
        " одну спробу і ще одну, коли з'явиться знову.",
    ["The door round"] = "Коло дверима",
    ["1. Go into Blackrock Depths (Blackrock Mountain, between Searing Gorge and Burning Steppes)."] =
        "1. Зайдіть у Глибини Чорної гори (Чорна гора, між Тліючою ущелиною та Палаючими степами).",
    ["2. Pick the locked doors on the way: the first on the left, through it the next on the right, then the" ..
        " first on the left again; the Shadowforge Lock under the big gear too, if nothing would pull."] =
        "2. Зламуйте замкнені двері дорогою: перші ліворуч, за ними наступні праворуч, потім знову перші" ..
        " ліворуч; і Сутінковий замок під великою шестірнею, якщо нікого не притягне.",
    ["3. Leave, right-click your portrait, Reset all instances and go in again: the game lets you in 5 times" ..
        " an hour."] = "3. Вийдіть, правий клік по портрету, «Скинути всі підземелля» і зайдіть знову: гра" ..
        " пускає 5 разів на годину.",
    ["The round is zockify's Forever guide's: about 4 doors a run."] = "Коло взяте з гайда zockify по Forever:" ..
        " близько 4 дверей за захід.",
    ["Where"] = "Де",
    ["Most %ss are around here"] = "Найбільше (%s) приблизно тут",
    ["Chest places: GatherMate2's and QuestieDB's Forever data. Which lock a chest needs, and the colours" ..
        " (yellow 25, green 50, grey 100 above it), are Classic's: Forever may differ."] =
        "Місця скринь: дані GatherMate2 та QuestieDB по Forever. Який замок потрібен скрині та кольори (жовтий" ..
        " 25, зелений 50, сірий 100 вище) - із Classic: у Forever може бути інакше.",
    ["Other zones, or boxes, from %d"] = "Інші зони або ящики, з %d",
    ["Pick %s"] = "Зламати %s",
    ["Skill %d - %d, about %d boxes, %s"] = "Навичка %d - %d, близько %d ящиків, %s",
    ["Pick the ones in your bags: you have %d."] = "Зламуйте ті, що в сумках: у вас %d.",
    ["Boxes to buy: %s"] = "Ящики до покупки: %s",
    ["A box gives one chance at a point, and what's inside is yours."] = "Ящик дає одну спробу на очко, і те," ..
        " що всередині, ваше.",
    ["Or pick locks in a zone, from %d"] = "Або зламувати замки в зоні, з %d",
    ["Every lock a rogue picks, by the skill it needs; its colour at your %d."] = "Усі замки, які зламує" ..
        " розбійник, за потрібною навичкою; колір при вашій %d.",
    ["Orange always gives a point, yellow mostly, green sometimes, grey never."] = "Помаранчевий завжди дає" ..
        " очко, жовтий майже завжди, зелений іноді, сірий ніколи.",
    ["Chests in the world"] = "Скрині у світі",
    ["Boxes from your bags"] = "Ящики із сумок",
    ["You have %d."] = "У вас %d.",
    [" %s at the auction house."] = " %s на аукціоні.",
    ["Dungeon doors"] = "Двері підземель",
    ["%s: %d locked doors, from %d (%s)."] = "%s: %d замкнених дверей, з %d (%s).",
    ["Getting started"] = "З чого почати",
    ["Pick Lock: any rogue trainer, from level 16, for %s. It needs Thieves' Tools in your bags (rogue" ..
        " supplies vendors, 15s). Your cap is your level x 5."] = "Зламування замків: будь-який учитель" ..
        " розбійників, з 16 рівня, за %s. Потрібні «Злодійські інструменти» в сумках (торговці товарами для" ..
        " розбійників, 15с). Ваша межа - рівень x 5.",

    -- the cards with nothing to show, and the rest
    ["Nothing earns now"] = "Зараз нічого не приносить",
    ["Nothing you can make sells for more than it costs at today's prices."] = "Ніщо з того, що ви можете" ..
        " зробити, не продається дорожче, ніж коштує за сьогоднішніми цінами.",
    ["Nothing you can get here has a price yet: Craft Ladder needs auction house prices."] =
        "Ніщо з видобутого тут поки не має ціни: Craft Ladder потребує цін аукціону.",
    ["Nothing to do here"] = "Тут нема чого робити",
    ["You've reached %d %s."] = "Ви досягли %d у навичці %s.",
    ["No recipe found for your skill."] = "Для вашої навички рецепт не знайдено.",
    [", Working Overtime %d/5: +%d%%"] = ", «Понаднормова робота» %d/5: +%d%%",

    -- what the data itself says on a rank card (Professions.lua, Data/*.lua)
    ["Your class quests at 16"] = "Ваші класові завдання на 16",
    ["They lead to the first practice chests and give you Thieves' Tools. Pick Lock itself is learned from any" ..
        " rogue trainer, quest or not."] = "Вони ведуть до перших тренувальних скринь і дають «Злодійські" ..
        " інструменти». Саме Зламування замків вивчається в будь-якого вчителя розбійників, із завданнями чи" ..
        " без.",
    ["Your class quests at 20"] = "Ваші класові завдання на 20",
    ["The last one teaches Poisons (and Recipe: Thistle Tea). On the way you pick a lock: Lockpicking 70 for" ..
        " the Alliance's Duskwood Chest, 80 for the Horde's Gallywix's Lockbox (Classic's numbers, not" ..
        " confirmed in Forever)."] = "Останнє навчає Отрут (і рецепту чаю з будяка). Дорогою потрібно зламати" ..
        " замок: Зламування 70 для скрині Сутінкового лісу в Альянсу, 80 для сейфа Ґаллівікса в Орди (числа" ..
        " Classic, у Forever не підтверджені).",
    ["Bring 12 Giant Egg, 10 Zesty Clam Meat and 20 Alterac Swiss to Dirge Quikcleave in Gadgetzan."] =
        "Принесіть 12 гігантських яєць, 10 шматків пряного м'яса молюска і 20 альтеракських сирів Дірджу" ..
        " Швидкорубу в Прибамбасск.",
    ["Catch the four fish below and bring them to Nat Pagle; he then teaches Artisan Fishing for 1g."] =
        "Зловіть чотири рибини нижче й принесіть їх Нату Пейґлу; він навчить умілого рибальства за 1з.",
    ["Hank the Hammer's (Alliance) or Aturk the Anvil's (Horde) quests lead to Galvan the Ancient and Trenton" ..
        " Lighthammer, whose quests teach the Ornate Mithril recipes the last quest asks for. Buy those 7" ..
        " items at the auction house and you can skip them."] = "Завдання Ханка Молота (Альянс) або Атурка" ..
        " Ковадла (Орда) ведуть до Ґальвана Древнього і Трентона Легкого Молота, чиї завдання навчають" ..
        " рецептів візерунчастого мітрилу, які просить останнє завдання. Купіть ці 7 предметів на аукціоні, і" ..
        " їх можна пропустити.",
    ["It gives you a letter to hand in."] = "Воно дає лист, який треба здати.",
    ["Right-click the pledge it gives you: that completes it."] = "Клацніть правою кнопкою по обітниці, яку" ..
        " воно дає: цим воно й завершується.",
    ["Save 15 wounded soldiers with the Triage Bandages the doctor gives you, before 6 of them die."] =
        "Врятуйте 15 поранених солдатів бинтами, які дає лікар, поки 6 із них не померли.",
    ["Then learn the mastery from the trainer who gave you the quest."] = "Потім вивчіть майстерність у" ..
        " вчителя, який дав завдання.",

    -- Buy or craft: the bar over the list, its groups, its rows and its card
    [", %s an item"] = ", %s за штуку",
    ["No price for one of the two sides yet."] = "Для однієї з двох сторін ціни поки немає.",
    ["Cheaper to make: one craft saves %s%s."] = "Зробити дешевше: одне створення економить %s%s.",
    ["Cheaper to buy: making it costs %s more%s."] = "Купити дешевше: зробити коштує на %s більше%s.",
    ["The same either way at today's prices."] = "За сьогоднішніми цінами однаково і так, і так.",
    ["Make %s, buy %s%s"] = "Зробити %s, купити %s%s",
    [" (one craft makes %d)"] = " (одне створення дає %d)",
    ["%s has no price: Craft Ladder can't say what a craft costs. Search the auction house for it, or scan" ..
        " again."] = "У %s немає ціни: Craft Ladder не може сказати, у що стане створення. Знайдіть його на" ..
        " аукціоні або пересканувайте.",
    ["Nothing says what %s costs to buy: nobody lists it, no vendor sells it, or it's soulbound (made only," ..
        " never bought)."] = "Ніщо не каже, у що стане покупка %s: ніхто його не виставляє, торговці не" ..
        " продають, або він прив'язується до персонажа (тільки створити, купити не можна).",
    ["%d listed at the auction house now."] = "Зараз на аукціоні виставлено %d.",
    ["Making it needs %s %d, and yours is %d."] = "Для створення потрібна навичка %s %d, а у вас %d.",
    ["You have %s: they're priced here all the same, since you could sell them instead."] =
        "У вас є %s: тут вони все одно пораховані за ціною, адже їх можна й продати.",
    ["Nothing matches"] = "Нічого не знайдено",
    ["Nothing here is called %s."] = "Тут немає нічого з назвою %s.",
    ["Favor (%d)"] = "Прихильність (%d)",
    ["Buy or craft (%d)"] = "Купити або зробити (%d)",
    ["%d recipes here, %d cheaper to make than to buy (one craft, at today's prices)"] =
        "Тут %d рецептів, %d дешевше зробити, ніж купити (одне створення, за сьогоднішніми цінами)",
    ["Buy or craft"] = "Купити або зробити",
    ["Every recipe of this profession: what one craft's ingredients cost at today's prices against what buying" ..
        " the thing itself costs. The ones you know come first."] = "Усі рецепти цієї професії: у що стануть" ..
        " складники одного створення за сьогоднішніми цінами проти того, у що стане покупка самої речі." ..
        " Спочатку ті, що ви знаєте.",
    ["search"] = "пошук",
    ["Type part of a name: the rows left are the ones that make something of that name. Escape clears it."] =
        "Введіть частину назви: залишаться рядки, які роблять річ із такою назвою. Escape очищає.",
    ["Recipes you know"] = "Рецепти, які ви знаєте",
    ["Not known yet"] = "Ще не вивчені",
    ["What you can make now, by the skill it's learned at. Click to fold or open."] =
        "Що ви можете зробити зараз, за навичкою, на якій це вивчають. Клік, щоб згорнути або розгорнути.",
    ["The rest of the profession's recipes: what each would cost to make, and how to learn it. Click to fold" ..
        " or open."] = "Решта рецептів професії: у що стало б створення кожного і як його вивчити. Клік, щоб" ..
        " згорнути або розгорнути.",

    -- The splitter between the list and the step's details
    ["List width"] = "Ширина списку",
    ["Drag it: the list takes the room and the step's details give it, down to as much as they need to be" ..
        " read."] = "Потягніть: список забирає місце, подробиці кроку віддають — до того, скільки їм потрібно," ..
        " щоб їх можна було читати.",
}
