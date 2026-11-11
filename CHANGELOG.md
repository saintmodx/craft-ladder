# Changelog

What's new in Craft Ladder, newest first. The format follows [Keep a Changelog](https://keepachangelog.com), the
version numbers [Semantic Versioning](https://semver.org).

## Unreleased

### Fixed

- Ingredients are priced at what half of what's listed costs, not at the single cheapest auction. That one lot is
  usually bought within minutes of the scan, so the ladder was planning on a price no one could still get - an
  ingredient could show up four times cheaper than the auction house really asked. Hovering a price still names the
  cheapest listing, so you can see when it's worth the gamble. What you sell is still priced at the cheapest
  listing, the one you undercut.
- Buying more of an ingredient than the auction house has listed no longer makes it cost several times the price:
  the ladder prices it the same and says the house is short.

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
