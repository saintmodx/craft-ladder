-- Craft Ladder in Spanish. The key is the English string as it stands in the code; what's missing here is shown in
-- English. Item, recipe and zone names come from the game itself, so they are not here.
-- The %s and %d of a line must stay in the same order as in the English one: the game fills them in that order.
local _, ns = ...

ns.Locales = ns.Locales or {}
ns.Locales.esES = {
    -- the auction house tab
    ["The items' names are still loading: click again."] = "Los nombres de los objetos aún se están cargando:" ..
        " haz clic otra vez.",
    ["Stop"] = "Parar",
    ["Full Rescan"] = "Reescanear todo",
    ["Scanning %s: %d of %d items."] = "Escaneando %s: %d de %d objetos.",
    ["the auction house"] = "la casa de subastas",
    ["Scan done: %d of %d items searched."] = "Escaneo terminado: %d de %d objetos encontrados.",
    ["A scan is already running: stop it first."] = "Ya hay un escaneo en marcha: párralo primero.",
    ["Nothing to scan here."] = "Aquí no hay nada que escanear.",
    ["Scanning %s: 0 of %d items."] = "Escaneando %s: 0 de %d objetos.",
    ["this step"] = "este paso",
    ["Confirm %s"] = "Comprar por %s",
    ["Asking..."] = "Preguntando...",
    ["Buying %d %s..."] = "Comprando %d %s...",
    ["The auction house is busy: try again in a moment."] = "La casa de subastas está ocupada: inténtalo de" ..
        " nuevo en un momento.",
    ["Asking the price of %d %s..."] = "Preguntando el precio de %d %s...",
    ["Scan"] = "Escanear",
    ["Asks the auction house what this one goes for now, and puts that price in the ladder. However fresh the" ..
        " price already is."] = "Pregunta a la casa de subastas cuánto vale este ahora y pone ese precio en la" ..
        " escalera. Por fresco que ya sea el precio.",
    ["Asks the auction house about what this step makes and everything it takes, then puts those prices in the" ..
        " ladder."] = "Pregunta a la casa de subastas por lo que fabrica este paso y por todo lo que lleva, y" ..
        " pone esos precios en la escalera.",
    ["Search"] = "Buscar",
    ["Auctionator's Shopping tab with what this step buys, and how many."] = "La pestaña de Compras de" ..
        " Auctionator con lo que compra este paso, y cuántos.",
    ["Learn %s"] = "Aprender %s",
    ["at %d, raises your cap to %d"] = "en %d, sube tu límite a %d",
    ["%s%s|r a craft, %s"] = "%s%s|r por fabricación, %s",
    ["sold to a vendor"] = "vendido a un vendedor",
    ["%d listed"] = "%d en venta",
    ["%d - %d, ~%d %s%s"] = "%d - %d, ~%d %s%s",
    [", %d listed"] = ", %d en venta",
    ["at %d, make one and keep it"] = "en %d, fabrica uno y guárdalo",
    ["nothing to buy"] = "nada que comprar",
    ["need %d, you have %d"] = "necesitas %d, tienes %d",
    ["%s each"] = "%s cada uno",
    ["not listed"] = "no está en venta",
    ["No crafting profession: nothing to buy for one."] = "Sin profesión de fabricación: nada que comprar para" ..
        " una.",
    ["%s: nothing to buy"] = "%s: nada que comprar",
    ["Scan stopped: the prices it had got are in."] = "Escaneo parado: los precios que consiguió están dentro.",
    ["Nothing here to rescan."] = "Aquí no hay nada que reescanear.",
    ["Every price here was searched in the last two minutes: nothing to ask again."] =
        "Todos los precios de aquí se buscaron en los últimos dos minutos: no hay nada que volver a preguntar.",
    ["Scanning the auction house: 0 of %d items."] = "Escaneando la casa de subastas: 0 de %d objetos.",
    ["Searches the auction house for everything this list buys and sells, then puts the prices in the ladder." ..
        " It goes one item at a time, as the server allows: watch the line below. An item searched in the last" ..
        " two minutes is left alone."] = "Busca en la casa de subastas todo lo que esta lista compra y vende," ..
        " y pone los precios en la escalera. Va de un objeto en uno, según permite el servidor: mira la línea" ..
        " de abajo. Un objeto buscado en los últimos dos minutos se deja estar.",
    ["Crafts"] = "Fabricaciones",
    ["A click on a step or a reagent searches it in Auctionator's Shopping tab."] = "Un clic en un paso o en" ..
        " un reactivo lo busca en la pestaña de Compras de Auctionator.",
    ["Craft Ladder"] = "Craft Ladder",
    ["%d %s for %s (%s each): click Confirm to buy."] = "%d %s por %s (%s cada uno): haz clic en Comprar.",
    ["No price for %s: not enough listed, or not sold that way (try the Buy tab)."] =
        "Sin precio para %s: no hay bastantes en venta, o no se vende así (prueba la pestaña de Compra).",
    ["Bought %d %s."] = "%d %s comprados.",
    ["The purchase failed (the price may have changed): ask again."] = "La compra ha fallado (el precio puede" ..
        " haber cambiado): pregunta otra vez.",

    -- the camp view
    ["No profession"] = "Sin profesión",
    [" (skill %d)"] = " (habilidad %d)",
    ["you know it"] = "lo conoces",
    ["you can learn it"] = "puedes aprenderlo",
    ["not your profession"] = "no es tu profesión",
    ["%d in your bags"] = "%d en tus bolsas",
    ["needs %s"] = "necesita %s",
    ["make %s"] = "fabricar %s",
    ["no price"] = "sin precio",
    ["AH %s"] = "CS %s",
    ["  (not with %s)"] = "  (no con %s)",
    ["Or, the same buff and more: %s"] = "O lo mismo y más: %s",
    ["Camp: the buffs a campfire gives, for a level %d %s"] = "Campamento: las mejoras de una hoguera, para el" ..
        " nivel %d, %s",
    ["Holds %d camp features. %s; %s."] = "Admite %d estructuras de campamento. %s; %s.",
    ["A %s holds %d: the ones above. Then:"] = "Un %s admite %d: las de arriba. Luego:",
    ["Doesn't help a %s"] = "No ayuda a un %s",
    ["Camp features with no buff"] = "Estructuras de campamento sin mejora",
    ["Build a campfire, place camp features around it and sit or craft nearby for a while: each feature gives" ..
        " everyone there its buff. A campfire holds only so many: here they are in the order your role wants" ..
        " them."] = "Haz una hoguera, pon estructuras alrededor y siéntate o trabaja cerca un rato: cada" ..
        " estructura da su mejora a todos los que estén allí. Una hoguera solo admite unas cuantas: aquí están" ..
        " en el orden que quiere tu rol.",
    ["Campfire:"] = "Hoguera:",

    -- the characters' buttons
    ["Level %d %s"] = "Nivel %d %s",
    ["Playing now"] = "Jugando ahora",
    ["Last seen %s"] = "Visto por última vez %s",

    -- the menu
    ["Show the %s ladder."] = "Mostrar la escalera de %s.",
    ["not learned"] = "no aprendido",
    ["Disenchant"] = "Desencantar",
    ["Camp"] = "Campamento",
    ["What's worth disenchanting on your whole account: what every character's bags and bank hold, what the" ..
        " auction house lists for less than disenchanting it brings, and what your crafting professions make" ..
        " that's worth more disenchanted than sold."] = "Lo que merece la pena desencantar en toda tu cuenta:" ..
        " lo que llevan las bolsas y el banco de cada personaje, lo que la casa de subastas ofrece por menos" ..
        " de lo que da desencantarlo, y lo que tus profesiones fabrican que vale más desencantado que vendido.",
    ["What each camp feature gives around a campfire, in the order your role wants them, and how to get it."] =
        "Lo que da cada estructura de campamento alrededor de una hoguera, en el orden que quiere tu rol, y" ..
        " cómo conseguirla.",

    -- the minimap button
    ["Earns most"] = "Da más",
    ["%s, %s an hour"] = "%s, %s por hora",
    ["Now"] = "Ahora",
    ["%s in %s to %d"] = "%s en %s hasta %d",
    ["fish"] = "pescar",
    ["mine"] = "minar",
    ["catches"] = "capturas",
    ["nodes"] = "filones",
    ["%s to %d"] = "%s hasta %d",
    ["~%d crafts, %s"] = "~%d fabricaciones, %s",
    ["Eat"] = "Comer",
    ["%s, +%s a craft"] = "%s, +%s por fabricación",
    ["reach level %d"] = "llegar a nivel %d",
    ["learn %s"] = "aprender %s",
    ["Up to %d"] = "Hasta %d",
    ["Prices"] = "Precios",
    ["Click: open or close the window"] = "Clic: abrir o cerrar la ventana",
    ["Drag: move the button"] = "Arrastrar: mover el botón",
    ["minimap button hidden - /craft minimap shows it again."] = "botón del minimapa oculto - /craft minimap" ..
        " lo muestra otra vez.",
    ["minimap button shown."] = "botón del minimapa visible.",

    -- the Settings menu
    ["Auction house prices from"] = "Precios de la casa de subastas de",
    ["Its last full scan of your faction's auction house: the lowest price, the median and how many are" ..
        " listed."] = "Su último escaneo completo de la casa de subastas de tu facción: el precio más bajo, la" ..
        " mediana y cuántos hay en venta.",
    ["Its last scan. It gives one price per item, so the median is that price."] = "Su último escaneo. Da un" ..
        " solo precio por objeto, así que la mediana es ese precio.",
    ["An ingredient costs"] = "Un reactivo cuesta",
    ["The median listed price"] = "El precio mediano en venta",
    ["Half of what's listed costs less. The cheapest listing is one auction, often gone minutes after the" ..
        " scan."] = "La mitad de lo que está en venta cuesta menos. La oferta más barata es una sola subasta," ..
        " que a menudo desaparece minutos después del escaneo.",
    ["The cheapest listing"] = "La oferta más barata",
    ["What the ladder cost before: the lowest price of the scan. Cheaper than what you will really pay, unless" ..
        " you are quick."] = "Lo que la escalera contaba antes: el precio más bajo del escaneo. Más barato de" ..
        " lo que pagarás de verdad, salvo que seas rápido.",
    ["Language"] = "Idioma",
    ["Craft Ladder's own words. Item, recipe and zone names come from your game client, in its language. A few" ..
        " buttons take a /reload to change."] = "Las palabras de Craft Ladder. Los nombres de objetos, recetas" ..
        " y zonas vienen de tu cliente de juego, en su idioma. Unos pocos botones necesitan un /reload.",
    ["What you sell is always priced at the cheapest listing, the one you undercut."] =
        "Lo que vendes se cuenta siempre a la oferta más barata, la que rebajas.",
    ["%s isn't installed: %s is read."] = "%s no está instalado: se lee %s.",
    ["Neither addon is installed: no auction house prices."] = "Ninguno de los dos addons está instalado: sin" ..
        " precios de la casa de subastas.",

    -- the Specialization view
    ["%s%d / %d|r  %s"] = "%s%d / %d|r  %s",
    ["level %d (you're %d)"] = "nivel %d (tú tienes %d)",
    ["%s %d (you have %d)"] = "%s %d (tú tienes %d)",
    ["Needs %s."] = "Necesita %s.",
    [" and "] = " y",
    ["Or take it here instead:"] = "O cógelo aquí en su lugar:",
    ["Take the quest:"] = "Coge la misión:",
    ["Take and hand in the quest:"] = "Coge y entrega la misión:",
    ["Hand it in:"] = "Entrégala:",
    ["you have them all"] = "los tienes todos",
    ["auction house %s"] = "casa de subastas %s",
    ["none at the auction house"] = "nada en la casa de subastas",
    ["Make %d; some of its ingredients have no price; %s"] = "Fabrica %d; algunos de sus reactivos no tienen" ..
        " precio; %s",
    ["Make %d for %s; %s"] = "Fabrica %d por %s; %s",
    ["Buy %d: %s%s"] = "Compra %d: %s%s",
    [", making them costs %s"] = ", fabricarlos cuesta %s",
    ["Drops from %s"] = "Lo sueltan %s",
    ["Drops from %d kinds of creatures; "] = "Lo sueltan %d clases de criaturas;",
    ["none at the auction house now"] = "nada en la casa de subastas ahora",
    [", learned at %d"] = ", aprendido en %d",
    ["its recipe drops from %d kinds of creatures, none at the auction house now"] = "su receta la sueltan %d" ..
        " clases de criaturas, nada en la casa de subastas ahora",
    ["no way to learn it for you now"] = "ahora no hay forma de que lo aprendas",
    ["Buy the recipe:"] = "Compra la receta:",
    ["Learn it from the trainer:"] = "Apréndela del maestro:",
    ["Bring to %s:"] = "Lleva a %s:",
    ["the quest giver"] = "al que da la misión",
    ["%s%d %s%s"] = "%s%d %s%s",
    ["smelt "] = "fundir",
    [" (besides the %d you have)"] = " (además de los %d que tienes)",
    ["Make: %s"] = "Fabricar: %s",
    ["Ingredients:"] = "Reactivos:",
    ["buy %d: "] = "compra %d:",
    ["the smith"] = "al herrero",
    ["%d. Talk to %s"] = "%d. Habla con %s",
    ["Talk to:"] = "Habla con:",
    ["%d. Master a weapon: one of them"] = "%d. Domina un arma: una de ellas",
    ["%s: the quest %s"] = "%s: la misión %s",
    ["The recipes"] = "Las recetas",
    ["  %d to learn"] = "  %d por aprender",
    ["Click to fold or open."] = "Clic para plegar o desplegar.",
    ["Show the steps to %s."] = "Mostrar los pasos hacia %s.",
    ["You have this specialization."] = "Tienes esta especialización.",
    ["Needs level %d and %s %d; you're level %d with %d."] = "Necesita nivel %d y %s %d; tú eres nivel %d con" ..
        " %d.",
    ["Unlocks %d recipes only this specialization can learn."] = "Desbloquea %d recetas que solo esta" ..
        " especialización puede aprender.",
    ["You have %s: a character can have only one %s specialization."] = "Tienes %s: un personaje solo puede" ..
        " tener una especialización de %s.",
    ["Still to spend: %s, each item made or bought, whichever costs less%s."] = "Aún por gastar: %s, cada" ..
        " objeto fabricado o comprado, lo que cueste menos%s.",
    ["; some have no price"] = "; algunos no tienen precio",
    ["You have %s"] = "Tienes %s",
    ["To %s: about %s%s"] = "Hasta %s: unos %s%s",
    [", some items unpriced"] = ", algunos objetos sin precio",

    -- the window: the list, its rows and their tooltips
    [" - %s%s %d|r"] = " - %s%s %d|r",
    ["%d days"] = "%d días",
    ["%d hours"] = "%d horas",
    ["~%d min"] = "~%d min",
    ["All locks"] = "Todas las cerraduras",
    ["Every lock a rogue picks, by the skill it needs, and its colour for you."] = "Cada cerradura que fuerza" ..
        " un pícaro, por la habilidad que pide y su color para ti.",
    ["At %d your cap is the level x 5: %d at level %d."] = "En %d tu límite es tu nivel x 5: %d a nivel %d.",
    ["at %d, cap %d"] = "en %d, límite %d",
    ["Skill"] = "Habilidad",
    ["Smelt on the way"] = "Fundir por el camino",
    ["Trainer"] = "Maestro",
    ["Catches"] = "Capturas",
    ["Lure"] = "Cebo",
    ["none"] = "ninguno",
    ["Cost"] = "Coste",
    ["In your bags"] = "En tus bolsas",
    [", soulbound"] = ", ligado",
    ["One craft"] = "Una fabricación",
    ["Disenchanted"] = "Desencantado",
    ["Sold"] = "Vendido",
    [" at the auction house"] = " en la casa de subastas",
    [" at a vendor"] = " a un vendedor",
    ["nobody buys it"] = "nadie lo compra",
    ["Best"] = "Lo mejor",
    ["Disenchanting one craft"] = "Desencantar una fabricación",
    ["Cheapest listing"] = "Oferta más barata",
    ["Gains"] = "Da",
    [", more %d%% of the time"] = ", más el %d%% de las veces",
    ["Raises"] = "Sube",
    ["Cook one"] = "Cocinar uno",
    ["Buy one"] = "Comprar uno",
    ["Sells for"] = "Se vende por",
    ["Profit"] = "Beneficio",
    ["Listed"] = "En venta",
    ["%d - %d, ~%d %s"] = "%d - %d, ~%d %s",
    ["%s of ~%d, from what you have (vendor reagents aside)"] = "%s de ~%d, con lo que tienes (aparte de los" ..
        " reactivos de vendedor)",
    ["%slvl %d|r - "] = "%snvl %d|r -",
    ["known, make %d now"] = "conocida, fabrica %d ahora",
    ["learn now (skill %d)"] = "aprender ahora (habilidad %d)",
    ["skill %d (you %d)"] = "habilidad %d (tú %d)",
    ["level %d (you %d)"] = "nivel %d (tú %d)",
    ["%s ready"] = "%s listo",
    ["chests, boxes and doors by skill"] = "cofres, cajas y puertas por habilidad",
    ["Reach level %d"] = "Llegar a nivel %d",
    ["at %d, raises your cap to %d%s"] = "en %d, sube tu límite a %d%s",
    ["Fish in %s"] = "Pescar en %s",
    ["your pick"] = "tu elección",
    ["an hour: ~%d catches, %s each%s%s"] = "una hora: ~%d capturas, %s cada una%s%s",
    ["%d - %d, ~%d catches%s"] = "%d - %d, ~%d capturas%s",
    ["%s%s, %s%s%s%s%s%s"] = "%s%s, %s%s%s%s%s%s",
    ["%s, %s, disenchanted ~%s, sold %s"] = "%s, %s, desencantado ~%s, vendido %s",
    ["%s's %s - %s: ~%s disenchanted, %s sold%s"] = "%s, %s - %s: ~%s desencantado, %s vendido%s",
    ["buy %s, ~%s disenchanted, pays %d%% of the time"] = "compra %s, ~%s desencantado, sale a cuenta el" ..
        " %d%% de las veces",
    ["%d - %d%s: %s"] = "%d - %d%s: %s",
    ["keep them"] = "guárdalos",
    ["unconfirmed"] = "sin confirmar",
    ["after %d%s, %sneeded for %s|r"] = "tras %d%s, %snecesario para %s|r",
    ["%s%s, %smake one and keep it|r"] = "%s%s, %sfabrica uno y guárdalo|r",
    ["%d favor"] = "%d favor",
    ["? favor"] = "? favor",
    ["Open your %s window once so Craft Ladder knows which recipes you have."] = "Abre tu ventana de %s una" ..
        " vez para que Craft Ladder sepa qué recetas tienes.",
    ["No %s found past %d with what Craft Ladder knows."] = "No se ha encontrado ningún %s pasado %d con lo" ..
        " que Craft Ladder conoce.",
    ["zone"] = "zona",
    ["recipe"] = "receta",
    ["Back to your ladder"] = "Volver a tu escalera",
    ["Merchant's Favor recipes (%d)"] = "Recetas de Favor del mercader (%d)",
    ["Dishes for this role, by what eating one raises. Click to fold or open."] = "Platos para este rol, por" ..
        " lo que sube comer uno. Clic para plegar o desplegar.",
    ["Nothing here"] = "Aquí no hay nada",
    ["Nothing earns this way at today's prices."] = "Nada da beneficio así a los precios de hoy.",
    ["Sell to a vendor"] = "Vender a un vendedor",
    ["These cost less to make than a vendor pays: vendors buy any number, no auction house needed. Click to" ..
        " fold or open."] = "Estos cuestan menos de fabricar de lo que paga un vendedor: los vendedores" ..
        " compran cualquier cantidad, sin casa de subastas. Clic para plegar o desplegar.",
    ["Sell at the auction house"] = "Vender en la casa de subastas",
    ["These earn more at the auction house: 5 or more listed (or however few when you searched it yourself)," ..
        " and it pays 1.5 times what a vendor does. How many sell, the auction house doesn't say."] =
        "Estos dan más en la casa de subastas: 5 o más en venta (o los que sean si lo has buscado tú mismo), y" ..
        " paga 1,5 veces lo que da un vendedor. Cuántos se venden, la casa de subastas no lo dice.",
    ["nothing at today's prices"] = "nada a los precios de hoy",
    ["Disenchant, your whole account: Enchanting 1 disenchants anything"] = "Desencantar, toda tu cuenta: Encantamiento 1 desencanta cualquier cosa",
    ["the ladder from %d to %d"] = "la escalera de %d a %d",
    ["the ladder to %d"] = "la escalera hasta %d",
    ["%s%s %d / %d, %s%s"] = "%s%s %d / %d, %s%s",
    ["as of %s"] = "a fecha de %s",
    ["%s has no %s yet"] = "%s aún no tiene %s",
    ["No %s yet"] = "Aún no hay %s",
    ["Specialization"] = "Especial.",
    ["Skill %d"] = "Habilidad %d",
    ["No auction house prices: AuctionDB or Auctionator needed"] = "Sin precios de la casa de subastas: hace" ..
        " falta AuctionDB o Auctionator",
    [" %s prices scanned %s, costs may be off: scan at the auction house|r"] = " Precios de %s escaneados %s," ..
        " los costes pueden fallar: escanea en la casa de subastas|r",
    ["%s prices scanned %s: scan at the auction house|r"] = "Precios de %s escaneados %s: escanea en la casa" ..
        " de subastas|r",
    ["Prices: %s, scanned %s (%s)|r"] = "Precios: %s, escaneados %s (%s)|r",
    ["today"] = "hoy",
    ["yesterday"] = "ayer",
    ["%d days ago"] = "hace %d días",
    ["Prices: Auctionator, newest prices from %s|r"] = "Precios: Auctionator, precios más nuevos de %s|r",
    ["Prices: %s"] = "Precios: %s",
    ["%d Merchant's Favor recipes, %d you can learn now%s"] = "%d recetas de Favor del mercader, %d que puedes" ..
        " aprender ahora%s",
    ["; you have %d favor"] = "; tienes %d de favor",
    ["%d dishes for your class; the cost is one dish from bought ingredients"] = "%d platos para tu clase; el" ..
        " coste es un plato con reactivos comprados",
    ["%d zones at skill %d; the best about %s an hour"] = "%d zonas con habilidad %d; la mejor unos %s por" ..
        " hora",
    ["Spend %s, catch about %s worth (%s, %s an hour)"] = "Gasta %s, pesca unos %s de valor (%s, %s por hora)",
    ["Spend %s, %s about %s worth (%s an hour), about %d %s"] = "Gasta %s, %s unos %s de valor (%s por hora)," ..
        " unos %d %s",
    ["%s%d at the auction house; the best +%s a craft"] = "%s%d en la casa de subastas; el mejor +%s por" ..
        " fabricación",
    ["Total %s, about %d %s%s"] = "Total %s, unas %d %s%s",
    ["Total %s, about %d catches (%s)"] = "Total %s, unas %d capturas (%s)",
    ["Spend %s, about %s back from sales, about %d crafts"] = "Gasta %s, unos %s de vuelta por las ventas," ..
        " unas %d fabricaciones",
    ["Total %s, about %d crafts"] = "Total %s, unas %d fabricaciones",
    ["Plan the ladder to %d."] = "Planear la escalera hasta %d.",
    ["Window size"] = "Tamaño de la ventana",
    ["Drag: make the window bigger."] = "Arrastrar: hacer la ventana más grande.",
    ["Ctrl + mouse wheel: bigger or smaller text (now %d%%)."] = "Ctrl + rueda del ratón: texto más grande o" ..
        " más pequeño (ahora %d%%).",
    ["Right-click: back to the normal size."] = "Clic derecho: volver al tamaño normal.",
    ["Close"] = "Cerrar",
    ["Escape closes it too."] = "Escape también la cierra.",
    ["Settings"] = "Ajustes",
    ["Which auction house addon the prices are read from, and which of its listed prices an ingredient costs."] =
        "De qué addon de casa de subastas se leen los precios, y cuál de sus precios en venta cuesta un" ..
        " reactivo.",
    ["Your hands are idle, adventurer."] = "Tus manos están ociosas, aventurero.",
    ["The trainers are waiting: learn a profession."] = "Los maestros esperan: aprende una profesión.",
    ["The steps to each of its specializations: the quests, what they ask for and what you have of it, the" ..
        " recipes, and what's still to make or buy."] = "Los pasos hacia cada una de sus especializaciones:" ..
        " las misiones, lo que piden y lo que tienes de ello, las recetas, y lo que queda por fabricar o" ..
        " comprar.",
    ["Merchant's Favor recipes"] = "Recetas de Favor del mercader",
    ["What the supply camps' quartermaster sells for Merchant's Favor: its price and level (seen at a" ..
        " quartermaster), your skill, what you know and can make."] = "Lo que el intendente de los campamentos" ..
        " de suministros vende por Favor del mercader: su precio y nivel (vistos en un intendente), tu" ..
        " habilidad, lo que conoces y puedes fabricar.",
    ["Back to cheapest"] = "Volver a la más barata",
    ["Use the cheapest recipe for this step again."] = "Usar otra vez la receta más barata para este paso.",
    ["Search the auction house"] = "Buscar en la casa de subastas",
    ["Auctionator's Shopping tab with this item. The auction house must be open."] = "La pestaña de Compras de" ..
        " Auctionator con este objeto. La casa de subastas debe estar abierta.",
    ["Also use recipes bought with Merchant's Favor."] = "Usar también recetas compradas con Favor del" ..
        " mercader.",
    ["Reset"] = "Reiniciar",
    ["The ladder from your skill to 300 again."] = "La escalera desde tu habilidad hasta 300 otra vez.",
    ["No profession yet"] = "Aún sin profesión",

    -- the menu's group headings
    ["PROFESSIONS"] = "PROFESIONES",
    ["SECONDARY"] = "SECUNDARIAS",
    ["CLASS"] = "CLASE",

    -- the modes over the list, and what each one plans (the names the tooltips use)
    ["Vendor sales"] = "Vendedor",
    ["AH sales"] = "Subasta",
    ["Food"] = "Comida",
    ["Favor"] = "Favor",
    ["done"] = "hecho",
    ["in your quest log"] = "en tu diario de misiones",

    -- one option's tooltip and its row
    ["Click: put a map pin and the arrow on it."] = "Clic: poner una marca en el mapa y la flecha hacia ella.",
    ["%s that give points"] = "%s que dan puntos",
    ["%s for this step"] = "%s para este paso",
    ["A %s is worth"] = "Un %s vale",
    ["Gold an hour"] = "Oro por hora",
    ["Click to %s here for this step."] = "Clic: %s aquí para este paso.",
    ["Fish that land"] = "Peces que pican",
    ["all of them"] = "todos",
    ["none needed"] = "ninguno necesario",
    ["A catch is worth"] = "Una captura vale",
    ["Lures for this step"] = "Cebos para este paso",
    ["Click to fish here for this step."] = "Clic: pescar aquí para este paso.",
    ["%s the %d you can make from what you have."] = "%s los %d que puedes hacer con lo que tienes.",
    ["Ingredients"] = "Reactivos",
    ["Learn"] = "Aprender",
    ["Recipe"] = "Receta",
    ["Selling them brings back"] = "Venderlos devuelve",
    ["Per skill point"] = "Por punto de habilidad",
    ["Click to use this recipe for this step."] = "Clic: usar esta receta para este paso.",
    ["~%d %s, %s a %s"] = "~%d %s, %s por %s",
    ["%s at the trainer"] = "%s en el maestro",
    ["no fish get away"] = "ningún pez se escapa",
    ["%d%% of casts land a fish"] = "el %d%% de los lanzamientos saca un pez",
    [", with %s"] = ", con %s",
    ["%s a catch%s"] = "%s por captura%s",
    [", lures %s"] = ", cebos %s",
    [" / catch"] = " / captura",
    ["%s for lures"] = "%s para cebos",
    ["  with what you have"] = "  con lo que tienes",
    ["from your bags"] = "de tus bolsas",
    ["bought at the auction house"] = "comprado en la casa de subastas",
    ["learn: %s"] = "aprender: %s",
    [" / point"] = " / punto",
    ["%s in all%s"] = "%s en total%s",
    [", %s back"] = ", %s de vuelta",
    [" / hour"] = " / hora",

    -- a folded list, the ingredients, the colours
    ["all %d %s"] = "los %d %s",
    ["and %d more %s"] = "y %d %s más",
    ["and %d more"] = "y %d más",
    ["vendors"] = "vendedores",
    ["trainers"] = "maestros",
    [" (you have them)"] = " (ya los tienes)",
    ["  (you have %d%s)"] = "  (tienes %d%s)",
    [", in the bank"] = ", en el banco",
    [", %d in the bank"] = ", %d en el banco",
    ["smelt"] = "fundir",
    ["%s %d yourself from %s%s"] = "%s %d tú mismo con %s%s",
    [", buy the other %d"] = ", compra los otros %d",
    ["you have enough"] = "tienes bastantes",
    ["only %d listed - you need %d"] = "solo %d en venta - necesitas %d",
    ["  your Cooking uses it"] = "  tu Cocina lo usa",
    ["%d%% of catches%s"] = "%d%% de las capturas%s",
    [" each"] = " cada uno",
    ["  creatures level %d+|r"] = "  criaturas de nivel %d+|r",
    ["at the auction house, after its cut"] = "en la casa de subastas, tras su comisión",
    ["at a vendor"] = "a un vendedor",
    ["what's inside, on average"] = "lo que hay dentro, de media",
    ["orange"] = "naranja",
    ["yellow"] = "amarillo",
    ["green"] = "verde",
    ["grey"] = "gris",
    ["from %d"] = "desde %d",
    ["Your pick."] = "Tu elección.",

    -- the Craft bar
    ["An enchantment: enchant from the profession window, on the item."] = "Un encantamiento: encanta desde la" ..
        " ventana de profesión, sobre el objeto.",
    ["Learn the recipe first."] = "Aprende primero la receta.",
    ["Not in combat."] = "No en combate.",
    ["Not enough reagents in your bags."] = "No hay bastantes reactivos en tus bolsas.",
    ["Craft"] = "Fabricar",
    ["Crafts as many as the box says; opens your profession window first if it's closed (the game crafts only" ..
        " with it open)."] = "Fabrica tantos como diga el campo; primero abre tu ventana de profesión si está" ..
        " cerrada (el juego solo fabrica con ella abierta).",
    [" Cooking needs a fire nearby."] = " La Cocina necesita un fuego cerca.",
    ["Your bags allow %d"] = "Tus bolsas dan para %d",
    ["; the step needs %d."] = "; el paso necesita %d.",
    ["Opening your %s window: crafting once it's ready."] = "Abriendo tu ventana de %s: fabricaré en cuanto" ..
        " esté lista.",

    -- how to learn a recipe
    ["Learn it"] = "Cómo aprenderla",
    ["Buy the recipe from %s:"] = "Compra la receta a %s:",
    ["one of these vendors"] = "uno de estos vendedores",
    ["this vendor"] = "este vendedor",
    ["%s Favor"] = "Favor %s",
    ["Merchant's"] = "del mercader",
    ["Quest reward: %s%s"] = "Recompensa de misión: %s%s",
    ["(needs level %d)"] = "(necesita nivel %d)",
    ["quest giver"] = "da la misión",
    ["Only these trainers teach it, for %s:"] = "Solo estos maestros la enseñan, por %s:",
    ["trainer"] = "maestro",
    ["None of them is of your faction."] = "Ninguno de ellos es de tu facción.",
    ["Or buy it at the auction house: %s."] = "O cómprala en la casa de subastas: %s.",
    ["Or %s."] = "O %s.",
    ["During %s: %s."] = "Durante %s: %s.",
    ["The price is an estimate: Craft Ladder learns the real one when you visit the %s."] =
        "El precio es una estimación: Craft Ladder sabrá el real cuando pases por allí (%s).",
    ["vendor"] = "vendedor",

    -- what it sells for, and one craft
    ["An enchantment: nothing to sell."] = "Un encantamiento: nada que vender.",
    ["%s%s at the auction house (after its cut%s)."] = "%s%s en la casa de subastas (tras su comisión%s).",
    ["Not on the auction house."] = "No está en la casa de subastas.",
    ["%s%s at a vendor."] = "%s%s a un vendedor.",
    ["Vendors don't buy it."] = "Los vendedores no lo compran.",
    ["One craft%s: %s"] = "Una fabricación%s: %s",
    ["One craft: %s"] = "Una fabricación: %s",
    [" (makes %d)"] = " (hace %d)",
    ["auction house"] = "casa de subastas",
    ["%s yourself%s"] = "%s tú mismo%s",
    [" and %s"] = " y %s",
    ["%s each, %s"] = "%s cada uno, %s",
    ["Each sells for "] = "Cada uno se vende por",
    ["Sells for "] = "Se vende por",
    ["%d sell for "] = "%d se venden por",

    -- a Merchant's Favor recipe
    ["You know it."] = "La conoces.",
    ["You can learn it now."] = "Puedes aprenderla ahora.",
    ["It needs %d %s (you: %d)."] = "Necesita %d %s (tú: %d).",
    ["It needs level %d (you: %d)."] = "Necesita nivel %d (tú: %d).",
    ["Merchant's Favor"] = "Favor del mercader",
    ["Costs %d Merchant's Favor%s."] = "Cuesta %d de Favor del mercader%s.",
    [" (you have %d)"] = " (tienes %d)",
    ["Its price: open a quartermaster once and Craft Ladder remembers it."] = "Su precio: pasa una vez por un" ..
        " intendente y Craft Ladder lo recordará.",
    ["From level %d (you: %d)."] = "Desde nivel %d (tú: %d).",
    ["Its level: open a quartermaster once and Craft Ladder remembers it."] = "Su nivel: pasa una vez por un" ..
        " intendente y Craft Ladder lo recordará.",
    ["From %d %s (you: %d)."] = "Desde %d %s (tú: %d).",
    ["%s is %s from level %d (you: %d)."] = "%s %s desde nivel %d (tú: %d).",
    ["worn"] = "se lleva",
    ["used"] = "se usa",
    ["Quartermaster"] = "Intendente",
    ["The plan needs %s with %s."] = "El plan necesita %s con %s.",
    ["Only for %s."] = "Solo para %s.",
    ["Hated"] = "Odio",
    ["Hostile"] = "Hostil",
    ["Unfriendly"] = "Hosco",
    ["Neutral"] = "Neutral",
    ["Friendly"] = "Amistoso",
    ["Honored"] = "Honorable",
    ["Revered"] = "Reverenciado",
    ["Exalted"] = "Exaltado",

    -- a crafting step
    ["Skill %d - %d, about %d crafts, %s%s"] = "Habilidad %d - %d, unas %d fabricaciones, %s%s",
    ["some prices missing"] = "faltan algunos precios",
    ["%s %s what you already have: %d crafts%s."] = "%s %s con lo que ya tienes: %d fabricaciones%s.",
    [", plus a few vendor ingredients"] = ", más unos pocos reactivos de vendedor",
    [", nothing to buy"] = ", nada que comprar",
    ["You can %s %d now with what you have."] = "%s: ahora %d con lo que tienes.",
    ["You have the reagents for %d."] = "Tienes los reactivos para %d.",
    ["You have the main ingredients for %d; the rest is sold by vendors."] = "Tienes los reactivos principales" ..
        " para %d; el resto lo venden los vendedores.",
    ["The cheapest here is %s."] = "Lo más barato aquí es %s.",
    ["Needed for %s: %d recipes (%s, ...), and no vendor sells it. None of them is for leveling (a cooldown," ..
        " or learned at 300): make it once you're done."] = "Necesario para %s: %d recetas (%s, ...), y ningún" ..
        " vendedor lo vende. Ninguna de ellas sirve para subir (tiene reutilización, o se aprende en 300):" ..
        " fabrícalo cuando hayas terminado.",
    ["A tool: %d %s recipes need it, and no vendor sells it. Make one and keep it in your bags%s."] =
        "Una herramienta: %d recetas de %s la necesitan, y ningún vendedor la vende. Fabrica una y guárdala en" ..
        " tus bolsas%s.",
    [" (it gives no skill point any more)"] = " (ya no da punto de habilidad)",
    ["You have %s: the step takes them from your bags, so it pays less than that."] =
        "Tienes %s: el paso los coge de tus bolsas, así que paga menos que eso.",
    ["Keep for later"] = "Guardar para luego",
    ["Keep %d %s: the steps at %d - %d use them."] = "Guarda %d %s: los pasos de %d - %d los usan.",
    ["Batch: %s"] = "Lote: %s",
    ["Craft counts are estimates: skill-ups are luck once a recipe is yellow."] = "El número de fabricaciones" ..
        " es una estimación: los puntos de habilidad son suerte en cuanto una receta está amarilla.",
    ["Sell the rest"] = "Vender el resto",
    ["Sell what you make"] = "Vender lo que fabricas",
    ["%d at the auction house, about %s each after its cut."] = "%d en la casa de subastas, unos %s cada uno" ..
        " tras su comisión.",
    ["%d to a vendor, %s each."] = "%d a un vendedor, %s cada uno.",
    ["About %s back, so this step %s %s."] = "Unos %s de vuelta, así que este paso %s %s.",
    ["earns"] = "da",
    ["costs"] = "cuesta",
    ["Vendor sales counts only what vendors pay: that money is sure. AH sales counts the auction house too."] =
        "Ventas a vendedor cuenta solo lo que pagan los vendedores: ese dinero es seguro. Ventas en la CS" ..
        " cuenta también la casa de subastas.",
    ["The auction house counts only when it pays 1.5 times a vendor and 5 or more are listed, and for at most" ..
        " a quarter of what's listed."] = "La casa de subastas solo cuenta cuando paga 1,5 veces lo de un" ..
        " vendedor y hay 5 o más en venta, y como mucho por un cuarto de lo que hay en venta.",
    ["Or %s, from %d"] = "O %s, desde %d",
    ["Recipes you could use from %d"] = "Recetas que podrías usar desde %d",
    ["No other recipe is open to you here."] = "Aquí no tienes ninguna otra receta abierta.",

    -- Gold: one recipe's profit
    ["One craft%s costs about %s and sells for about %s: %s+%s|r"] = "Una fabricación%s cuesta unos %s y se" ..
        " vende por unos %s: %s+%s|r",
    ["Sold to a vendor: vendors buy any number."] = "Vendido a un vendedor: los vendedores compran cualquier" ..
        " cantidad.",
    ["%d listed at the auction house now: sell a few at a time."] = "%d en venta ahora en la casa de subastas:" ..
        " vende unos pocos cada vez.",
    ["Making it needs %s %d, and yours is %d%s. It's here to level towards."] = "Fabricarla necesita %s %d, y" ..
        " el tuyo es %d%s. Está aquí como meta.",
    ["; the rank that lifts your cap to it asks level %d, and you're %d"] = "; el rango que sube tu límite" ..
        " hasta ahí pide nivel %d, y tú tienes %d",
    ["Learning it pays back after %d %s."] = "Aprenderla se amortiza tras %d %s.",
    ["craft"] = "fabricación",
    ["crafts"] = "fabricaciones",
    ["Once in %s: the recipe has a cooldown."] = "Una vez cada %s: la receta tiene reutilización.",
    ["You have %s: counted at their price too, since you could sell them."] = "Tienes %s: contados también a" ..
        " su precio, ya que podrías venderlos.",
    ["Profit: what a vendor pays, less the ingredients at today's prices. How many you can make, the auction" ..
        " house's ingredients decide."] = "Beneficio: lo que paga un vendedor, menos los reactivos a los" ..
        " precios de hoy. Cuántos puedes hacer lo deciden los reactivos de la casa de subastas.",
    ["Profit: at the lowest listing after the auction house's cut, with 5 or more listed, or however few when" ..
        " you searched it yourself; it counts only when it pays 1.5 times what a vendor does. How many sell," ..
        " the auction house doesn't say. Prices change: look again before buying."] =
        "Beneficio: a la oferta más barata tras la comisión de la casa de subastas, con 5 o más en venta, o" ..
        " los que sean si lo has buscado tú mismo; solo cuenta cuando paga 1,5 veces lo que da un vendedor." ..
        " Cuántos se venden, la casa de subastas no lo dice. Los precios cambian: mira otra vez antes de" ..
        " comprar.",

    -- Disenchant
    ["Disenchant one: about %s"] = "Desencantar uno: unos %s",
    ["%d%% of disenchants, %s each"] = "%d%% de los desencantamientos, %s cada uno",
    ["%s%d disenchanted: about %s, at least %s 9 times out of 10."] = "%s%d desencantados: unos %s, al menos" ..
        " %s 9 de cada 10 veces.",
    ["Your "] = "Tus",
    ["What it gives: from your %d disenchants of this item, recorded in game: it breaks unlike items of its" ..
        " kind."] = "Lo que da: de tus %d desencantamientos de este objeto, registrados en el juego: se" ..
        " deshace distinto a los objetos de su clase.",
    ["What it gives: from %d disenchants of items like it, recorded in game."] = "Lo que da: de %d" ..
        " desencantamientos de objetos parecidos, registrados en el juego.",
    ["You've disenchanted %d like it: %s in all. From %d, what you got replaces the table."] =
        "Has desencantado %d parecidos: %s en total. A partir de %d, lo que obtuviste sustituye a la tabla.",
    ["Forever added this kind of item: what it gives is a guess, checked for one item: a green's of its level," ..
        " one more of each."] = "Forever añadió esta clase de objeto: lo que da es una suposición, comprobada" ..
        " en un objeto: como la de un verde de su nivel, uno más de cada.",
    ["What a disenchant gives is luck%s. Materials at the auction house after its cut; 3 lesser essences make" ..
        " a greater one."] = "Lo que da un desencantamiento es suerte%s. Materiales en la casa de subastas" ..
        " tras su comisión; 3 esencias menores hacen una mayor.",
    [", from Classic's table (not checked in Forever yet): from %d of your disenchants of items like it, what" ..
        " you got replaces it"] = ", de la tabla de Classic (aún sin comprobar en Forever): a partir de %d de" ..
        " tus desencantamientos de objetos parecidos, lo que obtuviste la sustituye",
    ["One craft%s costs about %s; disenchanted, about %s on average: %s"] = "Una fabricación%s cuesta unos %s;" ..
        " desencantada, unos %s de media: %s",
    ["A %s recipe %s knows."] = "Una receta de %s que conoce %s.",
    ["you"] = "tú",
    ["Making it costs more than disenchanting brings: disenchant it when you make it anyway, for skill."] =
        "Fabricarla cuesta más de lo que da desencantarla: desencántala cuando la hagas de todos modos, por la" ..
        " habilidad.",
    ["Best: %s. %d in %s's %s: disenchanted, about %s on average; sold, %s."] = "Lo mejor: %s. %d en %s, %s:" ..
        " desencantado, unos %s de media; vendido, %s.",
    ["your"] = "tus",
    ["bags"] = "bolsas",
    ["Soulbound: no auction house."] = "Ligado al alma: sin casa de subastas.",
    ["Or sell it"] = "O venderlo",
    ["Soulbound: the auction house won't take it."] = "Ligado al alma: la casa de subastas no lo aceptará.",
    ["%s each at the auction house (after its cut%s)."] = "%s cada uno en la casa de subastas (tras su" ..
        " comisión%s).",
    ["%s each at a vendor."] = "%s cada uno a un vendedor.",
    ["The auction house counts with 5 or more listed, or however few when you searched it yourself. What made" ..
        " it doesn't count: it's made."] = "La casa de subastas cuenta con 5 o más en venta, o los que sean si" ..
        " lo has buscado tú mismo. De qué está hecho no cuenta: ya está hecho.",
    ["Buy one for %s; disenchanted, about %s on average: %s"] = "Compra uno por %s; desencantado, unos %s de" ..
        " media: %s",
    ["One disenchant brings more than it cost %d%% of the time."] = "Un desencantamiento da más de lo que" ..
        " costó el %d%% de las veces.",
    ["Buy it"] = "Comprarlo",
    ["The cheapest listing: %s. %s."] = "La oferta más barata: %s. %s.",
    ["Its level and quality are Classic's: Forever's client doesn't list it. "] = "Su nivel y calidad son los" ..
        " de Classic: el cliente de Forever no los da.",
    ["A random suffix (\"of the Monkey\") doesn't change what it breaks into. The listing may have sold since" ..
        " the scan."] = "Un sufijo al azar (\"del mono\") no cambia en qué se deshace. La oferta puede haberse" ..
        " vendido desde el escaneo.",
    ["Nothing to disenchant"] = "Nada que desencantar",
    ["No character of yours holds anything to disenchant, and "] = "Ningún personaje tuyo lleva nada que" ..
        " desencantar, y",
    ["none of the recipes they know makes something to disenchant: open a crafting profession's window once so" ..
        " Craft Ladder knows its recipes."] = "ninguna de las recetas que conocen fabrica algo que" ..
        " desencantar: abre una vez la ventana de una profesión de fabricación para que Craft Ladder conozca" ..
        " sus recetas.",
    ["nothing they can make is worth more disenchanted than sold at today's prices."] =
        "nada de lo que pueden fabricar vale más desencantado que vendido a los precios de hoy.",

    -- Cooking's Food
    [" (Well Fed). "] = " (Bien alimentado).",
    ["Needs level %d; you're %d."] = "Necesita nivel %d; tú tienes %d.",
    ["Level %d: you can eat it."] = "Nivel %d: puedes comerlo.",
    ["Any level can eat it."] = "Cualquier nivel puede comerlo.",
    ["Nobody sells its recipe now: look for it at the auction house."] = "Ahora nadie vende su receta: búscala" ..
        " en la casa de subastas.",
    ["No way to learn it for you now (a holiday's, or the other side's)."] = "Ahora no hay forma de que la" ..
        " aprendas (es de una festividad, o del otro bando).",
    ["Learned at %s %d; you have %d."] = "Se aprende con %s %d; tú tienes %d.",
    ["You have %s: cooking it takes them from your bags, so it costs you less than that."] =
        "Tienes %s: cocinarlo los coge de tus bolsas, así que te cuesta menos que eso.",
    ["Or buy it"] = "O comprarlo",
    ["One at the auction house: %s."] = "Uno en la casa de subastas: %s.",
    ["None listed at the auction house now."] = "Ahora no hay ninguno en venta en la casa de subastas.",
    ["What it raises is read from the game's files, not checked in game yet."] = "Lo que sube se lee de los" ..
        " archivos del juego, aún sin comprobar en el juego.",

    -- a rank step
    ["At skill %d. Your cap is your level x 5: %d at level %d."] = "Con habilidad %d. Tu límite es tu nivel x" ..
        " 5: %d a nivel %d.",
    ["You're level %d."] = "Eres nivel %d.",
    ["Your level allows it already."] = "Tu nivel ya lo permite.",
    ["Lockpicking can't go past your level x 5: level up before you go on."] = "Forzar cerraduras no pasa de" ..
        " tu nivel x 5: sube de nivel antes de seguir.",
    ["Learn %s%s"] = "Aprender %s%s",
    ["At skill %d, raises your cap to %d. %s"] = "Con habilidad %d, sube tu límite a %d. %s",
    ["Needs character level %d."] = "Necesita nivel de personaje %d.",
    ["How"] = "Cómo",
    ["Only these trainers teach it%s:"] = "Solo estos maestros lo enseñan%s:",
    [", for %s"] = ", por %s",
    ["Any %s trainer teaches it%s."] = "Cualquier maestro (%s) lo enseña%s.",
    [" for %s"] = " por %s",
    ["Buy the %s and read it:"] = "Compra %s y léelo:",
    ["At the auction house: %s."] = "En la casa de subastas: %s.",
    ["Or buy it at the auction house: %s.%s"] = "O cómpralo en la casa de subastas: %s.%s",
    [" Cheaper than the vendor, so the ladder counts this one."] = " Más barato que en el vendedor, así que la" ..
        " escalera cuenta este.",
    ["1. Take the quest %s:"] = "1. Coge la misión %s:",
    ["start"] = "inicio",
    ["2. Bring the ingredients below to %s for %s:"] = "2. Lleva los reactivos de abajo a %s por %s:",
    ["hand in"] = "entrega",
    ["Do the quest %s for %s:"] = "Haz la misión %s con %s:",
    ["What to bring"] = "Qué llevar",
    ["Any %s trainer teaches Apprentice %s."] = "Cualquier maestro (%s) enseña Aprendiz (%s).",

    -- fishing
    ["Fish to catch"] = "Qué peces pescar",
    ["%s: %s, %s (fish bite from %d)"] = "%s: %s, %s (pican desde %d)",
    ["seen by GatherMate2"] = "visto por GatherMate2",
    ["place known"] = "sitio conocido",
    ["places known"] = "sitios conocidos",
    [" a catch"] = " por captura",
    ["%d - %d catches before it's gone"] = "%d - %d capturas antes de que desaparezca",
    ["No fish get away here."] = "Aquí no se escapa ningún pez.",
    ["About %d%% of casts land a fish here."] = "Aquí un %d%% de los lanzamientos saca un pez.",
    ["An hour at skill %d: about %d catches, %s each"] = "Una hora con habilidad %d: unas %d capturas, %s cada" ..
        " una",
    [" An hour's catches are worth about %s%s."] = " Las capturas de una hora valen unos %s%s.",
    [", lures paid"] = ", cebos pagados",
    ["Skill %d - %d, about %d catches (%s), %s"] = "Habilidad %d - %d, unas %d capturas (%s), %s",
    [" Catches worth about %s (%s an hour)."] = " Capturas por unos %s (%s por hora).",
    ["Craft Ladder's choice here is %s."] = "La elección de Craft Ladder aquí es %s.",
    ["Its creatures are level %d - %d."] = "Sus criaturas son de nivel %d - %d.",
    ["Bring"] = "Llevar",
    ["Put %s on your pole: +%d fishing for %d minutes, so no fish get away."] = "Pon %s en tu caña: +%d a" ..
        " pesca durante %d minutos, y no se escapa ningún pez.",
    ["Fishing supplies vendors sell lures, in every capital."] = "Los vendedores de artículos de pesca venden" ..
        " cebos, en cada capital.",
    ["No lure needed: your skill keeps the fish from getting away."] = "No hace falta cebo: tu habilidad ya" ..
        " impide que los peces se escapen.",
    ["What you catch here"] = "Lo que pescas aquí",
    ["Fishing pools here"] = "Bancos de peces aquí",
    ["Fish pools when you see them: Craft Ladder counts a third of your catches here from pools. That makes a" ..
        " catch worth %s on average (%s in open water)."] = "Pesca en los bancos cuando los veas: Craft Ladder" ..
        " cuenta aquí un tercio de tus capturas en bancos. Así una captura vale %s de media (%s en aguas" ..
        " abiertas).",
    ["No fishing pools known here yet. GatherMate2 adds the ones you fish, and Craft Ladder counts them."] =
        "Aquí aún no se conocen bancos de peces. GatherMate2 añade aquellos en los que pescas, y Craft Ladder" ..
        " los cuenta.",
    ["Catches per point: from your %d catches, skill-ups come %d%% as often as Classic's rule says."] =
        "Capturas por punto: de tus %d capturas, los puntos de habilidad salen al %d%% de lo que dice la regla" ..
        " de Classic.",
    ["Catches per point follow Classic's rule (at 150, one point in about 4 catches) until Craft Ladder has" ..
        " counted 50 of your catches (%d so far)."] = "Las capturas por punto siguen la regla de Classic (en" ..
        " 150, un punto en unas 4 capturas) hasta que Craft Ladder haya contado 50 capturas tuyas (%d por" ..
        " ahora).",
    ["Zones and their fish come from Classic's world: Forever may differ."] = "Las zonas y sus peces vienen" ..
        " del mundo de Classic: Forever puede ser distinto.",
    ["Other zones from %d"] = "Otras zonas desde %d",
    ["No other zone is open to you here."] = "Aquí no tienes ninguna otra zona abierta.",

    -- skinning and mining
    ["about %d in the zone, %s %s each%s"] = "unos %d en la zona, %s %s cada uno%s",
    [", worth %s"] = ", vale %s",
    ["needs %d"] = "necesita %d",
    ["%s  %slevel %d%s|r"] = "%s  %snivel %d%s|r",
    [", seen skinned"] = ", ya desollada",
    ["about %d in the zone, needs %d%s"] = "unos %d en la zona, necesita %d%s",
    [", %s a skin"] = ", %s por piel",
    ["Skin in %s"] = "Desollar en %s",
    ["An hour at skill %d: about %d creatures, %s each"] = "Una hora con habilidad %d: unas %d criaturas, %s" ..
        " cada una",
    ["An hour's skins are worth about %s. Every creature you can skin counts, grey ones too."] =
        "Las pieles de una hora valen unos %s. Cuenta cada criatura que puedas desollar, también las grises.",
    ["Skill %d - %d, about %d creatures%s"] = "Habilidad %d - %d, unas %d criaturas%s",
    [", trainer %s"] = ", maestro %s",
    ["Worth about %s skinned (%s an hour)."] = "Vale unos %s desollado (%s por hora).",
    ["Skin every creature that still gives a point, of your level or below."] = "Desuella cada criatura que" ..
        " aún dé un punto, de tu nivel o por debajo.",
    ["Its creatures are well above your level."] = "Sus criaturas están muy por encima de tu nivel.",
    ["Creatures to skin here"] = "Criaturas que desollar aquí",
    ["Which creatures can be skinned and what one gives come from Classic; where they are and their levels" ..
        " from QuestieDB's Forever data. The skill one needs is Classic's rule from its level (level x 5 past" ..
        " 20), the colours Mining's (yellow 25, green 50, grey 100 above it). A creature new in Forever counts" ..
        " once you've skinned one."] = "Qué criaturas se pueden desollar y qué da una vienen de Classic; dónde" ..
        " están y su nivel, de los datos de Forever de QuestieDB. La habilidad que piden es la regla de" ..
        " Classic según su nivel (nivel x 5 pasado el 20), los colores los de Minería (amarillo 25, verde 50," ..
        " gris 100 por encima). Una criatura nueva en Forever cuenta en cuanto desuelles una.",
    ["Gold an hour assumes %d s a creature (kill, loot, skin) and a 60%% mount between them: about %d an hour" ..
        " here."] = "El oro por hora cuenta %d s por criatura (matar, saquear, desollar) y una montura del" ..
        " 60%% entre ellas: unos %d por hora aquí.",
    ["Other zones, from %d"] = "Otras zonas, desde %d",
    ["%s in %s"] = "%s en %s",
    ["An hour at skill %d: about %d %s, %s each"] = "Una hora con habilidad %d: unos %d %s, %s cada uno",
    ["An hour's worth about %s. Every %s you can reach counts, grey ones too. Creatures level %d - %d."] =
        "Una hora vale unos %s. Cuenta cada %s al que llegues, también los grises. Criaturas de nivel %d - %d.",
    ["Skill %d - %d, about %d %s%s"] = "Habilidad %d - %d, unos %d %s%s",
    ["Worth about %s (%s an hour). Creatures level %d - %d."] = "Vale unos %s (%s por hora). Criaturas de" ..
        " nivel %d - %d.",
    ["Creatures level %d - %d. %s every %s that still gives a point."] = "Criaturas de nivel %d - %d. %s cada" ..
        " %s que aún dé un punto.",
    ["%s places come from GatherMate2's Forever data; what one gives and how often a rarer kind takes a place," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what one" ..
        " needs): Forever may differ."] = "Los sitios (%s) vienen de los datos de Forever de GatherMate2; lo" ..
        " que da uno y cada cuánto una clase más rara ocupa un sitio, de Classic. Los puntos de habilidad" ..
        " siguen los colores de Classic (amarillo 25, verde 50, gris 100 por encima de lo que pide): Forever" ..
        " puede ser distinto.",
    ["Gold an hour assumes 15 s a %s, a third of the zone's places with one up and a 60%% mount: about %d an" ..
        " hour here."] = "El oro por hora cuenta 15 s por %s, un tercio de los sitios de la zona ocupados y" ..
        " una montura del 60%%: unos %d por hora aquí.",
    ["%s: about %d bars%s"] = "%s: unos %d lingotes%s",
    [", learn it from a Mining trainer for %s"] = ", apréndelo con un maestro de Minería por %s",
    ["Nothing you mine here still gives points when smelted."] = "Nada de lo que minas aquí da ya puntos al" ..
        " fundirlo.",
    ["Sell ore or bars"] = "Vender mineral o lingotes",
    ["%s: %s each. Smelting it needs more skill."] = "%s: %s cada uno. Fundirlo necesita más habilidad.",
    ["sell the ore, smelt it only for the skill-ups"] = "vende el mineral, fúndelo solo por los puntos de" ..
        " habilidad",
    ["smelt it and sell the bars"] = "fúndelo y vende los lingotes",
    [", %s as %s"] = ", %s como %s",
    ["make %s and sell it"] = "fabrica %s y véndelo",
    ["%s: %s as ore, %s as %s%s - %s."] = "%s: %s como mineral, %s como %s%s - %s.",
    ["%s: %s make %d %s, so per ore it's worth one of them; it takes both ores, as much as the scarcer one" ..
        " allows."] = "%s: %s hacen %d %s, así que por mineral vale como uno de ellos; necesita los dos" ..
        " minerales, tanto como permita el más escaso.",
    ["Nothing mined here can be smelted."] = "Nada de lo que se mina aquí se puede fundir.",
    ["Per ore, after the auction house's cut (only what's listed at least 5 times), or what a vendor pays."] =
        "Por mineral, tras la comisión de la casa de subastas (solo lo que está en venta al menos 5 veces), o" ..
        " lo que paga un vendedor.",
    ["Smelting gives skill-ups too: Craft Ladder counts the ore you mine as smelted, so you mine fewer nodes."] =
        "Fundir también da puntos de habilidad: Craft Ladder cuenta el mineral que minas como fundido, así que" ..
        " minas menos filones.",
    ["Node places come from GatherMate2's Forever data; how often rare veins appear and the ore a node gives," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what a node" ..
        " needs): Forever may differ."] = "Los sitios de los filones vienen de los datos de Forever de" ..
        " GatherMate2; cada cuánto aparecen vetas raras y cuánto mineral da un filón, de Classic. Los puntos" ..
        " de habilidad siguen los colores de Classic (amarillo 25, verde 50, gris 100 por encima de lo que" ..
        " pide un filón): Forever puede ser distinto.",
    ["Gold an hour assumes 15 s a node, a third of the zone's node places with a node up and a 60%% mount:" ..
        " about %d nodes an hour here."] = "El oro por hora cuenta 15 s por filón, un tercio de los sitios de" ..
        " la zona ocupados y una montura del 60%%: unos %d filones por hora aquí.",
    ["Other zones, or smelting, from %d"] = "Otras zonas, o fundir, desde %d",

    -- Lockpicking
    ["%d a run, needs %d"] = "%d por pasada, necesita %d",
    ["about %d in the zone, needs %d"] = "unos %d en la zona, necesita %d",
    ["Humanoids drop it; the auction house sells it."] = "Lo sueltan los humanoides; la casa de subastas lo" ..
        " vende.",
    ["Fished up from pools."] = "Pescada en los bancos.",
    ["Engineers make it."] = "La fabrican los ingenieros.",
    ["Pick Pocket humanoids of level %d - %d."] = "Roba a humanoides de nivel %d - %d.",
    ["Pick Pocket humanoids."] = "Roba a humanoides.",
    ["Pick locks in %s"] = "Forzar cerraduras en %s",
    ["Skill %d - %d, about %d locks"] = "Habilidad %d - %d, unas %d cerraduras",
    ["Creatures level %d - %d. Pick every lock that still gives a point: a chest gives one chance, and one" ..
        " more once it's back."] = "Criaturas de nivel %d - %d. Fuerza cada cerradura que aún dé un punto: un" ..
        " cofre da una oportunidad, y otra más cuando vuelve.",
    ["The door round"] = "La ronda de las puertas",
    ["1. Go into Blackrock Depths (Blackrock Mountain, between Searing Gorge and Burning Steppes)."] =
        "1. Entra en las Profundidades de Roca Negra (Pico Roca Negra, entre la Garganta de Fuego y las" ..
        " Estepas Ardientes).",
    ["2. Pick the locked doors on the way: the first on the left, through it the next on the right, then the" ..
        " first on the left again; the Shadowforge Lock under the big gear too, if nothing would pull."] =
        "2. Fuerza las puertas cerradas del camino: la primera a la izquierda, tras ella la siguiente a la" ..
        " derecha, luego otra vez la primera a la izquierda; y también la Cerradura de Forjaumbría bajo el" ..
        " engranaje grande, si no atrae a nadie.",
    ["3. Leave, right-click your portrait, Reset all instances and go in again: the game lets you in 5 times" ..
        " an hour."] = "3. Sal, clic derecho en tu retrato, Reiniciar todas las instancias y vuelve a entrar:" ..
        " el juego te deja entrar 5 veces por hora.",
    ["The round is zockify's Forever guide's: about 4 doors a run."] = "La ronda es la de la guía de Forever" ..
        " de zockify: unas 4 puertas por pasada.",
    ["Where"] = "Dónde",
    ["Most %ss are around here"] = "La mayoría (%s) están por aquí",
    ["Chest places: GatherMate2's and QuestieDB's Forever data. Which lock a chest needs, and the colours" ..
        " (yellow 25, green 50, grey 100 above it), are Classic's: Forever may differ."] =
        "Sitios de los cofres: datos de Forever de GatherMate2 y QuestieDB. Qué cerradura pide un cofre, y los" ..
        " colores (amarillo 25, verde 50, gris 100 por encima), son de Classic: Forever puede ser distinto.",
    ["Other zones, or boxes, from %d"] = "Otras zonas, o cajas, desde %d",
    ["Pick %s"] = "Forzar %s",
    ["Skill %d - %d, about %d boxes, %s"] = "Habilidad %d - %d, unas %d cajas, %s",
    ["Pick the ones in your bags: you have %d."] = "Fuerza las de tus bolsas: tienes %d.",
    ["Boxes to buy: %s"] = "Cajas que comprar: %s",
    ["A box gives one chance at a point, and what's inside is yours."] = "Una caja da una oportunidad de" ..
        " punto, y lo que hay dentro es tuyo.",
    ["Or pick locks in a zone, from %d"] = "O forzar cerraduras en una zona, desde %d",
    ["Every lock a rogue picks, by the skill it needs; its colour at your %d."] = "Cada cerradura que fuerza" ..
        " un pícaro, por la habilidad que pide; su color con tus %d.",
    ["Orange always gives a point, yellow mostly, green sometimes, grey never."] = "El naranja siempre da un" ..
        " punto, el amarillo casi siempre, el verde a veces, el gris nunca.",
    ["Chests in the world"] = "Cofres en el mundo",
    ["Boxes from your bags"] = "Cajas de tus bolsas",
    ["You have %d."] = "Tienes %d.",
    [" %s at the auction house."] = " %s en la casa de subastas.",
    ["Dungeon doors"] = "Puertas de mazmorra",
    ["%s: %d locked doors, from %d (%s)."] = "%s: %d puertas cerradas, desde %d (%s).",
    ["Getting started"] = "Para empezar",
    ["Pick Lock: any rogue trainer, from level 16, for %s. It needs Thieves' Tools in your bags (rogue" ..
        " supplies vendors, 15s). Your cap is your level x 5."] = "Forzar cerraduras: cualquier maestro" ..
        " pícaro, desde nivel 16, por %s. Necesita Herramientas de ladrón en tus bolsas (vendedores de" ..
        " suministros de pícaro, 15p). Tu límite es tu nivel x 5.",

    -- the cards with nothing to show, and the rest
    ["Nothing earns now"] = "Ahora no da beneficio nada",
    ["Nothing you can make sells for more than it costs at today's prices."] = "Nada de lo que puedes fabricar" ..
        " se vende por más de lo que cuesta a los precios de hoy.",
    ["Nothing you can get here has a price yet: Craft Ladder needs auction house prices."] =
        "Nada de lo que consigues aquí tiene aún precio: Craft Ladder necesita precios de la casa de subastas.",
    ["Nothing to do here"] = "Aquí no hay nada que hacer",
    ["You've reached %d %s."] = "Has llegado a %d en %s.",
    ["No recipe found for your skill."] = "No se ha encontrado receta para tu habilidad.",
    [", Working Overtime %d/5: +%d%%"] = ", Horas extra %d/5: +%d%%",

    -- what the data itself says on a rank card (Professions.lua, Data/*.lua)
    ["Your class quests at 16"] = "Tus misiones de clase a nivel 16",
    ["They lead to the first practice chests and give you Thieves' Tools. Pick Lock itself is learned from any" ..
        " rogue trainer, quest or not."] = "Llevan a los primeros cofres de práctica y te dan Herramientas de" ..
        " ladrón. Forzar cerraduras se aprende con cualquier maestro pícaro, con misión o sin ella.",
    ["Your class quests at 20"] = "Tus misiones de clase a nivel 20",
    ["The last one teaches Poisons (and Recipe: Thistle Tea). On the way you pick a lock: Lockpicking 70 for" ..
        " the Alliance's Duskwood Chest, 80 for the Horde's Gallywix's Lockbox (Classic's numbers, not" ..
        " confirmed in Forever)."] = "La última enseña Venenos (y la Receta: té de cardo). Por el camino" ..
        " fuerzas una cerradura: Forzar cerraduras 70 para el Cofre de Bosque del Ocaso de la Alianza, 80 para" ..
        " la Caja de Gallywix de la Horda (cifras de Classic, sin confirmar en Forever).",
    ["Bring 12 Giant Egg, 10 Zesty Clam Meat and 20 Alterac Swiss to Dirge Quikcleave in Gadgetzan."] =
        "Lleva 12 Huevo gigante, 10 Carne de almeja sabrosa y 20 Queso suizo de Alterac a Dirge Rajarrápido en" ..
        " Gadgetzan.",
    ["Catch the four fish below and bring them to Nat Pagle; he then teaches Artisan Fishing for 1g."] =
        "Pesca los cuatro peces de abajo y llévaselos a Nat Pagle; entonces enseña Pesca (artesano) por 1o.",
    ["Hank the Hammer's (Alliance) or Aturk the Anvil's (Horde) quests lead to Galvan the Ancient and Trenton" ..
        " Lighthammer, whose quests teach the Ornate Mithril recipes the last quest asks for. Buy those 7" ..
        " items at the auction house and you can skip them."] = "Las misiones de Hank el Martillo (Alianza) o" ..
        " Aturk el Yunque (Horda) llevan a Galvan el Anciano y Trenton Martillo Ligero, cuyas misiones enseñan" ..
        " las recetas de mitril adornado que pide la última misión. Compra esos 7 objetos en la casa de" ..
        " subastas y podrás saltártelas.",
    ["It gives you a letter to hand in."] = "Te da una carta que entregar.",
    ["Right-click the pledge it gives you: that completes it."] = "Clic derecho en la promesa que te da: así" ..
        " se completa.",
    ["Save 15 wounded soldiers with the Triage Bandages the doctor gives you, before 6 of them die."] =
        "Salva a 15 soldados heridos con los Vendajes de primeros auxilios que te da el médico, antes de que" ..
        " mueran 6 de ellos.",
    ["Then learn the mastery from the trainer who gave you the quest."] = "Luego aprende la maestría con el" ..
        " maestro que te dio la misión.",
}
