-- Craft Ladder in Italian. The key is the English string as it stands in the code; what's missing here is shown in
-- English. Item, recipe and zone names stay English: the Forever client has none in this language.
-- The %s and %d of a line must stay in the same order as in the English one: the game fills them in that order.
local _, ns = ...

ns.Locales = ns.Locales or {}
ns.Locales.itIT = {
    -- the auction house tab
    ["The items' names are still loading: click again."] = "I nomi degli oggetti si stanno ancora caricando:" ..
        " clicca di nuovo.",
    ["Stop"] = "Ferma",
    ["Full Rescan"] = "Riscansiona tutto",
    ["Scanning %s: %d of %d items."] = "Scansione di %s: %d di %d oggetti.",
    ["the auction house"] = "la casa d'aste",
    ["Scan done: %d of %d items searched."] = "Scansione finita: trovati %d di %d oggetti.",
    ["A scan is already running: stop it first."] = "Una scansione è già in corso: fermala prima.",
    ["Nothing to scan here."] = "Qui non c'è nulla da scansionare.",
    ["Scanning %s: 0 of %d items."] = "Scansione di %s: 0 di %d oggetti.",
    ["this step"] = "questo passo",
    ["Confirm %s"] = "Compra per %s",
    ["Asking..."] = "Richiesta...",
    ["Buying %d %s..."] = "Acquisto di %d %s...",
    ["The auction house is busy: try again in a moment."] = "La casa d'aste è occupata: riprova tra un" ..
        " momento.",
    ["Asking the price of %d %s..."] = "Chiedo il prezzo di %d %s...",
    ["Scan"] = "Scansiona",
    ["Asks the auction house what this one goes for now, and puts that price in the ladder. However fresh the" ..
        " price already is."] = "Chiede alla casa d'aste quanto vale questo adesso e mette quel prezzo nella" ..
        " scala. Per quanto fresco sia già il prezzo.",
    ["Asks the auction house about what this step makes and everything it takes, then puts those prices in the" ..
        " ladder."] = "Chiede alla casa d'aste quanto vale ciò che questo passo produce e tutto ciò che" ..
        " richiede, poi mette quei prezzi nella scala.",
    ["Search"] = "Cerca",
    ["Auctionator's Shopping tab with what this step buys, and how many."] = "La scheda Acquisti di" ..
        " Auctionator con ciò che questo passo compra, e quanti.",
    ["Learn %s"] = "Impara %s",
    ["at %d, raises your cap to %d"] = "a %d, alza il tuo limite a %d",
    ["%s%s|r a craft, %s"] = "%s%s|r a lavorazione, %s",
    ["sold to a vendor"] = "venduto a un mercante",
    ["%d listed"] = "%d in vendita",
    ["%d - %d, ~%d %s%s"] = "%d - %d, ~%d %s%s",
    [", %d listed"] = ", %d in vendita",
    ["at %d, make one and keep it"] = "a %d, creane uno e tienilo",
    ["nothing to buy"] = "nulla da comprare",
    ["need %d, you have %d"] = "te ne servono %d, ne hai %d",
    ["%s each"] = "%s l'uno",
    ["not listed"] = "non in vendita",
    ["No crafting profession: nothing to buy for one."] = "Nessuna professione di creazione: nulla da comprare" ..
        " per una.",
    ["%s: nothing to buy"] = "%s: nulla da comprare",
    ["Scan stopped: the prices it had got are in."] = "Scansione fermata: i prezzi che ha ottenuto sono" ..
        " dentro.",
    ["Nothing here to rescan."] = "Qui non c'è nulla da riscansionare.",
    ["Every price here was searched in the last two minutes: nothing to ask again."] =
        "Ogni prezzo qui è stato cercato negli ultimi due minuti: nulla da richiedere.",
    ["Scanning the auction house: 0 of %d items."] = "Scansione della casa d'aste: 0 di %d oggetti.",
    ["Searches the auction house for everything this list buys and sells, then puts the prices in the ladder." ..
        " It goes one item at a time, as the server allows: watch the line below. An item searched in the last" ..
        " two minutes is left alone."] = "Cerca nella casa d'aste tutto ciò che questa lista compra e vende," ..
        " poi mette i prezzi nella scala. Procede un oggetto alla volta, per quanto il server permette: guarda" ..
        " la riga qui sotto. Un oggetto cercato negli ultimi due minuti viene saltato.",
    ["Crafts"] = "Lavorazioni",
    ["A click on a step or a reagent searches it in Auctionator's Shopping tab."] = "Un clic su un passo o su" ..
        " un reagente lo cerca nella scheda Acquisti di Auctionator.",
    ["Craft Ladder"] = "Craft Ladder",
    ["%d %s for %s (%s each): click Confirm to buy."] = "%d %s per %s (%s l'uno): clicca su Compra.",
    ["No price for %s: not enough listed, or not sold that way (try the Buy tab)."] =
        "Nessun prezzo per %s: non ce ne sono abbastanza in vendita, o non si vende così (prova la scheda" ..
        " Acquisto).",
    ["Bought %d %s."] = "Comprati %d %s.",
    ["The purchase failed (the price may have changed): ask again."] = "L'acquisto è fallito (il prezzo può" ..
        " essere cambiato): richiedilo.",

    -- the camp view
    ["No profession"] = "Nessuna professione",
    [" (skill %d)"] = " (abilità %d)",
    ["you know it"] = "la conosci",
    ["you can learn it"] = "puoi impararla",
    ["not your profession"] = "non è la tua professione",
    ["%d in your bags"] = "%d nelle tue borse",
    ["needs %s"] = "richiede %s",
    ["make %s"] = "crea %s",
    ["no price"] = "nessun prezzo",
    ["AH %s"] = "CA %s",
    ["  (not with %s)"] = "  (non con %s)",
    ["Or, the same buff and more: %s"] = "Oppure lo stesso effetto e di più: %s",
    ["Camp: the buffs a campfire gives, for a level %d %s"] = "Accampamento: i bonus di un falò, per il" ..
        " livello %d, %s",
    ["Holds %d camp features. %s; %s."] = "Ospita %d strutture da campo. %s; %s.",
    ["A %s holds %d: the ones above. Then:"] = "Un %s ne ospita %d: quelle sopra. Poi:",
    ["Doesn't help a %s"] = "Non aiuta un %s",
    ["Camp features with no buff"] = "Strutture da campo senza bonus",
    ["Build a campfire, place camp features around it and sit or craft nearby for a while: each feature gives" ..
        " everyone there its buff. A campfire holds only so many: here they are in the order your role wants" ..
        " them."] = "Accendi un falò, disponi le strutture intorno e siediti o lavora lì vicino per un po':" ..
        " ogni struttura dà il suo bonus a tutti i presenti. Un falò ne ospita solo alcune: eccole nell'ordine" ..
        " che vuole il tuo ruolo.",
    ["Campfire:"] = "Falò:",

    -- the characters' buttons
    ["Level %d %s"] = "Livello %d %s",
    ["Playing now"] = "Sta giocando ora",
    ["Last seen %s"] = "Visto l'ultima volta %s",

    -- the menu
    ["Show the %s ladder."] = "Mostra la scala di %s.",
    ["not learned"] = "non imparata",
    ["Disenchant"] = "Disincanta",
    ["Camp"] = "Accampamento",
    ["What's worth disenchanting on your whole account: what every character's bags and bank hold, what the" ..
        " auction house lists for less than disenchanting it brings, and what your crafting professions make" ..
        " that's worth more disenchanted than sold."] = "Cosa conviene disincantare su tutto il tuo account:" ..
        " cosa tengono borse e banca di ogni personaggio, cosa la casa d'aste offre a meno di quanto rende" ..
        " disincantarlo, e cosa le tue professioni producono che vale di più disincantato che venduto.",
    ["What each camp feature gives around a campfire, in the order your role wants them, and how to get it."] =
        "Cosa dà ogni struttura da campo attorno a un falò, nell'ordine che vuole il tuo ruolo, e come" ..
        " ottenerla.",

    -- the minimap button
    ["Earns most"] = "Rende di più",
    ["%s, %s an hour"] = "%s, %s all'ora",
    ["Now"] = "Ora",
    ["%s in %s to %d"] = "%s in %s fino a %d",
    ["fish"] = "pescare",
    ["mine"] = "estrarre",
    ["catches"] = "pescate",
    ["nodes"] = "giacimenti",
    ["%s to %d"] = "%s fino a %d",
    ["~%d crafts, %s"] = "~%d lavorazioni, %s",
    ["Eat"] = "Mangia",
    ["%s, +%s a craft"] = "%s, +%s a lavorazione",
    ["reach level %d"] = "raggiungi il livello %d",
    ["learn %s"] = "impara %s",
    ["Up to %d"] = "Fino a %d",
    ["Prices"] = "Prezzi",
    ["Click: open or close the window"] = "Clic: apri o chiudi la finestra",
    ["Drag: move the button"] = "Trascina: sposta il pulsante",
    ["minimap button hidden - /craft minimap shows it again."] = "pulsante della minimappa nascosto - /craft" ..
        " minimap lo rimostra.",
    ["minimap button shown."] = "pulsante della minimappa visibile.",

    -- the Settings menu
    ["Auction house prices from"] = "Prezzi della casa d'aste da",
    ["Its last full scan of your faction's auction house: the lowest price, the median and how many are" ..
        " listed."] = "La sua ultima scansione completa della casa d'aste della tua fazione: il prezzo più" ..
        " basso, la mediana e quanti sono in vendita.",
    ["Its last scan. It gives one price per item, so the median is that price."] = "La sua ultima scansione." ..
        " Dà un solo prezzo per oggetto, quindi la mediana è quel prezzo.",
    ["An ingredient costs"] = "Un reagente costa",
    ["The median listed price"] = "Il prezzo mediano in vendita",
    ["Half of what's listed costs less. The cheapest listing is one auction, often gone minutes after the" ..
        " scan."] = "Metà di ciò che è in vendita costa meno. L'offerta più economica è una sola asta, spesso" ..
        " sparita pochi minuti dopo la scansione.",
    ["The cheapest listing"] = "L'offerta più economica",
    ["What the ladder cost before: the lowest price of the scan. Cheaper than what you will really pay, unless" ..
        " you are quick."] = "Come calcolava la scala prima: il prezzo più basso della scansione. Più basso di" ..
        " quanto pagherai davvero, a meno che tu non sia rapido.",
    ["Language"] = "Lingua",
    ["Craft Ladder's own words. Item, recipe and zone names come from your game client, in its language. A few" ..
        " buttons take a /reload to change."] = "Le parole di Craft Ladder. I nomi di oggetti, ricette e zone" ..
        " vengono dal tuo client di gioco, nella sua lingua. Alcuni pulsanti richiedono un /reload.",
    ["What you sell is always priced at the cheapest listing, the one you undercut."] =
        "Ciò che vendi è sempre contato all'offerta più economica, quella che ribassi.",
    ["%s isn't installed: %s is read."] = "%s non è installato: viene letto %s.",
    ["Neither addon is installed: no auction house prices."] = "Nessuno dei due addon è installato: nessun" ..
        " prezzo della casa d'aste.",

    -- the Specialization view
    ["%s%d / %d|r  %s"] = "%s%d / %d|r  %s",
    ["level %d (you're %d)"] = "livello %d (tu sei %d)",
    ["%s %d (you have %d)"] = "%s %d (tu hai %d)",
    ["Needs %s."] = "Richiede %s.",
    [" and "] = " e",
    ["Or take it here instead:"] = "Oppure prendilo qui:",
    ["Take the quest:"] = "Prendi la missione:",
    ["Take and hand in the quest:"] = "Prendi e consegna la missione:",
    ["Hand it in:"] = "Consegnala:",
    ["you have them all"] = "li hai tutti",
    ["auction house %s"] = "casa d'aste %s",
    ["none at the auction house"] = "nulla alla casa d'aste",
    ["Make %d; some of its ingredients have no price; %s"] = "Creane %d; alcuni reagenti non hanno prezzo; %s",
    ["Make %d for %s; %s"] = "Creane %d per %s; %s",
    ["Buy %d: %s%s"] = "Comprane %d: %s%s",
    [", making them costs %s"] = ", crearli costa %s",
    ["Drops from %s"] = "Lo lascia %s",
    ["Drops from %d kinds of creatures; "] = "Lo lasciano %d specie di creature;",
    ["none at the auction house now"] = "nulla alla casa d'aste adesso",
    [", learned at %d"] = ", imparata a %d",
    ["its recipe drops from %d kinds of creatures, none at the auction house now"] = "la sua ricetta la" ..
        " lasciano %d specie di creature, nulla alla casa d'aste adesso",
    ["no way to learn it for you now"] = "per te adesso non c'è modo di impararla",
    ["Buy the recipe:"] = "Compra la ricetta:",
    ["Learn it from the trainer:"] = "Imparala dal maestro:",
    ["Bring to %s:"] = "Porta a %s:",
    ["the quest giver"] = "a chi dà la missione",
    ["%s%d %s%s"] = "%s%d %s%s",
    ["smelt "] = "fondere",
    [" (besides the %d you have)"] = " (oltre ai %d che hai)",
    ["Make: %s"] = "Crea: %s",
    ["Ingredients:"] = "Reagenti:",
    ["buy %d: "] = "comprane %d:",
    ["the smith"] = "al fabbro",
    ["%d. Talk to %s"] = "%d. Parla con %s",
    ["Talk to:"] = "Parla con:",
    ["%d. Master a weapon: one of them"] = "%d. Padroneggia un'arma: una di queste",
    ["%s: the quest %s"] = "%s: la missione %s",
    ["The recipes"] = "Le ricette",
    ["  %d to learn"] = "  %d da imparare",
    ["Click to fold or open."] = "Clic per chiudere o aprire.",
    ["Show the steps to %s."] = "Mostra i passi verso %s.",
    ["You have this specialization."] = "Hai questa specializzazione.",
    ["Needs level %d and %s %d; you're level %d with %d."] = "Richiede il livello %d e %s %d; tu sei livello" ..
        " %d con %d.",
    ["Unlocks %d recipes only this specialization can learn."] = "Sblocca %d ricette che solo questa" ..
        " specializzazione può imparare.",
    ["You have %s: a character can have only one %s specialization."] = "Hai %s: un personaggio può avere una" ..
        " sola specializzazione in %s.",
    ["Still to spend: %s, each item made or bought, whichever costs less%s."] = "Ancora da spendere: %s, ogni" ..
        " oggetto creato o comprato, a seconda di cosa costa meno%s.",
    ["; some have no price"] = "; alcuni non hanno prezzo",
    ["You have %s"] = "Hai %s",
    ["To %s: about %s%s"] = "Fino a %s: circa %s%s",
    [", some items unpriced"] = ", alcuni oggetti senza prezzo",

    -- the window: the list, its rows and their tooltips
    [" - %s%s %d|r"] = " - %s%s %d|r",
    ["%d days"] = "%d giorni",
    ["%d hours"] = "%d ore",
    ["~%d min"] = "~%d min",
    ["All locks"] = "Tutte le serrature",
    ["Every lock a rogue picks, by the skill it needs, and its colour for you."] = "Ogni serratura che un" ..
        " ladro scassina, per l'abilità che richiede e il suo colore per te.",
    ["At %d your cap is the level x 5: %d at level %d."] = "A %d il tuo limite è il livello x 5: %d al livello" ..
        " %d.",
    ["at %d, cap %d"] = "a %d, limite %d",
    ["Skill"] = "Abilità",
    ["Smelt on the way"] = "Fondi lungo la strada",
    ["Trainer"] = "Maestro",
    ["Catches"] = "Pescate",
    ["Lure"] = "Esca",
    ["none"] = "nessuna",
    ["Cost"] = "Costo",
    ["In your bags"] = "Nelle tue borse",
    [", soulbound"] = ", legato",
    ["One craft"] = "Una lavorazione",
    ["Disenchanted"] = "Disincantato",
    ["Sold"] = "Venduto",
    [" at the auction house"] = " alla casa d'aste",
    [" at a vendor"] = " da un mercante",
    ["nobody buys it"] = "nessuno lo compra",
    ["Best"] = "Meglio",
    ["Disenchanting one craft"] = "Disincantare una lavorazione",
    ["Cheapest listing"] = "Offerta più economica",
    ["Gains"] = "Rende",
    [", more %d%% of the time"] = ", di più nel %d%% dei casi",
    ["Raises"] = "Aumenta",
    ["Cook one"] = "Cucinane uno",
    ["Buy one"] = "Comprane uno",
    ["Sells for"] = "Si vende a",
    ["Profit"] = "Profitto",
    ["Listed"] = "In vendita",
    ["%d - %d, ~%d %s"] = "%d - %d, ~%d %s",
    ["%s of ~%d, from what you have (vendor reagents aside)"] = "%s su ~%d, con ciò che hai (reagenti da" ..
        " mercante a parte)",
    ["%slvl %d|r - "] = "%sliv %d|r -",
    ["known, make %d now"] = "conosciuta, creane %d adesso",
    ["learn now (skill %d)"] = "impara adesso (abilità %d)",
    ["skill %d (you %d)"] = "abilità %d (tu %d)",
    ["level %d (you %d)"] = "livello %d (tu %d)",
    ["%s ready"] = "%s pronto",
    ["chests, boxes and doors by skill"] = "scrigni, scatole e porte per abilità",
    ["Reach level %d"] = "Raggiungi il livello %d",
    ["at %d, raises your cap to %d%s"] = "a %d, alza il tuo limite a %d%s",
    ["Fish in %s"] = "Pesca in %s",
    ["your pick"] = "la tua scelta",
    ["an hour: ~%d catches, %s each%s%s"] = "un'ora: ~%d pescate, %s l'una%s%s",
    ["%d - %d, ~%d catches%s"] = "%d - %d, ~%d pescate%s",
    ["%s%s, %s%s%s%s%s%s"] = "%s%s, %s%s%s%s%s%s",
    ["%s, %s, disenchanted ~%s, sold %s%s"] = "%s, %s, disincantato ~%s, venduto %s%s",
    ["%s's %s - %s: ~%s disenchanted, %s sold%s%s"] = "%s, %s - %s: ~%s disincantato, %s venduto%s%s",
    ["buy %s, ~%s disenchanted, pays %d%% of the time%s"] = "compra %s, ~%s disincantato, conviene nel %d%%" ..
        " dei casi%s",
    ["%d - %d%s: %s"] = "%d - %d%s: %s",
    ["keep them"] = "tienili",
    ["unconfirmed"] = "non confermato",
    ["after %d%s, %sneeded for %s|r"] = "dopo %d%s, %sserve per %s|r",
    ["%s%s, %smake one and keep it|r"] = "%s%s, %screane uno e tienilo|r",
    ["%d favor"] = "%d favore",
    ["? favor"] = "? favore",
    ["Open your %s window once so Craft Ladder knows which recipes you have."] = "Apri la finestra di %s una" ..
        " volta, così Craft Ladder sa quali ricette hai.",
    ["No %s found past %d with what Craft Ladder knows."] = "Nessun %s trovato oltre %d con ciò che Craft" ..
        " Ladder conosce.",
    ["zone"] = "zona",
    ["recipe"] = "ricetta",
    ["Back to your ladder"] = "Torna alla tua scala",
    ["Merchant's Favor recipes (%d)"] = "Ricette con Favore del Mercante (%d)",
    ["Dishes for this role, by what eating one raises. Click to fold or open."] = "Piatti per questo ruolo," ..
        " per ciò che mangiarne uno aumenta. Clic per chiudere o aprire.",
    ["Nothing here"] = "Qui non c'è nulla",
    ["Nothing earns this way at today's prices."] = "A prezzi di oggi qui non rende nulla.",
    ["Sell to a vendor"] = "Vendi a un mercante",
    ["These cost less to make than a vendor pays: vendors buy any number, no auction house needed. Click to" ..
        " fold or open."] = "Questi costano meno da creare di quanto paga un mercante: i mercanti comprano" ..
        " qualsiasi quantità, senza casa d'aste. Clic per chiudere o aprire.",
    ["Sell at the auction house"] = "Vendi alla casa d'aste",
    ["These earn more at the auction house: 5 or more listed (or however few when you searched it yourself)," ..
        " and it pays 1.5 times what a vendor does. How many sell, the auction house doesn't say."] =
        "Questi rendono di più alla casa d'aste: 5 o più in vendita (o quanti vuoi se li hai cercati tu), e" ..
        " paga 1,5 volte quanto dà un mercante. Quanti se ne vendano, la casa d'aste non lo dice.",
    ["nothing at today's prices"] = "nulla a prezzi di oggi",
    ["Disenchant, your whole account: %s"] = "Disincanta, tutto il tuo account: %s",
    ["your Enchanting %d is the best of yours"] = "il tuo Incantamento %d è il migliore che hai",
    ["%s has the most Enchanting, %d"] = "%s ha l'Incantamento più alto, %d",
    ["no character of yours has Enchanting yet"] = "nessuno dei tuoi personaggi ha ancora l'Incantamento",
    ["the ladder from %d to %d"] = "la scala da %d a %d",
    ["the ladder to %d"] = "la scala fino a %d",
    ["%s%s %d / %d, %s%s"] = "%s%s %d / %d, %s%s",
    ["as of %s"] = "al %s",
    ["%s has no %s yet"] = "%s non ha ancora %s",
    ["No %s yet"] = "Ancora nessun %s",
    ["Specialization"] = "Specializzazione",
    ["Skill %d"] = "Abilità %d",
    ["No auction house prices: AuctionDB or Auctionator needed"] = "Nessun prezzo della casa d'aste: serve" ..
        " AuctionDB o Auctionator",
    [" %s prices scanned %s, costs may be off: scan at the auction house|r"] = " Prezzi di %s scansionati %s," ..
        " i costi possono essere sbagliati: scansiona alla casa d'aste|r",
    ["%s prices scanned %s: scan at the auction house|r"] = "Prezzi di %s scansionati %s: scansiona alla casa" ..
        " d'aste|r",
    ["Prices: %s, scanned %s (%s)|r"] = "Prezzi: %s, scansionati %s (%s)|r",
    ["today"] = "oggi",
    ["yesterday"] = "ieri",
    ["%d days ago"] = "%d giorni fa",
    ["Prices: Auctionator, newest prices from %s|r"] = "Prezzi: Auctionator, prezzi più recenti del %s|r",
    ["Prices: %s"] = "Prezzi: %s",
    ["%d Merchant's Favor recipes, %d you can learn now%s"] = "%d ricette con Favore del Mercante, %d che puoi" ..
        " imparare adesso%s",
    ["; you have %d favor"] = "; hai %d di favore",
    ["%d dishes for your class; the cost is one dish from bought ingredients"] = "%d piatti per la tua classe;" ..
        " il costo è un piatto con reagenti comprati",
    ["%d zones at skill %d; the best about %s an hour"] = "%d zone ad abilità %d; la migliore circa %s all'ora",
    ["Spend %s, catch about %s worth (%s, %s an hour)"] = "Spendi %s, pesca circa %s di valore (%s, %s" ..
        " all'ora)",
    ["Spend %s, %s about %s worth (%s an hour), about %d %s"] = "Spendi %s, %s circa %s di valore (%s" ..
        " all'ora), circa %d %s",
    ["%s%d at the auction house; the best +%s a craft"] = "%s%d alla casa d'aste; il migliore +%s a" ..
        " lavorazione",
    ["Total %s, about %d %s%s"] = "Totale %s, circa %d %s%s",
    ["Total %s, about %d catches (%s)"] = "Totale %s, circa %d pescate (%s)",
    ["Spend %s, about %s back from sales, about %d crafts"] = "Spendi %s, circa %s di ritorno dalle vendite," ..
        " circa %d lavorazioni",
    ["Total %s, about %d crafts"] = "Totale %s, circa %d lavorazioni",
    ["Plan the ladder to %d."] = "Pianifica la scala fino a %d.",
    ["Window size"] = "Dimensioni della finestra",
    ["Drag: make the window bigger."] = "Trascina: ingrandisci la finestra.",
    ["Ctrl + mouse wheel: bigger or smaller text (now %d%%)."] = "Ctrl + rotella: testo più grande o più" ..
        " piccolo (ora %d%%).",
    ["Right-click: back to the normal size."] = "Clic destro: torna alla dimensione normale.",
    ["Close"] = "Chiudi",
    ["Escape closes it too."] = "Anche Esc la chiude.",
    ["Settings"] = "Impostazioni",
    ["Which auction house addon the prices are read from, and which of its listed prices an ingredient costs."] =
        "Da quale addon della casa d'aste vengono letti i prezzi, e quale dei suoi prezzi in vendita costa un" ..
        " reagente.",
    ["Your hands are idle, adventurer."] = "Le tue mani sono inoperose, avventuriero.",
    ["The trainers are waiting: learn a profession."] = "I maestri aspettano: impara una professione.",
    ["The steps to each of its specializations: the quests, what they ask for and what you have of it, the" ..
        " recipes, and what's still to make or buy."] = "I passi verso ognuna delle sue specializzazioni: le" ..
        " missioni, cosa chiedono e cosa ne hai, le ricette, e cosa resta da creare o comprare.",
    ["Merchant's Favor recipes"] = "Ricette con Favore del Mercante",
    ["What the supply camps' quartermaster sells for Merchant's Favor: its price and level (seen at a" ..
        " quartermaster), your skill, what you know and can make."] = "Cosa vende il quartiermastro degli" ..
        " accampamenti di rifornimento per il Favore del Mercante: prezzo e livello (visti da un" ..
        " quartiermastro), la tua abilità, cosa conosci e puoi creare.",
    ["Back to cheapest"] = "Torna alla più economica",
    ["Use the cheapest recipe for this step again."] = "Usa di nuovo la ricetta più economica per questo" ..
        " passo.",
    ["Search the auction house"] = "Cerca nella casa d'aste",
    ["Auctionator's Shopping tab with this item. The auction house must be open."] = "La scheda Acquisti di" ..
        " Auctionator con questo oggetto. La casa d'aste deve essere aperta.",
    ["Also use recipes bought with Merchant's Favor."] = "Usa anche le ricette comprate con il Favore del" ..
        " Mercante.",
    ["Reset"] = "Reimposta",
    ["The ladder from your skill to 300 again."] = "Di nuovo la scala dalla tua abilità fino a 300.",
    ["No profession yet"] = "Ancora nessuna professione",

    -- the menu's group headings
    ["PROFESSIONS"] = "PROFESSIONI",
    ["SECONDARY"] = "SECONDARIE",
    ["CLASS"] = "CLASSE",

    -- the modes over the list, and what each one plans (the names the tooltips use)
    ["Vendor sales"] = "Mercante",
    ["AH sales"] = "Asta",
    ["Food"] = "Cibo",
    ["Favor"] = "Favore",
    ["done"] = "fatto",
    ["in your quest log"] = "nel tuo diario delle missioni",

    -- one option's tooltip and its row
    ["Click: put a map pin and the arrow on it."] = "Clic: metti un segnalino sulla mappa e la freccia verso" ..
        " di esso.",
    ["%s that give points"] = "%s che danno punti",
    ["%s for this step"] = "%s per questo passo",
    ["A %s is worth"] = "Un %s vale",
    ["Gold an hour"] = "Oro all'ora",
    ["Click to %s here for this step."] = "Clic: %s qui per questo passo.",
    ["Fish that land"] = "Pesci che abboccano",
    ["all of them"] = "tutti",
    ["none needed"] = "nessuna necessaria",
    ["A catch is worth"] = "Una pescata vale",
    ["Lures for this step"] = "Esche per questo passo",
    ["Click to fish here for this step."] = "Clic: pesca qui per questo passo.",
    ["%s the %d you can make from what you have."] = "%s i %d che puoi fare con ciò che hai.",
    ["Ingredients"] = "Reagenti",
    ["Learn"] = "Impara",
    ["Recipe"] = "Ricetta",
    ["Selling them brings back"] = "Venderli restituisce",
    ["Per skill point"] = "Per punto abilità",
    ["Click to use this recipe for this step."] = "Clic: usa questa ricetta per questo passo.",
    ["~%d %s, %s a %s"] = "~%d %s, %s a %s",
    ["%s at the trainer"] = "%s dal maestro",
    ["no fish get away"] = "nessun pesce scappa",
    ["%d%% of casts land a fish"] = "il %d%% dei lanci porta un pesce",
    [", with %s"] = ", con %s",
    ["%s a catch%s"] = "%s a pescata%s",
    [", lures %s"] = ", esche %s",
    [" / catch"] = " / pescata",
    ["%s for lures"] = "%s per le esche",
    ["  with what you have"] = "  con ciò che hai",
    ["from your bags"] = "dalle tue borse",
    ["bought at the auction house"] = "comprato alla casa d'aste",
    ["learn: %s"] = "impara: %s",
    [" / point"] = " / punto",
    ["%s in all%s"] = "%s in tutto%s",
    [", %s back"] = ", %s di ritorno",
    [" / hour"] = " / ora",

    -- a folded list, the ingredients, the colours
    ["all %d %s"] = "tutti i %d %s",
    ["and %d more %s"] = "e altri %d %s",
    ["and %d more"] = "e altri %d",
    ["vendors"] = "mercanti",
    ["trainers"] = "maestri",
    [" (you have them)"] = " (li hai)",
    ["  (you have %d%s)"] = "  (ne hai %d%s)",
    [", in the bank"] = ", in banca",
    [", %d in the bank"] = ", %d in banca",
    ["smelt"] = "fondere",
    ["%s %d yourself from %s%s"] = "%s %d da solo con %s%s",
    [", buy the other %d"] = ", compra gli altri %d",
    ["you have enough"] = "ne hai abbastanza",
    ["only %d listed - you need %d"] = "solo %d in vendita - te ne servono %d",
    ["  your Cooking uses it"] = "  la tua Cucina lo usa",
    ["%d%% of catches%s"] = "%d%% delle pescate%s",
    [" each"] = " l'uno",
    ["  creatures level %d+|r"] = "  creature di livello %d+|r",
    ["at the auction house, after its cut"] = "alla casa d'aste, dopo la sua commissione",
    ["at a vendor"] = "da un mercante",
    ["what's inside, on average"] = "cosa c'è dentro, in media",
    ["orange"] = "arancione",
    ["yellow"] = "giallo",
    ["green"] = "verde",
    ["grey"] = "grigio",
    ["from %d"] = "da %d",
    ["Your pick."] = "La tua scelta.",

    -- the Craft bar
    ["An enchantment: enchant from the profession window, on the item."] = "Un incantamento: incanta dalla" ..
        " finestra della professione, sull'oggetto.",
    ["Learn the recipe first."] = "Impara prima la ricetta.",
    ["Not in combat."] = "Non in combattimento.",
    ["Not enough reagents in your bags."] = "Reagenti insufficienti nelle tue borse.",
    ["Craft"] = "Crea",
    ["Crafts as many as the box says; opens your profession window first if it's closed (the game crafts only" ..
        " with it open)."] = "Crea quanti ne dice il campo; apre prima la finestra della professione se è" ..
        " chiusa (il gioco crea solo con la finestra aperta).",
    [" Cooking needs a fire nearby."] = " La Cucina richiede un fuoco vicino.",
    ["Your bags allow %d"] = "Le tue borse bastano per %d",
    ["; the step needs %d."] = "; il passo ne richiede %d.",
    ["Opening your %s window: crafting once it's ready."] = "Apro la tua finestra di %s: creo appena è pronta.",

    -- how to learn a recipe
    ["Learn it"] = "Come impararla",
    ["Buy the recipe from %s:"] = "Compra la ricetta da %s:",
    ["one of these vendors"] = "uno di questi mercanti",
    ["this vendor"] = "questo mercante",
    ["%s Favor"] = "Favore %s",
    ["Merchant's"] = "del Mercante",
    ["Quest reward: %s%s"] = "Ricompensa di missione: %s%s",
    ["(needs level %d)"] = "(richiede il livello %d)",
    ["quest giver"] = "dà la missione",
    ["Only these trainers teach it, for %s:"] = "Solo questi maestri la insegnano, per %s:",
    ["trainer"] = "maestro",
    ["None of them is of your faction."] = "Nessuno di loro è della tua fazione.",
    ["Or buy it at the auction house: %s."] = "Oppure comprala alla casa d'aste: %s.",
    ["Or %s."] = "Oppure %s.",
    ["During %s: %s."] = "Durante %s: %s.",
    ["The price is an estimate: Craft Ladder learns the real one when you visit the %s."] =
        "Il prezzo è una stima: Craft Ladder saprà quello vero quando ci passerai (%s).",
    ["vendor"] = "mercante",

    -- what it sells for, and one craft
    ["An enchantment: nothing to sell."] = "Un incantamento: nulla da vendere.",
    ["%s%s at the auction house (after its cut%s)."] = "%s%s alla casa d'aste (dopo la sua commissione%s).",
    ["Not on the auction house."] = "Non alla casa d'aste.",
    ["%s%s at a vendor."] = "%s%s da un mercante.",
    ["Vendors don't buy it."] = "I mercanti non lo comprano.",
    ["One craft%s: %s"] = "Una lavorazione%s: %s",
    ["One craft: %s"] = "Una lavorazione: %s",
    [" (makes %d)"] = " (ne fa %d)",
    ["auction house"] = "casa d'aste",
    ["%s yourself%s"] = "%s da solo%s",
    [" and %s"] = " e %s",
    ["%s each, %s"] = "%s l'uno, %s",
    ["Each sells for "] = "Ognuno si vende a",
    ["Sells for "] = "Si vende a",
    ["%d sell for "] = "%d si vendono a",

    -- a Merchant's Favor recipe
    ["You know it."] = "La conosci.",
    ["You can learn it now."] = "Puoi impararla adesso.",
    ["It needs %d %s (you: %d)."] = "Richiede %d %s (tu: %d).",
    ["It needs level %d (you: %d)."] = "Richiede il livello %d (tu: %d).",
    ["Merchant's Favor"] = "Favore del Mercante",
    ["Costs %d Merchant's Favor%s."] = "Costa %d di Favore del Mercante%s.",
    [" (you have %d)"] = " (ne hai %d)",
    ["Its price: open a quartermaster once and Craft Ladder remembers it."] = "Il suo prezzo: passa una volta" ..
        " da un quartiermastro e Craft Ladder se lo ricorda.",
    ["From level %d (you: %d)."] = "Dal livello %d (tu: %d).",
    ["Its level: open a quartermaster once and Craft Ladder remembers it."] = "Il suo livello: passa una volta" ..
        " da un quartiermastro e Craft Ladder se lo ricorda.",
    ["From %d %s (you: %d)."] = "Da %d %s (tu: %d).",
    ["%s is %s from level %d (you: %d)."] = "%s %s dal livello %d (tu: %d).",
    ["worn"] = "si indossa",
    ["used"] = "si usa",
    ["Quartermaster"] = "Quartiermastro",
    ["The plan needs %s with %s."] = "Il piano richiede %s con %s.",
    ["Only for %s."] = "Solo per %s.",
    ["Hated"] = "Odio",
    ["Hostile"] = "Ostile",
    ["Unfriendly"] = "Scortese",
    ["Neutral"] = "Neutrale",
    ["Friendly"] = "Amichevole",
    ["Honored"] = "Onorato",
    ["Revered"] = "Riverito",
    ["Exalted"] = "Esaltato",

    -- a crafting step
    ["Skill %d - %d, about %d crafts, %s%s"] = "Abilità %d - %d, circa %d lavorazioni, %s%s",
    ["some prices missing"] = "mancano alcuni prezzi",
    ["%s %s what you already have: %d crafts%s."] = "%s %s con ciò che hai già: %d lavorazioni%s.",
    [", plus a few vendor ingredients"] = ", più qualche reagente da mercante",
    [", nothing to buy"] = ", nulla da comprare",
    ["You can %s %d now with what you have."] = "%s: adesso %d con ciò che hai.",
    ["You have the reagents for %d."] = "Hai i reagenti per %d.",
    ["You have the main ingredients for %d; the rest is sold by vendors."] = "Hai i reagenti principali per" ..
        " %d; il resto lo vendono i mercanti.",
    ["The cheapest here is %s."] = "Il più economico qui è %s.",
    ["Needed for %s: %d recipes (%s, ...), and no vendor sells it. None of them is for leveling (a cooldown," ..
        " or learned at 300): make it once you're done."] = "Serve per %s: %d ricette (%s, ...), e nessun" ..
        " mercante lo vende. Nessuna di esse serve a salire (ha un tempo di recupero, o si impara a 300):" ..
        " crealo quando hai finito.",
    ["A tool: %d %s recipes need it, and no vendor sells it. Make one and keep it in your bags%s."] =
        "Uno strumento: %d ricette di %s lo richiedono, e nessun mercante lo vende. Creane uno e tienilo nelle" ..
        " borse%s.",
    [" (it gives no skill point any more)"] = " (non dà più punti abilità)",
    ["You have %s: the step takes them from your bags, so it pays less than that."] =
        "Hai %s: il passo li prende dalle tue borse, quindi paga meno di così.",
    ["Keep for later"] = "Tieni per dopo",
    ["Keep %d %s: the steps at %d - %d use them."] = "Tieni %d %s: i passi a %d - %d li usano.",
    ["Batch: %s"] = "Lotto: %s",
    ["Craft counts are estimates: skill-ups are luck once a recipe is yellow."] = "Il numero di lavorazioni è" ..
        " una stima: i punti abilità sono fortuna appena una ricetta è gialla.",
    ["Sell the rest"] = "Vendi il resto",
    ["Sell what you make"] = "Vendi ciò che crei",
    ["%d at the auction house, about %s each after its cut."] = "%d alla casa d'aste, circa %s l'uno dopo la" ..
        " sua commissione.",
    ["%d to a vendor, %s each."] = "%d a un mercante, %s l'uno.",
    ["About %s back, so this step %s %s."] = "Circa %s di ritorno, quindi questo passo %s %s.",
    ["earns"] = "rende",
    ["costs"] = "costa",
    ["Vendor sales counts only what vendors pay: that money is sure. AH sales counts the auction house too."] =
        "Vendite a mercante conta solo ciò che pagano i mercanti: quei soldi sono sicuri. Vendite alla CA" ..
        " conta anche la casa d'aste.",
    ["The auction house counts only when it pays 1.5 times a vendor and 5 or more are listed, and for at most" ..
        " a quarter of what's listed."] = "La casa d'aste conta solo quando paga 1,5 volte un mercante e ce ne" ..
        " sono 5 o più in vendita, e al massimo per un quarto di quanto è in vendita.",
    ["Or %s, from %d"] = "Oppure %s, da %d",
    ["Recipes you could use from %d"] = "Ricette che potresti usare da %d",
    ["No other recipe is open to you here."] = "Qui non hai altre ricette aperte.",

    -- Gold: one recipe's profit
    ["One craft%s costs about %s and sells for about %s: %s+%s|r"] = "Una lavorazione%s costa circa %s e si" ..
        " vende a circa %s: %s+%s|r",
    ["Sold to a vendor: vendors buy any number."] = "Venduto a un mercante: i mercanti comprano qualsiasi" ..
        " quantità.",
    ["%d listed at the auction house now: sell a few at a time."] = "%d in vendita alla casa d'aste adesso:" ..
        " vendine pochi alla volta.",
    ["Making it needs %s %d, and yours is %d%s. It's here to level towards."] = "Per crearlo serve %s %d, e il" ..
        " tuo è %d%s. È qui come obiettivo.",
    ["; the rank that lifts your cap to it asks level %d, and you're %d"] = "; il grado che alza il tuo limite" ..
        " fin lì richiede il livello %d, e tu sei %d",
    ["Learning it pays back after %d %s."] = "Impararla si ripaga dopo %d %s.",
    ["craft"] = "lavorazione",
    ["crafts"] = "lavorazioni",
    ["Once in %s: the recipe has a cooldown."] = "Una volta ogni %s: la ricetta ha un tempo di recupero.",
    ["You have %s: counted at their price too, since you could sell them."] = "Hai %s: contati anche al loro" ..
        " prezzo, visto che potresti venderli.",
    ["Profit: what a vendor pays, less the ingredients at today's prices. How many you can make, the auction" ..
        " house's ingredients decide."] = "Profitto: quanto paga un mercante, meno i reagenti a prezzi di" ..
        " oggi. Quanti puoi farne lo decidono i reagenti della casa d'aste.",
    ["Profit: at the lowest listing after the auction house's cut, with 5 or more listed, or however few when" ..
        " you searched it yourself; it counts only when it pays 1.5 times what a vendor does. How many sell," ..
        " the auction house doesn't say. Prices change: look again before buying."] =
        "Profitto: all'offerta più economica dopo la commissione della casa d'aste, con 5 o più in vendita, o" ..
        " quanti vuoi se li hai cercati tu; conta solo quando paga 1,5 volte quanto dà un mercante. Quanti se" ..
        " ne vendano, la casa d'aste non lo dice. I prezzi cambiano: guarda di nuovo prima di comprare.",

    -- Disenchant
    ["Disenchant one: about %s"] = "Disincantane uno: circa %s",
    ["%d%% of disenchants, %s each"] = "%d%% dei disincantamenti, %s l'uno",
    ["%s%d disenchanted: about %s, at least %s 9 times out of 10."] = "%s%d disincantati: circa %s, almeno %s" ..
        " 9 volte su 10.",
    ["Your "] = "I tuoi",
    ["What it gives: from your %d disenchants of this item, recorded in game: it breaks unlike items of its" ..
        " kind."] = "Cosa dà: dai tuoi %d disincantamenti di questo oggetto, registrati in gioco: si scompone" ..
        " diversamente dagli oggetti del suo tipo.",
    ["What it gives: from %d disenchants of items like it, recorded in game."] = "Cosa dà: da %d" ..
        " disincantamenti di oggetti simili, registrati in gioco.",
    ["You've disenchanted %d like it: %s in all. From %d, what you got replaces the table."] =
        "Ne hai disincantati %d simili: %s in tutto. Da %d, ciò che hai ottenuto sostituisce la tabella.",
    ["Forever added this kind of item: what it gives is a guess, checked for one item: a green's of its level," ..
        " one more of each."] = "Forever ha aggiunto questo tipo di oggetto: ciò che dà è un'ipotesi," ..
        " verificata su un oggetto: come un verde del suo livello, uno in più di ciascuno.",
    ["What a disenchant gives is luck%s. Materials at the auction house after its cut; 3 lesser essences make" ..
        " a greater one."] = "Ciò che dà un disincantamento è fortuna%s. Materiali alla casa d'aste dopo la" ..
        " sua commissione; 3 essenze minori fanno una maggiore.",
    [", from Classic's table (not checked in Forever yet): from %d of your disenchants of items like it, what" ..
        " you got replaces it"] = ", dalla tabella di Classic (non ancora verificata in Forever): da %d dei" ..
        " tuoi disincantamenti di oggetti simili, ciò che hai ottenuto la sostituisce",
    ["One craft%s costs about %s; disenchanted, about %s on average: %s"] = "Una lavorazione%s costa circa %s;" ..
        " disincantata, circa %s in media: %s",
    ["Disenchanting it needs Enchanting %d; the best of yours is %d."] = "Disincantarla richiede Incantamento" ..
        " %d; il migliore che hai è %d.",
    ["A %s recipe %s knows."] = "Una ricetta di %s che %s conosce.",
    ["you"] = "tu",
    ["Making it costs more than disenchanting brings: disenchant it when you make it anyway, for skill."] =
        "Crearla costa più di quanto rende disincantarla: disincantala quando la fai comunque, per l'abilità.",
    ["Best: %s. %d in %s's %s: disenchanted, about %s on average; sold, %s."] = "Meglio: %s. %d da %s, %s:" ..
        " disincantato, circa %s in media; venduto, %s.",
    ["your"] = "tue",
    ["bags"] = "borse",
    ["Soulbound: no auction house."] = "Legato: niente casa d'aste.",
    ["%s has the most Enchanting of yours, %d: mail it there."] = "%s ha l'Incantamento più alto dei tuoi, %d:" ..
        " spediscilo lì per posta.",
    ["Or sell it"] = "Oppure vendilo",
    ["Soulbound: the auction house won't take it."] = "Legato: la casa d'aste non lo accetta.",
    ["%s each at the auction house (after its cut%s)."] = "%s l'uno alla casa d'aste (dopo la sua" ..
        " commissione%s).",
    ["%s each at a vendor."] = "%s l'uno da un mercante.",
    ["The auction house counts with 5 or more listed, or however few when you searched it yourself. What made" ..
        " it doesn't count: it's made."] = "La casa d'aste conta con 5 o più in vendita, o quanti vuoi se li" ..
        " hai cercati tu. Di cosa è fatto non conta: è fatto.",
    ["Buy one for %s; disenchanted, about %s on average: %s"] = "Comprane uno per %s; disincantato, circa %s" ..
        " in media: %s",
    ["Disenchanting it needs Enchanting %d; the best of yours is %d: no character of yours can.|r"] =
        "Disincantarlo richiede Incantamento %d; il migliore che hai è %d: nessuno dei tuoi personaggi può.|r",
    ["One disenchant brings more than it cost %d%% of the time."] = "Un disincantamento rende più di quanto è" ..
        " costato nel %d%% dei casi.",
    ["Buy it"] = "Compralo",
    ["The cheapest listing: %s. %s."] = "L'offerta più economica: %s. %s.",
    ["Its level and quality are Classic's: Forever's client doesn't list it. "] = "Livello e qualità sono" ..
        " quelli di Classic: il client di Forever non li fornisce.",
    ["A random suffix (\"of the Monkey\") doesn't change what it breaks into. The listing may have sold since" ..
        " the scan."] = "Un suffisso casuale (\"della scimmia\") non cambia in cosa si scompone. L'offerta" ..
        " potrebbe essere stata venduta dopo la scansione.",
    ["Nothing to disenchant"] = "Nulla da disincantare",
    ["No character of yours holds anything to disenchant, and "] = "Nessuno dei tuoi personaggi ha qualcosa da" ..
        " disincantare, e",
    ["none of the recipes they know makes something to disenchant: open a crafting profession's window once so" ..
        " Craft Ladder knows its recipes."] = "nessuna delle ricette che conoscono crea qualcosa da" ..
        " disincantare: apri una volta la finestra di una professione di creazione, così Craft Ladder ne" ..
        " conosce le ricette.",
    ["nothing they can make is worth more disenchanted than sold at today's prices."] =
        "nulla di ciò che possono creare vale di più disincantato che venduto a prezzi di oggi.",

    -- Cooking's Food
    [" (Well Fed). "] = " (Ben Nutrito).",
    ["Needs level %d; you're %d."] = "Richiede il livello %d; tu sei %d.",
    ["Level %d: you can eat it."] = "Livello %d: puoi mangiarlo.",
    ["Any level can eat it."] = "Qualsiasi livello può mangiarlo.",
    ["Nobody sells its recipe now: look for it at the auction house."] = "Adesso nessuno vende la sua ricetta:" ..
        " cercala alla casa d'aste.",
    ["No way to learn it for you now (a holiday's, or the other side's)."] = "Per te adesso non c'è modo di" ..
        " impararla (è di una festività, o dell'altra fazione).",
    ["Learned at %s %d; you have %d."] = "Si impara con %s %d; tu hai %d.",
    ["You have %s: cooking it takes them from your bags, so it costs you less than that."] =
        "Hai %s: cucinarlo li prende dalle tue borse, quindi ti costa meno di così.",
    ["Or buy it"] = "Oppure compralo",
    ["One at the auction house: %s."] = "Uno alla casa d'aste: %s.",
    ["None listed at the auction house now."] = "Adesso nessuno in vendita alla casa d'aste.",
    ["What it raises is read from the game's files, not checked in game yet."] = "Ciò che aumenta è letto dai" ..
        " file del gioco, non ancora verificato in gioco.",

    -- a rank step
    ["At skill %d. Your cap is your level x 5: %d at level %d."] = "Ad abilità %d. Il tuo limite è il tuo" ..
        " livello x 5: %d al livello %d.",
    ["You're level %d."] = "Sei livello %d.",
    ["Your level allows it already."] = "Il tuo livello lo permette già.",
    ["Lockpicking can't go past your level x 5: level up before you go on."] = "Scassinare non può superare il" ..
        " tuo livello x 5: sali di livello prima di proseguire.",
    ["Learn %s%s"] = "Impara %s%s",
    ["At skill %d, raises your cap to %d. %s"] = "Ad abilità %d, alza il tuo limite a %d. %s",
    ["Needs character level %d."] = "Richiede il livello personaggio %d.",
    ["How"] = "Come",
    ["Only these trainers teach it%s:"] = "Solo questi maestri la insegnano%s:",
    [", for %s"] = ", per %s",
    ["Any %s trainer teaches it%s."] = "Qualsiasi maestro (%s) la insegna%s.",
    [" for %s"] = " per %s",
    ["Buy the %s and read it:"] = "Compra %s e leggilo:",
    ["At the auction house: %s."] = "Alla casa d'aste: %s.",
    ["Or buy it at the auction house: %s.%s"] = "Oppure compralo alla casa d'aste: %s.%s",
    [" Cheaper than the vendor, so the ladder counts this one."] = " Più economico che dal mercante, quindi la" ..
        " scala conta questo.",
    ["1. Take the quest %s:"] = "1. Prendi la missione %s:",
    ["start"] = "inizio",
    ["2. Bring the ingredients below to %s for %s:"] = "2. Porta i reagenti qui sotto a %s per %s:",
    ["hand in"] = "consegna",
    ["Do the quest %s for %s:"] = "Fai la missione %s da %s:",
    ["What to bring"] = "Cosa portare",
    ["Any %s trainer teaches Apprentice %s."] = "Qualsiasi maestro (%s) insegna Apprendista (%s).",

    -- fishing
    ["Fish to catch"] = "Che pesci pescare",
    ["%s: %s, %s (fish bite from %d)"] = "%s: %s, %s (abboccano da %d)",
    ["seen by GatherMate2"] = "visto da GatherMate2",
    ["place known"] = "posto conosciuto",
    ["places known"] = "posti conosciuti",
    [" a catch"] = " a pescata",
    ["%d - %d catches before it's gone"] = "%d - %d pescate prima che sparisca",
    ["No fish get away here."] = "Qui nessun pesce scappa.",
    ["About %d%% of casts land a fish here."] = "Qui circa il %d%% dei lanci porta un pesce.",
    ["An hour at skill %d: about %d catches, %s each"] = "Un'ora ad abilità %d: circa %d pescate, %s l'una",
    [" An hour's catches are worth about %s%s."] = " Le pescate di un'ora valgono circa %s%s.",
    [", lures paid"] = ", esche pagate",
    ["Skill %d - %d, about %d catches (%s), %s"] = "Abilità %d - %d, circa %d pescate (%s), %s",
    [" Catches worth about %s (%s an hour)."] = " Pescate per circa %s (%s all'ora).",
    ["Craft Ladder's choice here is %s."] = "La scelta di Craft Ladder qui è %s.",
    ["Its creatures are level %d - %d."] = "Le sue creature sono di livello %d - %d.",
    ["Bring"] = "Porta con te",
    ["Put %s on your pole: +%d fishing for %d minutes, so no fish get away."] = "Metti %s sulla canna: +%d a" ..
        " pesca per %d minuti, così nessun pesce scappa.",
    ["Fishing supplies vendors sell lures, in every capital."] = "Le esche le vendono i mercanti di articoli" ..
        " da pesca, in ogni capitale.",
    ["No lure needed: your skill keeps the fish from getting away."] = "Nessuna esca necessaria: la tua" ..
        " abilità basta a non far scappare i pesci.",
    ["What you catch here"] = "Cosa peschi qui",
    ["Fishing pools here"] = "Banchi di pesci qui",
    ["Fish pools when you see them: Craft Ladder counts a third of your catches here from pools. That makes a" ..
        " catch worth %s on average (%s in open water)."] = "Pesca nei banchi quando li vedi: Craft Ladder" ..
        " conta qui un terzo delle tue pescate dai banchi. Così una pescata vale in media %s (%s in acqua" ..
        " aperta).",
    ["No fishing pools known here yet. GatherMate2 adds the ones you fish, and Craft Ladder counts them."] =
        "Qui non si conoscono ancora banchi di pesci. GatherMate2 aggiunge quelli in cui peschi, e Craft" ..
        " Ladder li conta.",
    ["Catches per point: from your %d catches, skill-ups come %d%% as often as Classic's rule says."] =
        "Pescate per punto: dalle tue %d pescate, i punti abilità arrivano al %d%% di quanto dice la regola di" ..
        " Classic.",
    ["Catches per point follow Classic's rule (at 150, one point in about 4 catches) until Craft Ladder has" ..
        " counted 50 of your catches (%d so far)."] = "Le pescate per punto seguono la regola di Classic (a" ..
        " 150, un punto ogni 4 pescate circa) finché Craft Ladder non ha contato 50 delle tue pescate (%d" ..
        " finora).",
    ["Zones and their fish come from Classic's world: Forever may differ."] = "Le zone e i loro pesci vengono" ..
        " dal mondo di Classic: in Forever può essere diverso.",
    ["Other zones from %d"] = "Altre zone da %d",
    ["No other zone is open to you here."] = "Qui non hai altre zone aperte.",

    -- skinning and mining
    ["about %d in the zone, %s %s each%s"] = "circa %d nella zona, %s %s l'uno%s",
    [", worth %s"] = ", vale %s",
    ["needs %d"] = "richiede %d",
    ["%s  %slevel %d%s|r"] = "%s  %slivello %d%s|r",
    [", seen skinned"] = ", già scuoiata",
    ["about %d in the zone, needs %d%s"] = "circa %d nella zona, richiede %d%s",
    [", %s a skin"] = ", %s a pelle",
    ["Skin in %s"] = "Scuoia in %s",
    ["An hour at skill %d: about %d creatures, %s each"] = "Un'ora ad abilità %d: circa %d creature, %s l'una",
    ["An hour's skins are worth about %s. Every creature you can skin counts, grey ones too."] =
        "Le pelli di un'ora valgono circa %s. Conta ogni creatura che puoi scuoiare, anche quelle grigie.",
    ["Skill %d - %d, about %d creatures%s"] = "Abilità %d - %d, circa %d creature%s",
    [", trainer %s"] = ", maestro %s",
    ["Worth about %s skinned (%s an hour)."] = "Vale circa %s scuoiato (%s all'ora).",
    ["Skin every creature that still gives a point, of your level or below."] = "Scuoia ogni creatura che dà" ..
        " ancora un punto, del tuo livello o sotto.",
    ["Its creatures are well above your level."] = "Le sue creature sono molto sopra il tuo livello.",
    ["Creatures to skin here"] = "Creature da scuoiare qui",
    ["Which creatures can be skinned and what one gives come from Classic; where they are and their levels" ..
        " from QuestieDB's Forever data. The skill one needs is Classic's rule from its level (level x 5 past" ..
        " 20), the colours Mining's (yellow 25, green 50, grey 100 above it). A creature new in Forever counts" ..
        " once you've skinned one."] = "Quali creature si possono scuoiare e cosa dà una vengono da Classic;" ..
        " dove sono e il loro livello dai dati Forever di QuestieDB. L'abilità richiesta è la regola di" ..
        " Classic dal loro livello (livello x 5 oltre il 20), i colori quelli dell'Estrazione (giallo 25," ..
        " verde 50, grigio 100 sopra). Una creatura nuova in Forever conta appena ne hai scuoiata una.",
    ["Gold an hour assumes %d s a creature (kill, loot, skin) and a 60%% mount between them: about %d an hour" ..
        " here."] = "L'oro all'ora conta %d s per creatura (uccidere, saccheggiare, scuoiare) e una" ..
        " cavalcatura al 60%% tra una e l'altra: circa %d all'ora qui.",
    ["Other zones, from %d"] = "Altre zone, da %d",
    ["%s in %s"] = "%s in %s",
    ["An hour at skill %d: about %d %s, %s each"] = "Un'ora ad abilità %d: circa %d %s, %s l'uno",
    ["An hour's worth about %s. Every %s you can reach counts, grey ones too. Creatures level %d - %d."] =
        "Un'ora vale circa %s. Conta ogni %s che riesci a raggiungere, anche quelli grigi. Creature di livello" ..
        " %d - %d.",
    ["Skill %d - %d, about %d %s%s"] = "Abilità %d - %d, circa %d %s%s",
    ["Worth about %s (%s an hour). Creatures level %d - %d."] = "Vale circa %s (%s all'ora). Creature di" ..
        " livello %d - %d.",
    ["Creatures level %d - %d. %s every %s that still gives a point."] = "Creature di livello %d - %d. %s ogni" ..
        " %s che dà ancora un punto.",
    ["%s places come from GatherMate2's Forever data; what one gives and how often a rarer kind takes a place," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what one" ..
        " needs): Forever may differ."] = "I posti (%s) vengono dai dati Forever di GatherMate2; cosa ne dà" ..
        " uno e ogni quanto una specie più rara occupa un posto, da Classic. I punti abilità seguono i colori" ..
        " di Classic (giallo 25, verde 50, grigio 100 sopra il necessario): in Forever può essere diverso.",
    ["Gold an hour assumes 15 s a %s, a third of the zone's places with one up and a 60%% mount: about %d an" ..
        " hour here."] = "L'oro all'ora conta 15 s per %s, un terzo dei posti della zona occupati e una" ..
        " cavalcatura al 60%%: circa %d all'ora qui.",
    ["%s: about %d bars%s"] = "%s: circa %d lingotti%s",
    [", learn it from a Mining trainer for %s"] = ", imparalo da un maestro di Estrazione per %s",
    ["Nothing you mine here still gives points when smelted."] = "Nulla di ciò che estrai qui dà ancora punti" ..
        " una volta fuso.",
    ["Sell ore or bars"] = "Vendi minerale o lingotti",
    ["%s: %s each. Smelting it needs more skill."] = "%s: %s l'uno. Fonderlo richiede più abilità.",
    ["sell the ore, smelt it only for the skill-ups"] = "vendi il minerale, fondilo solo per i punti abilità",
    ["smelt it and sell the bars"] = "fondilo e vendi i lingotti",
    [", %s as %s"] = ", %s come %s",
    ["make %s and sell it"] = "crea %s e vendilo",
    ["%s: %s as ore, %s as %s%s - %s."] = "%s: %s come minerale, %s come %s%s - %s.",
    ["%s: %s make %d %s, so per ore it's worth one of them; it takes both ores, as much as the scarcer one" ..
        " allows."] = "%s: %s fanno %d %s, quindi per minerale vale quanto uno di essi; servono entrambi i" ..
        " minerali, quanto permette il più scarso.",
    ["Nothing mined here can be smelted."] = "Nulla di ciò che si estrae qui si può fondere.",
    ["Per ore, after the auction house's cut (only what's listed at least 5 times), or what a vendor pays."] =
        "Per minerale, dopo la commissione della casa d'aste (solo ciò che è in vendita almeno 5 volte), o" ..
        " quanto paga un mercante.",
    ["Smelting gives skill-ups too: Craft Ladder counts the ore you mine as smelted, so you mine fewer nodes."] =
        "Anche fondere dà punti abilità: Craft Ladder conta il minerale che estrai come fuso, quindi estrai da" ..
        " meno giacimenti.",
    ["Node places come from GatherMate2's Forever data; how often rare veins appear and the ore a node gives," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what a node" ..
        " needs): Forever may differ."] = "I posti dei giacimenti vengono dai dati Forever di GatherMate2;" ..
        " ogni quanto compaiono vene rare e quanto minerale dà un giacimento, da Classic. I punti abilità" ..
        " seguono i colori di Classic (giallo 25, verde 50, grigio 100 sopra ciò che un giacimento richiede):" ..
        " in Forever può essere diverso.",
    ["Gold an hour assumes 15 s a node, a third of the zone's node places with a node up and a 60%% mount:" ..
        " about %d nodes an hour here."] = "L'oro all'ora conta 15 s per giacimento, un terzo dei posti della" ..
        " zona occupati e una cavalcatura al 60%%: circa %d giacimenti all'ora qui.",
    ["Other zones, or smelting, from %d"] = "Altre zone, o la fusione, da %d",

    -- Lockpicking
    ["%d a run, needs %d"] = "%d a giro, richiede %d",
    ["about %d in the zone, needs %d"] = "circa %d nella zona, richiede %d",
    ["Humanoids drop it; the auction house sells it."] = "La lasciano gli umanoidi; la casa d'aste la vende.",
    ["Fished up from pools."] = "Pescata dai banchi.",
    ["Engineers make it."] = "La creano gli ingegneri.",
    ["Pick Pocket humanoids of level %d - %d."] = "Borseggia umanoidi di livello %d - %d.",
    ["Pick Pocket humanoids."] = "Borseggia umanoidi.",
    ["Pick locks in %s"] = "Scassina serrature in %s",
    ["Skill %d - %d, about %d locks"] = "Abilità %d - %d, circa %d serrature",
    ["Creatures level %d - %d. Pick every lock that still gives a point: a chest gives one chance, and one" ..
        " more once it's back."] = "Creature di livello %d - %d. Scassina ogni serratura che dà ancora un" ..
        " punto: uno scrigno dà una possibilità, e un'altra quando ricompare.",
    ["The door round"] = "Il giro delle porte",
    ["1. Go into Blackrock Depths (Blackrock Mountain, between Searing Gorge and Burning Steppes)."] =
        "1. Entra nelle Profondità Roccianera (Picco Roccianera, tra la Gola Infuocata e le Steppe Ardenti).",
    ["2. Pick the locked doors on the way: the first on the left, through it the next on the right, then the" ..
        " first on the left again; the Shadowforge Lock under the big gear too, if nothing would pull."] =
        "2. Scassina le porte chiuse lungo il percorso: la prima a sinistra, dietro di essa la successiva a" ..
        " destra, poi di nuovo la prima a sinistra; anche la Serratura di Forgiatenebra sotto il grande" ..
        " ingranaggio, se non attira nessuno.",
    ["3. Leave, right-click your portrait, Reset all instances and go in again: the game lets you in 5 times" ..
        " an hour."] = "3. Esci, clic destro sul tuo ritratto, Reimposta tutte le istanze e rientra: il gioco" ..
        " ti fa entrare 5 volte all'ora.",
    ["The round is zockify's Forever guide's: about 4 doors a run."] = "Il giro viene dalla guida Forever di" ..
        " zockify: circa 4 porte a giro.",
    ["Where"] = "Dove",
    ["Most %ss are around here"] = "La maggior parte (%s) sono da queste parti",
    ["Chest places: GatherMate2's and QuestieDB's Forever data. Which lock a chest needs, and the colours" ..
        " (yellow 25, green 50, grey 100 above it), are Classic's: Forever may differ."] =
        "Posti degli scrigni: dati Forever di GatherMate2 e QuestieDB. Quale serratura richiede uno scrigno, e" ..
        " i colori (giallo 25, verde 50, grigio 100 sopra), sono di Classic: in Forever può essere diverso.",
    ["Other zones, or boxes, from %d"] = "Altre zone, o scatole, da %d",
    ["Pick %s"] = "Scassina %s",
    ["Skill %d - %d, about %d boxes, %s"] = "Abilità %d - %d, circa %d scatole, %s",
    ["Pick the ones in your bags: you have %d."] = "Scassina quelle nelle tue borse: ne hai %d.",
    ["Boxes to buy: %s"] = "Scatole da comprare: %s",
    ["A box gives one chance at a point, and what's inside is yours."] = "Una scatola dà una possibilità di" ..
        " punto, e ciò che c'è dentro è tuo.",
    ["Or pick locks in a zone, from %d"] = "Oppure scassina serrature in una zona, da %d",
    ["Every lock a rogue picks, by the skill it needs; its colour at your %d."] = "Ogni serratura che un ladro" ..
        " scassina, per l'abilità che richiede; il suo colore con i tuoi %d.",
    ["Orange always gives a point, yellow mostly, green sometimes, grey never."] = "L'arancione dà sempre un" ..
        " punto, il giallo quasi sempre, il verde a volte, il grigio mai.",
    ["Chests in the world"] = "Scrigni nel mondo",
    ["Boxes from your bags"] = "Scatole dalle tue borse",
    ["You have %d."] = "Ne hai %d.",
    [" %s at the auction house."] = " %s alla casa d'aste.",
    ["Dungeon doors"] = "Porte dei dungeon",
    ["%s: %d locked doors, from %d (%s)."] = "%s: %d porte chiuse, da %d (%s).",
    ["Getting started"] = "Per cominciare",
    ["Pick Lock: any rogue trainer, from level 16, for %s. It needs Thieves' Tools in your bags (rogue" ..
        " supplies vendors, 15s). Your cap is your level x 5."] = "Scassinare: qualsiasi maestro ladro, dal" ..
        " livello 16, per %s. Servono gli Arnesi da Scasso nelle borse (mercanti di forniture da ladro, 15a)." ..
        " Il tuo limite è il tuo livello x 5.",

    -- the cards with nothing to show, and the rest
    ["Nothing earns now"] = "Adesso non rende nulla",
    ["Nothing you can make sells for more than it costs at today's prices."] = "Nulla di ciò che puoi creare" ..
        " si vende a più di quanto costa a prezzi di oggi.",
    ["Nothing you can get here has a price yet: Craft Ladder needs auction house prices."] =
        "Nulla di ciò che ottieni qui ha ancora un prezzo: Craft Ladder ha bisogno dei prezzi della casa" ..
        " d'aste.",
    ["Nothing to do here"] = "Qui non c'è nulla da fare",
    ["You've reached %d %s."] = "Hai raggiunto %d in %s.",
    ["No recipe found for your skill."] = "Nessuna ricetta trovata per la tua abilità.",
    [", Working Overtime %d/5: +%d%%"] = ", Straordinari %d/5: +%d%%",

    -- what the data itself says on a rank card (Professions.lua, Data/*.lua)
    ["Your class quests at 16"] = "Le tue missioni di classe a 16",
    ["They lead to the first practice chests and give you Thieves' Tools. Pick Lock itself is learned from any" ..
        " rogue trainer, quest or not."] = "Portano ai primi scrigni di pratica e ti danno gli Arnesi da" ..
        " Scasso. Scassinare si impara da qualsiasi maestro ladro, con missione o senza.",
    ["Your class quests at 20"] = "Le tue missioni di classe a 20",
    ["The last one teaches Poisons (and Recipe: Thistle Tea). On the way you pick a lock: Lockpicking 70 for" ..
        " the Alliance's Duskwood Chest, 80 for the Horde's Gallywix's Lockbox (Classic's numbers, not" ..
        " confirmed in Forever)."] = "L'ultima insegna i Veleni (e la Ricetta: tè di cardo). Lungo la strada" ..
        " scassini una serratura: Scassinare 70 per lo Scrigno di Boscocupo dell'Alleanza, 80 per la Cassetta" ..
        " di Gallywix dell'Orda (numeri di Classic, non confermati in Forever).",
    ["Bring 12 Giant Egg, 10 Zesty Clam Meat and 20 Alterac Swiss to Dirge Quikcleave in Gadgetzan."] =
        "Porta 12 Uovo Gigante, 10 Polpa di Vongola Speziata e 20 Svizzero di Alterac a Dirge Tagliasvelto a" ..
        " Gadgetzan.",
    ["Catch the four fish below and bring them to Nat Pagle; he then teaches Artisan Fishing for 1g."] =
        "Pesca i quattro pesci qui sotto e portali a Nat Pagle; allora insegna Pesca (artigiano) per 1o.",
    ["Hank the Hammer's (Alliance) or Aturk the Anvil's (Horde) quests lead to Galvan the Ancient and Trenton" ..
        " Lighthammer, whose quests teach the Ornate Mithril recipes the last quest asks for. Buy those 7" ..
        " items at the auction house and you can skip them."] = "Le missioni di Hank il Martello (Alleanza) o" ..
        " di Aturk l'Incudine (Orda) portano a Galvan l'Antico e Trenton Martelloleggero, le cui missioni" ..
        " insegnano le ricette in mithril ornato che chiede l'ultima missione. Compra quei 7 oggetti alla casa" ..
        " d'aste e potrai saltarle.",
    ["It gives you a letter to hand in."] = "Ti dà una lettera da consegnare.",
    ["Right-click the pledge it gives you: that completes it."] = "Clic destro sul voto che ti dà: così si" ..
        " completa.",
    ["Save 15 wounded soldiers with the Triage Bandages the doctor gives you, before 6 of them die."] =
        "Salva 15 soldati feriti con le Bende di Primo Soccorso che ti dà il medico, prima che 6 di loro" ..
        " muoiano.",
    ["Then learn the mastery from the trainer who gave you the quest."] = "Poi impara la maestria dal maestro" ..
        " che ti ha dato la missione.",
}
