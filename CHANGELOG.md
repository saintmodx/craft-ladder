# Changelog

What's new in Craft Ladder, newest first. The format follows [Keep a Changelog](https://keepachangelog.com), the
version numbers [Semantic Versioning](https://semver.org).

## 1.12.0 - 2026-11-25

### Added

- The list of steps can be made wider: drag the line between it and the step's details to the right and the list
  takes the room, to the left and it gives it back. Long names and the two bars over the list get the space they
  need. The details never give up more than the window added, so nothing in them is ever cut short - make the
  window bigger (drag its corner) and that is the room the list can take. The width is the account's and holds
  through a /reload.

- **Buy or craft**: a bar over the list, next to the Merchant's Favor one, shows every recipe of the profession with
  what one craft's ingredients cost at today's prices against what buying the same thing costs, and says which is
  cheaper and by how much. Meant for the materials you keep remaking: leather, bars, cloth, bolts, oils. The recipes
  you know come first, the rest under them, each group folds, and both are by the skill they're learned at. The
  boxes over the list leave only the skills you want, and the search box leaves the recipes whose item matches what
  you type. A row's card compares both sides and lists what one craft takes. What's in your
  bags doesn't make a craft free here: both sides are prices, so the answer doesn't change every time you buy
  something. The bar works like the modes over the list: it stays lit while the view is open, and Skill, Profit or
  another mode brings the ladder back.

- Profit has the same search box over its list: type part of a name and only the recipes that make something of
  that name stay.

- Settings has a "Bars over the list" section: untick Buy or craft or Favor to hide that bar, and the view it opens
  goes with it. Both are shown until you say otherwise, and the setting is the account's.

### Changed

- The Merchant's Favor bar is called just "Favor (81)" while the Buy or craft bar shares the line with it; on its
  own it keeps its full name.

## 1.11.6 - 2026-11-23

### Fixed

- The Disenchant view no longer stops the game for a moment every time your bags change. It used to work out the
  whole account again on every loot, sale or bag move, and with it the price of every item in the game that can be
  disenchanted. The "Buy and disenchant" group now keeps what it found until the prices change, so looting a
  dungeon with the view open costs nothing.
- Craft Ladder's saved data no longer grows without end. It records every node you gather and every item you
  disenchant, which is how the addon's own numbers get better; it now keeps the newest 10,000 of each and drops
  what is older when you log in, so the file stays small and logging in stays quick.

## 1.11.5 - 2026-11-21

### Changed

- The data is read from Forever's client build 1.60.1.71037. Only one recipe changes with it: Orcish War Leggings
  is learned at Blacksmithing 205, not 210, and its plans are bought at the auction house - the build added the
  plans as an item of its own, and nothing says who sells or drops them, so the plan no longer sends you to the
  quest Classic rewarded them with.

## 1.11.4 - 2026-11-21

### Fixed

- Disenchanting no longer asks for a higher Enchanting. In Forever any enchanter disenchants anything, from
  Enchanting 1, but the Disenchant view still held back the items Classic wanted more for: they were greyed out,
  pushed to the end of their group, labelled with the skill they supposedly needed and with the character to mail
  them to, and left out of what the groups and the footer say you can gain. Every row now counts and is sorted by
  what it brings, so the blues and the higher-level greens sit in the plan where they belong, whatever your
  Enchanting.
- Disenchants are recorded again when the cast is instant (the Disenchanter perk) or when auto-loot takes the
  materials without opening a window. They were missed before, so the odds on a card never became your own.
- Shields and off-hand items now disenchant as the armor they are: mostly dust, not mostly essence. Classic put
  them with the weapons and Craft Ladder followed, which made a green off-hand item of level 56-60 look worth
  about 3g27s disenchanted when it brings about 1g21s - enough to send you buying at the auction house at a loss.
  453 items moved, and 72 more can be disenchanted that the plan used to leave out.
- The disenchanting data is Forever's client build 1.60.1.71037.

## 1.11.3 - 2026-11-18

### Fixed

- The step you're crafting stays until you've crafted it through. It used to be dropped a point or two before its
  end: the reagents in your bags go into that very step, which makes every other recipe look better by comparison,
  and the plan swapped to one of them - after you had already bought what the step asked for. Now the plan only
  drops it if that recipe itself has got dearer a point, and it keeps the end it showed you, so the row that comes
  after it stays in place too (it used to vanish when the held step ran over it). The step you're on is kept
  with the character now, so a /reload or coming back tomorrow doesn't change what you are in the middle of
  crafting.
- The plan no longer sends you off to make reagents and then drops the recipe they were for. Making what a step
  needs earns skill of its own - the 156 Bolts of Linen Cloth a run of Linen Bags asks for take Tailoring from 1 to
  50 by themselves - and none of it was counted, so you came back with the reagents already past the step, the plan
  moved on and the rest of the materials you had bought sat unused. Reagents that still earn skill are now a step of
  their own, with the points they earn counted, and the recipe comes after, from the skill you really have by then.

## 1.11.2 - 2026-11-18

### Fixed

- A full scan with Auctionator reaches the ladder the moment it ends. Auctionator marks the scan's time when it
  starts, so the window used to go on showing the prices it had until the next /reload; now its own "scan finished"
  redraws the ladder and the cards.
- Auctionator's old prices no longer pass for today's. Auctionator keeps the price it last saw of an item for ever,
  so an item that wasn't in the last scan kept a price and a "120 listed" from days ago - and a dead high price
  could send the plan after a recipe nobody is buying. Such a price is now shown with the day it was last seen
  ("last seen 2 days ago") and counts only for what things cost to buy, not for what a step earns at the auction
  house.
- The header no longer promises a scan that brought nothing. Auctionator notes the moment a scan starts and keeps
  it even when the scan dies halfway, so "scanned 10:51 (22m ago)" could sit over prices days old. When its newest
  prices are older than that, the header says the day they are from, in yellow - and a client left open past
  midnight, which makes Auctionator date its own fresh prices a day back, no longer counts as old.

## 1.11.1 - 2026-11-17

### Fixed

- The plan stops changing its mind under you. The recipe of the step you're on is kept while it's still of the
  same colour and nearly as cheap a skill point, so one craft, a new auction house scan or a trip to a vendor no
  longer swaps it for a recipe that costs the same, after you've already bought the reagents for the one it showed.
  It still switches the moment another recipe is really cheaper a point (your reagents ran out, a price moved for
  real) — and your own pick on a card always wins.

## 1.11.0 - 2026-11-17

### Added

- Craft Ladder speaks nine languages besides English: Deutsch, Español, Français, Italiano, Português,
  Русский, Українська, 한국어 and 简体中文. Settings has a Language setting at the bottom, each language written in its own
  language; a new install follows your game client (a Latin American Spanish client reads the Spanish file,
  a Traditional Chinese one the Simplified file). The whole window is translated, from the menu and the
  modes down to the long notes on a card about where the numbers come from. The names of items, recipes and
  zones come from the client itself, so they are in its language; with Russian picked on an English client,
  Craft Ladder knows the Russian names of 6512 items and 2550 recipes of its own. NPC and quest names stay
  English: nothing translates them.

  The translations are Craft Ladder's own work, not a native speaker's: if a line reads wrong in your
  language, say so and it will be fixed.

  The window makes room for them: the buttons over the list (Vendor sales, AH sales, Profit, Food,
  Specialization) share the width of the list, growing tighter and, if they must, smaller, so the last of
  them never runs over the step's card; and in Settings every tick sits under the help line above it,
  however many lines that takes.

### Removed

- `/craft chat` and `/craft chat disenchant` are gone, and a right-click on the minimap button no longer
  prints the ladder in chat. The window says all of it, and more, and the chat version was the one
  corner of Craft Ladder nobody could read in Russian.

## 1.10.1 - 2026-11-16

### Changed

- The data is rebuilt from today's AllTheThings and QuestieDB: 366 recipes now say where their plan comes from - a
  vendor, a quest or a drop - instead of only "buy it at the auction house", and four recipes were added (Draught of
  Tongues, Revealing Draught, Gurubashi Mojo Madness, Goblin Mortar). The Steam Tonk Controller's schematic is sold
  at the Darkmoon Faire, not from a quest.

### Fixed

- Skinning no longer sends you after a creature far above your skill because its level was read wrong (Echeyakee, a
  level 16 rare, counted as needing skill 190).

## 1.10.0 - 2026-11-15

### Added

- The Craft Ladder tab at the auction house has a Full Rescan button: it searches the auction house itself for
  everything the list buys and sells, then puts those prices in the list and in the ladder. Until now the prices
  were whatever your last AuctionDB or Auctionator scan saw, and only what you searched by hand was fresh. The line
  under the list counts how far it has got ("Scanning the auction house: 12 of 57 items"), the button turns into
  Stop while it runs, and an item searched in the last two minutes is left alone. It goes one item at a time, as
  the server allows, so a long list takes a while.

- A Scan button of its own on every row: on a step it asks about what the step makes and everything it takes, on an
  ingredient about that one item. These ask whatever the price's age - you clicked for them.

### Changed

- In Profit and in Favor, the auction house tab now lists every ingredient a craft takes, not only the ones you
  still have to buy: an ingredient already in your bags or bank is there, saying how many you need and how many you
  have. Its box and Buy are there too, so you can buy more of something you already have. The other modes stay a plain
  shopping list. Ingredients a vendor sells (thread, dye) are still left out everywhere: the tab is for the
  auction house.

- The auction house tab has no line over the list saying what it shows: the profession and the mode above it say
  that already. An empty list still says why.

### Fixed

- Hovering a step on the auction house tab now shows what it makes, the game's own tooltip, as hovering an
  ingredient shows the ingredient.

- Searching the auction house for something your ladder makes now changes what the step says it sells for, as a
  searched reagent already changed what it costs. Until now a search of the finished item was thrown away unless at
  least 5 of them were listed, so the price you had just seen with your own eyes was ignored and the step still
  counted on a vendor. A thin market still sells one at the auction house and the rest to a vendor.

## 1.9.3 - 2026-11-13

### Fixed

- All the data is rebuilt from the live Forever client (build 1.60.1.70938): the recipes, their ingredients, the
  trainers, the vendors and the prices are the ones the game shows now. Up to now they came from the last beta
  build, so a few recipes asked for the wrong amount - the Green and the Red Woolen Bag take 5 Bolts of Woolen
  Cloth, not 4.

## 1.9.2 - 2026-11-12

### Fixed

- A card's "One craft" now always says what the craft costs at today's prices: every ingredient at its price, or at
  what making it yourself costs when that's cheaper. It used to show what the step happens to pay, so an ingredient
  already in your bags cost "0" and the same recipe could be dearer in Vendor sales or AH sales than in Gold. What
  you have is now a line of its own under the ingredients - the step still spends nothing on it.

## 1.9.1 - 2026-11-11

### Added

- A recipe or a profession book a vendor sells now also says what the auction house asks for it - "Or buy it at the
  auction house: 1g 20s" - so you can skip the flight when someone listed one. The ladder still counts the cheaper
  of the two, and a book nobody of your side sells is now priced from the auction house instead of counting as
  free.

## 1.9.0 - 2026-11-11

### Added

- Searching an item at the auction house now prices it in the ladder: its own search sees every auction of that
  item, so the ladder and the cards use what you just saw instead of the last scan's price, until a scan passes it.
  It counts whoever did the search - the game's Buy tab, Auctionator's Shopping tab or a shift-click from a card -
  and the card says "you searched it 4m ago". Only a search of one item counts, not the list of names a search by
  text brings.

## 1.8.1 - 2026-11-11

### Fixed

- With Auctionator picked, the header no longer shows AuctionDB's "Next AuctionDB scan in M:SS": that countdown
  belongs to prices you aren't reading.
- The header now dates Auctionator's prices even when Auctionator never scanned by itself - "Prices: Auctionator,
  newest prices from today", or "from 3 days ago" in orange. It keeps no time of day, only the day it last saw a
  price, so the line says the day; it said just "Prices: Auctionator" before.

## 1.8.0 - 2026-11-11

### Added

- A Settings button in the header: its menu takes the card's place and holds how prices are read. Pick the auction
  house addon the prices come from - AuctionDB or Auctionator - and what an ingredient costs: the median listed
  price or the cheapest listing. The settings are the account's: every character and profession plans the same way.
  Picking a step in the ladder closes the menu and brings that step's card back.

### Changed

- Ingredients are priced at what half of what's listed costs, not at the single cheapest auction. That one lot is
  usually bought within minutes of the scan, so the ladder was planning on a price no one could still get - an
  ingredient could show up four times cheaper than the auction house really asked. Hovering a price still names the
  cheapest listing, so you can see when it's worth the gamble, and Settings has the old way back. What you sell is
  still priced at the cheapest listing, the one you undercut.
- Prices now come from one auction house addon, the one Settings picked, instead of AuctionDB with Auctionator
  filling its gaps: two addons' prices are two scan times, and the older one made costs look wrong.

### Fixed

- The header says when AuctionDB last scanned again - "Prices: AuctionDB, scanned 13:42 (30m ago)" - and warns when
  that scan is hours old. Craft Ladder was looking for AuctionDB's data under the wrong name and never found the
  time.
- A fresh AuctionDB scan reaches the ladder without a /reload: the prices it had read were kept for the whole
  session, because they were only ever dropped when the scan time changed, and that time was the one it could not
  find.
- Buying more of an ingredient than the auction house has listed no longer makes it cost several times the price:
  the ladder prices it the same and says the house is short.

## 1.7.2 - 2026-11-11

### Fixed

- Without AuctionDB, ingredients are no longer priced too low: what Auctionator gives is now the price of its last
  scan, not the cheapest price seen at any time that day. A ladder could plan on a price that was hours gone.
- The header now says when Auctionator last scanned and warns when that was long ago, as it already did for
  AuctionDB.
- Barbaric Bracers no longer sends you to a vendor for its pattern: in Forever it is a world drop, so the ladder
  prices it at the auction house, and leaves the recipe out when nobody lists one.
- Shift-clicking an item in a card now fills Auctionator's Shopping tab too: its search box gets the name and the
  search runs. Only Blizzard's own auction house box was filled before, because Craft Ladder handed the link to the
  older of the game's two names for it, the one add-ons don't listen on.

## 1.7.1 - 2026-11-10

### Added

- Profit's rows say where the craft turns its next colour - "yellow 90" - and its card lists them all: orange from 1,
  yellow 90, green 110, grey 130. Earning and levelling at once: now you can see how long a craft keeps giving points.

## 1.7.0 - 2026-11-07

### Changed

- Profit's "Sell to a vendor" group now also holds what you can't make yet, after everything you can: in red, with
  the skill it asks and the character level of the rank that would lift your cap to it. A vendor buys any number, so
  those are what the profession is worth levelling towards, and at low skill the group was usually empty. The
  auction house group is unchanged, only what you can make now, and the auction house tab's shopping list skips the
  rows you can't craft.
- Disenchant is in the menu even when no character of yours has Enchanting yet: every row then says what
  Enchanting it needs and its card opens as usual, so you can see what learning it would be worth before you
  learn it.
- At 300 in a profession the Vendor sales and AH sales buttons are gone: there is nothing left to level with them,
  so Profit and Specialization take their place. A mode picked before 300 isn't kept either.

### Fixed

- Lockpicking and Poisons now show the skill the game shows. The window read the skill list through an API
  this client doesn't have, so a rogue's Lockpicking sat at 0 however much it was levelled, and its ladder
  with it; Poisons the same.
- A reagent in your bags is free for one craft, not for the whole ladder: one your professions can make again
  (Light Leather, bars, bolts of cloth) now counts at what having it again will cost when recipes are compared.
  With 48 Light Leather, Leatherworking planned Handstitched Leather Vests, 3 leather a point, because the leather
  looked free; it plans Light Armor Kits now, 1 a point, three times the skill out of the same bags. A reagent
  nothing you have makes - meat, fish, hides - is still free, and what you have is still crafted first.
- The buttons left of the window and the Disenchant view now hold every character of your account on your side,
  whatever realm name it carries. Forever is one world: characters of its realms play, trade and use the same
  auction house, so splitting them by realm name only hid your own alts.

## 1.6.0 - 2026-11-05

### Added

- Disenchant is a view of its own now, after the professions in the menu, and it covers your whole account. Three
  groups, each folding, the biggest gain on top of each: what every character of yours holds that can be disenchanted
  (its bags and its bank, every row saying whose it is and where), what the auction house sells for less than
  disenchanting it brings, and what any character's crafting professions make that's worth more disenchanted than
  sold. Each heading says what its group brings in all, and the footer what all three do. Disenchanting is luck, so a
  row says what one brings on average and its card what a batch brings at least 9 times out of 10, what it breaks
  into, and how often buying one pays for itself; with Auctionator, a button that searches it. The Enchanting that
  counts is the best of your characters, since an item can be mailed, and the card says where to send it.
  `/craft disenchant` opens the view, `/craft chat disenchant` prints it.
- Gear bound when picked up counts there too, so another character's dungeon and quest greens and blues show up
  without the game having to load them first, each with what a vendor pays for it. A bank keeps its gear as well,
  from when you last closed it, so it counts without Bagnon too.

### Changed

- A recipe sold by many vendors no longer ends in "and 16 more vendors" you can't see: the card lists four and the
  line under them unfolds the rest, and folds them away again. The same for a recipe only certain trainers teach.
- AH sales rows say how many of what you make the auction house has listed, the way Profit's rows do, so you can see
  at a glance whether your crafts will sell. It shows on the ladder and in the auction house tab.
- Enchanting has no Disenchant mode of its own any more, in the window or in the auction house tab: the menu's
  Disenchant view does everything it did, for every character instead of one.
- Your own disenchants of one item replace the usual table for it after 3, when they never gave its most likely
  material: Forever breaks some items differently.

## 1.5.1 - 2026-10-31

### Fixed

- With Auctionator and no AuctionDB, AH sales and Profit's auction house rows were empty: Craft Ladder now reads how
  many are listed from Auctionator's own database, which its API doesn't give. With AuctionDB installed nothing
  changes.

## 1.5.0 - 2026-10-21

### Added

- Your other characters on this realm and side, a button each left of the window (once two have logged in with
  Craft Ladder): a click shows that character's professions and ladders as its last session left them, with its
  skills, recipes, bags, bank and level, and says how old that is. To read, not to craft from: no Craft bar, Camp or
  Disenchant for them. Click yourself to come back.
- The bank counts in the ladder before you open it in a session without Bagnon too: Craft Ladder remembers what was
  in it when it last closed (with Bagnon, its copy comes first).

### Changed

- A step's other recipes read like the ladder's rows: "+" in green when a point earns, "-" in red when it costs, and
  "you know it" in green instead of "learn: you know it".

### Fixed

- Craft with the profession window closed: one click is enough, it crafts once the window has opened.

## 1.4.0 - 2026-10-21

### Added

- **Range to level**: pick From and To over the ladder, or click a rank's name under the skill bar; Reset brings
  back your skill to 300.
- **Working Overtime**: the Legacy perk's skill-up bonus is counted, so ladders need fewer crafts.
- **Craft in Profit**: the Craft bar on Profit's cards, set to as many as your bags allow.

### Changed

- Modes renamed: **Vendor sales** (was Sure cost), **AH sales** (gathering: was Skill + Gold), **Profit** (was Gold).
- The last auction house scan shows at the top: yellow after 3 hours, red after 12.
- Your skill on the bar is a gold "Skill 142" badge.
- Easier to read: lighter grey notes, bigger text in a step's details, coin icons for money, items in their
  quality's colour.
- Profit: no "Sell at the auction house" heading when nothing sells to a vendor.
- A neutral line under the window's title instead of the faction's colour.

## 1.3.0 - 2026-10-20

### Added

- **Specialization** (Blacksmithing, Engineering, Leatherworking): a button beside the ladder's modes shows the steps
  to each specialization of the profession, the one you pick remembered: Weaponsmith (and a weapon mastery after it)
  or Armorsmith, Gnomish or Goblin Engineer, Dragonscale, Elemental or Tribal Leatherworking. Each step has its quest
  givers on the map, says when a quest is in your log or done, and counts what it asks for against your bags and bank
  ("2 / 4 Moonsteel Broadsword"). The recipes it takes say whether you know them and where to learn the rest; what's
  still missing is made or bought, whichever costs less, with its ingredients and the total still to spend.
- **Disenchant (beta)** (Enchanting): a mode for what's worth disenchanting. First what's in your bags that can be
  disenchanted, whatever made it, each with what brings more: disenchant it, sell it at the auction house (not when
  it's soulbound) or to a vendor. Then what your crafting professions make with the recipes you know that's worth
  more disenchanted than sold, the best first, in red when making it costs more than disenchanting brings; grey when
  your Enchanting can't disenchant it yet. A card shows what one disenchant gives (chance, count and price of each
  material), what 10 (or yours) bring on average and at least 9 times out of 10, and the Craft bar to make it. What a
  disenchant gives is Classic's table, except WoW Forever's low-level blue items, which give dust and essences like a
  green of their level, one more of each. Craft Ladder records your disenchants: from 5 of one kind of item, what you
  got replaces the table.

## 1.2.0 - 2026-10-20

### Added

- Each step in the ladder says how many of its crafts what you already have covers, under its cost: "12 ready" or
  "all ready". Bags and bank count, bars you'd smelt from your own ore too, and as the plan uses them (what an earlier
  step takes is gone); reagents vendors sell count as had. It replaces the first step's "N now".

### Changed

- The ladder's list is 30 px wider, and the window's smallest size with it, so long recipe names fit.
- The crafting modes are called **Sure cost** and **AH sales** (they were Skill and Skill + Gold), and their tooltips
  say what each counts: Sure cost is what you're sure to spend, what you make going to vendors; AH sales is cheaper only
  if what you make sells at the auction house. Gathering keeps Skill and Skill + Gold.
- The ladder's amounts: what a step costs is red with a minus, what it earns green with a plus (costs were white, with
  no sign).

### Fixed

- A step that smelts its bars from ore (Bronze Bars from Copper and Tin) asked for far too little ore: its card, the
  auction house tab and Auctionator's shopping list counted only the ore for the step's first few skill points.
- A step that makes some of an ingredient and buys the rest (Light Leather, bars, bolts of cloth: whichever is cheaper
  as prices climb) said it makes them all, and its shopping list left out the ones to buy. Its card now says both
  ("Make 30 yourself from 90 Ruined Leather Scraps, buy the other 91"), and the auction house tab lists both.
- The auction house tab showed a recipe twice in a row where the ladder learns a rank in the middle of it (Big Bear
  Steak 120-125, Expert Cooking, Big Bear Steak 125-135). It's one row now, 120-135, with what all of it buys.
- After an AuctionDB scan the window and the auction house tab kept the old prices until the auction house was closed
  (or a /reload). They're calculated again with the new prices within a second of the scan.

## 1.1.0 - 2026-10-18

### Added

- Merchant's Favor recipes: a recipe's card plans its reagents the way the ladder does. What you have counts first,
  bars are smelted from your ore when that's cheaper, and the card says what's left to buy. A recipe you know has a
  Craft button.
- Auction house tab: a Favor mode next to Skill, Skill + Gold and Gold. A row per Merchant's Favor recipe with what
  one craft of it buys there, Buy and Auctionator's Search as in the other modes.
- Craft Ladder's own logo in the window's header, on the minimap button and in the addon list.
- Cooking's Food: each dish shows its skill-up colour at your skill (orange, yellow, green; white once it gives no
  more points, red while your skill can't learn it), and its card says where it turns yellow, green and grey.

### Fixed

- With Bagnon: an item taken out of the bank while it was open was counted twice, in the bags and still in the bank.

## 1.0.1 - 2026-10-17

### Fixed

- "Pays back after 1 craft", not "1 crafts".
- A recipe you haven't learned yet, with its reagents in your bags, says "You have the reagents for N", not "You can
  make N now".
- Camp: the price shows both lines (make, auction house); the text wraps to the window's width and the rows grow to
  fit it, also when the window is resized.

## 1.0.0 - 2026-10-17

First release.
