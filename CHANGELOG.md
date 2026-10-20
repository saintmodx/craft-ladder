# Changelog

What's new in Craft Ladder, newest first. The format follows [Keep a Changelog](https://keepachangelog.com), the
version numbers [Semantic Versioning](https://semver.org).

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
