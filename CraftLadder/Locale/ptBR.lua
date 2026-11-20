-- Craft Ladder in Portuguese. The key is the English string as it stands in the code; what's missing here is shown in
-- English. Item, recipe and zone names come from the game itself, so they are not here.
-- The %s and %d of a line must stay in the same order as in the English one: the game fills them in that order.
local _, ns = ...

ns.Locales = ns.Locales or {}
ns.Locales.ptBR = {
    -- the auction house tab
    ["The items' names are still loading: click again."] = "Os nomes dos itens ainda estão carregando: clique" ..
        " de novo.",
    ["Stop"] = "Parar",
    ["Full Rescan"] = "Reescanear tudo",
    ["Scanning %s: %d of %d items."] = "Escaneando %s: %d de %d itens.",
    ["the auction house"] = "a casa de leilões",
    ["Scan done: %d of %d items searched."] = "Escaneamento concluído: %d de %d itens encontrados.",
    ["A scan is already running: stop it first."] = "Já há um escaneamento em andamento: pare-o primeiro.",
    ["Nothing to scan here."] = "Nada para escanear aqui.",
    ["Scanning %s: 0 of %d items."] = "Escaneando %s: 0 de %d itens.",
    ["this step"] = "este passo",
    ["Confirm %s"] = "Comprar por %s",
    ["Asking..."] = "Perguntando...",
    ["Buying %d %s..."] = "Comprando %d %s...",
    ["The auction house is busy: try again in a moment."] = "A casa de leilões está ocupada: tente de novo em" ..
        " um instante.",
    ["Asking the price of %d %s..."] = "Perguntando o preço de %d %s...",
    ["Scan"] = "Escanear",
    ["Asks the auction house what this one goes for now, and puts that price in the ladder. However fresh the" ..
        " price already is."] = "Pergunta à casa de leilões quanto este vale agora e põe esse preço na escada." ..
        " Por mais recente que o preço já seja.",
    ["Asks the auction house about what this step makes and everything it takes, then puts those prices in the" ..
        " ladder."] = "Pergunta à casa de leilões o que este passo produz e tudo o que ele usa, e põe esses" ..
        " preços na escada.",
    ["Search"] = "Buscar",
    ["Auctionator's Shopping tab with what this step buys, and how many."] = "A aba de Compras do Auctionator" ..
        " com o que este passo compra, e quantos.",
    ["Learn %s"] = "Aprender %s",
    ["at %d, raises your cap to %d"] = "em %d, sobe seu limite para %d",
    ["%s%s|r a craft, %s"] = "%s%s|r por produção, %s",
    ["sold to a vendor"] = "vendido a um vendedor",
    ["%d listed"] = "%d à venda",
    ["%d - %d, ~%d %s%s"] = "%d - %d, ~%d %s%s",
    [", %d listed"] = ", %d à venda",
    ["at %d, make one and keep it"] = "em %d, faça um e guarde",
    ["nothing to buy"] = "nada para comprar",
    ["need %d, you have %d"] = "precisa de %d, você tem %d",
    ["%s each"] = "%s cada",
    ["not listed"] = "não está à venda",
    ["No crafting profession: nothing to buy for one."] = "Sem profissão de produção: nada para comprar para" ..
        " uma.",
    ["%s: nothing to buy"] = "%s: nada para comprar",
    ["Scan stopped: the prices it had got are in."] = "Escaneamento parado: os preços que ele obteve estão" ..
        " dentro.",
    ["Nothing here to rescan."] = "Nada para reescanear aqui.",
    ["Every price here was searched in the last two minutes: nothing to ask again."] =
        "Todos os preços aqui foram buscados nos últimos dois minutos: nada a perguntar de novo.",
    ["Scanning the auction house: 0 of %d items."] = "Escaneando a casa de leilões: 0 de %d itens.",
    ["Searches the auction house for everything this list buys and sells, then puts the prices in the ladder." ..
        " It goes one item at a time, as the server allows: watch the line below. An item searched in the last" ..
        " two minutes is left alone."] = "Busca na casa de leilões tudo o que esta lista compra e vende, e põe" ..
        " os preços na escada. Vai um item por vez, conforme o servidor permite: veja a linha abaixo. Um item" ..
        " buscado nos últimos dois minutos fica de fora.",
    ["Crafts"] = "Produções",
    ["A click on a step or a reagent searches it in Auctionator's Shopping tab."] = "Um clique num passo ou" ..
        " num reagente o busca na aba de Compras do Auctionator.",
    ["Craft Ladder"] = "Craft Ladder",
    ["%d %s for %s (%s each): click Confirm to buy."] = "%d %s por %s (%s cada): clique em Comprar.",
    ["No price for %s: not enough listed, or not sold that way (try the Buy tab)."] =
        "Sem preço para %s: não há o bastante à venda, ou não é vendido assim (tente a aba de Compra).",
    ["Bought %d %s."] = "%d %s comprados.",
    ["The purchase failed (the price may have changed): ask again."] = "A compra falhou (o preço pode ter" ..
        " mudado): pergunte de novo.",

    -- the camp view
    ["No profession"] = "Sem profissão",
    [" (skill %d)"] = " (perícia %d)",
    ["you know it"] = "você conhece",
    ["you can learn it"] = "você pode aprender",
    ["not your profession"] = "não é sua profissão",
    ["%d in your bags"] = "%d nas suas bolsas",
    ["needs %s"] = "precisa de %s",
    ["make %s"] = "fazer %s",
    ["no price"] = "sem preço",
    ["AH %s"] = "CL %s",
    ["  (not with %s)"] = "  (não com %s)",
    ["Or, the same buff and more: %s"] = "Ou o mesmo efeito e mais: %s",
    ["Camp: the buffs a campfire gives, for a level %d %s"] = "Acampamento: os bônus de uma fogueira, para o" ..
        " nível %d, %s",
    ["Holds %d camp features. %s; %s."] = "Comporta %d estruturas de acampamento. %s; %s.",
    ["A %s holds %d: the ones above. Then:"] = "Um %s comporta %d: as de cima. Depois:",
    ["Doesn't help a %s"] = "Não ajuda um %s",
    ["Camp features with no buff"] = "Estruturas de acampamento sem bônus",
    ["Build a campfire, place camp features around it and sit or craft nearby for a while: each feature gives" ..
        " everyone there its buff. A campfire holds only so many: here they are in the order your role wants" ..
        " them."] = "Faça uma fogueira, ponha estruturas ao redor e sente-se ou trabalhe perto por um tempo:" ..
        " cada estrutura dá seu bônus a todos que estiverem ali. Uma fogueira comporta só algumas: aqui estão" ..
        " na ordem que seu papel quer.",
    ["Campfire:"] = "Fogueira:",

    -- the characters' buttons
    ["Level %d %s"] = "Nível %d %s",
    ["Playing now"] = "Jogando agora",
    ["Last seen %s"] = "Visto pela última vez %s",

    -- the menu
    ["Show the %s ladder."] = "Mostrar a escada de %s.",
    ["not learned"] = "não aprendido",
    ["Disenchant"] = "Desencantar",
    ["Camp"] = "Acampamento",
    ["What's worth disenchanting on your whole account: what every character's bags and bank hold, what the" ..
        " auction house lists for less than disenchanting it brings, and what your crafting professions make" ..
        " that's worth more disenchanted than sold."] = "O que vale a pena desencantar em toda a sua conta: o" ..
        " que as bolsas e o banco de cada personagem guardam, o que a casa de leilões oferece por menos do que" ..
        " desencantar rende, e o que suas profissões produzem que vale mais desencantado do que vendido.",
    ["What each camp feature gives around a campfire, in the order your role wants them, and how to get it."] =
        "O que cada estrutura de acampamento dá ao redor de uma fogueira, na ordem que seu papel quer, e como" ..
        " consegui-la.",

    -- the minimap button
    ["Earns most"] = "Rende mais",
    ["%s, %s an hour"] = "%s, %s por hora",
    ["Now"] = "Agora",
    ["%s in %s to %d"] = "%s em %s até %d",
    ["fish"] = "pescar",
    ["mine"] = "minerar",
    ["catches"] = "pescas",
    ["nodes"] = "veios",
    ["%s to %d"] = "%s até %d",
    ["~%d crafts, %s"] = "~%d produções, %s",
    ["Eat"] = "Comer",
    ["%s, +%s a craft"] = "%s, +%s por produção",
    ["reach level %d"] = "chegar ao nível %d",
    ["learn %s"] = "aprender %s",
    ["Up to %d"] = "Até %d",
    ["Prices"] = "Preços",
    ["Click: open or close the window"] = "Clique: abrir ou fechar a janela",
    ["Drag: move the button"] = "Arrastar: mover o botão",
    ["minimap button hidden - /craft minimap shows it again."] = "botão do minimapa escondido - /craft minimap" ..
        " mostra de novo.",
    ["minimap button shown."] = "botão do minimapa visível.",

    -- the Settings menu
    ["Auction house prices from"] = "Preços da casa de leilões de",
    ["Its last full scan of your faction's auction house: the lowest price, the median and how many are" ..
        " listed."] = "O último escaneamento completo dele da casa de leilões da sua facção: o menor preço, a" ..
        " mediana e quantos estão à venda.",
    ["Its last scan. It gives one price per item, so the median is that price."] = "O último escaneamento" ..
        " dele. Dá um só preço por item, então a mediana é esse preço.",
    ["An ingredient costs"] = "Um reagente custa",
    ["The median listed price"] = "O preço mediano à venda",
    ["Half of what's listed costs less. The cheapest listing is one auction, often gone minutes after the" ..
        " scan."] = "Metade do que está à venda custa menos. A oferta mais barata é um único leilão, muitas" ..
        " vezes já ido minutos depois do escaneamento.",
    ["The cheapest listing"] = "A oferta mais barata",
    ["What the ladder cost before: the lowest price of the scan. Cheaper than what you will really pay, unless" ..
        " you are quick."] = "Como a escada contava antes: o menor preço do escaneamento. Mais barato do que" ..
        " você vai pagar de verdade, a não ser que seja rápido.",
    ["Language"] = "Idioma",
    ["Craft Ladder's own words. Item, recipe and zone names come from your game client, in its language. A few" ..
        " buttons take a /reload to change."] = "As palavras do Craft Ladder. Nomes de itens, receitas e zonas" ..
        " vêm do seu cliente de jogo, no idioma dele. Alguns botões pedem um /reload.",
    ["What you sell is always priced at the cheapest listing, the one you undercut."] =
        "O que você vende é sempre contado pela oferta mais barata, a que você corta.",
    ["%s isn't installed: %s is read."] = "%s não está instalado: %s é lido.",
    ["Neither addon is installed: no auction house prices."] = "Nenhum dos dois addons está instalado: sem" ..
        " preços da casa de leilões.",

    -- the Specialization view
    ["%s%d / %d|r  %s"] = "%s%d / %d|r  %s",
    ["level %d (you're %d)"] = "nível %d (você tem %d)",
    ["%s %d (you have %d)"] = "%s %d (você tem %d)",
    ["Needs %s."] = "Precisa de %s.",
    [" and "] = " e",
    ["Or take it here instead:"] = "Ou pegue aqui no lugar:",
    ["Take the quest:"] = "Pegue a missão:",
    ["Take and hand in the quest:"] = "Pegue e entregue a missão:",
    ["Hand it in:"] = "Entregue:",
    ["you have them all"] = "você tem todos",
    ["auction house %s"] = "casa de leilões %s",
    ["none at the auction house"] = "nada na casa de leilões",
    ["Make %d; some of its ingredients have no price; %s"] = "Faça %d; alguns reagentes não têm preço; %s",
    ["Make %d for %s; %s"] = "Faça %d por %s; %s",
    ["Buy %d: %s%s"] = "Compre %d: %s%s",
    [", making them costs %s"] = ", fazê-los custa %s",
    ["Drops from %s"] = "Cai de %s",
    ["Drops from %d kinds of creatures; "] = "Cai de %d tipos de criaturas;",
    ["none at the auction house now"] = "nada na casa de leilões agora",
    [", learned at %d"] = ", aprendido em %d",
    ["its recipe drops from %d kinds of creatures, none at the auction house now"] = "a receta dele cai de %d" ..
        " tipos de criaturas, nada na casa de leilões agora",
    ["no way to learn it for you now"] = "não há como você aprender agora",
    ["Buy the recipe:"] = "Compre a receita:",
    ["Learn it from the trainer:"] = "Aprenda com o mestre:",
    ["Bring to %s:"] = "Leve para %s:",
    ["the quest giver"] = "quem dá a missão",
    ["%s%d %s%s"] = "%s%d %s%s",
    ["smelt "] = "fundir",
    [" (besides the %d you have)"] = " (além dos %d que você tem)",
    ["Make: %s"] = "Fazer: %s",
    ["Ingredients:"] = "Reagentes:",
    ["buy %d: "] = "compre %d:",
    ["the smith"] = "o ferreiro",
    ["%d. Talk to %s"] = "%d. Fale com %s",
    ["Talk to:"] = "Fale com:",
    ["%d. Master a weapon: one of them"] = "%d. Domine uma arma: uma delas",
    ["%s: the quest %s"] = "%s: a missão %s",
    ["The recipes"] = "As receitas",
    ["  %d to learn"] = "  %d a aprender",
    ["Click to fold or open."] = "Clique para fechar ou abrir.",
    ["Show the steps to %s."] = "Mostrar os passos até %s.",
    ["You have this specialization."] = "Você tem esta especialização.",
    ["Needs level %d and %s %d; you're level %d with %d."] = "Precisa de nível %d e %s %d; você é nível %d com" ..
        " %d.",
    ["Unlocks %d recipes only this specialization can learn."] = "Libera %d receitas que só esta" ..
        " especialização pode aprender.",
    ["You have %s: a character can have only one %s specialization."] = "Você tem %s: um personagem só pode" ..
        " ter uma especialização em %s.",
    ["Still to spend: %s, each item made or bought, whichever costs less%s."] = "Ainda a gastar: %s, cada item" ..
        " feito ou comprado, o que custar menos%s.",
    ["; some have no price"] = "; alguns não têm preço",
    ["You have %s"] = "Você tem %s",
    ["To %s: about %s%s"] = "Até %s: cerca de %s%s",
    [", some items unpriced"] = ", alguns itens sem preço",

    -- the window: the list, its rows and their tooltips
    [" - %s%s %d|r"] = " - %s%s %d|r",
    ["%d days"] = "%d dias",
    ["%d hours"] = "%d horas",
    ["~%d min"] = "~%d min",
    ["All locks"] = "Todas as fechaduras",
    ["Every lock a rogue picks, by the skill it needs, and its colour for you."] = "Cada fechadura que um" ..
        " ladino arromba, pela perícia que ela pede e a cor dela para você.",
    ["At %d your cap is the level x 5: %d at level %d."] = "Em %d seu limite é seu nível x 5: %d no nível %d.",
    ["at %d, cap %d"] = "em %d, limite %d",
    ["Skill"] = "Perícia",
    ["Smelt on the way"] = "Fundir no caminho",
    ["Trainer"] = "Mestre",
    ["Catches"] = "Pescas",
    ["Lure"] = "Isca",
    ["none"] = "nenhuma",
    ["Cost"] = "Custo",
    ["In your bags"] = "Nas suas bolsas",
    [", soulbound"] = ", vinculado",
    ["One craft"] = "Uma produção",
    ["Disenchanted"] = "Desencantado",
    ["Sold"] = "Vendido",
    [" at the auction house"] = " na casa de leilões",
    [" at a vendor"] = " a um vendedor",
    ["nobody buys it"] = "ninguém compra",
    ["Best"] = "Melhor",
    ["Disenchanting one craft"] = "Desencantar uma produção",
    ["Cheapest listing"] = "Oferta mais barata",
    ["Gains"] = "Rende",
    [", more %d%% of the time"] = ", mais em %d%% das vezes",
    ["Raises"] = "Aumenta",
    ["Cook one"] = "Cozinhar um",
    ["Buy one"] = "Comprar um",
    ["Sells for"] = "Vende por",
    ["Profit"] = "Lucro",
    ["Listed"] = "À venda",
    ["%d - %d, ~%d %s"] = "%d - %d, ~%d %s",
    ["%s of ~%d, from what you have (vendor reagents aside)"] = "%s de ~%d, com o que você tem (reagentes de" ..
        " vendedor à parte)",
    ["%slvl %d|r - "] = "%snív %d|r -",
    ["known, make %d now"] = "conhecida, faça %d agora",
    ["learn now (skill %d)"] = "aprender agora (perícia %d)",
    ["skill %d (you %d)"] = "perícia %d (você %d)",
    ["level %d (you %d)"] = "nível %d (você %d)",
    ["%s ready"] = "%s pronto",
    ["chests, boxes and doors by skill"] = "baús, caixas e portas por perícia",
    ["Reach level %d"] = "Chegar ao nível %d",
    ["at %d, raises your cap to %d%s"] = "em %d, sobe seu limite para %d%s",
    ["Fish in %s"] = "Pescar em %s",
    ["your pick"] = "sua escolha",
    ["an hour: ~%d catches, %s each%s%s"] = "uma hora: ~%d pescas, %s cada%s%s",
    ["%d - %d, ~%d catches%s"] = "%d - %d, ~%d pescas%s",
    ["%s%s, %s%s%s%s%s%s"] = "%s%s, %s%s%s%s%s%s",
    ["%s, %s, disenchanted ~%s, sold %s"] = "%s, %s, desencantado ~%s, vendido %s",
    ["%s's %s - %s: ~%s disenchanted, %s sold%s"] = "%s, %s - %s: ~%s desencantado, %s vendido%s",
    ["buy %s, ~%s disenchanted, pays %d%% of the time"] = "compre %s, ~%s desencantado, compensa em %d%% das" ..
        " vezes",
    ["%d - %d%s: %s"] = "%d - %d%s: %s",
    ["keep them"] = "guarde-os",
    ["unconfirmed"] = "não confirmado",
    ["after %d%s, %sneeded for %s|r"] = "depois de %d%s, %sprecisa para %s|r",
    ["%s%s, %smake one and keep it|r"] = "%s%s, %sfaça um e guarde|r",
    ["%d favor"] = "%d favor",
    ["? favor"] = "? favor",
    ["Open your %s window once so Craft Ladder knows which recipes you have."] = "Abra sua janela de %s uma" ..
        " vez para que o Craft Ladder saiba quais receitas você tem.",
    ["No %s found past %d with what Craft Ladder knows."] = "Nenhum %s encontrado além de %d com o que o Craft" ..
        " Ladder conhece.",
    ["zone"] = "zona",
    ["recipe"] = "receita",
    ["Back to your ladder"] = "Voltar à sua escada",
    ["Merchant's Favor recipes (%d)"] = "Receitas de Favor do Mercador (%d)",
    ["Dishes for this role, by what eating one raises. Click to fold or open."] = "Pratos para este papel," ..
        " pelo que comer um aumenta. Clique para fechar ou abrir.",
    ["Nothing here"] = "Nada aqui",
    ["Nothing earns this way at today's prices."] = "Nada rende assim pelos preços de hoje.",
    ["Sell to a vendor"] = "Vender a um vendedor",
    ["These cost less to make than a vendor pays: vendors buy any number, no auction house needed. Click to" ..
        " fold or open."] = "Estes custam menos para fazer do que um vendedor paga: vendedores compram" ..
        " qualquer quantidade, sem casa de leilões. Clique para fechar ou abrir.",
    ["Sell at the auction house"] = "Vender na casa de leilões",
    ["These earn more at the auction house: 5 or more listed (or however few when you searched it yourself)," ..
        " and it pays 1.5 times what a vendor does. How many sell, the auction house doesn't say."] =
        "Estes rendem mais na casa de leilões: 5 ou mais à venda (ou quantos forem se você mesmo buscou), e" ..
        " ela paga 1,5 vezes o que um vendedor dá. Quantos vão vender, a casa de leilões não diz.",
    ["nothing at today's prices"] = "nada pelos preços de hoje",
    ["Disenchant, your whole account: no Enchanting needed"] = "Desencantar, toda a sua conta: não precisa de Encantamento",
    ["the ladder from %d to %d"] = "a escada de %d até %d",
    ["the ladder to %d"] = "a escada até %d",
    ["%s%s %d / %d, %s%s"] = "%s%s %d / %d, %s%s",
    ["as of %s"] = "em %s",
    ["%s has no %s yet"] = "%s ainda não tem %s",
    ["No %s yet"] = "Ainda sem %s",
    ["Specialization"] = "Especialização",
    ["Skill %d"] = "Perícia %d",
    ["No auction house prices: AuctionDB or Auctionator needed"] = "Sem preços da casa de leilões: é preciso" ..
        " AuctionDB ou Auctionator",
    [" %s prices scanned %s, costs may be off: scan at the auction house|r"] = " Preços de %s escaneados %s," ..
        " os custos podem estar errados: escaneie na casa de leilões|r",
    ["%s prices scanned %s: scan at the auction house|r"] = "Preços de %s escaneados %s: escaneie na casa de" ..
        " leilões|r",
    ["Prices: %s, scanned %s (%s)|r"] = "Preços: %s, escaneados %s (%s)|r",
    ["today"] = "hoje",
    ["yesterday"] = "ontem",
    ["%d days ago"] = "há %d dias",
    ["Prices: Auctionator, newest prices from %s|r"] = "Preços: Auctionator, preços mais novos de %s|r",
    ["Prices: %s"] = "Preços: %s",
    ["%d Merchant's Favor recipes, %d you can learn now%s"] = "%d receitas de Favor do Mercador, %d que você" ..
        " pode aprender agora%s",
    ["; you have %d favor"] = "; você tem %d de favor",
    ["%d dishes for your class; the cost is one dish from bought ingredients"] = "%d pratos para sua classe; o" ..
        " custo é um prato com reagentes comprados",
    ["%d zones at skill %d; the best about %s an hour"] = "%d zonas na perícia %d; a melhor cerca de %s por" ..
        " hora",
    ["Spend %s, catch about %s worth (%s, %s an hour)"] = "Gaste %s, pesque cerca de %s em valor (%s, %s por" ..
        " hora)",
    ["Spend %s, %s about %s worth (%s an hour), about %d %s"] = "Gaste %s, %s cerca de %s em valor (%s por" ..
        " hora), cerca de %d %s",
    ["%s%d at the auction house; the best +%s a craft"] = "%s%d na casa de leilões; o melhor +%s por produção",
    ["Total %s, about %d %s%s"] = "Total %s, cerca de %d %s%s",
    ["Total %s, about %d catches (%s)"] = "Total %s, cerca de %d pescas (%s)",
    ["Spend %s, about %s back from sales, about %d crafts"] = "Gaste %s, cerca de %s de volta nas vendas," ..
        " cerca de %d produções",
    ["Total %s, about %d crafts"] = "Total %s, cerca de %d produções",
    ["Plan the ladder to %d."] = "Planejar a escada até %d.",
    ["Window size"] = "Tamanho da janela",
    ["Drag: make the window bigger."] = "Arrastar: deixar a janela maior.",
    ["Ctrl + mouse wheel: bigger or smaller text (now %d%%)."] = "Ctrl + roda do mouse: texto maior ou menor" ..
        " (agora %d%%).",
    ["Right-click: back to the normal size."] = "Clique direito: voltar ao tamanho normal.",
    ["Close"] = "Fechar",
    ["Escape closes it too."] = "Esc também fecha.",
    ["Settings"] = "Configurações",
    ["Which auction house addon the prices are read from, and which of its listed prices an ingredient costs."] =
        "De qual addon de casa de leilões os preços são lidos, e qual dos preços à venda dele um reagente" ..
        " custa.",
    ["Your hands are idle, adventurer."] = "Suas mãos estão ociosas, aventureiro.",
    ["The trainers are waiting: learn a profession."] = "Os mestres esperam: aprenda uma profissão.",
    ["The steps to each of its specializations: the quests, what they ask for and what you have of it, the" ..
        " recipes, and what's still to make or buy."] = "Os passos até cada uma das especializações dela: as" ..
        " missões, o que elas pedem e o que você tem disso, as receitas, e o que falta fazer ou comprar.",
    ["Merchant's Favor recipes"] = "Receitas de Favor do Mercador",
    ["What the supply camps' quartermaster sells for Merchant's Favor: its price and level (seen at a" ..
        " quartermaster), your skill, what you know and can make."] = "O que o intendente dos acampamentos de" ..
        " suprimentos vende por Favor do Mercador: preço e nível (vistos num intendente), sua perícia, o que" ..
        " você conhece e pode fazer.",
    ["Back to cheapest"] = "Voltar à mais barata",
    ["Use the cheapest recipe for this step again."] = "Usar de novo a receita mais barata para este passo.",
    ["Search the auction house"] = "Buscar na casa de leilões",
    ["Auctionator's Shopping tab with this item. The auction house must be open."] = "A aba de Compras do" ..
        " Auctionator com este item. A casa de leilões precisa estar aberta.",
    ["Also use recipes bought with Merchant's Favor."] = "Usar também receitas compradas com Favor do" ..
        " Mercador.",
    ["Reset"] = "Redefinir",
    ["The ladder from your skill to 300 again."] = "A escada da sua perícia até 300 de novo.",
    ["No profession yet"] = "Ainda sem profissão",

    -- the menu's group headings
    ["PROFESSIONS"] = "PROFISSÕES",
    ["SECONDARY"] = "SECUNDÁRIAS",
    ["CLASS"] = "CLASSE",

    -- the modes over the list, and what each one plans (the names the tooltips use)
    ["Vendor sales"] = "Vendedor",
    ["AH sales"] = "Leilão",
    ["Food"] = "Comida",
    ["Favor"] = "Favor",
    ["done"] = "feito",
    ["in your quest log"] = "no seu diário de missões",

    -- one option's tooltip and its row
    ["Click: put a map pin and the arrow on it."] = "Clique: pôr uma marca no mapa e a seta para ela.",
    ["%s that give points"] = "%s que dão pontos",
    ["%s for this step"] = "%s para este passo",
    ["A %s is worth"] = "Um %s vale",
    ["Gold an hour"] = "Ouro por hora",
    ["Click to %s here for this step."] = "Clique: %s aqui para este passo.",
    ["Fish that land"] = "Peixes que mordem",
    ["all of them"] = "todos",
    ["none needed"] = "nenhuma necessária",
    ["A catch is worth"] = "Uma pesca vale",
    ["Lures for this step"] = "Iscas para este passo",
    ["Click to fish here for this step."] = "Clique: pescar aqui para este passo.",
    ["%s the %d you can make from what you have."] = "%s os %d que você pode fazer com o que tem.",
    ["Ingredients"] = "Reagentes",
    ["Learn"] = "Aprender",
    ["Recipe"] = "Receita",
    ["Selling them brings back"] = "Vendê-los devolve",
    ["Per skill point"] = "Por ponto de perícia",
    ["Click to use this recipe for this step."] = "Clique: usar esta receita para este passo.",
    ["~%d %s, %s a %s"] = "~%d %s, %s por %s",
    ["%s at the trainer"] = "%s no mestre",
    ["no fish get away"] = "nenhum peixe escapa",
    ["%d%% of casts land a fish"] = "%d%% dos lançamentos trazem um peixe",
    [", with %s"] = ", com %s",
    ["%s a catch%s"] = "%s por pesca%s",
    [", lures %s"] = ", iscas %s",
    [" / catch"] = " / pesca",
    ["%s for lures"] = "%s em iscas",
    ["  with what you have"] = "  com o que você tem",
    ["from your bags"] = "das suas bolsas",
    ["bought at the auction house"] = "comprado na casa de leilões",
    ["learn: %s"] = "aprender: %s",
    [" / point"] = " / ponto",
    ["%s in all%s"] = "%s no total%s",
    [", %s back"] = ", %s de volta",
    [" / hour"] = " / hora",

    -- a folded list, the ingredients, the colours
    ["all %d %s"] = "todos os %d %s",
    ["and %d more %s"] = "e mais %d %s",
    ["and %d more"] = "e mais %d",
    ["vendors"] = "vendedores",
    ["trainers"] = "mestres",
    [" (you have them)"] = " (você já tem)",
    ["  (you have %d%s)"] = "  (você tem %d%s)",
    [", in the bank"] = ", no banco",
    [", %d in the bank"] = ", %d no banco",
    ["smelt"] = "fundir",
    ["%s %d yourself from %s%s"] = "%s %d você mesmo com %s%s",
    [", buy the other %d"] = ", compre os outros %d",
    ["you have enough"] = "você tem o bastante",
    ["only %d listed - you need %d"] = "só %d à venda - você precisa de %d",
    ["  your Cooking uses it"] = "  sua Culinária usa",
    ["%d%% of catches%s"] = "%d%% das pescas%s",
    [" each"] = " cada",
    ["  creatures level %d+|r"] = "  criaturas de nível %d+|r",
    ["at the auction house, after its cut"] = "na casa de leilões, após a taxa dela",
    ["at a vendor"] = "a um vendedor",
    ["what's inside, on average"] = "o que há dentro, em média",
    ["orange"] = "laranja",
    ["yellow"] = "amarelo",
    ["green"] = "verde",
    ["grey"] = "cinza",
    ["from %d"] = "a partir de %d",
    ["Your pick."] = "Sua escolha.",

    -- the Craft bar
    ["An enchantment: enchant from the profession window, on the item."] = "Um encantamento: encante pela" ..
        " janela da profissão, no item.",
    ["Learn the recipe first."] = "Aprenda a receita primeiro.",
    ["Not in combat."] = "Não em combate.",
    ["Not enough reagents in your bags."] = "Reagentes insuficientes nas suas bolsas.",
    ["Craft"] = "Produzir",
    ["Crafts as many as the box says; opens your profession window first if it's closed (the game crafts only" ..
        " with it open)."] = "Produz quantos o campo disser; abre antes sua janela de profissão se estiver" ..
        " fechada (o jogo só produz com ela aberta).",
    [" Cooking needs a fire nearby."] = " A Culinária precisa de um fogo por perto.",
    ["Your bags allow %d"] = "Suas bolsas dão para %d",
    ["; the step needs %d."] = "; o passo precisa de %d.",
    ["Opening your %s window: crafting once it's ready."] = "Abrindo sua janela de %s: vou produzir assim que" ..
        " estiver pronta.",

    -- how to learn a recipe
    ["Learn it"] = "Como aprender",
    ["Buy the recipe from %s:"] = "Compre a receita de %s:",
    ["one of these vendors"] = "um destes vendedores",
    ["this vendor"] = "este vendedor",
    ["%s Favor"] = "Favor %s",
    ["Merchant's"] = "do Mercador",
    ["Quest reward: %s%s"] = "Recompensa de missão: %s%s",
    ["(needs level %d)"] = "(precisa de nível %d)",
    ["quest giver"] = "dá a missão",
    ["Only these trainers teach it, for %s:"] = "Só estes mestres ensinam, por %s:",
    ["trainer"] = "mestre",
    ["None of them is of your faction."] = "Nenhum deles é da sua facção.",
    ["Or buy it at the auction house: %s."] = "Ou compre na casa de leilões: %s.",
    ["Or %s."] = "Ou %s.",
    ["During %s: %s."] = "Durante %s: %s.",
    ["The price is an estimate: Craft Ladder learns the real one when you visit the %s."] =
        "O preço é uma estimativa: o Craft Ladder saberá o real quando você passar por lá (%s).",
    ["vendor"] = "vendedor",

    -- what it sells for, and one craft
    ["An enchantment: nothing to sell."] = "Um encantamento: nada para vender.",
    ["%s%s at the auction house (after its cut%s)."] = "%s%s na casa de leilões (após a taxa dela%s).",
    ["Not on the auction house."] = "Não está na casa de leilões.",
    ["%s%s at a vendor."] = "%s%s a um vendedor.",
    ["Vendors don't buy it."] = "Vendedores não compram.",
    ["One craft%s: %s"] = "Uma produção%s: %s",
    ["One craft: %s"] = "Uma produção: %s",
    [" (makes %d)"] = " (faz %d)",
    ["auction house"] = "casa de leilões",
    ["%s yourself%s"] = "%s você mesmo%s",
    [" and %s"] = " e %s",
    ["%s each, %s"] = "%s cada, %s",
    ["Each sells for "] = "Cada um vende por",
    ["Sells for "] = "Vende por",
    ["%d sell for "] = "%d vendem por",

    -- a Merchant's Favor recipe
    ["You know it."] = "Você conhece.",
    ["You can learn it now."] = "Você pode aprender agora.",
    ["It needs %d %s (you: %d)."] = "Precisa de %d %s (você: %d).",
    ["It needs level %d (you: %d)."] = "Precisa de nível %d (você: %d).",
    ["Merchant's Favor"] = "Favor do Mercador",
    ["Costs %d Merchant's Favor%s."] = "Custa %d de Favor do Mercador%s.",
    [" (you have %d)"] = " (você tem %d)",
    ["Its price: open a quartermaster once and Craft Ladder remembers it."] = "O preço dele: passe uma vez num" ..
        " intendente e o Craft Ladder guarda.",
    ["From level %d (you: %d)."] = "A partir do nível %d (você: %d).",
    ["Its level: open a quartermaster once and Craft Ladder remembers it."] = "O nível dele: passe uma vez num" ..
        " intendente e o Craft Ladder guarda.",
    ["From %d %s (you: %d)."] = "A partir de %d %s (você: %d).",
    ["%s is %s from level %d (you: %d)."] = "%s %s a partir do nível %d (você: %d).",
    ["worn"] = "é usado no corpo",
    ["used"] = "é usado",
    ["Quartermaster"] = "Intendente",
    ["The plan needs %s with %s."] = "O plano precisa de %s com %s.",
    ["Only for %s."] = "Só para %s.",
    ["Hated"] = "Ódio",
    ["Hostile"] = "Hostil",
    ["Unfriendly"] = "Inamistoso",
    ["Neutral"] = "Neutro",
    ["Friendly"] = "Amistoso",
    ["Honored"] = "Honrado",
    ["Revered"] = "Reverenciado",
    ["Exalted"] = "Exaltado",

    -- a crafting step
    ["Skill %d - %d, about %d crafts, %s%s"] = "Perícia %d - %d, cerca de %d produções, %s%s",
    ["some prices missing"] = "faltam alguns preços",
    ["%s %s what you already have: %d crafts%s."] = "%s %s com o que você já tem: %d produções%s.",
    [", plus a few vendor ingredients"] = ", mais alguns reagentes de vendedor",
    [", nothing to buy"] = ", nada para comprar",
    ["You can %s %d now with what you have."] = "%s: agora %d com o que você tem.",
    ["You have the reagents for %d."] = "Você tem os reagentes para %d.",
    ["You have the main ingredients for %d; the rest is sold by vendors."] = "Você tem os reagentes principais" ..
        " para %d; o resto é vendido por vendedores.",
    ["The cheapest here is %s."] = "O mais barato aqui é %s.",
    ["Needed for %s: %d recipes (%s, ...), and no vendor sells it. None of them is for leveling (a cooldown," ..
        " or learned at 300): make it once you're done."] = "Preciso para %s: %d receitas (%s, ...), e nenhum" ..
        " vendedor vende. Nenhuma delas serve para subir (tem recarga, ou se aprende em 300): faça quando você" ..
        " terminar.",
    ["A tool: %d %s recipes need it, and no vendor sells it. Make one and keep it in your bags%s."] =
        "Uma ferramenta: %d receitas de %s precisam dela, e nenhum vendedor vende. Faça uma e guarde nas" ..
        " bolsas%s.",
    [" (it gives no skill point any more)"] = " (não dá mais ponto de perícia)",
    ["You have %s: the step takes them from your bags, so it pays less than that."] =
        "Você tem %s: o passo tira das suas bolsas, então paga menos que isso.",
    ["Keep for later"] = "Guardar para depois",
    ["Keep %d %s: the steps at %d - %d use them."] = "Guarde %d %s: os passos em %d - %d usam.",
    ["Batch: %s"] = "Lote: %s",
    ["Craft counts are estimates: skill-ups are luck once a recipe is yellow."] = "O número de produções é uma" ..
        " estimativa: pontos de perícia são sorte assim que uma receita fica amarela.",
    ["Sell the rest"] = "Vender o resto",
    ["Sell what you make"] = "Vender o que você faz",
    ["%d at the auction house, about %s each after its cut."] = "%d na casa de leilões, cerca de %s cada após" ..
        " a taxa dela.",
    ["%d to a vendor, %s each."] = "%d a um vendedor, %s cada.",
    ["About %s back, so this step %s %s."] = "Cerca de %s de volta, então este passo %s %s.",
    ["earns"] = "rende",
    ["costs"] = "custa",
    ["Vendor sales counts only what vendors pay: that money is sure. AH sales counts the auction house too."] =
        "Vendas a vendedor conta só o que os vendedores pagam: esse dinheiro é certo. Vendas na CL conta a" ..
        " casa de leilões também.",
    ["The auction house counts only when it pays 1.5 times a vendor and 5 or more are listed, and for at most" ..
        " a quarter of what's listed."] = "A casa de leilões só conta quando paga 1,5 vezes o de um vendedor e" ..
        " há 5 ou mais à venda, e no máximo por um quarto do que está à venda.",
    ["Or %s, from %d"] = "Ou %s, a partir de %d",
    ["Recipes you could use from %d"] = "Receitas que você poderia usar a partir de %d",
    ["No other recipe is open to you here."] = "Aqui não há outra receita aberta para você.",

    -- Gold: one recipe's profit
    ["One craft%s costs about %s and sells for about %s: %s+%s|r"] = "Uma produção%s custa cerca de %s e vende" ..
        " por cerca de %s: %s+%s|r",
    ["Sold to a vendor: vendors buy any number."] = "Vendido a um vendedor: vendedores compram qualquer" ..
        " quantidade.",
    ["%d listed at the auction house now: sell a few at a time."] = "%d à venda na casa de leilões agora:" ..
        " venda poucos de cada vez.",
    ["Making it needs %s %d, and yours is %d%s. It's here to level towards."] = "Fazer pede %s %d, e o seu é" ..
        " %d%s. Está aqui como meta.",
    ["; the rank that lifts your cap to it asks level %d, and you're %d"] = "; o grau que sobe seu limite até" ..
        " lá pede nível %d, e você tem %d",
    ["Learning it pays back after %d %s."] = "Aprender se paga depois de %d %s.",
    ["craft"] = "produção",
    ["crafts"] = "produções",
    ["Once in %s: the recipe has a cooldown."] = "Uma vez a cada %s: a receita tem recarga.",
    ["You have %s: counted at their price too, since you could sell them."] = "Você tem %s: contados pelo" ..
        " preço deles também, já que poderia vendê-los.",
    ["Profit: what a vendor pays, less the ingredients at today's prices. How many you can make, the auction" ..
        " house's ingredients decide."] = "Lucro: o que um vendedor paga, menos os reagentes pelos preços de" ..
        " hoje. Quantos você pode fazer, quem decide são os reagentes da casa de leilões.",
    ["Profit: at the lowest listing after the auction house's cut, with 5 or more listed, or however few when" ..
        " you searched it yourself; it counts only when it pays 1.5 times what a vendor does. How many sell," ..
        " the auction house doesn't say. Prices change: look again before buying."] =
        "Lucro: pela oferta mais barata após a taxa da casa de leilões, com 5 ou mais à venda, ou quantos" ..
        " forem se você mesmo buscou; só conta quando paga 1,5 vezes o que um vendedor dá. Quantos vão vender," ..
        " a casa de leilões não diz. Preços mudam: olhe de novo antes de comprar.",

    -- Disenchant
    ["Disenchant one: about %s"] = "Desencantar um: cerca de %s",
    ["%d%% of disenchants, %s each"] = "%d%% dos desencantamentos, %s cada",
    ["%s%d disenchanted: about %s, at least %s 9 times out of 10."] = "%s%d desencantados: cerca de %s, pelo" ..
        " menos %s em 9 de 10 vezes.",
    ["Your "] = "Seus",
    ["What it gives: from your %d disenchants of this item, recorded in game: it breaks unlike items of its" ..
        " kind."] = "O que dá: pelos seus %d desencantamentos deste item, registrados no jogo: ele se desfaz" ..
        " diferente dos itens do tipo dele.",
    ["What it gives: from %d disenchants of items like it, recorded in game."] = "O que dá: por %d" ..
        " desencantamentos de itens parecidos, registrados no jogo.",
    ["You've disenchanted %d like it: %s in all. From %d, what you got replaces the table."] =
        "Você desencantou %d parecidos: %s no total. A partir de %d, o que você obteve substitui a tabela.",
    ["Forever added this kind of item: what it gives is a guess, checked for one item: a green's of its level," ..
        " one more of each."] = "O Forever acrescentou este tipo de item: o que ele dá é um palpite, conferido" ..
        " em um item: como o de um verde do nível dele, um a mais de cada.",
    ["What a disenchant gives is luck%s. Materials at the auction house after its cut; 3 lesser essences make" ..
        " a greater one."] = "O que um desencantamento dá é sorte%s. Materiais na casa de leilões após a taxa" ..
        " dela; 3 essências menores fazem uma maior.",
    [", from Classic's table (not checked in Forever yet): from %d of your disenchants of items like it, what" ..
        " you got replaces it"] = ", pela tabela do Classic (ainda não conferida no Forever): a partir de %d" ..
        " dos seus desencantamentos de itens parecidos, o que você obteve a substitui",
    ["One craft%s costs about %s; disenchanted, about %s on average: %s"] = "Uma produção%s custa cerca de %s;" ..
        " desencantada, cerca de %s em média: %s",
    ["A %s recipe %s knows."] = "Uma receita de %s que %s conhece.",
    ["you"] = "você",
    ["Making it costs more than disenchanting brings: disenchant it when you make it anyway, for skill."] =
        "Fazer custa mais do que desencantar rende: desencante quando fizer de qualquer jeito, pela perícia.",
    ["Best: %s. %d in %s's %s: disenchanted, about %s on average; sold, %s."] = "Melhor: %s. %d com %s, %s:" ..
        " desencantado, cerca de %s em média; vendido, %s.",
    ["your"] = "suas",
    ["bags"] = "bolsas",
    ["Soulbound: no auction house."] = "Vinculado: sem casa de leilões.",
    ["Or sell it"] = "Ou vender",
    ["Soulbound: the auction house won't take it."] = "Vinculado: a casa de leilões não aceita.",
    ["%s each at the auction house (after its cut%s)."] = "%s cada na casa de leilões (após a taxa dela%s).",
    ["%s each at a vendor."] = "%s cada a um vendedor.",
    ["The auction house counts with 5 or more listed, or however few when you searched it yourself. What made" ..
        " it doesn't count: it's made."] = "A casa de leilões conta com 5 ou mais à venda, ou quantos forem se" ..
        " você mesmo buscou. Do que foi feito não conta: já está feito.",
    ["Buy one for %s; disenchanted, about %s on average: %s"] = "Compre um por %s; desencantado, cerca de %s" ..
        " em média: %s",
    ["One disenchant brings more than it cost %d%% of the time."] = "Um desencantamento rende mais do que" ..
        " custou em %d%% das vezes.",
    ["Buy it"] = "Comprar",
    ["The cheapest listing: %s. %s."] = "A oferta mais barata: %s. %s.",
    ["Its level and quality are Classic's: Forever's client doesn't list it. "] = "Nível e qualidade são do" ..
        " Classic: o cliente do Forever não os traz.",
    ["A random suffix (\"of the Monkey\") doesn't change what it breaks into. The listing may have sold since" ..
        " the scan."] = "Um sufixo aleatório (\"do macaco\") não muda em que ele se desfaz. A oferta pode ter" ..
        " sido vendida desde o escaneamento.",
    ["Nothing to disenchant"] = "Nada para desencantar",
    ["No character of yours holds anything to disenchant, and "] = "Nenhum personagem seu carrega algo para" ..
        " desencantar, e",
    ["none of the recipes they know makes something to disenchant: open a crafting profession's window once so" ..
        " Craft Ladder knows its recipes."] = "nenhuma das receitas que eles conhecem faz algo para" ..
        " desencantar: abra uma vez a janela de uma profissão de produção para o Craft Ladder conhecer as" ..
        " receitas dela.",
    ["nothing they can make is worth more disenchanted than sold at today's prices."] =
        "nada do que eles podem fazer vale mais desencantado do que vendido pelos preços de hoje.",

    -- Cooking's Food
    [" (Well Fed). "] = " (Bem Alimentado).",
    ["Needs level %d; you're %d."] = "Precisa de nível %d; você tem %d.",
    ["Level %d: you can eat it."] = "Nível %d: você pode comer.",
    ["Any level can eat it."] = "Qualquer nível pode comer.",
    ["Nobody sells its recipe now: look for it at the auction house."] = "Ninguém vende a receita agora:" ..
        " procure na casa de leilões.",
    ["No way to learn it for you now (a holiday's, or the other side's)."] = "Não há como você aprender agora" ..
        " (é de um feriado, ou do outro lado).",
    ["Learned at %s %d; you have %d."] = "Aprendido em %s %d; você tem %d.",
    ["You have %s: cooking it takes them from your bags, so it costs you less than that."] =
        "Você tem %s: cozinhar tira das suas bolsas, então custa menos que isso.",
    ["Or buy it"] = "Ou comprar",
    ["One at the auction house: %s."] = "Um na casa de leilões: %s.",
    ["None listed at the auction house now."] = "Nenhum à venda na casa de leilões agora.",
    ["What it raises is read from the game's files, not checked in game yet."] = "O que ele aumenta é lido dos" ..
        " arquivos do jogo, ainda não conferido no jogo.",

    -- a rank step
    ["At skill %d. Your cap is your level x 5: %d at level %d."] = "Na perícia %d. Seu limite é seu nível x 5:" ..
        " %d no nível %d.",
    ["You're level %d."] = "Você é nível %d.",
    ["Your level allows it already."] = "Seu nível já permite.",
    ["Lockpicking can't go past your level x 5: level up before you go on."] = "Arrombamento não passa do seu" ..
        " nível x 5: suba de nível antes de seguir.",
    ["Learn %s%s"] = "Aprender %s%s",
    ["At skill %d, raises your cap to %d. %s"] = "Na perícia %d, sobe seu limite para %d. %s",
    ["Needs character level %d."] = "Precisa de nível de personagem %d.",
    ["How"] = "Como",
    ["Only these trainers teach it%s:"] = "Só estes mestres ensinam%s:",
    [", for %s"] = ", por %s",
    ["Any %s trainer teaches it%s."] = "Qualquer mestre (%s) ensina%s.",
    [" for %s"] = " por %s",
    ["Buy the %s and read it:"] = "Compre %s e leia:",
    ["At the auction house: %s."] = "Na casa de leilões: %s.",
    ["Or buy it at the auction house: %s.%s"] = "Ou compre na casa de leilões: %s.%s",
    [" Cheaper than the vendor, so the ladder counts this one."] = " Mais barato que no vendedor, então a" ..
        " escada conta este.",
    ["1. Take the quest %s:"] = "1. Pegue a missão %s:",
    ["start"] = "início",
    ["2. Bring the ingredients below to %s for %s:"] = "2. Leve os reagentes abaixo a %s por %s:",
    ["hand in"] = "entrega",
    ["Do the quest %s for %s:"] = "Faça a missão %s com %s:",
    ["What to bring"] = "O que levar",
    ["Any %s trainer teaches Apprentice %s."] = "Qualquer mestre (%s) ensina Aprendiz (%s).",

    -- fishing
    ["Fish to catch"] = "Que peixes pescar",
    ["%s: %s, %s (fish bite from %d)"] = "%s: %s, %s (mordem a partir de %d)",
    ["seen by GatherMate2"] = "visto pelo GatherMate2",
    ["place known"] = "lugar conhecido",
    ["places known"] = "lugares conhecidos",
    [" a catch"] = " por pesca",
    ["%d - %d catches before it's gone"] = "%d - %d pescas antes de acabar",
    ["No fish get away here."] = "Aqui nenhum peixe escapa.",
    ["About %d%% of casts land a fish here."] = "Aqui cerca de %d%% dos lançamentos trazem um peixe.",
    ["An hour at skill %d: about %d catches, %s each"] = "Uma hora na perícia %d: cerca de %d pescas, %s cada",
    [" An hour's catches are worth about %s%s."] = " As pescas de uma hora valem cerca de %s%s.",
    [", lures paid"] = ", iscas pagas",
    ["Skill %d - %d, about %d catches (%s), %s"] = "Perícia %d - %d, cerca de %d pescas (%s), %s",
    [" Catches worth about %s (%s an hour)."] = " Pescas valendo cerca de %s (%s por hora).",
    ["Craft Ladder's choice here is %s."] = "A escolha do Craft Ladder aqui é %s.",
    ["Its creatures are level %d - %d."] = "As criaturas daqui são nível %d - %d.",
    ["Bring"] = "Levar",
    ["Put %s on your pole: +%d fishing for %d minutes, so no fish get away."] = "Ponha %s na sua vara: +%d em" ..
        " pesca por %d minutos, e nenhum peixe escapa.",
    ["Fishing supplies vendors sell lures, in every capital."] = "As iscas são vendidas por vendedores de" ..
        " artigos de pesca, em cada capital.",
    ["No lure needed: your skill keeps the fish from getting away."] = "Nenhuma isca necessária: sua perícia" ..
        " já impede que os peixes escapem.",
    ["What you catch here"] = "O que você pesca aqui",
    ["Fishing pools here"] = "Cardumes aqui",
    ["Fish pools when you see them: Craft Ladder counts a third of your catches here from pools. That makes a" ..
        " catch worth %s on average (%s in open water)."] = "Pesque nos cardumes quando os vir: o Craft Ladder" ..
        " conta aqui um terço das suas pescas em cardumes. Assim uma pesca vale %s em média (%s em água" ..
        " aberta).",
    ["No fishing pools known here yet. GatherMate2 adds the ones you fish, and Craft Ladder counts them."] =
        "Nenhum cardume conhecido aqui ainda. O GatherMate2 acrescenta aqueles em que você pesca, e o Craft" ..
        " Ladder os conta.",
    ["Catches per point: from your %d catches, skill-ups come %d%% as often as Classic's rule says."] =
        "Pescas por ponto: pelas suas %d pescas, os pontos de perícia saem a %d%% do que diz a regra do" ..
        " Classic.",
    ["Catches per point follow Classic's rule (at 150, one point in about 4 catches) until Craft Ladder has" ..
        " counted 50 of your catches (%d so far)."] = "As pescas por ponto seguem a regra do Classic (em 150," ..
        " um ponto a cada 4 pescas mais ou menos) até o Craft Ladder ter contado 50 pescas suas (%d até" ..
        " agora).",
    ["Zones and their fish come from Classic's world: Forever may differ."] = "As zonas e seus peixes vêm do" ..
        " mundo do Classic: no Forever pode ser diferente.",
    ["Other zones from %d"] = "Outras zonas a partir de %d",
    ["No other zone is open to you here."] = "Aqui não há outra zona aberta para você.",

    -- skinning and mining
    ["about %d in the zone, %s %s each%s"] = "cerca de %d na zona, %s %s cada%s",
    [", worth %s"] = ", vale %s",
    ["needs %d"] = "precisa de %d",
    ["%s  %slevel %d%s|r"] = "%s  %snível %d%s|r",
    [", seen skinned"] = ", já esfolada",
    ["about %d in the zone, needs %d%s"] = "cerca de %d na zona, precisa de %d%s",
    [", %s a skin"] = ", %s por couro",
    ["Skin in %s"] = "Esfolar em %s",
    ["An hour at skill %d: about %d creatures, %s each"] = "Uma hora na perícia %d: cerca de %d criaturas, %s" ..
        " cada",
    ["An hour's skins are worth about %s. Every creature you can skin counts, grey ones too."] =
        "Os couros de uma hora valem cerca de %s. Conta cada criatura que você pode esfolar, as cinzas também.",
    ["Skill %d - %d, about %d creatures%s"] = "Perícia %d - %d, cerca de %d criaturas%s",
    [", trainer %s"] = ", mestre %s",
    ["Worth about %s skinned (%s an hour)."] = "Vale cerca de %s esfolado (%s por hora).",
    ["Skin every creature that still gives a point, of your level or below."] = "Esfole cada criatura que" ..
        " ainda dá um ponto, do seu nível ou abaixo.",
    ["Its creatures are well above your level."] = "As criaturas daqui estão bem acima do seu nível.",
    ["Creatures to skin here"] = "Criaturas para esfolar aqui",
    ["Which creatures can be skinned and what one gives come from Classic; where they are and their levels" ..
        " from QuestieDB's Forever data. The skill one needs is Classic's rule from its level (level x 5 past" ..
        " 20), the colours Mining's (yellow 25, green 50, grey 100 above it). A creature new in Forever counts" ..
        " once you've skinned one."] = "Quais criaturas podem ser esfoladas e o que uma dá vêm do Classic;" ..
        " onde estão e o nível delas, dos dados do Forever do QuestieDB. A perícia pedida é a regra do Classic" ..
        " pelo nível delas (nível x 5 depois de 20), as cores as da Mineração (amarelo 25, verde 50, cinza 100" ..
        " acima). Uma criatura nova no Forever conta assim que você esfolar uma.",
    ["Gold an hour assumes %d s a creature (kill, loot, skin) and a 60%% mount between them: about %d an hour" ..
        " here."] = "O ouro por hora conta %d s por criatura (matar, saquear, esfolar) e uma montaria de 60%%" ..
        " entre elas: cerca de %d por hora aqui.",
    ["Other zones, from %d"] = "Outras zonas, a partir de %d",
    ["%s in %s"] = "%s em %s",
    ["An hour at skill %d: about %d %s, %s each"] = "Uma hora na perícia %d: cerca de %d %s, %s cada",
    ["An hour's worth about %s. Every %s you can reach counts, grey ones too. Creatures level %d - %d."] =
        "Uma hora vale cerca de %s. Conta cada %s que você alcança, os cinzas também. Criaturas de nível %d -" ..
        " %d.",
    ["Skill %d - %d, about %d %s%s"] = "Perícia %d - %d, cerca de %d %s%s",
    ["Worth about %s (%s an hour). Creatures level %d - %d."] = "Vale cerca de %s (%s por hora). Criaturas de" ..
        " nível %d - %d.",
    ["Creatures level %d - %d. %s every %s that still gives a point."] = "Criaturas de nível %d - %d. %s cada" ..
        " %s que ainda dá um ponto.",
    ["%s places come from GatherMate2's Forever data; what one gives and how often a rarer kind takes a place," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what one" ..
        " needs): Forever may differ."] = "Os lugares (%s) vêm dos dados do Forever do GatherMate2; o que um" ..
        " dá e com que frequência um tipo mais raro ocupa um lugar, do Classic. Os pontos de perícia seguem as" ..
        " cores do Classic (amarelo 25, verde 50, cinza 100 acima do necessário): no Forever pode ser" ..
        " diferente.",
    ["Gold an hour assumes 15 s a %s, a third of the zone's places with one up and a 60%% mount: about %d an" ..
        " hour here."] = "O ouro por hora conta 15 s por %s, um terço dos lugares da zona ocupados e uma" ..
        " montaria de 60%%: cerca de %d por hora aqui.",
    ["%s: about %d bars%s"] = "%s: cerca de %d barras%s",
    [", learn it from a Mining trainer for %s"] = ", aprenda com um mestre de Mineração por %s",
    ["Nothing you mine here still gives points when smelted."] = "Nada do que você minera aqui ainda dá pontos" ..
        " quando fundido.",
    ["Sell ore or bars"] = "Vender minério ou barras",
    ["%s: %s each. Smelting it needs more skill."] = "%s: %s cada. Fundir pede mais perícia.",
    ["sell the ore, smelt it only for the skill-ups"] = "venda o minério, funda só pelos pontos de perícia",
    ["smelt it and sell the bars"] = "funda e venda as barras",
    [", %s as %s"] = ", %s como %s",
    ["make %s and sell it"] = "faça %s e venda",
    ["%s: %s as ore, %s as %s%s - %s."] = "%s: %s como minério, %s como %s%s - %s.",
    ["%s: %s make %d %s, so per ore it's worth one of them; it takes both ores, as much as the scarcer one" ..
        " allows."] = "%s: %s fazem %d %s, então por minério vale como um deles; precisa dos dois minérios, o" ..
        " quanto o mais escasso permitir.",
    ["Nothing mined here can be smelted."] = "Nada do que é minerado aqui pode ser fundido.",
    ["Per ore, after the auction house's cut (only what's listed at least 5 times), or what a vendor pays."] =
        "Por minério, após a taxa da casa de leilões (só o que está à venda ao menos 5 vezes), ou o que um" ..
        " vendedor paga.",
    ["Smelting gives skill-ups too: Craft Ladder counts the ore you mine as smelted, so you mine fewer nodes."] =
        "Fundir também dá pontos de perícia: o Craft Ladder conta o minério que você minera como fundido," ..
        " então você minera menos veios.",
    ["Node places come from GatherMate2's Forever data; how often rare veins appear and the ore a node gives," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what a node" ..
        " needs): Forever may differ."] = "Os lugares dos veios vêm dos dados do Forever do GatherMate2; com" ..
        " que frequência veios raros aparecem e quanto minério um veio dá, do Classic. Os pontos de perícia" ..
        " seguem as cores do Classic (amarelo 25, verde 50, cinza 100 acima do que um veio pede): no Forever" ..
        " pode ser diferente.",
    ["Gold an hour assumes 15 s a node, a third of the zone's node places with a node up and a 60%% mount:" ..
        " about %d nodes an hour here."] = "O ouro por hora conta 15 s por veio, um terço dos lugares da zona" ..
        " ocupados e uma montaria de 60%%: cerca de %d veios por hora aqui.",
    ["Other zones, or smelting, from %d"] = "Outras zonas, ou fundição, a partir de %d",

    -- Lockpicking
    ["%d a run, needs %d"] = "%d por rodada, precisa de %d",
    ["about %d in the zone, needs %d"] = "cerca de %d na zona, precisa de %d",
    ["Humanoids drop it; the auction house sells it."] = "Cai de humanoides; a casa de leilões vende.",
    ["Fished up from pools."] = "Pescada em cardumes.",
    ["Engineers make it."] = "Os engenheiros fazem.",
    ["Pick Pocket humanoids of level %d - %d."] = "Bata a carteira de humanoides de nível %d - %d.",
    ["Pick Pocket humanoids."] = "Bata a carteira de humanoides.",
    ["Pick locks in %s"] = "Arrombar fechaduras em %s",
    ["Skill %d - %d, about %d locks"] = "Perícia %d - %d, cerca de %d fechaduras",
    ["Creatures level %d - %d. Pick every lock that still gives a point: a chest gives one chance, and one" ..
        " more once it's back."] = "Criaturas de nível %d - %d. Arrombe cada fechadura que ainda dá um ponto:" ..
        " um baú dá uma chance, e mais uma quando voltar.",
    ["The door round"] = "A rodada das portas",
    ["1. Go into Blackrock Depths (Blackrock Mountain, between Searing Gorge and Burning Steppes)."] =
        "1. Entre nas Profundezas Rocha Negra (Pico Rocha Negra, entre a Ravina Rasgafogo e os Ermos de" ..
        " Queimara).",
    ["2. Pick the locked doors on the way: the first on the left, through it the next on the right, then the" ..
        " first on the left again; the Shadowforge Lock under the big gear too, if nothing would pull."] =
        "2. Arrombe as portas trancadas no caminho: a primeira à esquerda, atrás dela a seguinte à direita," ..
        " depois de novo a primeira à esquerda; e também a Fechadura de Forja das Sombras sob a engrenagem" ..
        " grande, se nada vier junto.",
    ["3. Leave, right-click your portrait, Reset all instances and go in again: the game lets you in 5 times" ..
        " an hour."] = "3. Saia, clique direito no seu retrato, Redefinir todas as instâncias e entre de novo:" ..
        " o jogo deixa você entrar 5 vezes por hora.",
    ["The round is zockify's Forever guide's: about 4 doors a run."] = "A rodada é a do guia do Forever do" ..
        " zockify: cerca de 4 portas por rodada.",
    ["Where"] = "Onde",
    ["Most %ss are around here"] = "A maioria (%s) está por aqui",
    ["Chest places: GatherMate2's and QuestieDB's Forever data. Which lock a chest needs, and the colours" ..
        " (yellow 25, green 50, grey 100 above it), are Classic's: Forever may differ."] =
        "Lugares dos baús: dados do Forever do GatherMate2 e do QuestieDB. Que fechadura um baú pede, e as" ..
        " cores (amarelo 25, verde 50, cinza 100 acima), são do Classic: no Forever pode ser diferente.",
    ["Other zones, or boxes, from %d"] = "Outras zonas, ou caixas, a partir de %d",
    ["Pick %s"] = "Arrombar %s",
    ["Skill %d - %d, about %d boxes, %s"] = "Perícia %d - %d, cerca de %d caixas, %s",
    ["Pick the ones in your bags: you have %d."] = "Arrombe as das suas bolsas: você tem %d.",
    ["Boxes to buy: %s"] = "Caixas para comprar: %s",
    ["A box gives one chance at a point, and what's inside is yours."] = "Uma caixa dá uma chance de ponto, e" ..
        " o que está dentro é seu.",
    ["Or pick locks in a zone, from %d"] = "Ou arrombar fechaduras numa zona, a partir de %d",
    ["Every lock a rogue picks, by the skill it needs; its colour at your %d."] = "Cada fechadura que um" ..
        " ladino arromba, pela perícia que pede; a cor dela com seus %d.",
    ["Orange always gives a point, yellow mostly, green sometimes, grey never."] = "Laranja sempre dá um" ..
        " ponto, amarelo quase sempre, verde às vezes, cinza nunca.",
    ["Chests in the world"] = "Baús no mundo",
    ["Boxes from your bags"] = "Caixas das suas bolsas",
    ["You have %d."] = "Você tem %d.",
    [" %s at the auction house."] = " %s na casa de leilões.",
    ["Dungeon doors"] = "Portas de masmorra",
    ["%s: %d locked doors, from %d (%s)."] = "%s: %d portas trancadas, a partir de %d (%s).",
    ["Getting started"] = "Para começar",
    ["Pick Lock: any rogue trainer, from level 16, for %s. It needs Thieves' Tools in your bags (rogue" ..
        " supplies vendors, 15s). Your cap is your level x 5."] = "Arrombamento: qualquer mestre ladino, a" ..
        " partir do nível 16, por %s. Precisa de Ferramentas de Ladrão nas bolsas (vendedores de suprimentos" ..
        " de ladino, 15p). Seu limite é seu nível x 5.",

    -- the cards with nothing to show, and the rest
    ["Nothing earns now"] = "Agora nada rende",
    ["Nothing you can make sells for more than it costs at today's prices."] = "Nada do que você pode fazer" ..
        " vende por mais do que custa pelos preços de hoje.",
    ["Nothing you can get here has a price yet: Craft Ladder needs auction house prices."] =
        "Nada do que você consegue aqui tem preço ainda: o Craft Ladder precisa de preços da casa de leilões.",
    ["Nothing to do here"] = "Nada para fazer aqui",
    ["You've reached %d %s."] = "Você chegou a %d em %s.",
    ["No recipe found for your skill."] = "Nenhuma receita encontrada para sua perícia.",
    [", Working Overtime %d/5: +%d%%"] = ", Hora Extra %d/5: +%d%%",

    -- what the data itself says on a rank card (Professions.lua, Data/*.lua)
    ["Your class quests at 16"] = "Suas missões de classe no 16",
    ["They lead to the first practice chests and give you Thieves' Tools. Pick Lock itself is learned from any" ..
        " rogue trainer, quest or not."] = "Elas levam aos primeiros baús de treino e dão Ferramentas de" ..
        " Ladrão. Arrombamento em si se aprende com qualquer mestre ladino, com missão ou sem.",
    ["Your class quests at 20"] = "Suas missões de classe no 20",
    ["The last one teaches Poisons (and Recipe: Thistle Tea). On the way you pick a lock: Lockpicking 70 for" ..
        " the Alliance's Duskwood Chest, 80 for the Horde's Gallywix's Lockbox (Classic's numbers, not" ..
        " confirmed in Forever)."] = "A última ensina Venenos (e a Receita: chá de cardo). No caminho você" ..
        " arromba uma fechadura: Arrombamento 70 para o Baú de Bosque da Penumbra da Aliança, 80 para o Cofre" ..
        " do Gallywix da Horda (números do Classic, não confirmados no Forever).",
    ["Bring 12 Giant Egg, 10 Zesty Clam Meat and 20 Alterac Swiss to Dirge Quikcleave in Gadgetzan."] =
        "Leve 12 Ovo Gigante, 10 Carne de Marisco Picante e 20 Queijo Suíço de Alterac para Dirge Cortaligeiro" ..
        " em Gadgetzan.",
    ["Catch the four fish below and bring them to Nat Pagle; he then teaches Artisan Fishing for 1g."] =
        "Pesque os quatro peixes abaixo e leve-os a Nat Pagle; ele então ensina Pesca (artesão) por 1o.",
    ["Hank the Hammer's (Alliance) or Aturk the Anvil's (Horde) quests lead to Galvan the Ancient and Trenton" ..
        " Lighthammer, whose quests teach the Ornate Mithril recipes the last quest asks for. Buy those 7" ..
        " items at the auction house and you can skip them."] = "As missões de Hank o Martelo (Aliança) ou" ..
        " Aturk a Bigorna (Horda) levam a Galvan o Antigo e Trenton Martelo Leve, cujas missões ensinam as" ..
        " receitas de mitril ornado que a última missão pede. Compre esses 7 itens na casa de leilões e você" ..
        " pode pulá-las.",
    ["It gives you a letter to hand in."] = "Ela dá uma carta para entregar.",
    ["Right-click the pledge it gives you: that completes it."] = "Clique direito no juramento que ela dá:" ..
        " isso a conclui.",
    ["Save 15 wounded soldiers with the Triage Bandages the doctor gives you, before 6 of them die."] =
        "Salve 15 soldados feridos com as Bandagens de Primeiros Socorros que o médico dá, antes que 6 deles" ..
        " morram.",
    ["Then learn the mastery from the trainer who gave you the quest."] = "Depois aprenda a maestria com o" ..
        " mestre que deu a missão.",
}
