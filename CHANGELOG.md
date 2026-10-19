# Changelog

What's new in Craft Ladder, newest first. The format follows [Keep a Changelog](https://keepachangelog.com), the
version numbers [Semantic Versioning](https://semver.org).

## Unreleased

### Fixed

- A step that smelts its bars from ore (Bronze Bars from Copper and Tin) asked for far too little ore: its card, the
  auction house tab and Auctionator's shopping list counted only the ore for the step's first few skill points.
- A step that makes some of an ingredient and buys the rest (Light Leather, bars, bolts of cloth: whichever is cheaper
  as prices climb) said it makes them all, and its shopping list left out the ones to buy. Its card now says both
  ("Make 30 yourself from 90 Ruined Leather Scraps, buy the other 91"), and the auction house tab lists both.
- The auction house tab showed a recipe twice in a row where the ladder learns a rank in the middle of it (Big Bear
  Steak 120-125, Expert Cooking, Big Bear Steak 125-135). It's one row now, 120-135, with what all of it buys.

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
