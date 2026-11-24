-- Craft Ladder in French. The key is the English string as it stands in the code; what's missing here is shown in
-- English. Item, recipe and zone names come from the game itself, so they are not here.
-- The %s and %d of a line must stay in the same order as in the English one: the game fills them in that order.
local _, ns = ...

ns.Locales = ns.Locales or {}
ns.Locales.frFR = {
    -- the auction house tab
    ["The items' names are still loading: click again."] = "Les noms des objets chargent encore : clique à" ..
        " nouveau.",
    ["Stop"] = "Arrêter",
    ["Full Rescan"] = "Tout rescanner",
    ["Scanning %s: %d of %d items."] = "Scan de %s : %d objets sur %d.",
    ["the auction house"] = "l'hôtel des ventes",
    ["Scan done: %d of %d items searched."] = "Scan terminé : %d objets trouvés sur %d.",
    ["A scan is already running: stop it first."] = "Un scan est déjà en cours : arrête-le d'abord.",
    ["Nothing to scan here."] = "Rien à scanner ici.",
    ["Scanning %s: 0 of %d items."] = "Scan de %s : 0 objet sur %d.",
    ["this step"] = "cette étape",
    ["Confirm %s"] = "Acheter pour %s",
    ["Asking..."] = "Demande...",
    ["Buying %d %s..."] = "Achat de %d %s...",
    ["The auction house is busy: try again in a moment."] = "L'hôtel des ventes est occupé : réessaie dans un" ..
        " instant.",
    ["Asking the price of %d %s..."] = "Demande du prix de %d %s...",
    ["Scan"] = "Scan",
    ["Asks the auction house what this one goes for now, and puts that price in the ladder. However fresh the" ..
        " price already is."] = "Demande à l'hôtel des ventes ce que celui-ci vaut maintenant et met ce prix" ..
        " dans l'échelle. Même si le prix est déjà frais.",
    ["Asks the auction house about what this step makes and everything it takes, then puts those prices in the" ..
        " ladder."] = "Demande à l'hôtel des ventes ce que cette étape fabrique et tout ce qu'elle prend, puis" ..
        " met ces prix dans l'échelle.",
    ["Search"] = "Recherche",
    ["Auctionator's Shopping tab with what this step buys, and how many."] = "L'onglet Achats d'Auctionator" ..
        " avec ce que cette étape achète, et en quelle quantité.",
    ["Learn %s"] = "Apprendre %s",
    ["at %d, raises your cap to %d"] = "à %d, monte ta limite à %d",
    ["%s%s|r a craft, %s"] = "%s%s|r par fabrication, %s",
    ["sold to a vendor"] = "vendu à un marchand",
    ["%d listed"] = "%d en vente",
    ["%d - %d, ~%d %s%s"] = "%d - %d, ~%d %s%s",
    [", %d listed"] = ", %d en vente",
    ["at %d, make one and keep it"] = "à %d, en fabriquer un et le garder",
    ["nothing to buy"] = "rien à acheter",
    ["need %d, you have %d"] = "il en faut %d, tu en as %d",
    ["%s each"] = "%s pièce",
    ["not listed"] = "pas en vente",
    ["No crafting profession: nothing to buy for one."] = "Pas de métier de fabrication : rien à acheter pour" ..
        " un.",
    ["%s: nothing to buy"] = "%s : rien à acheter",
    ["Scan stopped: the prices it had got are in."] = "Scan arrêté : les prix qu'il a obtenus sont dedans.",
    ["Nothing here to rescan."] = "Rien à rescanner ici.",
    ["Every price here was searched in the last two minutes: nothing to ask again."] =
        "Chaque prix ici a été cherché dans les deux dernières minutes : rien à redemander.",
    ["Scanning the auction house: 0 of %d items."] = "Scan de l'hôtel des ventes : 0 objet sur %d.",
    ["Searches the auction house for everything this list buys and sells, then puts the prices in the ladder." ..
        " It goes one item at a time, as the server allows: watch the line below. An item searched in the last" ..
        " two minutes is left alone."] = "Cherche à l'hôtel des ventes tout ce que cette liste achète et vend," ..
        " puis met les prix dans l'échelle. Il avance un objet à la fois, selon ce que le serveur permet :" ..
        " regarde la ligne ci-dessous. Un objet cherché dans les deux dernières minutes est laissé de côté.",
    ["Crafts"] = "Fabrications",
    ["A click on a step or a reagent searches it in Auctionator's Shopping tab."] = "Un clic sur une étape ou" ..
        " un composant le cherche dans l'onglet Achats d'Auctionator.",
    ["Craft Ladder"] = "Craft Ladder",
    ["%d %s for %s (%s each): click Confirm to buy."] = "%d %s pour %s (%s pièce) : clique sur Acheter.",
    ["No price for %s: not enough listed, or not sold that way (try the Buy tab)."] =
        "Pas de prix pour %s : pas assez en vente, ou pas vendu ainsi (essaie l'onglet Achat).",
    ["Bought %d %s."] = "%d %s achetés.",
    ["The purchase failed (the price may have changed): ask again."] = "L'achat a échoué (le prix a pu" ..
        " changer) : redemande.",

    -- the camp view
    ["No profession"] = "Pas de métier",
    [" (skill %d)"] = " (compétence %d)",
    ["you know it"] = "tu le connais",
    ["you can learn it"] = "tu peux l'apprendre",
    ["not your profession"] = "pas ton métier",
    ["%d in your bags"] = "%d dans tes sacs",
    ["needs %s"] = "il faut %s",
    ["make %s"] = "fabriquer %s",
    ["no price"] = "pas de prix",
    ["AH %s"] = "HV %s",
    ["  (not with %s)"] = "  (pas avec %s)",
    ["Or, the same buff and more: %s"] = "Ou le même effet et plus : %s",
    ["Camp: the buffs a campfire gives, for a level %d %s"] = "Camp : les bonus d'un feu de camp, pour le" ..
        " niveau %d, %s",
    ["Holds %d camp features. %s; %s."] = "Accueille %d éléments de camp. %s ; %s.",
    ["A %s holds %d: the ones above. Then:"] = "Un %s en accueille %d : ceux du dessus. Puis :",
    ["Doesn't help a %s"] = "N'aide pas un %s",
    ["Camp features with no buff"] = "Éléments de camp sans bonus",
    ["Build a campfire, place camp features around it and sit or craft nearby for a while: each feature gives" ..
        " everyone there its buff. A campfire holds only so many: here they are in the order your role wants" ..
        " them."] = "Fais un feu de camp, place des éléments autour et assieds-toi ou travaille à côté un" ..
        " moment : chaque élément donne son bonus à tous ceux qui sont là. Un feu de camp n'en accueille qu'un" ..
        " certain nombre : les voici dans l'ordre que ton rôle veut.",
    ["Campfire:"] = "Feu de camp :",

    -- the characters' buttons
    ["Level %d %s"] = "Niveau %d %s",
    ["Playing now"] = "Joue en ce moment",
    ["Last seen %s"] = "Vu pour la dernière fois %s",

    -- the menu
    ["Show the %s ladder."] = "Montrer l'échelle de %s.",
    ["not learned"] = "pas appris",
    ["Disenchant"] = "Désenchanter",
    ["Camp"] = "Camp",
    ["What's worth disenchanting on your whole account: what every character's bags and bank hold, what the" ..
        " auction house lists for less than disenchanting it brings, and what your crafting professions make" ..
        " that's worth more disenchanted than sold."] = "Ce qu'il vaut la peine de désenchanter sur tout ton" ..
        " compte : ce que les sacs et la banque de chaque personnage contiennent, ce que l'hôtel des ventes" ..
        " propose pour moins que ce que le désenchantement rapporte, et ce que tes métiers fabriquent qui vaut" ..
        " plus désenchanté que vendu.",
    ["What each camp feature gives around a campfire, in the order your role wants them, and how to get it."] =
        "Ce que chaque élément de camp donne autour d'un feu de camp, dans l'ordre que ton rôle veut, et" ..
        " comment l'obtenir.",

    -- the minimap button
    ["Earns most"] = "Rapporte le plus",
    ["%s, %s an hour"] = "%s, %s de l'heure",
    ["Now"] = "Maintenant",
    ["%s in %s to %d"] = "%s à %s jusqu'à %d",
    ["fish"] = "pêcher",
    ["mine"] = "miner",
    ["catches"] = "prises",
    ["nodes"] = "filons",
    ["%s to %d"] = "%s jusqu'à %d",
    ["~%d crafts, %s"] = "~%d fabrications, %s",
    ["Eat"] = "Manger",
    ["%s, +%s a craft"] = "%s, +%s par fabrication",
    ["reach level %d"] = "atteindre le niveau %d",
    ["learn %s"] = "apprendre %s",
    ["Up to %d"] = "Jusqu'à %d",
    ["Prices"] = "Prix",
    ["Click: open or close the window"] = "Clic : ouvrir ou fermer la fenêtre",
    ["Drag: move the button"] = "Glisser : déplacer le bouton",
    ["minimap button hidden - /craft minimap shows it again."] = "bouton de la minicarte caché - /craft" ..
        " minimap le remontre.",
    ["minimap button shown."] = "bouton de la minicarte affiché.",

    -- the Settings menu
    ["Auction house prices from"] = "Prix de l'hôtel des ventes depuis",
    ["Its last full scan of your faction's auction house: the lowest price, the median and how many are" ..
        " listed."] = "Son dernier scan complet de l'hôtel des ventes de ta faction : le prix le plus bas, la" ..
        " médiane et combien sont en vente.",
    ["Its last scan. It gives one price per item, so the median is that price."] = "Son dernier scan. Il donne" ..
        " un seul prix par objet, donc la médiane est ce prix.",
    ["An ingredient costs"] = "Un composant coûte",
    ["The median listed price"] = "Le prix médian en vente",
    ["Half of what's listed costs less. The cheapest listing is one auction, often gone minutes after the" ..
        " scan."] = "La moitié de ce qui est en vente coûte moins. L'offre la moins chère est une seule" ..
        " enchère, souvent partie quelques minutes après le scan.",
    ["The cheapest listing"] = "L'offre la moins chère",
    ["What the ladder cost before: the lowest price of the scan. Cheaper than what you will really pay, unless" ..
        " you are quick."] = "Ce que l'échelle comptait avant : le prix le plus bas du scan. Moins cher que ce" ..
        " que tu paieras vraiment, sauf si tu es rapide.",
    ["Language"] = "Langue",
    ["Craft Ladder's own words. Item, recipe and zone names come from your game client, in its language. A few" ..
        " buttons take a /reload to change."] = "Les mots de Craft Ladder. Les noms d'objets, de recettes et" ..
        " de zones viennent de ton client de jeu, dans sa langue. Quelques boutons demandent un /reload.",
    ["What you sell is always priced at the cheapest listing, the one you undercut."] =
        "Ce que tu vends est toujours compté à l'offre la moins chère, celle que tu sous-cotes.",
    ["%s isn't installed: %s is read."] = "%s n'est pas installé : %s est lu.",
    ["Neither addon is installed: no auction house prices."] = "Aucun des deux addons n'est installé : pas de" ..
        " prix de l'hôtel des ventes.",

    -- the Specialization view
    ["%s%d / %d|r  %s"] = "%s%d / %d|r  %s",
    ["level %d (you're %d)"] = "niveau %d (tu es %d)",
    ["%s %d (you have %d)"] = "%s %d (tu as %d)",
    ["Needs %s."] = "Il faut %s.",
    [" and "] = " et",
    ["Or take it here instead:"] = "Ou prends-le ici à la place :",
    ["Take the quest:"] = "Prends la quête :",
    ["Take and hand in the quest:"] = "Prends et rends la quête :",
    ["Hand it in:"] = "Rends-la :",
    ["you have them all"] = "tu les as tous",
    ["auction house %s"] = "hôtel des ventes %s",
    ["none at the auction house"] = "rien à l'hôtel des ventes",
    ["Make %d; some of its ingredients have no price; %s"] = "Fabriques-en %d ; certains composants n'ont pas" ..
        " de prix ; %s",
    ["Make %d for %s; %s"] = "Fabriques-en %d pour %s ; %s",
    ["Buy %d: %s%s"] = "Achètes-en %d : %s%s",
    [", making them costs %s"] = ", les fabriquer coûte %s",
    ["Drops from %s"] = "Tombe de %s",
    ["Drops from %d kinds of creatures; "] = "Tombe de %d sortes de créatures ;",
    ["none at the auction house now"] = "rien à l'hôtel des ventes en ce moment",
    [", learned at %d"] = ", appris à %d",
    ["its recipe drops from %d kinds of creatures, none at the auction house now"] = "sa recette tombe de %d" ..
        " sortes de créatures, rien à l'hôtel des ventes en ce moment",
    ["no way to learn it for you now"] = "pas moyen de l'apprendre pour toi en ce moment",
    ["Buy the recipe:"] = "Achète la recette :",
    ["Learn it from the trainer:"] = "Apprends-la au maître :",
    ["Bring to %s:"] = "Apporte à %s :",
    ["the quest giver"] = "au donneur de quête",
    ["%s%d %s%s"] = "%s%d %s%s",
    ["smelt "] = "fondre",
    [" (besides the %d you have)"] = " (en plus des %d que tu as)",
    ["Make: %s"] = "Fabriquer : %s",
    ["Ingredients:"] = "Composants :",
    ["buy %d: "] = "achètes-en %d :",
    ["the smith"] = "au forgeron",
    ["%d. Talk to %s"] = "%d. Parle à %s",
    ["Talk to:"] = "Parle à :",
    ["%d. Master a weapon: one of them"] = "%d. Maîtrise une arme : l'une d'elles",
    ["%s: the quest %s"] = "%s : la quête %s",
    ["The recipes"] = "Les recettes",
    ["  %d to learn"] = "  %d à apprendre",
    ["Click to fold or open."] = "Clic pour plier ou déplier.",
    ["Show the steps to %s."] = "Montrer les étapes vers %s.",
    ["You have this specialization."] = "Tu as cette spécialisation.",
    ["Needs level %d and %s %d; you're level %d with %d."] = "Il faut le niveau %d et %s %d ; tu es niveau %d" ..
        " avec %d.",
    ["Unlocks %d recipes only this specialization can learn."] = "Débloque %d recettes que seule cette" ..
        " spécialisation peut apprendre.",
    ["You have %s: a character can have only one %s specialization."] = "Tu as %s : un personnage ne peut" ..
        " avoir qu'une spécialisation en %s.",
    ["Still to spend: %s, each item made or bought, whichever costs less%s."] = "Reste à dépenser : %s, chaque" ..
        " objet fabriqué ou acheté, selon ce qui coûte le moins%s.",
    ["; some have no price"] = "; certains n'ont pas de prix",
    ["You have %s"] = "Tu as %s",
    ["To %s: about %s%s"] = "Jusqu'à %s : environ %s%s",
    [", some items unpriced"] = ", certains objets sans prix",

    -- the window: the list, its rows and their tooltips
    [" - %s%s %d|r"] = " - %s%s %d|r",
    ["%d days"] = "%d jours",
    ["%d hours"] = "%d heures",
    ["~%d min"] = "~%d min",
    ["All locks"] = "Toutes les serrures",
    ["Every lock a rogue picks, by the skill it needs, and its colour for you."] = "Chaque serrure qu'un" ..
        " voleur crochète, selon la compétence qu'elle demande et sa couleur pour toi.",
    ["At %d your cap is the level x 5: %d at level %d."] = "À %d ta limite est le niveau x 5 : %d au niveau" ..
        " %d.",
    ["at %d, cap %d"] = "à %d, limite %d",
    ["Skill"] = "Compétence",
    ["Smelt on the way"] = "Fondre en chemin",
    ["Trainer"] = "Maître",
    ["Catches"] = "Prises",
    ["Lure"] = "Appât",
    ["none"] = "aucun",
    ["Cost"] = "Coût",
    ["In your bags"] = "Dans tes sacs",
    [", soulbound"] = ", lié",
    ["One craft"] = "Une fabrication",
    ["Disenchanted"] = "Désenchanté",
    ["Sold"] = "Vendu",
    [" at the auction house"] = " à l'hôtel des ventes",
    [" at a vendor"] = " chez un marchand",
    ["nobody buys it"] = "personne ne l'achète",
    ["Best"] = "Le mieux",
    ["Disenchanting one craft"] = "Désenchanter une fabrication",
    ["Cheapest listing"] = "Offre la moins chère",
    ["Gains"] = "Rapporte",
    [", more %d%% of the time"] = ", plus dans %d%% des cas",
    ["Raises"] = "Monte",
    ["Cook one"] = "Cuisiner un",
    ["Buy one"] = "En acheter un",
    ["Sells for"] = "Se vend",
    ["Profit"] = "Profit",
    ["Listed"] = "En vente",
    ["%d - %d, ~%d %s"] = "%d - %d, ~%d %s",
    ["%s of ~%d, from what you have (vendor reagents aside)"] = "%s sur ~%d, avec ce que tu as (composants de" ..
        " marchand mis à part)",
    ["%slvl %d|r - "] = "%sniv %d|r -",
    ["known, make %d now"] = "connue, fabriques-en %d tout de suite",
    ["learn now (skill %d)"] = "apprendre maintenant (compétence %d)",
    ["skill %d (you %d)"] = "compétence %d (toi %d)",
    ["level %d (you %d)"] = "niveau %d (toi %d)",
    ["%s ready"] = "%s prêt",
    ["chests, boxes and doors by skill"] = "coffres, boîtes et portes par compétence",
    ["Reach level %d"] = "Atteindre le niveau %d",
    ["at %d, raises your cap to %d%s"] = "à %d, monte ta limite à %d%s",
    ["Fish in %s"] = "Pêcher à %s",
    ["your pick"] = "ton choix",
    ["an hour: ~%d catches, %s each%s%s"] = "une heure : ~%d prises, %s pièce%s%s",
    ["%d - %d, ~%d catches%s"] = "%d - %d, ~%d prises%s",
    ["%s%s, %s%s%s%s%s%s"] = "%s%s, %s%s%s%s%s%s",
    ["%s, %s, disenchanted ~%s, sold %s"] = "%s, %s, désenchanté ~%s, vendu %s",
    ["%s's %s - %s: ~%s disenchanted, %s sold%s"] = "%s, %s - %s : ~%s désenchanté, %s vendu%s",
    ["buy %s, ~%s disenchanted, pays %d%% of the time"] = "achète %s, ~%s désenchanté, rentable dans %d%%" ..
        " des cas",
    ["%d - %d%s: %s"] = "%d - %d%s : %s",
    ["keep them"] = "garde-les",
    ["unconfirmed"] = "non confirmé",
    ["after %d%s, %sneeded for %s|r"] = "après %d%s, %snécessaire pour %s|r",
    ["%s%s, %smake one and keep it|r"] = "%s%s, %sen fabriquer un et le garder|r",
    ["%d favor"] = "%d faveur",
    ["? favor"] = "? faveur",
    ["Open your %s window once so Craft Ladder knows which recipes you have."] = "Ouvre ta fenêtre de %s une" ..
        " fois pour que Craft Ladder sache quelles recettes tu as.",
    ["No %s found past %d with what Craft Ladder knows."] = "Aucun %s trouvé au-delà de %d avec ce que Craft" ..
        " Ladder connaît.",
    ["zone"] = "zone",
    ["recipe"] = "recette",
    ["Back to your ladder"] = "Retour à ton échelle",
    ["Merchant's Favor recipes (%d)"] = "Recettes en Faveur du marchand (%d)",
    ["Dishes for this role, by what eating one raises. Click to fold or open."] = "Plats pour ce rôle, selon" ..
        " ce que manger monte. Clic pour plier ou déplier.",
    ["Nothing here"] = "Rien ici",
    ["Nothing earns this way at today's prices."] = "Rien ne rapporte ainsi aux prix d'aujourd'hui.",
    ["Sell to a vendor"] = "Vendre à un marchand",
    ["These cost less to make than a vendor pays: vendors buy any number, no auction house needed. Click to" ..
        " fold or open."] = "Ceux-ci coûtent moins à fabriquer que ce qu'un marchand paie : les marchands" ..
        " achètent en toute quantité, pas besoin de l'hôtel des ventes. Clic pour plier ou déplier.",
    ["Sell at the auction house"] = "Vendre à l'hôtel des ventes",
    ["These earn more at the auction house: 5 or more listed (or however few when you searched it yourself)," ..
        " and it pays 1.5 times what a vendor does. How many sell, the auction house doesn't say."] =
        "Ceux-ci rapportent plus à l'hôtel des ventes : 5 ou plus en vente (ou aussi peu que tu veux si tu as" ..
        " cherché toi-même), et il paie 1,5 fois ce que donne un marchand. Combien se vendent, l'hôtel des" ..
        " ventes ne le dit pas.",
    ["nothing at today's prices"] = "rien aux prix d'aujourd'hui",
    ["Disenchant, your whole account: Enchanting 1 disenchants anything"] = "Désenchanter, tout ton compte : Enchantement 1 désenchante tout",
    ["the ladder from %d to %d"] = "l'échelle de %d à %d",
    ["the ladder to %d"] = "l'échelle jusqu'à %d",
    ["%s%s %d / %d, %s%s"] = "%s%s %d / %d, %s%s",
    ["as of %s"] = "au %s",
    ["%s has no %s yet"] = "%s n'a pas encore %s",
    ["No %s yet"] = "Pas encore de %s",
    ["Specialization"] = "Spécialisation",
    ["Skill %d"] = "Compétence %d",
    ["No auction house prices: AuctionDB or Auctionator needed"] = "Pas de prix de l'hôtel des ventes :" ..
        " AuctionDB ou Auctionator nécessaire",
    [" %s prices scanned %s, costs may be off: scan at the auction house|r"] = " Prix %s scannés %s, les coûts" ..
        " peuvent être faux : scanne à l'hôtel des ventes|r",
    ["%s prices scanned %s: scan at the auction house|r"] = "Prix %s scannés %s : scanne à l'hôtel des" ..
        " ventes|r",
    ["Prices: %s, scanned %s (%s)|r"] = "Prix : %s, scannés %s (%s)|r",
    ["today"] = "aujourd'hui",
    ["yesterday"] = "hier",
    ["%d days ago"] = "il y a %d jours",
    ["Prices: Auctionator, newest prices from %s|r"] = "Prix : Auctionator, prix les plus récents du %s|r",
    ["Prices: %s"] = "Prix : %s",
    ["%d Merchant's Favor recipes, %d you can learn now%s"] = "%d recettes en Faveur du marchand, %d" ..
        " apprenables maintenant%s",
    ["; you have %d favor"] = "; tu as %d faveur",
    ["%d dishes for your class; the cost is one dish from bought ingredients"] = "%d plats pour ta classe ; le" ..
        " coût est un plat avec des composants achetés",
    ["%d zones at skill %d; the best about %s an hour"] = "%d zones à la compétence %d ; la meilleure environ" ..
        " %s de l'heure",
    ["Spend %s, catch about %s worth (%s, %s an hour)"] = "Dépense %s, pêche environ %s de valeur (%s, %s de" ..
        " l'heure)",
    ["Spend %s, %s about %s worth (%s an hour), about %d %s"] = "Dépense %s, %s environ %s de valeur (%s de" ..
        " l'heure), environ %d %s",
    ["%s%d at the auction house; the best +%s a craft"] = "%s%d à l'hôtel des ventes ; le meilleur +%s par" ..
        " fabrication",
    ["Total %s, about %d %s%s"] = "Total %s, environ %d %s%s",
    ["Total %s, about %d catches (%s)"] = "Total %s, environ %d prises (%s)",
    ["Spend %s, about %s back from sales, about %d crafts"] = "Dépense %s, environ %s récupérés par les" ..
        " ventes, environ %d fabrications",
    ["Total %s, about %d crafts"] = "Total %s, environ %d fabrications",
    ["Plan the ladder to %d."] = "Planifier l'échelle jusqu'à %d.",
    ["Window size"] = "Taille de la fenêtre",
    ["Drag: make the window bigger."] = "Glisser : agrandir la fenêtre.",
    ["Ctrl + mouse wheel: bigger or smaller text (now %d%%)."] = "Ctrl + molette : texte plus grand ou plus" ..
        " petit (actuellement %d%%).",
    ["Right-click: back to the normal size."] = "Clic droit : retour à la taille normale.",
    ["Close"] = "Fermer",
    ["Escape closes it too."] = "Échap la ferme aussi.",
    ["Settings"] = "Réglages",
    ["Which auction house addon the prices are read from, and which of its listed prices an ingredient costs."] =
        "De quel addon d'hôtel des ventes les prix sont lus, et lequel de ses prix en vente un composant" ..
        " coûte.",
    ["Your hands are idle, adventurer."] = "Tes mains sont oisives, aventurier.",
    ["The trainers are waiting: learn a profession."] = "Les maîtres attendent : apprends un métier.",
    ["The steps to each of its specializations: the quests, what they ask for and what you have of it, the" ..
        " recipes, and what's still to make or buy."] = "Les étapes vers chacune de ses spécialisations : les" ..
        " quêtes, ce qu'elles demandent et ce que tu en as, les recettes, et ce qu'il reste à fabriquer ou" ..
        " acheter.",
    ["Merchant's Favor recipes"] = "Recettes en Faveur du marchand",
    ["What the supply camps' quartermaster sells for Merchant's Favor: its price and level (seen at a" ..
        " quartermaster), your skill, what you know and can make."] = "Ce que le quartier-maître des camps de" ..
        " ravitaillement vend contre la Faveur du marchand : son prix et son niveau (vus chez un" ..
        " quartier-maître), ta compétence, ce que tu connais et peux fabriquer.",
    ["Back to cheapest"] = "Retour au moins cher",
    ["Use the cheapest recipe for this step again."] = "Reprendre la recette la moins chère pour cette étape.",
    ["Search the auction house"] = "Chercher à l'hôtel des ventes",
    ["Auctionator's Shopping tab with this item. The auction house must be open."] = "L'onglet Achats" ..
        " d'Auctionator avec cet objet. L'hôtel des ventes doit être ouvert.",
    ["Also use recipes bought with Merchant's Favor."] = "Utiliser aussi les recettes achetées avec la Faveur" ..
        " du marchand.",
    ["Reset"] = "Réinitialiser",
    ["The ladder from your skill to 300 again."] = "L'échelle de ta compétence jusqu'à 300 à nouveau.",
    ["No profession yet"] = "Pas encore de métier",

    -- the menu's group headings
    ["PROFESSIONS"] = "MÉTIERS",
    ["SECONDARY"] = "SECONDAIRES",
    ["CLASS"] = "CLASSE",

    -- the modes over the list, and what each one plans (the names the tooltips use)
    ["Vendor sales"] = "Marchand",
    ["AH sales"] = "HV",
    ["Food"] = "Nourriture",
    ["Favor"] = "Faveur",
    ["done"] = "fait",
    ["in your quest log"] = "dans ton journal de quêtes",

    -- one option's tooltip and its row
    ["Click: put a map pin and the arrow on it."] = "Clic : poser un point sur la carte et la flèche dessus.",
    ["%s that give points"] = "%s qui donnent des points",
    ["%s for this step"] = "%s pour cette étape",
    ["A %s is worth"] = "Un %s vaut",
    ["Gold an hour"] = "Or de l'heure",
    ["Click to %s here for this step."] = "Clic : %s ici pour cette étape.",
    ["Fish that land"] = "Poissons qui mordent",
    ["all of them"] = "tous",
    ["none needed"] = "aucun nécessaire",
    ["A catch is worth"] = "Une prise vaut",
    ["Lures for this step"] = "Appâts pour cette étape",
    ["Click to fish here for this step."] = "Clic : pêcher ici pour cette étape.",
    ["%s the %d you can make from what you have."] = "%s les %d que tu peux faire avec ce que tu as.",
    ["Ingredients"] = "Composants",
    ["Learn"] = "Apprendre",
    ["Recipe"] = "Recette",
    ["Selling them brings back"] = "Les vendre rapporte",
    ["Per skill point"] = "Par point de compétence",
    ["Click to use this recipe for this step."] = "Clic : prendre cette recette pour cette étape.",
    ["~%d %s, %s a %s"] = "~%d %s, %s le %s",
    ["%s at the trainer"] = "%s au maître",
    ["no fish get away"] = "aucun poisson ne s'échappe",
    ["%d%% of casts land a fish"] = "%d%% des lancers ramènent un poisson",
    [", with %s"] = ", avec %s",
    ["%s a catch%s"] = "%s la prise%s",
    [", lures %s"] = ", appâts %s",
    [" / catch"] = " / prise",
    ["%s for lures"] = "%s pour les appâts",
    ["  with what you have"] = "  avec ce que tu as",
    ["from your bags"] = "de tes sacs",
    ["bought at the auction house"] = "acheté à l'hôtel des ventes",
    ["learn: %s"] = "apprendre : %s",
    [" / point"] = " / point",
    ["%s in all%s"] = "%s en tout%s",
    [", %s back"] = ", %s récupérés",
    [" / hour"] = " / heure",

    -- a folded list, the ingredients, the colours
    ["all %d %s"] = "tous les %d %s",
    ["and %d more %s"] = "et %d autres %s",
    ["and %d more"] = "et %d autres",
    ["vendors"] = "marchands",
    ["trainers"] = "maîtres",
    [" (you have them)"] = " (tu les as)",
    ["  (you have %d%s)"] = "  (tu en as %d%s)",
    [", in the bank"] = ", à la banque",
    [", %d in the bank"] = ", %d à la banque",
    ["smelt"] = "fondre",
    ["%s %d yourself from %s%s"] = "%s %d toi-même avec %s%s",
    [", buy the other %d"] = ", achète les %d autres",
    ["you have enough"] = "tu en as assez",
    ["only %d listed - you need %d"] = "seulement %d en vente - il t'en faut %d",
    ["  your Cooking uses it"] = "  ta Cuisine s'en sert",
    ["%d%% of catches%s"] = "%d%% des prises%s",
    [" each"] = " pièce",
    ["  creatures level %d+|r"] = "  créatures niveau %d+|r",
    ["at the auction house, after its cut"] = "à l'hôtel des ventes, après sa commission",
    ["at a vendor"] = "chez un marchand",
    ["what's inside, on average"] = "ce qu'il y a dedans, en moyenne",
    ["orange"] = "orange",
    ["yellow"] = "jaune",
    ["green"] = "vert",
    ["grey"] = "gris",
    ["from %d"] = "à partir de %d",
    ["Your pick."] = "Ton choix.",

    -- the Craft bar
    ["An enchantment: enchant from the profession window, on the item."] = "Un enchantement : enchante depuis" ..
        " la fenêtre du métier, sur l'objet.",
    ["Learn the recipe first."] = "Apprends d'abord la recette.",
    ["Not in combat."] = "Pas en combat.",
    ["Not enough reagents in your bags."] = "Pas assez de composants dans tes sacs.",
    ["Craft"] = "Fabriquer",
    ["Crafts as many as the box says; opens your profession window first if it's closed (the game crafts only" ..
        " with it open)."] = "Fabrique autant que le champ l'indique ; ouvre d'abord ta fenêtre de métier si" ..
        " elle est fermée (le jeu ne fabrique qu'avec la fenêtre ouverte).",
    [" Cooking needs a fire nearby."] = " La Cuisine demande un feu à proximité.",
    ["Your bags allow %d"] = "Tes sacs permettent %d",
    ["; the step needs %d."] = "; l'étape en demande %d.",
    ["Opening your %s window: crafting once it's ready."] = "Ouverture de ta fenêtre de %s : fabrication dès" ..
        " qu'elle est prête.",

    -- how to learn a recipe
    ["Learn it"] = "Comment l'apprendre",
    ["Buy the recipe from %s:"] = "Achète la recette chez %s :",
    ["one of these vendors"] = "l'un de ces marchands",
    ["this vendor"] = "ce marchand",
    ["%s Favor"] = "Faveur %s",
    ["Merchant's"] = "du marchand",
    ["Quest reward: %s%s"] = "Récompense de quête : %s%s",
    ["(needs level %d)"] = "(niveau %d requis)",
    ["quest giver"] = "donneur de quête",
    ["Only these trainers teach it, for %s:"] = "Seuls ces maîtres l'enseignent, pour %s :",
    ["trainer"] = "maître",
    ["None of them is of your faction."] = "Aucun d'eux n'est de ta faction.",
    ["Or buy it at the auction house: %s."] = "Ou achète-la à l'hôtel des ventes : %s.",
    ["Or %s."] = "Ou %s.",
    ["During %s: %s."] = "Pendant %s : %s.",
    ["The price is an estimate: Craft Ladder learns the real one when you visit the %s."] =
        "Le prix est une estimation : Craft Ladder apprendra le vrai quand tu passeras par là (%s).",
    ["vendor"] = "marchand",

    -- what it sells for, and one craft
    ["An enchantment: nothing to sell."] = "Un enchantement : rien à vendre.",
    ["%s%s at the auction house (after its cut%s)."] = "%s%s à l'hôtel des ventes (après sa commission%s).",
    ["Not on the auction house."] = "Pas à l'hôtel des ventes.",
    ["%s%s at a vendor."] = "%s%s chez un marchand.",
    ["Vendors don't buy it."] = "Les marchands ne l'achètent pas.",
    ["One craft%s: %s"] = "Une fabrication%s : %s",
    ["One craft: %s"] = "Une fabrication : %s",
    [" (makes %d)"] = " (en fait %d)",
    ["auction house"] = "hôtel des ventes",
    ["%s yourself%s"] = "%s toi-même%s",
    [" and %s"] = " et %s",
    ["%s each, %s"] = "%s pièce, %s",
    ["Each sells for "] = "Chacun se vend",
    ["Sells for "] = "Se vend",
    ["%d sell for "] = "%d se vendent",

    -- a Merchant's Favor recipe
    ["You know it."] = "Tu la connais.",
    ["You can learn it now."] = "Tu peux l'apprendre maintenant.",
    ["It needs %d %s (you: %d)."] = "Il faut %d %s (toi : %d).",
    ["It needs level %d (you: %d)."] = "Il faut le niveau %d (toi : %d).",
    ["Merchant's Favor"] = "Faveur du marchand",
    ["Costs %d Merchant's Favor%s."] = "Coûte %d en Faveur du marchand%s.",
    [" (you have %d)"] = " (tu en as %d)",
    ["Its price: open a quartermaster once and Craft Ladder remembers it."] = "Son prix : passe une fois chez" ..
        " un quartier-maître et Craft Ladder s'en souvient.",
    ["From level %d (you: %d)."] = "À partir du niveau %d (toi : %d).",
    ["Its level: open a quartermaster once and Craft Ladder remembers it."] = "Son niveau : passe une fois" ..
        " chez un quartier-maître et Craft Ladder s'en souvient.",
    ["From %d %s (you: %d)."] = "À partir de %d %s (toi : %d).",
    ["%s is %s from level %d (you: %d)."] = "%s %s à partir du niveau %d (toi : %d).",
    ["worn"] = "se porte",
    ["used"] = "s'utilise",
    ["Quartermaster"] = "Quartier-maître",
    ["The plan needs %s with %s."] = "Le plan demande %s avec %s.",
    ["Only for %s."] = "Seulement pour %s.",
    ["Hated"] = "Haine",
    ["Hostile"] = "Hostile",
    ["Unfriendly"] = "Inamical",
    ["Neutral"] = "Neutre",
    ["Friendly"] = "Amical",
    ["Honored"] = "Honoré",
    ["Revered"] = "Révéré",
    ["Exalted"] = "Exalté",

    -- a crafting step
    ["Skill %d - %d, about %d crafts, %s%s"] = "Compétence %d - %d, environ %d fabrications, %s%s",
    ["some prices missing"] = "certains prix manquent",
    ["%s %s what you already have: %d crafts%s."] = "%s %s avec ce que tu as déjà : %d fabrications%s.",
    [", plus a few vendor ingredients"] = ", plus quelques composants de marchand",
    [", nothing to buy"] = ", rien à acheter",
    ["You can %s %d now with what you have."] = "%s : maintenant %d avec ce que tu as.",
    ["You have the reagents for %d."] = "Tu as les composants pour %d.",
    ["You have the main ingredients for %d; the rest is sold by vendors."] = "Tu as les composants principaux" ..
        " pour %d ; le reste est vendu par des marchands.",
    ["The cheapest here is %s."] = "Le moins cher ici est %s.",
    ["Needed for %s: %d recipes (%s, ...), and no vendor sells it. None of them is for leveling (a cooldown," ..
        " or learned at 300): make it once you're done."] = "Nécessaire pour %s : %d recettes (%s, ...), et" ..
        " aucun marchand ne le vend. Aucune d'elles ne sert à monter (un temps de recharge, ou appris à 300) :" ..
        " fabrique-le une fois que tu as fini.",
    ["A tool: %d %s recipes need it, and no vendor sells it. Make one and keep it in your bags%s."] =
        "Un outil : %d recettes en %s en ont besoin, et aucun marchand ne le vend. Fabriques-en un et garde-le" ..
        " dans tes sacs%s.",
    [" (it gives no skill point any more)"] = " (il ne donne plus de point de compétence)",
    ["You have %s: the step takes them from your bags, so it pays less than that."] =
        "Tu as %s : l'étape les prend dans tes sacs, elle coûte donc moins que ça.",
    ["Keep for later"] = "Garder pour plus tard",
    ["Keep %d %s: the steps at %d - %d use them."] = "Garde %d %s : les étapes de %d - %d s'en servent.",
    ["Batch: %s"] = "Lot : %s",
    ["Craft counts are estimates: skill-ups are luck once a recipe is yellow."] = "Le nombre de fabrications" ..
        " est une estimation : les points de compétence sont une affaire de chance dès qu'une recette est" ..
        " jaune.",
    ["Sell the rest"] = "Vendre le reste",
    ["Sell what you make"] = "Vendre ce que tu fabriques",
    ["%d at the auction house, about %s each after its cut."] = "%d à l'hôtel des ventes, environ %s pièce" ..
        " après sa commission.",
    ["%d to a vendor, %s each."] = "%d à un marchand, %s pièce.",
    ["About %s back, so this step %s %s."] = "Environ %s récupérés, donc cette étape %s %s.",
    ["earns"] = "rapporte",
    ["costs"] = "coûte",
    ["Vendor sales counts only what vendors pay: that money is sure. AH sales counts the auction house too."] =
        "Ventes au marchand ne compte que ce que les marchands paient : cet argent est sûr. Ventes à l'HV" ..
        " compte aussi l'hôtel des ventes.",
    ["The auction house counts only when it pays 1.5 times a vendor and 5 or more are listed, and for at most" ..
        " a quarter of what's listed."] = "L'hôtel des ventes ne compte que s'il paie 1,5 fois un marchand et" ..
        " que 5 ou plus sont en vente, et au plus pour un quart de ce qui est en vente.",
    ["Or %s, from %d"] = "Ou %s, à partir de %d",
    ["Recipes you could use from %d"] = "Recettes utilisables à partir de %d",
    ["No other recipe is open to you here."] = "Aucune autre recette ne t'est ouverte ici.",

    -- Gold: one recipe's profit
    ["One craft%s costs about %s and sells for about %s: %s+%s|r"] = "Une fabrication%s coûte environ %s et se" ..
        " vend environ %s : %s+%s|r",
    ["Sold to a vendor: vendors buy any number."] = "Vendu à un marchand : les marchands achètent en toute" ..
        " quantité.",
    ["%d listed at the auction house now: sell a few at a time."] = "%d en vente à l'hôtel des ventes en ce" ..
        " moment : vends-en quelques-uns à la fois.",
    ["Making it needs %s %d, and yours is %d%s. It's here to level towards."] = "Pour la fabriquer il faut %s" ..
        " %d, et le tien est %d%s. Elle est là comme objectif.",
    ["; the rank that lifts your cap to it asks level %d, and you're %d"] = "; le rang qui monte ta limite" ..
        " jusque-là demande le niveau %d, et tu es %d",
    ["Learning it pays back after %d %s."] = "L'apprendre est rentabilisé après %d %s.",
    ["craft"] = "fabrication",
    ["crafts"] = "fabrications",
    ["Once in %s: the recipe has a cooldown."] = "Une fois tous les %s : la recette a un temps de recharge.",
    ["You have %s: counted at their price too, since you could sell them."] = "Tu as %s : comptés à leur prix" ..
        " aussi, puisque tu pourrais les vendre.",
    ["Profit: what a vendor pays, less the ingredients at today's prices. How many you can make, the auction" ..
        " house's ingredients decide."] = "Profit : ce qu'un marchand paie, moins les composants aux prix" ..
        " d'aujourd'hui. Combien tu peux en faire, ce sont les composants de l'hôtel des ventes qui le" ..
        " décident.",
    ["Profit: at the lowest listing after the auction house's cut, with 5 or more listed, or however few when" ..
        " you searched it yourself; it counts only when it pays 1.5 times what a vendor does. How many sell," ..
        " the auction house doesn't say. Prices change: look again before buying."] =
        "Profit : à l'offre la moins chère après la commission de l'hôtel des ventes, avec 5 ou plus en vente," ..
        " ou aussi peu que tu veux si tu as cherché toi-même ; cela ne compte que s'il paie 1,5 fois ce que" ..
        " donne un marchand. Combien se vendent, l'hôtel des ventes ne le dit pas. Les prix changent : regarde" ..
        " à nouveau avant d'acheter.",

    -- Disenchant
    ["Disenchant one: about %s"] = "Désenchanter un : environ %s",
    ["%d%% of disenchants, %s each"] = "%d%% des désenchantements, %s pièce",
    ["%s%d disenchanted: about %s, at least %s 9 times out of 10."] = "%s%d désenchantés : environ %s, au" ..
        " moins %s 9 fois sur 10.",
    ["Your "] = "Tes",
    ["What it gives: from your %d disenchants of this item, recorded in game: it breaks unlike items of its" ..
        " kind."] = "Ce qu'il donne : d'après tes %d désenchantements de cet objet, enregistrés en jeu : il se" ..
        " défait autrement que les objets de son genre.",
    ["What it gives: from %d disenchants of items like it, recorded in game."] = "Ce qu'il donne : d'après %d" ..
        " désenchantements d'objets semblables, enregistrés en jeu.",
    ["You've disenchanted %d like it: %s in all. From %d, what you got replaces the table."] =
        "Tu en as désenchanté %d de semblables : %s en tout. À partir de %d, ce que tu as obtenu remplace la" ..
        " table.",
    ["Forever added this kind of item: what it gives is a guess, checked for one item: a green's of its level," ..
        " one more of each."] = "Forever a ajouté ce genre d'objet : ce qu'il donne est une supposition," ..
        " vérifiée sur un objet : comme un vert de son niveau, un de plus de chaque.",
    ["What a disenchant gives is luck%s. Materials at the auction house after its cut; 3 lesser essences make" ..
        " a greater one."] = "Ce qu'un désenchantement donne est une affaire de chance%s. Matériaux à l'hôtel" ..
        " des ventes après sa commission ; 3 petites essences font une grande.",
    [", from Classic's table (not checked in Forever yet): from %d of your disenchants of items like it, what" ..
        " you got replaces it"] = ", d'après la table de Classic (pas encore vérifiée dans Forever) : à partir" ..
        " de %d de tes désenchantements d'objets semblables, ce que tu as obtenu la remplace",
    ["One craft%s costs about %s; disenchanted, about %s on average: %s"] = "Une fabrication%s coûte environ" ..
        " %s ; désenchantée, environ %s en moyenne : %s",
    ["A %s recipe %s knows."] = "Une recette de %s que %s connaît.",
    ["you"] = "toi",
    ["Making it costs more than disenchanting brings: disenchant it when you make it anyway, for skill."] =
        "La fabriquer coûte plus que ce que le désenchantement rapporte : désenchante-la quand tu la fais de" ..
        " toute façon, pour la compétence.",
    ["Best: %s. %d in %s's %s: disenchanted, about %s on average; sold, %s."] = "Le mieux : %s. %d chez %s, %s" ..
        " : désenchanté, environ %s en moyenne ; vendu, %s.",
    ["your"] = "toi",
    ["bags"] = "sacs",
    ["Soulbound: no auction house."] = "Lié : pas d'hôtel des ventes.",
    ["Or sell it"] = "Ou le vendre",
    ["Soulbound: the auction house won't take it."] = "Lié : l'hôtel des ventes ne le prendra pas.",
    ["%s each at the auction house (after its cut%s)."] = "%s pièce à l'hôtel des ventes (après sa" ..
        " commission%s).",
    ["%s each at a vendor."] = "%s pièce chez un marchand.",
    ["The auction house counts with 5 or more listed, or however few when you searched it yourself. What made" ..
        " it doesn't count: it's made."] = "L'hôtel des ventes compte à partir de 5 en vente, ou aussi peu que" ..
        " tu veux si tu as cherché toi-même. Ce qui l'a fait ne compte pas : il est fait.",
    ["Buy one for %s; disenchanted, about %s on average: %s"] = "En acheter un pour %s ; désenchanté, environ" ..
        " %s en moyenne : %s",
    ["One disenchant brings more than it cost %d%% of the time."] = "Un désenchantement rapporte plus qu'il" ..
        " n'a coûté dans %d%% des cas.",
    ["Buy it"] = "L'acheter",
    ["The cheapest listing: %s. %s."] = "L'offre la moins chère : %s. %s.",
    ["Its level and quality are Classic's: Forever's client doesn't list it. "] = "Son niveau et sa qualité" ..
        " viennent de Classic : le client de Forever ne les donne pas.",
    ["A random suffix (\"of the Monkey\") doesn't change what it breaks into. The listing may have sold since" ..
        " the scan."] = "Un suffixe aléatoire (\"du singe\") ne change rien à ce en quoi il se défait. L'offre a" ..
        " pu être vendue depuis le scan.",
    ["Nothing to disenchant"] = "Rien à désenchanter",
    ["No character of yours holds anything to disenchant, and "] = "Aucun de tes personnages ne détient quoi" ..
        " que ce soit à désenchanter, et",
    ["none of the recipes they know makes something to disenchant: open a crafting profession's window once so" ..
        " Craft Ladder knows its recipes."] = "aucune des recettes qu'ils connaissent ne fabrique quelque" ..
        " chose à désenchanter : ouvre une fois la fenêtre d'un métier de fabrication pour que Craft Ladder" ..
        " connaisse ses recettes.",
    ["nothing they can make is worth more disenchanted than sold at today's prices."] =
        "rien de ce qu'ils peuvent fabriquer ne vaut plus désenchanté que vendu aux prix d'aujourd'hui.",

    -- Cooking's Food
    [" (Well Fed). "] = " (Bien nourri).",
    ["Needs level %d; you're %d."] = "Il faut le niveau %d ; tu es %d.",
    ["Level %d: you can eat it."] = "Niveau %d : tu peux le manger.",
    ["Any level can eat it."] = "N'importe quel niveau peut le manger.",
    ["Nobody sells its recipe now: look for it at the auction house."] = "Personne ne vend sa recette en ce" ..
        " moment : cherche-la à l'hôtel des ventes.",
    ["No way to learn it for you now (a holiday's, or the other side's)."] = "Pas moyen de l'apprendre pour" ..
        " toi en ce moment (une recette de fête, ou de l'autre camp).",
    ["Learned at %s %d; you have %d."] = "Appris à %s %d ; tu as %d.",
    ["You have %s: cooking it takes them from your bags, so it costs you less than that."] =
        "Tu as %s : la cuisine les prend dans tes sacs, elle te coûte donc moins que ça.",
    ["Or buy it"] = "Ou l'acheter",
    ["One at the auction house: %s."] = "Un à l'hôtel des ventes : %s.",
    ["None listed at the auction house now."] = "Aucun en vente à l'hôtel des ventes en ce moment.",
    ["What it raises is read from the game's files, not checked in game yet."] = "Ce qu'il monte est lu dans" ..
        " les fichiers du jeu, pas encore vérifié en jeu.",

    -- a rank step
    ["At skill %d. Your cap is your level x 5: %d at level %d."] = "À la compétence %d. Ta limite est ton" ..
        " niveau x 5 : %d au niveau %d.",
    ["You're level %d."] = "Tu es niveau %d.",
    ["Your level allows it already."] = "Ton niveau le permet déjà.",
    ["Lockpicking can't go past your level x 5: level up before you go on."] = "Le Crochetage ne peut dépasser" ..
        " ton niveau x 5 : monte de niveau avant de continuer.",
    ["Learn %s%s"] = "Apprendre %s%s",
    ["At skill %d, raises your cap to %d. %s"] = "À la compétence %d, monte ta limite à %d. %s",
    ["Needs character level %d."] = "Il faut le niveau de personnage %d.",
    ["How"] = "Comment",
    ["Only these trainers teach it%s:"] = "Seuls ces maîtres l'enseignent%s :",
    [", for %s"] = ", pour %s",
    ["Any %s trainer teaches it%s."] = "N'importe quel maître (%s) l'enseigne%s.",
    [" for %s"] = " pour %s",
    ["Buy the %s and read it:"] = "Achète %s et lis-le :",
    ["At the auction house: %s."] = "À l'hôtel des ventes : %s.",
    ["Or buy it at the auction house: %s.%s"] = "Ou achète-le à l'hôtel des ventes : %s.%s",
    [" Cheaper than the vendor, so the ladder counts this one."] = " Moins cher que chez le marchand, donc" ..
        " l'échelle compte celui-ci.",
    ["1. Take the quest %s:"] = "1. Prends la quête %s :",
    ["start"] = "début",
    ["2. Bring the ingredients below to %s for %s:"] = "2. Apporte les composants ci-dessous à %s pour %s :",
    ["hand in"] = "remise",
    ["Do the quest %s for %s:"] = "Fais la quête %s chez %s :",
    ["What to bring"] = "Quoi apporter",
    ["Any %s trainer teaches Apprentice %s."] = "N'importe quel maître (%s) enseigne Apprenti (%s).",

    -- fishing
    ["Fish to catch"] = "Quels poissons pêcher",
    ["%s: %s, %s (fish bite from %d)"] = "%s : %s, %s (mordent à partir de %d)",
    ["seen by GatherMate2"] = "vu par GatherMate2",
    ["place known"] = "endroit connu",
    ["places known"] = "endroits connus",
    [" a catch"] = " la prise",
    ["%d - %d catches before it's gone"] = "%d - %d prises avant qu'il disparaisse",
    ["No fish get away here."] = "Ici aucun poisson ne s'échappe.",
    ["About %d%% of casts land a fish here."] = "Ici environ %d%% des lancers ramènent un poisson.",
    ["An hour at skill %d: about %d catches, %s each"] = "Une heure à la compétence %d : environ %d prises, %s" ..
        " pièce",
    [" An hour's catches are worth about %s%s."] = " Les prises d'une heure valent environ %s%s.",
    [", lures paid"] = ", appâts payés",
    ["Skill %d - %d, about %d catches (%s), %s"] = "Compétence %d - %d, environ %d prises (%s), %s",
    [" Catches worth about %s (%s an hour)."] = " Prises valant environ %s (%s de l'heure).",
    ["Craft Ladder's choice here is %s."] = "Le choix de Craft Ladder ici est %s.",
    ["Its creatures are level %d - %d."] = "Ses créatures sont niveau %d - %d.",
    ["Bring"] = "Emporter",
    ["Put %s on your pole: +%d fishing for %d minutes, so no fish get away."] = "Mets %s sur ta canne : +%d en" ..
        " pêche pendant %d minutes, et aucun poisson ne s'échappe.",
    ["Fishing supplies vendors sell lures, in every capital."] = "Les marchands d'articles de pêche vendent" ..
        " des appâts, dans chaque capitale.",
    ["No lure needed: your skill keeps the fish from getting away."] = "Pas d'appât nécessaire : ta compétence" ..
        " empêche déjà les poissons de s'échapper.",
    ["What you catch here"] = "Ce que tu pêches ici",
    ["Fishing pools here"] = "Bancs de poissons ici",
    ["Fish pools when you see them: Craft Ladder counts a third of your catches here from pools. That makes a" ..
        " catch worth %s on average (%s in open water)."] = "Pêche dans les bancs quand tu en vois : Craft" ..
        " Ladder compte ici un tiers de tes prises dans les bancs. Une prise vaut alors %s en moyenne (%s en" ..
        " eau libre).",
    ["No fishing pools known here yet. GatherMate2 adds the ones you fish, and Craft Ladder counts them."] =
        "Aucun banc de poissons connu ici pour l'instant. GatherMate2 ajoute ceux où tu pêches, et Craft" ..
        " Ladder les compte.",
    ["Catches per point: from your %d catches, skill-ups come %d%% as often as Classic's rule says."] =
        "Prises par point : d'après tes %d prises, les points de compétence tombent à %d%% de ce que dit la" ..
        " règle de Classic.",
    ["Catches per point follow Classic's rule (at 150, one point in about 4 catches) until Craft Ladder has" ..
        " counted 50 of your catches (%d so far)."] = "Les prises par point suivent la règle de Classic (à" ..
        " 150, un point en environ 4 prises) jusqu'à ce que Craft Ladder ait compté 50 de tes prises (%d pour" ..
        " l'instant).",
    ["Zones and their fish come from Classic's world: Forever may differ."] = "Les zones et leurs poissons" ..
        " viennent du monde de Classic : Forever peut différer.",
    ["Other zones from %d"] = "Autres zones à partir de %d",
    ["No other zone is open to you here."] = "Aucune autre zone ne t'est ouverte ici.",

    -- skinning and mining
    ["about %d in the zone, %s %s each%s"] = "environ %d dans la zone, %s %s pièce%s",
    [", worth %s"] = ", vaut %s",
    ["needs %d"] = "il faut %d",
    ["%s  %slevel %d%s|r"] = "%s  %sniveau %d%s|r",
    [", seen skinned"] = ", déjà dépecée",
    ["about %d in the zone, needs %d%s"] = "environ %d dans la zone, il faut %d%s",
    [", %s a skin"] = ", %s la peau",
    ["Skin in %s"] = "Dépecer à %s",
    ["An hour at skill %d: about %d creatures, %s each"] = "Une heure à la compétence %d : environ %d" ..
        " créatures, %s pièce",
    ["An hour's skins are worth about %s. Every creature you can skin counts, grey ones too."] =
        "Les peaux d'une heure valent environ %s. Chaque créature que tu peux dépecer compte, les grises" ..
        " aussi.",
    ["Skill %d - %d, about %d creatures%s"] = "Compétence %d - %d, environ %d créatures%s",
    [", trainer %s"] = ", maître %s",
    ["Worth about %s skinned (%s an hour)."] = "Vaut environ %s dépecé (%s de l'heure).",
    ["Skin every creature that still gives a point, of your level or below."] = "Dépèce chaque créature qui" ..
        " donne encore un point, de ton niveau ou en dessous.",
    ["Its creatures are well above your level."] = "Ses créatures sont bien au-dessus de ton niveau.",
    ["Creatures to skin here"] = "Créatures à dépecer ici",
    ["Which creatures can be skinned and what one gives come from Classic; where they are and their levels" ..
        " from QuestieDB's Forever data. The skill one needs is Classic's rule from its level (level x 5 past" ..
        " 20), the colours Mining's (yellow 25, green 50, grey 100 above it). A creature new in Forever counts" ..
        " once you've skinned one."] = "Quelles créatures peuvent être dépecées et ce qu'une donne viennent de" ..
        " Classic ; où elles sont et leur niveau des données Forever de QuestieDB. La compétence demandée est" ..
        " la règle de Classic d'après leur niveau (niveau x 5 au-delà de 20), les couleurs celles de la" ..
        " Minéralogie (jaune 25, vert 50, gris 100 au-dessus). Une créature nouvelle dans Forever compte dès" ..
        " que tu en as dépecé une.",
    ["Gold an hour assumes %d s a creature (kill, loot, skin) and a 60%% mount between them: about %d an hour" ..
        " here."] = "L'or de l'heure compte %d s par créature (tuer, piller, dépecer) et une monture 60%%" ..
        " entre elles : environ %d de l'heure ici.",
    ["Other zones, from %d"] = "Autres zones, à partir de %d",
    ["%s in %s"] = "%s à %s",
    ["An hour at skill %d: about %d %s, %s each"] = "Une heure à la compétence %d : environ %d %s, %s pièce",
    ["An hour's worth about %s. Every %s you can reach counts, grey ones too. Creatures level %d - %d."] =
        "Une heure vaut environ %s. Chaque %s que tu atteins compte, les gris aussi. Créatures niveau %d - %d.",
    ["Skill %d - %d, about %d %s%s"] = "Compétence %d - %d, environ %d %s%s",
    ["Worth about %s (%s an hour). Creatures level %d - %d."] = "Vaut environ %s (%s de l'heure). Créatures" ..
        " niveau %d - %d.",
    ["Creatures level %d - %d. %s every %s that still gives a point."] = "Créatures niveau %d - %d. %s chaque" ..
        " %s qui donne encore un point.",
    ["%s places come from GatherMate2's Forever data; what one gives and how often a rarer kind takes a place," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what one" ..
        " needs): Forever may differ."] = "Les emplacements (%s) viennent des données Forever de GatherMate2 ;" ..
        " ce qu'un donne et à quelle fréquence une sorte plus rare prend un emplacement, de Classic. Les" ..
        " points de compétence suivent les couleurs de Classic (jaune 25, vert 50, gris 100 au-dessus du" ..
        " nécessaire) : Forever peut différer.",
    ["Gold an hour assumes 15 s a %s, a third of the zone's places with one up and a 60%% mount: about %d an" ..
        " hour here."] = "L'or de l'heure compte 15 s par %s, un tiers des emplacements de la zone occupés et" ..
        " une monture 60%% : environ %d de l'heure ici.",
    ["%s: about %d bars%s"] = "%s : environ %d lingots%s",
    [", learn it from a Mining trainer for %s"] = ", apprends-le chez un maître de Minéralogie pour %s",
    ["Nothing you mine here still gives points when smelted."] = "Rien de ce que tu mines ici ne donne encore" ..
        " de points une fois fondu.",
    ["Sell ore or bars"] = "Vendre le minerai ou les lingots",
    ["%s: %s each. Smelting it needs more skill."] = "%s : %s pièce. Le fondre demande plus de compétence.",
    ["sell the ore, smelt it only for the skill-ups"] = "vends le minerai, ne le fonds que pour les points de" ..
        " compétence",
    ["smelt it and sell the bars"] = "fonds-le et vends les lingots",
    [", %s as %s"] = ", %s en %s",
    ["make %s and sell it"] = "fabrique %s et vends-le",
    ["%s: %s as ore, %s as %s%s - %s."] = "%s : %s en minerai, %s en %s%s - %s.",
    ["%s: %s make %d %s, so per ore it's worth one of them; it takes both ores, as much as the scarcer one" ..
        " allows."] = "%s : %s font %d %s, donc par minerai cela vaut l'un d'eux ; il faut les deux minerais," ..
        " autant que le plus rare le permet.",
    ["Nothing mined here can be smelted."] = "Rien de ce qui est miné ici ne peut être fondu.",
    ["Per ore, after the auction house's cut (only what's listed at least 5 times), or what a vendor pays."] =
        "Par minerai, après la commission de l'hôtel des ventes (seulement ce qui est en vente au moins 5" ..
        " fois), ou ce qu'un marchand paie.",
    ["Smelting gives skill-ups too: Craft Ladder counts the ore you mine as smelted, so you mine fewer nodes."] =
        "Fondre donne aussi des points de compétence : Craft Ladder compte le minerai que tu mines comme" ..
        " fondu, tu mines donc moins de filons.",
    ["Node places come from GatherMate2's Forever data; how often rare veins appear and the ore a node gives," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what a node" ..
        " needs): Forever may differ."] = "Les emplacements des filons viennent des données Forever de" ..
        " GatherMate2 ; à quelle fréquence les veines rares apparaissent et combien de minerai un filon donne," ..
        " de Classic. Les points de compétence suivent les couleurs de Classic (jaune 25, vert 50, gris 100" ..
        " au-dessus de ce qu'un filon demande) : Forever peut différer.",
    ["Gold an hour assumes 15 s a node, a third of the zone's node places with a node up and a 60%% mount:" ..
        " about %d nodes an hour here."] = "L'or de l'heure compte 15 s par filon, un tiers des emplacements" ..
        " de la zone occupés et une monture 60%% : environ %d filons de l'heure ici.",
    ["Other zones, or smelting, from %d"] = "Autres zones, ou la fonte, à partir de %d",

    -- Lockpicking
    ["%d a run, needs %d"] = "%d par passage, il faut %d",
    ["about %d in the zone, needs %d"] = "environ %d dans la zone, il faut %d",
    ["Humanoids drop it; the auction house sells it."] = "Tombe des humanoïdes ; l'hôtel des ventes en vend.",
    ["Fished up from pools."] = "Pêchée dans les bancs.",
    ["Engineers make it."] = "Les ingénieurs en fabriquent.",
    ["Pick Pocket humanoids of level %d - %d."] = "Vole à la tire des humanoïdes de niveau %d - %d.",
    ["Pick Pocket humanoids."] = "Vole à la tire des humanoïdes.",
    ["Pick locks in %s"] = "Crocheter des serrures à %s",
    ["Skill %d - %d, about %d locks"] = "Compétence %d - %d, environ %d serrures",
    ["Creatures level %d - %d. Pick every lock that still gives a point: a chest gives one chance, and one" ..
        " more once it's back."] = "Créatures niveau %d - %d. Crochète chaque serrure qui donne encore un" ..
        " point : un coffre donne une chance, et une de plus quand il revient.",
    ["The door round"] = "La tournée des portes",
    ["1. Go into Blackrock Depths (Blackrock Mountain, between Searing Gorge and Burning Steppes)."] =
        "1. Entre dans les Profondeurs de Rochenoire (Mont Rochenoire, entre les Gorges des Vents brûlants et" ..
        " les Steppes ardentes).",
    ["2. Pick the locked doors on the way: the first on the left, through it the next on the right, then the" ..
        " first on the left again; the Shadowforge Lock under the big gear too, if nothing would pull."] =
        "2. Crochète les portes verrouillées en chemin : la première à gauche, derrière elle la suivante à" ..
        " droite, puis de nouveau la première à gauche ; et la Serrure de Forge-de-l'ombre sous le grand" ..
        " engrenage, si rien ne vient.",
    ["3. Leave, right-click your portrait, Reset all instances and go in again: the game lets you in 5 times" ..
        " an hour."] = "3. Sors, clic droit sur ton portrait, Réinitialiser toutes les instances et rentre :" ..
        " le jeu te laisse entrer 5 fois par heure.",
    ["The round is zockify's Forever guide's: about 4 doors a run."] = "La tournée vient du guide Forever de" ..
        " zockify : environ 4 portes par passage.",
    ["Where"] = "Où",
    ["Most %ss are around here"] = "La plupart des (%s) sont par ici",
    ["Chest places: GatherMate2's and QuestieDB's Forever data. Which lock a chest needs, and the colours" ..
        " (yellow 25, green 50, grey 100 above it), are Classic's: Forever may differ."] =
        "Emplacements des coffres : données Forever de GatherMate2 et QuestieDB. Quelle serrure un coffre" ..
        " demande, et les couleurs (jaune 25, vert 50, gris 100 au-dessus), viennent de Classic : Forever peut" ..
        " différer.",
    ["Other zones, or boxes, from %d"] = "Autres zones, ou boîtes, à partir de %d",
    ["Pick %s"] = "Crocheter %s",
    ["Skill %d - %d, about %d boxes, %s"] = "Compétence %d - %d, environ %d boîtes, %s",
    ["Pick the ones in your bags: you have %d."] = "Crochète celles de tes sacs : tu en as %d.",
    ["Boxes to buy: %s"] = "Boîtes à acheter : %s",
    ["A box gives one chance at a point, and what's inside is yours."] = "Une boîte donne une chance d'avoir" ..
        " un point, et ce qu'il y a dedans est à toi.",
    ["Or pick locks in a zone, from %d"] = "Ou crocheter des serrures dans une zone, à partir de %d",
    ["Every lock a rogue picks, by the skill it needs; its colour at your %d."] = "Chaque serrure qu'un voleur" ..
        " crochète, selon la compétence demandée ; sa couleur à tes %d.",
    ["Orange always gives a point, yellow mostly, green sometimes, grey never."] = "L'orange donne toujours un" ..
        " point, le jaune presque toujours, le vert parfois, le gris jamais.",
    ["Chests in the world"] = "Coffres dans le monde",
    ["Boxes from your bags"] = "Boîtes de tes sacs",
    ["You have %d."] = "Tu en as %d.",
    [" %s at the auction house."] = " %s à l'hôtel des ventes.",
    ["Dungeon doors"] = "Portes de donjon",
    ["%s: %d locked doors, from %d (%s)."] = "%s : %d portes verrouillées, à partir de %d (%s).",
    ["Getting started"] = "Pour commencer",
    ["Pick Lock: any rogue trainer, from level 16, for %s. It needs Thieves' Tools in your bags (rogue" ..
        " supplies vendors, 15s). Your cap is your level x 5."] = "Crochetage : n'importe quel maître voleur," ..
        " à partir du niveau 16, pour %s. Il faut des Outils de voleur dans tes sacs (marchands de fournitures" ..
        " de voleur, 15p). Ta limite est ton niveau x 5.",

    -- the cards with nothing to show, and the rest
    ["Nothing earns now"] = "Rien ne rapporte en ce moment",
    ["Nothing you can make sells for more than it costs at today's prices."] = "Rien de ce que tu peux" ..
        " fabriquer ne se vend plus cher que son coût aux prix d'aujourd'hui.",
    ["Nothing you can get here has a price yet: Craft Ladder needs auction house prices."] =
        "Rien de ce que tu obtiens ici n'a encore de prix : Craft Ladder a besoin des prix de l'hôtel des" ..
        " ventes.",
    ["Nothing to do here"] = "Rien à faire ici",
    ["You've reached %d %s."] = "Tu as atteint %d en %s.",
    ["No recipe found for your skill."] = "Aucune recette trouvée pour ta compétence.",
    [", Working Overtime %d/5: +%d%%"] = ", Heures supplémentaires %d/5 : +%d%%",

    -- what the data itself says on a rank card (Professions.lua, Data/*.lua)
    ["Your class quests at 16"] = "Tes quêtes de classe à 16",
    ["They lead to the first practice chests and give you Thieves' Tools. Pick Lock itself is learned from any" ..
        " rogue trainer, quest or not."] = "Elles mènent aux premiers coffres d'entraînement et te donnent des" ..
        " Outils de voleur. Le Crochetage lui-même s'apprend chez n'importe quel maître voleur, avec ou sans" ..
        " quête.",
    ["Your class quests at 20"] = "Tes quêtes de classe à 20",
    ["The last one teaches Poisons (and Recipe: Thistle Tea). On the way you pick a lock: Lockpicking 70 for" ..
        " the Alliance's Duskwood Chest, 80 for the Horde's Gallywix's Lockbox (Classic's numbers, not" ..
        " confirmed in Forever)."] = "La dernière enseigne les Poisons (et la Recette : thé de chardon). En" ..
        " chemin tu crochètes une serrure : Crochetage 70 pour le Coffre de Bois-de-la-Nuit de l'Alliance, 80" ..
        " pour le Coffret de Gallywix de la Horde (chiffres de Classic, non confirmés dans Forever).",
    ["Bring 12 Giant Egg, 10 Zesty Clam Meat and 20 Alterac Swiss to Dirge Quikcleave in Gadgetzan."] =
        "Apporte 12 Œuf géant, 10 Chair de palourde épicée et 20 Gruyère d'Alterac à Dirge Lebonbec à" ..
        " Gadgetzan.",
    ["Catch the four fish below and bring them to Nat Pagle; he then teaches Artisan Fishing for 1g."] =
        "Pêche les quatre poissons ci-dessous et apporte-les à Nat Pagle ; il enseigne alors la Pêche" ..
        " (artisan) pour 1p.",
    ["Hank the Hammer's (Alliance) or Aturk the Anvil's (Horde) quests lead to Galvan the Ancient and Trenton" ..
        " Lighthammer, whose quests teach the Ornate Mithril recipes the last quest asks for. Buy those 7" ..
        " items at the auction house and you can skip them."] = "Les quêtes de Hank le Marteau (Alliance) ou" ..
        " d'Aturk l'Enclume (Horde) mènent à Galvan l'Ancien et Trenton Marteaufin, dont les quêtes enseignent" ..
        " les recettes en mithril ouvragé que la dernière quête demande. Achète ces 7 objets à l'hôtel des" ..
        " ventes et tu peux les sauter.",
    ["It gives you a letter to hand in."] = "Elle te donne une lettre à remettre.",
    ["Right-click the pledge it gives you: that completes it."] = "Clic droit sur le serment qu'elle te donne" ..
        " : cela la termine.",
    ["Save 15 wounded soldiers with the Triage Bandages the doctor gives you, before 6 of them die."] =
        "Sauve 15 soldats blessés avec les Bandages de secours que le médecin te donne, avant que 6 d'entre" ..
        " eux meurent.",
    ["Then learn the mastery from the trainer who gave you the quest."] = "Apprends ensuite la maîtrise chez" ..
        " le maître qui t'a donné la quête.",

    -- Buy or craft: the bar over the list, its groups, its rows and its card
    [", %s an item"] = ", %s par pièce",
    ["No price for one of the two sides yet."] = "Pas encore de prix pour l'un des deux côtés.",
    ["Cheaper to make: one craft saves %s%s."] = "Moins cher à fabriquer : une fabrication économise %s%s.",
    ["Cheaper to buy: making it costs %s more%s."] = "Moins cher à acheter : fabriquer coûte %s de plus%s.",
    ["The same either way at today's prices."] = "Aux prix d'aujourd'hui, c'est pareil dans les deux cas.",
    ["Make %s, buy %s%s"] = "Fabriquer %s, acheter %s%s",
    [" (one craft makes %d)"] = " (une fabrication en fait %d)",
    ["%s has no price: Craft Ladder can't say what a craft costs. Search the auction house for it, or scan" ..
        " again."] = "%s n'a pas de prix : Craft Ladder ne peut pas dire ce que coûte une fabrication." ..
        " Cherche-le à l'hôtel des ventes, ou rescanne.",
    ["Nothing says what %s costs to buy: nobody lists it, no vendor sells it, or it's soulbound (made only," ..
        " never bought)."] = "Rien ne dit ce que %s coûte à l'achat : personne ne le met en vente, aucun" ..
        " marchand ne le vend, ou il est lié à l'âme (fabriqué seulement, jamais acheté).",
    ["%d listed at the auction house now."] = "%d en vente à l'hôtel des ventes en ce moment.",
    ["Making it needs %s %d, and yours is %d."] = "Pour la fabriquer il faut %s %d, et le tien est %d.",
    ["You have %s: they're priced here all the same, since you could sell them instead."] =
        "Tu as %s : ils sont quand même comptés à leur prix ici, puisque tu pourrais les vendre à la place.",
    ["Nothing matches"] = "Rien ne correspond",
    ["Nothing here is called %s."] = "Rien ici ne s'appelle %s.",
    ["Favor (%d)"] = "Faveur (%d)",
    ["Buy or craft (%d)"] = "Acheter/fabriquer (%d)",
    ["%d recipes here, %d cheaper to make than to buy (one craft, at today's prices)"] =
        "%d recettes ici, %d moins chères à fabriquer qu'à acheter (une fabrication, aux prix d'aujourd'hui)",
    ["Buy or craft"] = "Acheter ou fabriquer",
    ["Every recipe of this profession: what one craft's ingredients cost at today's prices against what buying" ..
        " the thing itself costs. The ones you know come first."] = "Chaque recette de ce métier : ce que" ..
        " coûtent les composants d'une fabrication aux prix d'aujourd'hui, face au prix de l'objet lui-même." ..
        " Celles que tu connais d'abord.",
    ["search"] = "rechercher",
    ["Type part of a name: the rows left are the ones that make something of that name. Escape clears it."] =
        "Tape une partie d'un nom : il reste les lignes qui fabriquent quelque chose de ce nom. Échap" ..
        " l'efface.",
    ["Recipes you know"] = "Recettes que tu connais",
    ["Not known yet"] = "Pas encore connues",
    ["What you can make now, by the skill it's learned at. Click to fold or open."] =
        "Ce que tu peux fabriquer maintenant, selon la compétence à laquelle on l'apprend. Clic pour plier ou" ..
        " déplier.",
    ["The rest of the profession's recipes: what each would cost to make, and how to learn it. Click to fold" ..
        " or open."] = "Les autres recettes du métier : ce que chacune coûterait à fabriquer, et comment" ..
        " l'apprendre. Clic pour plier ou déplier.",

    -- The splitter between the list and the step's details
    ["List width"] = "Largeur de la liste",
    ["Drag it: the list takes the room and the step's details give it, down to as much as they need to be" ..
        " read."] = "Tire-le : la liste prend la place et les détails la cèdent, jusqu'à ce qu'il leur faut" ..
        " pour rester lisibles.",
}
