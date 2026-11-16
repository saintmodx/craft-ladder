-- Craft Ladder in German. The key is the English string as it stands in the code; what's missing here is shown in
-- English. Item, recipe and zone names come from the game itself, so they are not here.
-- The %s and %d of a line must stay in the same order as in the English one: the game fills them in that order.
local _, ns = ...

ns.Locales = ns.Locales or {}
ns.Locales.deDE = {
    -- the auction house tab
    ["The items' names are still loading: click again."] = "Die Namen der Gegenstände laden noch: klick noch" ..
        " einmal.",
    ["Stop"] = "Stopp",
    ["Full Rescan"] = "Alles neu scannen",
    ["Scanning %s: %d of %d items."] = "Scanne %s: %d von %d Gegenständen.",
    ["the auction house"] = "das Auktionshaus",
    ["Scan done: %d of %d items searched."] = "Scan fertig: %d von %d Gegenständen gefunden.",
    ["A scan is already running: stop it first."] = "Ein Scan läuft bereits: stoppe ihn zuerst.",
    ["Nothing to scan here."] = "Hier gibt es nichts zu scannen.",
    ["Scanning %s: 0 of %d items."] = "Scanne %s: 0 von %d Gegenständen.",
    ["this step"] = "diesen Schritt",
    ["Confirm %s"] = "Für %s kaufen",
    ["Asking..."] = "Frage an...",
    ["Buying %d %s..."] = "Kaufe %d %s...",
    ["The auction house is busy: try again in a moment."] = "Das Auktionshaus ist beschäftigt: versuch es" ..
        " gleich noch einmal.",
    ["Asking the price of %d %s..."] = "Frage den Preis von %d %s ab...",
    ["Scan"] = "Scan",
    ["Asks the auction house what this one goes for now, and puts that price in the ladder. However fresh the" ..
        " price already is."] = "Fragt das Auktionshaus, was dieser eine gerade kostet, und setzt den Preis in" ..
        " die Leiter. Egal wie frisch der Preis schon ist.",
    ["Asks the auction house about what this step makes and everything it takes, then puts those prices in the" ..
        " ladder."] = "Fragt das Auktionshaus nach dem, was dieser Schritt herstellt, und allem, was er" ..
        " braucht, und setzt die Preise in die Leiter.",
    ["Search"] = "Suche",
    ["Auctionator's Shopping tab with what this step buys, and how many."] = "Auctionators Einkaufsreiter mit" ..
        " dem, was dieser Schritt kauft, und wie viel.",
    ["Learn %s"] = "%s lernen",
    ["at %d, raises your cap to %d"] = "bei %d, hebt deine Grenze auf %d",
    ["%s%s|r a craft, %s"] = "%s%s|r pro Herstellung, %s",
    ["sold to a vendor"] = "an einen Händler verkauft",
    ["%d listed"] = "%d angeboten",
    ["%d - %d, ~%d %s%s"] = "%d - %d, ~%d %s%s",
    [", %d listed"] = ", %d angeboten",
    ["at %d, make one and keep it"] = "bei %d, eins herstellen und behalten",
    ["nothing to buy"] = "nichts zu kaufen",
    ["need %d, you have %d"] = "brauchst %d, du hast %d",
    ["%s each"] = "%s pro Stück",
    ["not listed"] = "nicht angeboten",
    ["No crafting profession: nothing to buy for one."] = "Kein Handwerksberuf: nichts dafür zu kaufen.",
    ["%s: nothing to buy"] = "%s: nichts zu kaufen",
    ["Scan stopped: the prices it had got are in."] = "Scan gestoppt: die Preise, die er bekommen hat, sind" ..
        " drin.",
    ["Nothing here to rescan."] = "Hier gibt es nichts neu zu scannen.",
    ["Every price here was searched in the last two minutes: nothing to ask again."] =
        "Jeder Preis hier wurde in den letzten zwei Minuten gesucht: nichts erneut zu fragen.",
    ["Scanning the auction house: 0 of %d items."] = "Scanne das Auktionshaus: 0 von %d Gegenständen.",
    ["Searches the auction house for everything this list buys and sells, then puts the prices in the ladder." ..
        " It goes one item at a time, as the server allows: watch the line below. An item searched in the last" ..
        " two minutes is left alone."] = "Sucht im Auktionshaus alles, was diese Liste kauft und verkauft, und" ..
        " setzt die Preise in die Leiter. Es geht einen Gegenstand nach dem anderen, so wie der Server es" ..
        " erlaubt: sieh auf die Zeile unten. Ein Gegenstand, der in den letzten zwei Minuten gesucht wurde," ..
        " bleibt aus.",
    ["Crafts"] = "Herstellungen",
    ["A click on a step or a reagent searches it in Auctionator's Shopping tab."] = "Ein Klick auf einen" ..
        " Schritt oder eine Zutat sucht sie in Auctionators Einkaufsreiter.",
    ["Craft Ladder"] = "Craft Ladder",
    ["%d %s for %s (%s each): click Confirm to buy."] = "%d %s für %s (%s pro Stück): klick auf Kaufen.",
    ["No price for %s: not enough listed, or not sold that way (try the Buy tab)."] =
        "Kein Preis für %s: zu wenig angeboten oder nicht so verkauft (versuch den Kaufreiter).",
    ["Bought %d %s."] = "%d %s gekauft.",
    ["The purchase failed (the price may have changed): ask again."] = "Der Kauf ist fehlgeschlagen (der Preis" ..
        " kann sich geändert haben): frag noch einmal.",

    -- the camp view
    ["No profession"] = "Kein Beruf",
    [" (skill %d)"] = " (Fertigkeit %d)",
    ["you know it"] = "du kennst es",
    ["you can learn it"] = "du kannst es lernen",
    ["not your profession"] = "nicht dein Beruf",
    ["%d in your bags"] = "%d in deinen Taschen",
    ["needs %s"] = "braucht %s",
    ["make %s"] = "%s herstellen",
    ["no price"] = "kein Preis",
    ["AH %s"] = "AH %s",
    ["  (not with %s)"] = "  (nicht mit %s)",
    ["Or, the same buff and more: %s"] = "Oder dasselbe Essen und mehr: %s",
    ["Camp: the buffs a campfire gives, for a level %d %s"] = "Lager: die Boni eines Lagerfeuers, für Stufe" ..
        " %d, %s",
    ["Holds %d camp features. %s; %s."] = "Fasst %d Lagerbauten. %s; %s.",
    ["A %s holds %d: the ones above. Then:"] = "Ein %s fasst %d: die oben. Dann:",
    ["Doesn't help a %s"] = "Hilft einem %s nicht",
    ["Camp features with no buff"] = "Lagerbauten ohne Bonus",
    ["Build a campfire, place camp features around it and sit or craft nearby for a while: each feature gives" ..
        " everyone there its buff. A campfire holds only so many: here they are in the order your role wants" ..
        " them."] = "Bau ein Lagerfeuer, stell Lagerbauten darum und setz dich oder arbeite eine Weile in der" ..
        " Nähe: jeder Bau gibt allen dort seinen Bonus. Ein Lagerfeuer fasst nur so viele: hier stehen sie in" ..
        " der Reihenfolge, die deine Rolle will.",
    ["Campfire:"] = "Lagerfeuer:",

    -- the characters' buttons
    ["Level %d %s"] = "Stufe %d %s",
    ["Playing now"] = "Spielt gerade",
    ["Last seen %s"] = "Zuletzt gesehen %s",

    -- the menu
    ["Show the %s ladder."] = "Die Leiter für %s zeigen.",
    ["not learned"] = "nicht gelernt",
    ["Disenchant"] = "Entzaubern",
    ["Camp"] = "Lager",
    ["What's worth disenchanting on your whole account: what every character's bags and bank hold, what the" ..
        " auction house lists for less than disenchanting it brings, and what your crafting professions make" ..
        " that's worth more disenchanted than sold."] = "Was sich auf deinem ganzen Account zu entzaubern" ..
        " lohnt: was die Taschen und die Bank jedes Charakters halten, was das Auktionshaus für weniger" ..
        " anbietet, als das Entzaubern bringt, und was deine Handwerksberufe herstellen, das entzaubert mehr" ..
        " wert ist als verkauft.",
    ["What each camp feature gives around a campfire, in the order your role wants them, and how to get it."] =
        "Was jeder Lagerbau an einem Lagerfeuer gibt, in der Reihenfolge, die deine Rolle will, und wie man" ..
        " ihn bekommt.",

    -- the minimap button
    ["Earns most"] = "Bringt am meisten",
    ["%s, %s an hour"] = "%s, %s pro Stunde",
    ["Now"] = "Jetzt",
    ["%s in %s to %d"] = "%s in %s bis %d",
    ["fish"] = "fischen",
    ["mine"] = "abbauen",
    ["catches"] = "Fänge",
    ["nodes"] = "Vorkommen",
    ["%s to %d"] = "%s bis %d",
    ["~%d crafts, %s"] = "~%d Herstellungen, %s",
    ["Eat"] = "Essen",
    ["%s, +%s a craft"] = "%s, +%s pro Herstellung",
    ["reach level %d"] = "Stufe %d erreichen",
    ["learn %s"] = "%s lernen",
    ["Up to %d"] = "Bis %d",
    ["Prices"] = "Preise",
    ["Click: open or close the window"] = "Klick: das Fenster öffnen oder schließen",
    ["Drag: move the button"] = "Ziehen: den Knopf verschieben",
    ["minimap button hidden - /craft minimap shows it again."] = "Minimap-Knopf versteckt - /craft minimap" ..
        " zeigt ihn wieder.",
    ["minimap button shown."] = "Minimap-Knopf sichtbar.",

    -- the Settings menu
    ["Auction house prices from"] = "Auktionspreise von",
    ["Its last full scan of your faction's auction house: the lowest price, the median and how many are" ..
        " listed."] = "Sein letzter voller Scan des Auktionshauses deiner Fraktion: der niedrigste Preis, der" ..
        " Median und wie viel angeboten ist.",
    ["Its last scan. It gives one price per item, so the median is that price."] = "Sein letzter Scan. Er gibt" ..
        " einen Preis je Gegenstand, also ist der Median genau dieser Preis.",
    ["An ingredient costs"] = "Eine Zutat kostet",
    ["The median listed price"] = "Den mittleren Angebotspreis",
    ["Half of what's listed costs less. The cheapest listing is one auction, often gone minutes after the" ..
        " scan."] = "Die Hälfte des Angebotenen kostet weniger. Das billigste Angebot ist eine einzelne" ..
        " Auktion, oft Minuten nach dem Scan schon weg.",
    ["The cheapest listing"] = "Das billigste Angebot",
    ["What the ladder cost before: the lowest price of the scan. Cheaper than what you will really pay, unless" ..
        " you are quick."] = "Wie die Leiter früher rechnete: der niedrigste Preis des Scans. Billiger als" ..
        " das, was du wirklich zahlst, wenn du nicht schnell bist.",
    ["Language"] = "Sprache",
    ["Craft Ladder's own words. Item, recipe and zone names come from your game client, in its language. A few" ..
        " buttons take a /reload to change."] = "Craft Ladders eigene Worte. Namen von Gegenständen, Rezepten" ..
        " und Zonen kommen aus deinem Spielclient, in dessen Sprache. Ein paar Knöpfe brauchen ein /reload.",
    ["What you sell is always priced at the cheapest listing, the one you undercut."] =
        "Was du verkaufst, wird immer zum billigsten Angebot gerechnet, das du unterbietest.",
    ["%s isn't installed: %s is read."] = "%s ist nicht installiert: %s wird gelesen.",
    ["Neither addon is installed: no auction house prices."] = "Keines der beiden Addons ist installiert:" ..
        " keine Auktionspreise.",

    -- the Specialization view
    ["%s%d / %d|r  %s"] = "%s%d / %d|r  %s",
    ["level %d (you're %d)"] = "Stufe %d (du bist %d)",
    ["%s %d (you have %d)"] = "%s %d (du hast %d)",
    ["Needs %s."] = "Braucht %s.",
    [" and "] = " und",
    ["Or take it here instead:"] = "Oder nimm es stattdessen hier:",
    ["Take the quest:"] = "Nimm die Quest an:",
    ["Take and hand in the quest:"] = "Nimm die Quest an und gib sie ab:",
    ["Hand it in:"] = "Gib sie ab:",
    ["you have them all"] = "du hast sie alle",
    ["auction house %s"] = "Auktionshaus %s",
    ["none at the auction house"] = "nichts im Auktionshaus",
    ["Make %d; some of its ingredients have no price; %s"] = "Stell %d her; einige Zutaten haben keinen Preis;" ..
        " %s",
    ["Make %d for %s; %s"] = "Stell %d her für %s; %s",
    ["Buy %d: %s%s"] = "Kauf %d: %s%s",
    [", making them costs %s"] = ", selbst herstellen kostet %s",
    ["Drops from %s"] = "Fällt von %s",
    ["Drops from %d kinds of creatures; "] = "Fällt von %d Arten von Kreaturen;",
    ["none at the auction house now"] = "gerade nichts im Auktionshaus",
    [", learned at %d"] = ", gelernt bei %d",
    ["its recipe drops from %d kinds of creatures, none at the auction house now"] = "sein Rezept fällt von %d" ..
        " Arten von Kreaturen, gerade nichts im Auktionshaus",
    ["no way to learn it for you now"] = "für dich gerade nicht zu lernen",
    ["Buy the recipe:"] = "Kauf das Rezept:",
    ["Learn it from the trainer:"] = "Lern es beim Lehrer:",
    ["Bring to %s:"] = "Bring zu %s:",
    ["the quest giver"] = "dem Questgeber",
    ["%s%d %s%s"] = "%s%d %s%s",
    ["smelt "] = "schmelzen",
    [" (besides the %d you have)"] = " (neben den %d, die du hast)",
    ["Make: %s"] = "Herstellen: %s",
    ["Ingredients:"] = "Zutaten:",
    ["buy %d: "] = "kauf %d:",
    ["the smith"] = "dem Schmied",
    ["%d. Talk to %s"] = "%d. Sprich mit %s",
    ["Talk to:"] = "Sprich mit:",
    ["%d. Master a weapon: one of them"] = "%d. Meistere eine Waffe: eine davon",
    ["%s: the quest %s"] = "%s: die Quest %s",
    ["The recipes"] = "Die Rezepte",
    ["  %d to learn"] = "  %d zu lernen",
    ["Click to fold or open."] = "Klick zum Zu- oder Aufklappen.",
    ["Show the steps to %s."] = "Die Schritte zu %s zeigen.",
    ["You have this specialization."] = "Du hast diese Spezialisierung.",
    ["Needs level %d and %s %d; you're level %d with %d."] = "Braucht Stufe %d und %s %d; du bist Stufe %d mit" ..
        " %d.",
    ["Unlocks %d recipes only this specialization can learn."] = "Schaltet %d Rezepte frei, die nur diese" ..
        " Spezialisierung lernen kann.",
    ["You have %s: a character can have only one %s specialization."] = "Du hast %s: ein Charakter kann nur" ..
        " eine Spezialisierung in %s haben.",
    ["Still to spend: %s, each item made or bought, whichever costs less%s."] = "Noch auszugeben: %s, jeder" ..
        " Gegenstand hergestellt oder gekauft, je nachdem was weniger kostet%s.",
    ["; some have no price"] = "; einige haben keinen Preis",
    ["You have %s"] = "Du hast %s",
    ["To %s: about %s%s"] = "Bis %s: etwa %s%s",
    [", some items unpriced"] = ", einige Gegenstände ohne Preis",

    -- the window: the list, its rows and their tooltips
    [" - %s%s %d|r"] = " - %s%s %d|r",
    ["%d days"] = "%d Tage",
    ["%d hours"] = "%d Stunden",
    ["~%d min"] = "~%d Min",
    ["All locks"] = "Alle Schlösser",
    ["Every lock a rogue picks, by the skill it needs, and its colour for you."] = "Jedes Schloss, das ein" ..
        " Schurke knackt, nach der nötigen Fertigkeit und seiner Farbe für dich.",
    ["At %d your cap is the level x 5: %d at level %d."] = "Bei %d ist deine Grenze die Stufe x 5: %d auf" ..
        " Stufe %d.",
    ["at %d, cap %d"] = "bei %d, Grenze %d",
    ["Skill"] = "Fertigkeit",
    ["Smelt on the way"] = "Unterwegs schmelzen",
    ["Trainer"] = "Lehrer",
    ["Catches"] = "Fänge",
    ["Lure"] = "Köder",
    ["none"] = "keiner",
    ["Cost"] = "Kosten",
    ["In your bags"] = "In deinen Taschen",
    [", soulbound"] = ", seelengebunden",
    ["One craft"] = "Eine Herstellung",
    ["Disenchanted"] = "Entzaubert",
    ["Sold"] = "Verkauft",
    [" at the auction house"] = " im Auktionshaus",
    [" at a vendor"] = " bei einem Händler",
    ["nobody buys it"] = "niemand kauft es",
    ["Best"] = "Am besten",
    ["Disenchanting one craft"] = "Eine Herstellung entzaubern",
    ["Cheapest listing"] = "Billigstes Angebot",
    ["Gains"] = "Bringt",
    [", more %d%% of the time"] = ", mehr in %d%% der Fälle",
    ["Raises"] = "Hebt",
    ["Cook one"] = "Eins kochen",
    ["Buy one"] = "Eins kaufen",
    ["Sells for"] = "Verkauft sich für",
    ["Profit"] = "Gewinn",
    ["Listed"] = "Angeboten",
    ["%d - %d, ~%d %s"] = "%d - %d, ~%d %s",
    ["%s of ~%d, from what you have (vendor reagents aside)"] = "%s von ~%d, aus dem, was du hast" ..
        " (Händlerzutaten beiseite)",
    ["%slvl %d|r - "] = "%sStufe %d|r -",
    ["known, make %d now"] = "bekannt, stell jetzt %d her",
    ["learn now (skill %d)"] = "jetzt lernen (Fertigkeit %d)",
    ["skill %d (you %d)"] = "Fertigkeit %d (du %d)",
    ["level %d (you %d)"] = "Stufe %d (du %d)",
    ["%s ready"] = "%s bereit",
    ["chests, boxes and doors by skill"] = "Truhen, Kisten und Türen nach Fertigkeit",
    ["Reach level %d"] = "Stufe %d erreichen",
    ["at %d, raises your cap to %d%s"] = "bei %d, hebt deine Grenze auf %d%s",
    ["Fish in %s"] = "Fischen in %s",
    ["your pick"] = "deine Wahl",
    ["an hour: ~%d catches, %s each%s%s"] = "eine Stunde: ~%d Fänge, %s pro Stück%s%s",
    ["%d - %d, ~%d catches%s"] = "%d - %d, ~%d Fänge%s",
    ["%s%s, %s%s%s%s%s%s"] = "%s%s, %s%s%s%s%s%s",
    ["%s, %s, disenchanted ~%s, sold %s%s"] = "%s, %s, entzaubert ~%s, verkauft %s%s",
    ["%s's %s - %s: ~%s disenchanted, %s sold%s%s"] = "%s%s - %s: ~%s entzaubert, %s verkauft%s%s",
    ["buy %s, ~%s disenchanted, pays %d%% of the time%s"] = "kauf %s, ~%s entzaubert, lohnt sich in %d%% der" ..
        " Fälle%s",
    ["%d - %d%s: %s"] = "%d - %d%s: %s",
    ["keep them"] = "behalte sie",
    ["unconfirmed"] = "unbestätigt",
    ["after %d%s, %sneeded for %s|r"] = "nach %d%s, %sgebraucht für %s|r",
    ["%s%s, %smake one and keep it|r"] = "%s%s, %seins herstellen und behalten|r",
    ["%d favor"] = "%d Gunst",
    ["? favor"] = "? Gunst",
    ["Open your %s window once so Craft Ladder knows which recipes you have."] = "Öffne dein %s-Fenster" ..
        " einmal, damit Craft Ladder weiß, welche Rezepte du hast.",
    ["No %s found past %d with what Craft Ladder knows."] = "Kein %s über %d hinaus gefunden mit dem, was" ..
        " Craft Ladder kennt.",
    ["zone"] = "Zone",
    ["recipe"] = "Rezept",
    ["Back to your ladder"] = "Zurück zu deiner Leiter",
    ["Merchant's Favor recipes (%d)"] = "Rezepte für Händlergunst (%d)",
    ["Dishes for this role, by what eating one raises. Click to fold or open."] = "Gerichte für diese Rolle," ..
        " nach dem, was Essen hebt. Klick zum Zu- oder Aufklappen.",
    ["Nothing here"] = "Hier ist nichts",
    ["Nothing earns this way at today's prices."] = "Zu heutigen Preisen bringt hier nichts etwas ein.",
    ["Sell to a vendor"] = "An einen Händler verkaufen",
    ["These cost less to make than a vendor pays: vendors buy any number, no auction house needed. Click to" ..
        " fold or open."] = "Diese kosten weniger herzustellen, als ein Händler zahlt: Händler kaufen jede" ..
        " Menge, kein Auktionshaus nötig. Klick zum Zu- oder Aufklappen.",
    ["Sell at the auction house"] = "Im Auktionshaus verkaufen",
    ["These earn more at the auction house: 5 or more listed (or however few when you searched it yourself)," ..
        " and it pays 1.5 times what a vendor does. How many sell, the auction house doesn't say."] =
        "Diese bringen im Auktionshaus mehr: 5 oder mehr angeboten (oder beliebig wenige, wenn du selbst" ..
        " gesucht hast), und es zahlt das 1,5-fache eines Händlers. Wie viel sich verkauft, sagt das" ..
        " Auktionshaus nicht.",
    ["nothing at today's prices"] = "nichts zu heutigen Preisen",
    ["Disenchant, your whole account: %s"] = "Entzaubern, dein ganzer Account: %s",
    ["your Enchanting %d is the best of yours"] = "dein Verzauberkunst %d ist dein bestes",
    ["%s has the most Enchanting, %d"] = "%s hat die höchste Verzauberkunst, %d",
    ["no character of yours has Enchanting yet"] = "kein Charakter von dir hat bisher Verzauberkunst",
    ["the ladder from %d to %d"] = "die Leiter von %d bis %d",
    ["the ladder to %d"] = "die Leiter bis %d",
    ["%s%s %d / %d, %s%s"] = "%s%s %d / %d, %s%s",
    ["as of %s"] = "Stand %s",
    ["%s has no %s yet"] = "%s hat noch kein %s",
    ["No %s yet"] = "Noch kein %s",
    ["Specialization"] = "Spezialisierung",
    ["Skill %d"] = "Fertigkeit %d",
    ["No auction house prices: AuctionDB or Auctionator needed"] = "Keine Auktionspreise: AuctionDB oder" ..
        " Auctionator nötig",
    [" %s prices scanned %s, costs may be off: scan at the auction house|r"] = " %s-Preise gescannt %s, die" ..
        " Kosten können daneben liegen: scanne im Auktionshaus|r",
    ["%s prices scanned %s: scan at the auction house|r"] = "%s-Preise gescannt %s: scanne im Auktionshaus|r",
    ["Prices: %s, scanned %s (%s)|r"] = "Preise: %s, gescannt %s (%s)|r",
    ["today"] = "heute",
    ["yesterday"] = "gestern",
    ["%d days ago"] = "vor %d Tagen",
    ["Prices: Auctionator, newest prices from %s|r"] = "Preise: Auctionator, neueste Preise von %s|r",
    ["Prices: %s"] = "Preise: %s",
    ["%d Merchant's Favor recipes, %d you can learn now%s"] = "%d Rezepte für Händlergunst, %d davon jetzt" ..
        " lernbar%s",
    ["; you have %d favor"] = "; du hast %d Gunst",
    ["%d dishes for your class; the cost is one dish from bought ingredients"] = "%d Gerichte für deine" ..
        " Klasse; die Kosten sind ein Gericht aus gekauften Zutaten",
    ["%d zones at skill %d; the best about %s an hour"] = "%d Zonen bei Fertigkeit %d; die beste etwa %s pro" ..
        " Stunde",
    ["Spend %s, catch about %s worth (%s, %s an hour)"] = "Gib %s aus, fang etwa %s Wert (%s, %s pro Stunde)",
    ["Spend %s, %s about %s worth (%s an hour), about %d %s"] = "Gib %s aus, %s etwa %s Wert (%s pro Stunde)," ..
        " etwa %d %s",
    ["%s%d at the auction house; the best +%s a craft"] = "%s%d im Auktionshaus; das beste +%s pro Herstellung",
    ["Total %s, about %d %s%s"] = "Zusammen %s, etwa %d %s%s",
    ["Total %s, about %d catches (%s)"] = "Zusammen %s, etwa %d Fänge (%s)",
    ["Spend %s, about %s back from sales, about %d crafts"] = "Gib %s aus, etwa %s zurück aus Verkäufen, etwa" ..
        " %d Herstellungen",
    ["Total %s, about %d crafts"] = "Zusammen %s, etwa %d Herstellungen",
    ["Plan the ladder to %d."] = "Die Leiter bis %d planen.",
    ["Window size"] = "Fenstergröße",
    ["Drag: make the window bigger."] = "Ziehen: das Fenster größer machen.",
    ["Ctrl + mouse wheel: bigger or smaller text (now %d%%)."] = "Strg + Mausrad: größere oder kleinere" ..
        " Schrift (jetzt %d%%).",
    ["Right-click: back to the normal size."] = "Rechtsklick: zurück zur normalen Größe.",
    ["Close"] = "Schließen",
    ["Escape closes it too."] = "Escape schließt es auch.",
    ["Settings"] = "Einstellungen",
    ["Which auction house addon the prices are read from, and which of its listed prices an ingredient costs."] =
        "Aus welchem Auktionsaddon die Preise gelesen werden und welcher seiner Angebotspreise eine Zutat" ..
        " kostet.",
    ["Your hands are idle, adventurer."] = "Deine Hände sind untätig, Abenteurer.",
    ["The trainers are waiting: learn a profession."] = "Die Lehrer warten: lern einen Beruf.",
    ["The steps to each of its specializations: the quests, what they ask for and what you have of it, the" ..
        " recipes, and what's still to make or buy."] = "Die Schritte zu jeder ihrer Spezialisierungen: die" ..
        " Quests, was sie verlangen und was du davon hast, die Rezepte und was noch herzustellen oder zu" ..
        " kaufen ist.",
    ["Merchant's Favor recipes"] = "Rezepte für Händlergunst",
    ["What the supply camps' quartermaster sells for Merchant's Favor: its price and level (seen at a" ..
        " quartermaster), your skill, what you know and can make."] = "Was der Quartiermeister der" ..
        " Versorgungslager für Händlergunst verkauft: Preis und Stufe (bei einem Quartiermeister gesehen)," ..
        " deine Fertigkeit, was du kennst und herstellen kannst.",
    ["Back to cheapest"] = "Zurück zum billigsten",
    ["Use the cheapest recipe for this step again."] = "Wieder das billigste Rezept für diesen Schritt nehmen.",
    ["Search the auction house"] = "Im Auktionshaus suchen",
    ["Auctionator's Shopping tab with this item. The auction house must be open."] = "Auctionators" ..
        " Einkaufsreiter mit diesem Gegenstand. Das Auktionshaus muss offen sein.",
    ["Also use recipes bought with Merchant's Favor."] = "Auch Rezepte nehmen, die mit Händlergunst gekauft" ..
        " werden.",
    ["Reset"] = "Zurücksetzen",
    ["The ladder from your skill to 300 again."] = "Die Leiter wieder von deiner Fertigkeit bis 300.",
    ["No profession yet"] = "Noch kein Beruf",

    -- the menu's group headings
    ["PROFESSIONS"] = "BERUFE",
    ["SECONDARY"] = "NEBENBERUFE",
    ["CLASS"] = "KLASSE",

    -- the modes over the list, and what each one plans (the names the tooltips use)
    ["Vendor sales"] = "Händler",
    ["AH sales"] = "Auktion",
    ["Food"] = "Essen",
    ["Favor"] = "Gunst",
    ["done"] = "erledigt",
    ["in your quest log"] = "in deinem Questlog",

    -- one option's tooltip and its row
    ["Click: put a map pin and the arrow on it."] = "Klick: eine Kartenmarkierung und den Pfeil darauf setzen.",
    ["%s that give points"] = "%s, die Punkte geben",
    ["%s for this step"] = "%s für diesen Schritt",
    ["A %s is worth"] = "Ein %s ist wert",
    ["Gold an hour"] = "Gold pro Stunde",
    ["Click to %s here for this step."] = "Klick: hier %s für diesen Schritt.",
    ["Fish that land"] = "Fische, die anbeißen",
    ["all of them"] = "alle",
    ["none needed"] = "keiner nötig",
    ["A catch is worth"] = "Ein Fang ist wert",
    ["Lures for this step"] = "Köder für diesen Schritt",
    ["Click to fish here for this step."] = "Klick: hier fischen für diesen Schritt.",
    ["%s the %d you can make from what you have."] = "%s die %d, die du aus dem herstellen kannst, was du" ..
        " hast.",
    ["Ingredients"] = "Zutaten",
    ["Learn"] = "Lernen",
    ["Recipe"] = "Rezept",
    ["Selling them brings back"] = "Verkauf bringt zurück",
    ["Per skill point"] = "Pro Fertigkeitspunkt",
    ["Click to use this recipe for this step."] = "Klick: dieses Rezept für diesen Schritt nehmen.",
    ["~%d %s, %s a %s"] = "~%d %s, %s pro %s",
    ["%s at the trainer"] = "%s beim Lehrer",
    ["no fish get away"] = "kein Fisch entkommt",
    ["%d%% of casts land a fish"] = "%d%% der Würfe bringen einen Fisch",
    [", with %s"] = ", mit %s",
    ["%s a catch%s"] = "%s pro Fang%s",
    [", lures %s"] = ", Köder %s",
    [" / catch"] = " / Fang",
    ["%s for lures"] = "%s für Köder",
    ["  with what you have"] = "  aus dem, was du hast",
    ["from your bags"] = "aus deinen Taschen",
    ["bought at the auction house"] = "im Auktionshaus gekauft",
    ["learn: %s"] = "lernen: %s",
    [" / point"] = " / Punkt",
    ["%s in all%s"] = "%s insgesamt%s",
    [", %s back"] = ", %s zurück",
    [" / hour"] = " / Stunde",

    -- a folded list, the ingredients, the colours
    ["all %d %s"] = "alle %d %s",
    ["and %d more %s"] = "und %d weitere %s",
    ["and %d more"] = "und %d weitere",
    ["vendors"] = "Händler",
    ["trainers"] = "Lehrer",
    [" (you have them)"] = " (du hast sie)",
    ["  (you have %d%s)"] = "  (du hast %d%s)",
    [", in the bank"] = ", in der Bank",
    [", %d in the bank"] = ", %d in der Bank",
    ["smelt"] = "schmelzen",
    ["%s %d yourself from %s%s"] = "%s %d selbst aus %s%s",
    [", buy the other %d"] = ", die anderen %d kaufen",
    ["you have enough"] = "du hast genug",
    ["only %d listed - you need %d"] = "nur %d angeboten - du brauchst %d",
    ["  your Cooking uses it"] = "  deine Kochkunst nutzt ihn",
    ["%d%% of catches%s"] = "%d%% der Fänge%s",
    [" each"] = " pro Stück",
    ["  creatures level %d+|r"] = "  Kreaturen der Stufe %d+|r",
    ["at the auction house, after its cut"] = "im Auktionshaus, nach dessen Abzug",
    ["at a vendor"] = "bei einem Händler",
    ["what's inside, on average"] = "was drin ist, im Schnitt",
    ["orange"] = "orange",
    ["yellow"] = "gelb",
    ["green"] = "grün",
    ["grey"] = "grau",
    ["from %d"] = "ab %d",
    ["Your pick."] = "Deine Wahl.",

    -- the Craft bar
    ["An enchantment: enchant from the profession window, on the item."] = "Eine Verzauberung: verzaubere aus" ..
        " dem Berufsfenster, auf dem Gegenstand.",
    ["Learn the recipe first."] = "Lern zuerst das Rezept.",
    ["Not in combat."] = "Nicht im Kampf.",
    ["Not enough reagents in your bags."] = "Nicht genug Zutaten in deinen Taschen.",
    ["Craft"] = "Herstellen",
    ["Crafts as many as the box says; opens your profession window first if it's closed (the game crafts only" ..
        " with it open)."] = "Stellt so viele her, wie das Feld sagt; öffnet zuerst dein Berufsfenster, wenn" ..
        " es zu ist (das Spiel stellt nur mit offenem Fenster her).",
    [" Cooking needs a fire nearby."] = " Kochkunst braucht ein Feuer in der Nähe.",
    ["Your bags allow %d"] = "Deine Taschen reichen für %d",
    ["; the step needs %d."] = "; der Schritt braucht %d.",
    ["Opening your %s window: crafting once it's ready."] = "Öffne dein %s-Fenster: stelle her, sobald es" ..
        " bereit ist.",

    -- how to learn a recipe
    ["Learn it"] = "Wie lernen",
    ["Buy the recipe from %s:"] = "Kauf das Rezept bei %s:",
    ["one of these vendors"] = "einem dieser Händler",
    ["this vendor"] = "diesem Händler",
    ["%s Favor"] = "%s Gunst",
    ["Merchant's"] = "Händler",
    ["Quest reward: %s%s"] = "Questbelohnung: %s%s",
    ["(needs level %d)"] = "(braucht Stufe %d)",
    ["quest giver"] = "Questgeber",
    ["Only these trainers teach it, for %s:"] = "Nur diese Lehrer lehren es, für %s:",
    ["trainer"] = "Lehrer",
    ["None of them is of your faction."] = "Keiner davon gehört deiner Fraktion an.",
    ["Or buy it at the auction house: %s."] = "Oder kauf es im Auktionshaus: %s.",
    ["Or %s."] = "Oder %s.",
    ["During %s: %s."] = "Während %s: %s.",
    ["The price is an estimate: Craft Ladder learns the real one when you visit the %s."] =
        "Der Preis ist geschätzt: Craft Ladder erfährt den echten, wenn du dort vorbeischaust (%s).",
    ["vendor"] = "Händler",

    -- what it sells for, and one craft
    ["An enchantment: nothing to sell."] = "Eine Verzauberung: nichts zu verkaufen.",
    ["%s%s at the auction house (after its cut%s)."] = "%s%s im Auktionshaus (nach dessen Abzug%s).",
    ["Not on the auction house."] = "Nicht im Auktionshaus.",
    ["%s%s at a vendor."] = "%s%s bei einem Händler.",
    ["Vendors don't buy it."] = "Händler kaufen es nicht.",
    ["One craft%s: %s"] = "Eine Herstellung%s: %s",
    ["One craft: %s"] = "Eine Herstellung: %s",
    [" (makes %d)"] = " (macht %d)",
    ["auction house"] = "Auktionshaus",
    ["%s yourself%s"] = "%s selbst%s",
    [" and %s"] = " und %s",
    ["%s each, %s"] = "%s pro Stück, %s",
    ["Each sells for "] = "Jedes verkauft sich für",
    ["Sells for "] = "Verkauft sich für",
    ["%d sell for "] = "%d verkaufen sich für",

    -- a Merchant's Favor recipe
    ["You know it."] = "Du kennst es.",
    ["You can learn it now."] = "Du kannst es jetzt lernen.",
    ["It needs %d %s (you: %d)."] = "Es braucht %d %s (du: %d).",
    ["It needs level %d (you: %d)."] = "Es braucht Stufe %d (du: %d).",
    ["Merchant's Favor"] = "Händlergunst",
    ["Costs %d Merchant's Favor%s."] = "Kostet %d Händlergunst%s.",
    [" (you have %d)"] = " (du hast %d)",
    ["Its price: open a quartermaster once and Craft Ladder remembers it."] = "Sein Preis: schau einmal bei" ..
        " einem Quartiermeister vorbei, dann merkt Craft Ladder ihn sich.",
    ["From level %d (you: %d)."] = "Ab Stufe %d (du: %d).",
    ["Its level: open a quartermaster once and Craft Ladder remembers it."] = "Seine Stufe: schau einmal bei" ..
        " einem Quartiermeister vorbei, dann merkt Craft Ladder sie sich.",
    ["From %d %s (you: %d)."] = "Ab %d %s (du: %d).",
    ["%s is %s from level %d (you: %d)."] = "%s %s ab Stufe %d (du: %d).",
    ["worn"] = "wird getragen",
    ["used"] = "wird benutzt",
    ["Quartermaster"] = "Quartiermeister",
    ["The plan needs %s with %s."] = "Der Plan braucht %s bei %s.",
    ["Only for %s."] = "Nur für %s.",
    ["Hated"] = "Hasserfüllt",
    ["Hostile"] = "Feindselig",
    ["Unfriendly"] = "Unfreundlich",
    ["Neutral"] = "Neutral",
    ["Friendly"] = "Freundlich",
    ["Honored"] = "Wohlwollend",
    ["Revered"] = "Respektvoll",
    ["Exalted"] = "Ehrfürchtig",

    -- a crafting step
    ["Skill %d - %d, about %d crafts, %s%s"] = "Fertigkeit %d - %d, etwa %d Herstellungen, %s%s",
    ["some prices missing"] = "einige Preise fehlen",
    ["%s %s what you already have: %d crafts%s."] = "%s %s aus dem, was du schon hast: %d Herstellungen%s.",
    [", plus a few vendor ingredients"] = ", dazu ein paar Zutaten vom Händler",
    [", nothing to buy"] = ", nichts zu kaufen",
    ["You can %s %d now with what you have."] = "%s: jetzt %d aus dem, was du hast.",
    ["You have the reagents for %d."] = "Du hast die Zutaten für %d.",
    ["You have the main ingredients for %d; the rest is sold by vendors."] = "Du hast die Hauptzutaten für %d;" ..
        " den Rest verkaufen Händler.",
    ["The cheapest here is %s."] = "Das billigste hier ist %s.",
    ["Needed for %s: %d recipes (%s, ...), and no vendor sells it. None of them is for leveling (a cooldown," ..
        " or learned at 300): make it once you're done."] = "Gebraucht für %s: %d Rezepte (%s, ...), und kein" ..
        " Händler verkauft es. Keines davon dient dem Hochleveln (eine Abklingzeit oder erst bei 300 gelernt):" ..
        " stell es her, wenn du fertig bist.",
    ["A tool: %d %s recipes need it, and no vendor sells it. Make one and keep it in your bags%s."] =
        "Ein Werkzeug: %d Rezepte in %s brauchen es, und kein Händler verkauft es. Stell eins her und behalte" ..
        " es in den Taschen%s.",
    [" (it gives no skill point any more)"] = " (es gibt keinen Fertigkeitspunkt mehr)",
    ["You have %s: the step takes them from your bags, so it pays less than that."] =
        "Du hast %s: der Schritt nimmt sie aus deinen Taschen, also zahlt er weniger als das.",
    ["Keep for later"] = "Für später behalten",
    ["Keep %d %s: the steps at %d - %d use them."] = "Behalte %d %s: die Schritte bei %d - %d brauchen sie.",
    ["Batch: %s"] = "Charge: %s",
    ["Craft counts are estimates: skill-ups are luck once a recipe is yellow."] = "Die Anzahl der" ..
        " Herstellungen ist geschätzt: Fertigkeitspunkte sind Glückssache, sobald ein Rezept gelb ist.",
    ["Sell the rest"] = "Den Rest verkaufen",
    ["Sell what you make"] = "Verkaufen, was du herstellst",
    ["%d at the auction house, about %s each after its cut."] = "%d im Auktionshaus, etwa %s pro Stück nach" ..
        " dessen Abzug.",
    ["%d to a vendor, %s each."] = "%d an einen Händler, %s pro Stück.",
    ["About %s back, so this step %s %s."] = "Etwa %s zurück, also %s dieser Schritt %s.",
    ["earns"] = "bringt",
    ["costs"] = "kostet",
    ["Vendor sales counts only what vendors pay: that money is sure. AH sales counts the auction house too."] =
        "Händlerverkauf zählt nur, was Händler zahlen: dieses Geld ist sicher. Auktionsverkauf zählt auch das" ..
        " Auktionshaus.",
    ["The auction house counts only when it pays 1.5 times a vendor and 5 or more are listed, and for at most" ..
        " a quarter of what's listed."] = "Das Auktionshaus zählt nur, wenn es das 1,5-fache eines Händlers" ..
        " zahlt und 5 oder mehr angeboten sind, und höchstens für ein Viertel des Angebotenen.",
    ["Or %s, from %d"] = "Oder %s, ab %d",
    ["Recipes you could use from %d"] = "Rezepte, die du ab %d nehmen könntest",
    ["No other recipe is open to you here."] = "Hier steht dir kein anderes Rezept offen.",

    -- Gold: one recipe's profit
    ["One craft%s costs about %s and sells for about %s: %s+%s|r"] = "Eine Herstellung%s kostet etwa %s und" ..
        " verkauft sich für etwa %s: %s+%s|r",
    ["Sold to a vendor: vendors buy any number."] = "An einen Händler verkauft: Händler kaufen jede Menge.",
    ["%d listed at the auction house now: sell a few at a time."] = "Gerade %d im Auktionshaus angeboten:" ..
        " verkauf ein paar auf einmal.",
    ["Making it needs %s %d, and yours is %d%s. It's here to level towards."] = "Zum Herstellen braucht es %s" ..
        " %d, und deines ist %d%s. Es steht hier als Ziel.",
    ["; the rank that lifts your cap to it asks level %d, and you're %d"] = "; der Rang, der deine Grenze" ..
        " dorthin hebt, verlangt Stufe %d, und du bist %d",
    ["Learning it pays back after %d %s."] = "Das Lernen zahlt sich nach %d %s aus.",
    ["craft"] = "Herstellung",
    ["crafts"] = "Herstellungen",
    ["Once in %s: the recipe has a cooldown."] = "Einmal in %s: das Rezept hat eine Abklingzeit.",
    ["You have %s: counted at their price too, since you could sell them."] = "Du hast %s: auch sie sind zum" ..
        " Preis gezählt, denn du könntest sie verkaufen.",
    ["Profit: what a vendor pays, less the ingredients at today's prices. How many you can make, the auction" ..
        " house's ingredients decide."] = "Gewinn: was ein Händler zahlt, minus die Zutaten zu heutigen" ..
        " Preisen. Wie viele du herstellen kannst, entscheiden die Zutaten im Auktionshaus.",
    ["Profit: at the lowest listing after the auction house's cut, with 5 or more listed, or however few when" ..
        " you searched it yourself; it counts only when it pays 1.5 times what a vendor does. How many sell," ..
        " the auction house doesn't say. Prices change: look again before buying."] =
        "Gewinn: zum billigsten Angebot nach dem Abzug des Auktionshauses, mit 5 oder mehr angeboten, oder" ..
        " beliebig wenigen, wenn du selbst gesucht hast; es zählt nur, wenn es das 1,5-fache eines Händlers" ..
        " zahlt. Wie viel sich verkauft, sagt das Auktionshaus nicht. Preise ändern sich: schau noch einmal," ..
        " bevor du kaufst.",

    -- Disenchant
    ["Disenchant one: about %s"] = "Einen entzaubern: etwa %s",
    ["%d%% of disenchants, %s each"] = "%d%% der Entzauberungen, %s pro Stück",
    ["%s%d disenchanted: about %s, at least %s 9 times out of 10."] = "%s%d entzaubert: etwa %s, mindestens %s" ..
        " in 9 von 10 Fällen.",
    ["Your "] = "Deine",
    ["What it gives: from your %d disenchants of this item, recorded in game: it breaks unlike items of its" ..
        " kind."] = "Was es gibt: aus deinen %d Entzauberungen dieses Gegenstands, im Spiel aufgezeichnet: er" ..
        " zerfällt anders als Gegenstände seiner Art.",
    ["What it gives: from %d disenchants of items like it, recorded in game."] = "Was es gibt: aus %d" ..
        " Entzauberungen ähnlicher Gegenstände, im Spiel aufgezeichnet.",
    ["You've disenchanted %d like it: %s in all. From %d, what you got replaces the table."] =
        "Du hast %d ähnliche entzaubert: zusammen %s. Ab %d ersetzt das, was du bekommen hast, die Tabelle.",
    ["Forever added this kind of item: what it gives is a guess, checked for one item: a green's of its level," ..
        " one more of each."] = "Forever hat diese Art von Gegenstand hinzugefügt: was sie gibt, ist eine" ..
        " Vermutung, an einem Gegenstand geprüft: wie bei einem grünen seiner Stufe, eins mehr von jedem.",
    ["What a disenchant gives is luck%s. Materials at the auction house after its cut; 3 lesser essences make" ..
        " a greater one."] = "Was eine Entzauberung gibt, ist Glückssache%s. Materialien im Auktionshaus nach" ..
        " dessen Abzug; 3 kleine Essenzen ergeben eine große.",
    [", from Classic's table (not checked in Forever yet): from %d of your disenchants of items like it, what" ..
        " you got replaces it"] = ", aus Classics Tabelle (in Forever noch nicht geprüft): ab %d deiner" ..
        " Entzauberungen ähnlicher Gegenstände ersetzt das, was du bekommen hast, sie",
    ["One craft%s costs about %s; disenchanted, about %s on average: %s"] = "Eine Herstellung%s kostet etwa" ..
        " %s; entzaubert im Schnitt etwa %s: %s",
    ["Disenchanting it needs Enchanting %d; the best of yours is %d."] = "Zum Entzaubern braucht es" ..
        " Verzauberkunst %d; dein bestes ist %d.",
    ["A %s recipe %s knows."] = "Ein Rezept in %s, das %s kennt.",
    ["you"] = "du",
    ["Making it costs more than disenchanting brings: disenchant it when you make it anyway, for skill."] =
        "Herstellen kostet mehr, als Entzaubern bringt: entzauber es, wenn du es ohnehin für die Fertigkeit" ..
        " herstellst.",
    ["Best: %s. %d in %s's %s: disenchanted, about %s on average; sold, %s."] = "Am besten: %s. %d bei %s, %s:" ..
        " entzaubert im Schnitt etwa %s; verkauft %s.",
    ["your"] = "dir",
    ["bags"] = "Taschen",
    ["Soulbound: no auction house."] = "Seelengebunden: kein Auktionshaus.",
    ["%s has the most Enchanting of yours, %d: mail it there."] = "%s hat die höchste Verzauberkunst von dir," ..
        " %d: schick es per Post dorthin.",
    ["Or sell it"] = "Oder verkaufen",
    ["Soulbound: the auction house won't take it."] = "Seelengebunden: das Auktionshaus nimmt es nicht.",
    ["%s each at the auction house (after its cut%s)."] = "%s pro Stück im Auktionshaus (nach dessen Abzug%s).",
    ["%s each at a vendor."] = "%s pro Stück bei einem Händler.",
    ["The auction house counts with 5 or more listed, or however few when you searched it yourself. What made" ..
        " it doesn't count: it's made."] = "Das Auktionshaus zählt ab 5 Angeboten, oder bei beliebig wenigen," ..
        " wenn du selbst gesucht hast. Woraus es gemacht ist, zählt nicht: es ist gemacht.",
    ["Buy one for %s; disenchanted, about %s on average: %s"] = "Für %s kaufen; entzaubert im Schnitt etwa %s:" ..
        " %s",
    ["Disenchanting it needs Enchanting %d; the best of yours is %d: no character of yours can.|r"] =
        "Zum Entzaubern braucht es Verzauberkunst %d; dein bestes ist %d: kein Charakter von dir kann es.|r",
    ["One disenchant brings more than it cost %d%% of the time."] = "Eine Entzauberung bringt in %d%% der" ..
        " Fälle mehr, als sie gekostet hat.",
    ["Buy it"] = "Kaufen",
    ["The cheapest listing: %s. %s."] = "Das billigste Angebot: %s. %s.",
    ["Its level and quality are Classic's: Forever's client doesn't list it. "] = "Stufe und Qualität stammen" ..
        " aus Classic: der Forever-Client führt sie nicht.",
    ["A random suffix (\"of the Monkey\") doesn't change what it breaks into. The listing may have sold since" ..
        " the scan."] = "Ein zufälliges Suffix (\"des Affen\") ändert nichts daran, worin es zerfällt. Das" ..
        " Angebot kann seit dem Scan verkauft sein.",
    ["Nothing to disenchant"] = "Nichts zu entzaubern",
    ["No character of yours holds anything to disenchant, and "] = "Kein Charakter von dir hält etwas zum" ..
        " Entzaubern, und",
    ["none of the recipes they know makes something to disenchant: open a crafting profession's window once so" ..
        " Craft Ladder knows its recipes."] = "keines der Rezepte, die sie kennen, stellt etwas zum Entzaubern" ..
        " her: öffne einmal das Fenster eines Handwerksberufs, damit Craft Ladder seine Rezepte kennt.",
    ["nothing they can make is worth more disenchanted than sold at today's prices."] =
        "nichts, was sie herstellen können, ist entzaubert mehr wert als verkauft zu heutigen Preisen.",

    -- Cooking's Food
    [" (Well Fed). "] = " (Sattgegessen).",
    ["Needs level %d; you're %d."] = "Braucht Stufe %d; du bist %d.",
    ["Level %d: you can eat it."] = "Stufe %d: du kannst es essen.",
    ["Any level can eat it."] = "Jede Stufe kann es essen.",
    ["Nobody sells its recipe now: look for it at the auction house."] = "Sein Rezept verkauft gerade niemand:" ..
        " such es im Auktionshaus.",
    ["No way to learn it for you now (a holiday's, or the other side's)."] = "Für dich gerade nicht zu lernen" ..
        " (ein Feiertagsrezept oder das der anderen Seite).",
    ["Learned at %s %d; you have %d."] = "Gelernt bei %s %d; du hast %d.",
    ["You have %s: cooking it takes them from your bags, so it costs you less than that."] =
        "Du hast %s: das Kochen nimmt sie aus deinen Taschen, also kostet es dich weniger als das.",
    ["Or buy it"] = "Oder kaufen",
    ["One at the auction house: %s."] = "Eines im Auktionshaus: %s.",
    ["None listed at the auction house now."] = "Gerade keines im Auktionshaus angeboten.",
    ["What it raises is read from the game's files, not checked in game yet."] = "Was es hebt, ist aus den" ..
        " Dateien des Spiels gelesen, im Spiel noch nicht geprüft.",

    -- a rank step
    ["At skill %d. Your cap is your level x 5: %d at level %d."] = "Bei Fertigkeit %d. Deine Grenze ist deine" ..
        " Stufe x 5: %d auf Stufe %d.",
    ["You're level %d."] = "Du bist Stufe %d.",
    ["Your level allows it already."] = "Deine Stufe erlaubt es schon.",
    ["Lockpicking can't go past your level x 5: level up before you go on."] = "Schlossknacken geht nicht über" ..
        " deine Stufe x 5 hinaus: level erst, bevor du weitermachst.",
    ["Learn %s%s"] = "%s%s lernen",
    ["At skill %d, raises your cap to %d. %s"] = "Bei Fertigkeit %d, hebt deine Grenze auf %d. %s",
    ["Needs character level %d."] = "Braucht Charakterstufe %d.",
    ["How"] = "Wie",
    ["Only these trainers teach it%s:"] = "Nur diese Lehrer lehren es%s:",
    [", for %s"] = ", für %s",
    ["Any %s trainer teaches it%s."] = "Jeder Lehrer (%s) lehrt es%s.",
    [" for %s"] = " für %s",
    ["Buy the %s and read it:"] = "Kauf %s und lies es:",
    ["At the auction house: %s."] = "Im Auktionshaus: %s.",
    ["Or buy it at the auction house: %s.%s"] = "Oder kauf es im Auktionshaus: %s.%s",
    [" Cheaper than the vendor, so the ladder counts this one."] = " Billiger als beim Händler, also rechnet" ..
        " die Leiter mit diesem.",
    ["1. Take the quest %s:"] = "1. Nimm die Quest %s an:",
    ["start"] = "Anfang",
    ["2. Bring the ingredients below to %s for %s:"] = "2. Bring die Zutaten unten zu %s für %s:",
    ["hand in"] = "Abgabe",
    ["Do the quest %s for %s:"] = "Mach die Quest %s bei %s:",
    ["What to bring"] = "Was mitbringen",
    ["Any %s trainer teaches Apprentice %s."] = "Jeder Lehrer (%s) lehrt Lehrling (%s).",

    -- fishing
    ["Fish to catch"] = "Welche Fische fangen",
    ["%s: %s, %s (fish bite from %d)"] = "%s: %s, %s (beißen ab %d)",
    ["seen by GatherMate2"] = "von GatherMate2 gesehen",
    ["place known"] = "Stelle bekannt",
    ["places known"] = "Stellen bekannt",
    [" a catch"] = " pro Fang",
    ["%d - %d catches before it's gone"] = "%d - %d Fänge, bis er weg ist",
    ["No fish get away here."] = "Hier entkommt kein Fisch.",
    ["About %d%% of casts land a fish here."] = "Hier bringen etwa %d%% der Würfe einen Fisch.",
    ["An hour at skill %d: about %d catches, %s each"] = "Eine Stunde bei Fertigkeit %d: etwa %d Fänge, %s pro" ..
        " Stück",
    [" An hour's catches are worth about %s%s."] = " Die Fänge einer Stunde sind etwa %s wert%s.",
    [", lures paid"] = ", Köder bezahlt",
    ["Skill %d - %d, about %d catches (%s), %s"] = "Fertigkeit %d - %d, etwa %d Fänge (%s), %s",
    [" Catches worth about %s (%s an hour)."] = " Fänge etwa %s wert (%s pro Stunde).",
    ["Craft Ladder's choice here is %s."] = "Craft Ladders Wahl ist hier %s.",
    ["Its creatures are level %d - %d."] = "Seine Kreaturen sind Stufe %d - %d.",
    ["Bring"] = "Mitnehmen",
    ["Put %s on your pole: +%d fishing for %d minutes, so no fish get away."] = "Steck %s an deine Rute: +%d" ..
        " Angeln für %d Minuten, dann entkommt kein Fisch.",
    ["Fishing supplies vendors sell lures, in every capital."] = "Köder verkaufen Händler für Angelbedarf, in" ..
        " jeder Hauptstadt.",
    ["No lure needed: your skill keeps the fish from getting away."] = "Kein Köder nötig: deine Fertigkeit" ..
        " hält die Fische schon.",
    ["What you catch here"] = "Was du hier fängst",
    ["Fishing pools here"] = "Fischschwärme hier",
    ["Fish pools when you see them: Craft Ladder counts a third of your catches here from pools. That makes a" ..
        " catch worth %s on average (%s in open water)."] = "Fisch in Schwärmen, wenn du sie siehst: Craft" ..
        " Ladder rechnet hier ein Drittel deiner Fänge aus Schwärmen. Damit ist ein Fang im Schnitt %s wert" ..
        " (%s im offenen Wasser).",
    ["No fishing pools known here yet. GatherMate2 adds the ones you fish, and Craft Ladder counts them."] =
        "Hier sind noch keine Fischschwärme bekannt. GatherMate2 trägt die ein, in denen du fischst, und Craft" ..
        " Ladder rechnet sie mit.",
    ["Catches per point: from your %d catches, skill-ups come %d%% as often as Classic's rule says."] =
        "Fänge pro Punkt: aus deinen %d Fängen kommen Fertigkeitspunkte zu %d%% so oft wie Classics Regel" ..
        " sagt.",
    ["Catches per point follow Classic's rule (at 150, one point in about 4 catches) until Craft Ladder has" ..
        " counted 50 of your catches (%d so far)."] = "Fänge pro Punkt folgen Classics Regel (bei 150 ein" ..
        " Punkt in etwa 4 Fängen), bis Craft Ladder 50 deiner Fänge gezählt hat (bisher %d).",
    ["Zones and their fish come from Classic's world: Forever may differ."] = "Zonen und ihre Fische stammen" ..
        " aus Classics Welt: in Forever kann es anders sein.",
    ["Other zones from %d"] = "Andere Zonen ab %d",
    ["No other zone is open to you here."] = "Hier steht dir keine andere Zone offen.",

    -- skinning and mining
    ["about %d in the zone, %s %s each%s"] = "etwa %d in der Zone, %s %s pro Stück%s",
    [", worth %s"] = ", wert %s",
    ["needs %d"] = "braucht %d",
    ["%s  %slevel %d%s|r"] = "%s  %sStufe %d%s|r",
    [", seen skinned"] = ", schon gehäutet",
    ["about %d in the zone, needs %d%s"] = "etwa %d in der Zone, braucht %d%s",
    [", %s a skin"] = ", %s pro Haut",
    ["Skin in %s"] = "Kürschnern in %s",
    ["An hour at skill %d: about %d creatures, %s each"] = "Eine Stunde bei Fertigkeit %d: etwa %d Kreaturen," ..
        " %s pro Stück",
    ["An hour's skins are worth about %s. Every creature you can skin counts, grey ones too."] =
        "Die Häute einer Stunde sind etwa %s wert. Jede Kreatur, die du häuten kannst, zählt, auch graue.",
    ["Skill %d - %d, about %d creatures%s"] = "Fertigkeit %d - %d, etwa %d Kreaturen%s",
    [", trainer %s"] = ", Lehrer %s",
    ["Worth about %s skinned (%s an hour)."] = "Etwa %s wert gehäutet (%s pro Stunde).",
    ["Skin every creature that still gives a point, of your level or below."] = "Häute jede Kreatur, die noch" ..
        " einen Punkt gibt, auf deiner Stufe oder darunter.",
    ["Its creatures are well above your level."] = "Seine Kreaturen sind weit über deiner Stufe.",
    ["Creatures to skin here"] = "Kreaturen zum Häuten hier",
    ["Which creatures can be skinned and what one gives come from Classic; where they are and their levels" ..
        " from QuestieDB's Forever data. The skill one needs is Classic's rule from its level (level x 5 past" ..
        " 20), the colours Mining's (yellow 25, green 50, grey 100 above it). A creature new in Forever counts" ..
        " once you've skinned one."] = "Welche Kreaturen gehäutet werden können und was eine gibt, stammt aus" ..
        " Classic; wo sie sind und welche Stufe sie haben, aus QuestieDBs Forever-Daten. Die nötige Fertigkeit" ..
        " ist Classics Regel aus ihrer Stufe (Stufe x 5 ab 20), die Farben die des Bergbaus (gelb 25, grün 50," ..
        " grau 100 darüber). Eine in Forever neue Kreatur zählt, sobald du eine gehäutet hast.",
    ["Gold an hour assumes %d s a creature (kill, loot, skin) and a 60%% mount between them: about %d an hour" ..
        " here."] = "Gold pro Stunde rechnet mit %d s je Kreatur (töten, plündern, häuten) und einem" ..
        " 60%%-Reittier dazwischen: etwa %d pro Stunde hier.",
    ["Other zones, from %d"] = "Andere Zonen, ab %d",
    ["%s in %s"] = "%s in %s",
    ["An hour at skill %d: about %d %s, %s each"] = "Eine Stunde bei Fertigkeit %d: etwa %d %s, %s pro Stück",
    ["An hour's worth about %s. Every %s you can reach counts, grey ones too. Creatures level %d - %d."] =
        "Eine Stunde etwa %s wert. Jedes %s, das du erreichst, zählt, auch graue. Kreaturen Stufe %d - %d.",
    ["Skill %d - %d, about %d %s%s"] = "Fertigkeit %d - %d, etwa %d %s%s",
    ["Worth about %s (%s an hour). Creatures level %d - %d."] = "Etwa %s wert (%s pro Stunde). Kreaturen Stufe" ..
        " %d - %d.",
    ["Creatures level %d - %d. %s every %s that still gives a point."] = "Kreaturen Stufe %d - %d. %s jedes" ..
        " %s, das noch einen Punkt gibt.",
    ["%s places come from GatherMate2's Forever data; what one gives and how often a rarer kind takes a place," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what one" ..
        " needs): Forever may differ."] = "Die Stellen (%s) stammen aus GatherMate2s Forever-Daten; was eine" ..
        " gibt und wie oft eine seltenere Art eine Stelle einnimmt, aus Classic. Fertigkeitspunkte folgen" ..
        " Classics Farben (gelb 25, grün 50, grau 100 über dem Nötigen): in Forever kann es anders sein.",
    ["Gold an hour assumes 15 s a %s, a third of the zone's places with one up and a 60%% mount: about %d an" ..
        " hour here."] = "Gold pro Stunde rechnet mit 15 s je %s, einem Drittel der Stellen der Zone besetzt" ..
        " und einem 60%%-Reittier: etwa %d pro Stunde hier.",
    ["%s: about %d bars%s"] = "%s: etwa %d Barren%s",
    [", learn it from a Mining trainer for %s"] = ", lern es bei einem Bergbaulehrer für %s",
    ["Nothing you mine here still gives points when smelted."] = "Nichts, was du hier abbaust, gibt" ..
        " geschmolzen noch Punkte.",
    ["Sell ore or bars"] = "Erz oder Barren verkaufen",
    ["%s: %s each. Smelting it needs more skill."] = "%s: %s pro Stück. Zum Schmelzen braucht es mehr" ..
        " Fertigkeit.",
    ["sell the ore, smelt it only for the skill-ups"] = "verkauf das Erz, schmelz es nur für die" ..
        " Fertigkeitspunkte",
    ["smelt it and sell the bars"] = "schmelz es und verkauf die Barren",
    [", %s as %s"] = ", %s als %s",
    ["make %s and sell it"] = "stell %s her und verkauf es",
    ["%s: %s as ore, %s as %s%s - %s."] = "%s: %s als Erz, %s als %s%s - %s.",
    ["%s: %s make %d %s, so per ore it's worth one of them; it takes both ores, as much as the scarcer one" ..
        " allows."] = "%s: %s ergeben %d %s, also ist es je Erz so viel wert wie eines davon; es braucht beide" ..
        " Erze, so viel das seltenere erlaubt.",
    ["Nothing mined here can be smelted."] = "Nichts, was hier abgebaut wird, lässt sich schmelzen.",
    ["Per ore, after the auction house's cut (only what's listed at least 5 times), or what a vendor pays."] =
        "Je Erz, nach dem Abzug des Auktionshauses (nur was mindestens 5-mal angeboten ist), oder was ein" ..
        " Händler zahlt.",
    ["Smelting gives skill-ups too: Craft Ladder counts the ore you mine as smelted, so you mine fewer nodes."] =
        "Schmelzen gibt auch Fertigkeitspunkte: Craft Ladder rechnet das Erz, das du abbaust, als geschmolzen," ..
        " also brauchst du weniger Vorkommen.",
    ["Node places come from GatherMate2's Forever data; how often rare veins appear and the ore a node gives," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what a node" ..
        " needs): Forever may differ."] = "Die Stellen der Vorkommen stammen aus GatherMate2s Forever-Daten;" ..
        " wie oft seltene Adern auftauchen und wie viel Erz ein Vorkommen gibt, aus Classic. Fertigkeitspunkte" ..
        " folgen Classics Farben (gelb 25, grün 50, grau 100 über dem, was ein Vorkommen braucht): in Forever" ..
        " kann es anders sein.",
    ["Gold an hour assumes 15 s a node, a third of the zone's node places with a node up and a 60%% mount:" ..
        " about %d nodes an hour here."] = "Gold pro Stunde rechnet mit 15 s je Vorkommen, einem Drittel der" ..
        " Stellen der Zone besetzt und einem 60%%-Reittier: etwa %d Vorkommen pro Stunde hier.",
    ["Other zones, or smelting, from %d"] = "Andere Zonen oder Schmelzen, ab %d",

    -- Lockpicking
    ["%d a run, needs %d"] = "%d pro Durchgang, braucht %d",
    ["about %d in the zone, needs %d"] = "etwa %d in der Zone, braucht %d",
    ["Humanoids drop it; the auction house sells it."] = "Fällt von Humanoiden; das Auktionshaus verkauft sie.",
    ["Fished up from pools."] = "Aus Schwärmen gefischt.",
    ["Engineers make it."] = "Ingenieure stellen sie her.",
    ["Pick Pocket humanoids of level %d - %d."] = "Beklaue Humanoide der Stufe %d - %d.",
    ["Pick Pocket humanoids."] = "Beklaue Humanoide.",
    ["Pick locks in %s"] = "Schlösser knacken in %s",
    ["Skill %d - %d, about %d locks"] = "Fertigkeit %d - %d, etwa %d Schlösser",
    ["Creatures level %d - %d. Pick every lock that still gives a point: a chest gives one chance, and one" ..
        " more once it's back."] = "Kreaturen Stufe %d - %d. Knack jedes Schloss, das noch einen Punkt gibt:" ..
        " eine Truhe gibt eine Chance und noch eine, wenn sie wieder da ist.",
    ["The door round"] = "Die Türenrunde",
    ["1. Go into Blackrock Depths (Blackrock Mountain, between Searing Gorge and Burning Steppes)."] =
        "1. Geh in die Schwarzfelstiefen (Schwarzfels, zwischen der Sengenden Schlucht und den Brennenden" ..
        " Steppen).",
    ["2. Pick the locked doors on the way: the first on the left, through it the next on the right, then the" ..
        " first on the left again; the Shadowforge Lock under the big gear too, if nothing would pull."] =
        "2. Knack unterwegs die verschlossenen Türen: die erste links, dahinter die nächste rechts, dann" ..
        " wieder die erste links; auch das Schattenschmiedeschloss unter dem großen Zahnrad, wenn nichts" ..
        " anzieht.",
    ["3. Leave, right-click your portrait, Reset all instances and go in again: the game lets you in 5 times" ..
        " an hour."] = "3. Geh raus, Rechtsklick auf dein Porträt, Alle Instanzen zurücksetzen und wieder" ..
        " rein: das Spiel lässt dich 5-mal pro Stunde hinein.",
    ["The round is zockify's Forever guide's: about 4 doors a run."] = "Die Runde stammt aus zockifys" ..
        " Forever-Guide: etwa 4 Türen pro Durchgang.",
    ["Where"] = "Wo",
    ["Most %ss are around here"] = "Die meisten (%s) sind hier in der Gegend",
    ["Chest places: GatherMate2's and QuestieDB's Forever data. Which lock a chest needs, and the colours" ..
        " (yellow 25, green 50, grey 100 above it), are Classic's: Forever may differ."] =
        "Truhenstellen: Forever-Daten von GatherMate2 und QuestieDB. Welches Schloss eine Truhe braucht und" ..
        " die Farben (gelb 25, grün 50, grau 100 darüber) stammen aus Classic: in Forever kann es anders sein.",
    ["Other zones, or boxes, from %d"] = "Andere Zonen oder Kisten, ab %d",
    ["Pick %s"] = "%s knacken",
    ["Skill %d - %d, about %d boxes, %s"] = "Fertigkeit %d - %d, etwa %d Kisten, %s",
    ["Pick the ones in your bags: you have %d."] = "Knack die in deinen Taschen: du hast %d.",
    ["Boxes to buy: %s"] = "Kisten zu kaufen: %s",
    ["A box gives one chance at a point, and what's inside is yours."] = "Eine Kiste gibt eine Chance auf" ..
        " einen Punkt, und was drin ist, gehört dir.",
    ["Or pick locks in a zone, from %d"] = "Oder Schlösser in einer Zone knacken, ab %d",
    ["Every lock a rogue picks, by the skill it needs; its colour at your %d."] = "Jedes Schloss, das ein" ..
        " Schurke knackt, nach der nötigen Fertigkeit; seine Farbe bei deinen %d.",
    ["Orange always gives a point, yellow mostly, green sometimes, grey never."] = "Orange gibt immer einen" ..
        " Punkt, gelb meistens, grün manchmal, grau nie.",
    ["Chests in the world"] = "Truhen in der Welt",
    ["Boxes from your bags"] = "Kisten aus deinen Taschen",
    ["You have %d."] = "Du hast %d.",
    [" %s at the auction house."] = " %s im Auktionshaus.",
    ["Dungeon doors"] = "Türen in Dungeons",
    ["%s: %d locked doors, from %d (%s)."] = "%s: %d verschlossene Türen, ab %d (%s).",
    ["Getting started"] = "Wie anfangen",
    ["Pick Lock: any rogue trainer, from level 16, for %s. It needs Thieves' Tools in your bags (rogue" ..
        " supplies vendors, 15s). Your cap is your level x 5."] = "Schlossknacken: jeder Schurkenlehrer, ab" ..
        " Stufe 16, für %s. Es braucht Diebeswerkzeug in deinen Taschen (Händler für Schurkenbedarf, 15s)." ..
        " Deine Grenze ist deine Stufe x 5.",

    -- the cards with nothing to show, and the rest
    ["Nothing earns now"] = "Gerade bringt nichts etwas ein",
    ["Nothing you can make sells for more than it costs at today's prices."] = "Nichts, was du herstellen" ..
        " kannst, verkauft sich zu heutigen Preisen für mehr, als es kostet.",
    ["Nothing you can get here has a price yet: Craft Ladder needs auction house prices."] =
        "Nichts, was du hier bekommst, hat bisher einen Preis: Craft Ladder braucht Auktionspreise.",
    ["Nothing to do here"] = "Hier gibt es nichts zu tun",
    ["You've reached %d %s."] = "Du hast %d in %s erreicht.",
    ["No recipe found for your skill."] = "Kein Rezept für deine Fertigkeit gefunden.",
    [", Working Overtime %d/5: +%d%%"] = ", Überstunden %d/5: +%d%%",

    -- what the data itself says on a rank card (Professions.lua, Data/*.lua)
    ["Your class quests at 16"] = "Deine Klassenquests mit 16",
    ["They lead to the first practice chests and give you Thieves' Tools. Pick Lock itself is learned from any" ..
        " rogue trainer, quest or not."] = "Sie führen zu den ersten Übungstruhen und geben dir" ..
        " Diebeswerkzeug. Schlösser knacken selbst lernt man bei jedem Schurkenlehrer, mit Quest oder ohne.",
    ["Your class quests at 20"] = "Deine Klassenquests mit 20",
    ["The last one teaches Poisons (and Recipe: Thistle Tea). On the way you pick a lock: Lockpicking 70 for" ..
        " the Alliance's Duskwood Chest, 80 for the Horde's Gallywix's Lockbox (Classic's numbers, not" ..
        " confirmed in Forever)."] = "Die letzte lehrt Gifte (und Rezept: Distelteе). Unterwegs knackst du ein" ..
        " Schloss: Schlossknacken 70 für die Dunkelhaintruhe der Allianz, 80 für Gallywix' Schließkassette der" ..
        " Horde (Classics Zahlen, in Forever nicht bestätigt).",
    ["Bring 12 Giant Egg, 10 Zesty Clam Meat and 20 Alterac Swiss to Dirge Quikcleave in Gadgetzan."] =
        "Bring 12 Riesenei, 10 Würziges Muschelfleisch und 20 Alteracer Schweizer zu Dirge Quikcleave in" ..
        " Gadgetzan.",
    ["Catch the four fish below and bring them to Nat Pagle; he then teaches Artisan Fishing for 1g."] =
        "Fang die vier Fische unten und bring sie zu Nat Pagle; er lehrt dann Angeln (Kunsthandwerker) für 1g.",
    ["Hank the Hammer's (Alliance) or Aturk the Anvil's (Horde) quests lead to Galvan the Ancient and Trenton" ..
        " Lighthammer, whose quests teach the Ornate Mithril recipes the last quest asks for. Buy those 7" ..
        " items at the auction house and you can skip them."] = "Die Quests von Hank dem Hammer (Allianz) oder" ..
        " Aturk dem Amboss (Horde) führen zu Galvan dem Alten und Trenton Leichthammer, deren Quests die" ..
        " Rezepte für verzierten Mithril lehren, die die letzte Quest verlangt. Kauf diese 7 Gegenstände im" ..
        " Auktionshaus, dann kannst du sie überspringen.",
    ["It gives you a letter to hand in."] = "Sie gibt dir einen Brief zum Abgeben.",
    ["Right-click the pledge it gives you: that completes it."] = "Rechtsklick auf das Gelöbnis, das sie dir" ..
        " gibt: damit ist sie erledigt.",
    ["Save 15 wounded soldiers with the Triage Bandages the doctor gives you, before 6 of them die."] =
        "Rette 15 verwundete Soldaten mit den Erstversorgungsbandagen, die dir der Arzt gibt, bevor 6 von" ..
        " ihnen sterben.",
    ["Then learn the mastery from the trainer who gave you the quest."] = "Lern dann die Meisterschaft bei dem" ..
        " Lehrer, der dir die Quest gegeben hat.",
}
