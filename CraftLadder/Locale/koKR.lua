-- Craft Ladder in Korean. The key is the English string as it stands in the code; what's missing here is shown in
-- English. Item, recipe and zone names come from the game itself, so they are not here.
-- The %s and %d of a line must stay in the same order as in the English one: the game fills them in that order.
local _, ns = ...

ns.Locales = ns.Locales or {}
ns.Locales.koKR = {
    -- the auction house tab
    ["The items' names are still loading: click again."] = "아이템 이름을 아직 불러오는 중입니다: 다시 클릭하세요.",
    ["Stop"] = "중지",
    ["Full Rescan"] = "전체 재검색",
    ["Scanning %s: %d of %d items."] = "%s 검색 중: %d / %d개 아이템.",
    ["the auction house"] = "경매장",
    ["Scan done: %d of %d items searched."] = "검색 완료: %d / %d개 아이템을 찾았습니다.",
    ["A scan is already running: stop it first."] = "이미 검색이 진행 중입니다: 먼저 중지하세요.",
    ["Nothing to scan here."] = "여기에는 검색할 것이 없습니다.",
    ["Scanning %s: 0 of %d items."] = "%s 검색 중: 0 / %d개 아이템.",
    ["this step"] = "이 단계",
    ["Confirm %s"] = "%s에 구매",
    ["Asking..."] = "문의 중...",
    ["Buying %d %s..."] = "%d개의 %s 구매 중...",
    ["The auction house is busy: try again in a moment."] = "경매장이 바쁩니다: 잠시 후 다시 시도하세요.",
    ["Asking the price of %d %s..."] = "%d개의 %s 가격을 묻는 중...",
    ["Scan"] = "검색",
    ["Asks the auction house what this one goes for now, and puts that price in the ladder. However fresh the" ..
        " price already is."] = "이 아이템의 현재 시세를 경매장에 물어 그 가격을 사다리에 넣습니다. 지금 가격이 아무리 최신이어도 다시 묻습니다.",
    ["Asks the auction house about what this step makes and everything it takes, then puts those prices in the" ..
        " ladder."] = "이 단계가 만드는 것과 필요한 모든 재료의 시세를 경매장에 물어 그 가격을 사다리에 넣습니다.",
    ["Search"] = "찾기",
    ["Auctionator's Shopping tab with what this step buys, and how many."] = "이 단계가 사는 것과 수량을 담은 Auctionator" ..
        " 구매 탭입니다.",
    ["Learn %s"] = "%s 배우기",
    ["at %d, raises your cap to %d"] = "%d에서 한계를 %d(으)로 올림",
    ["%s%s|r a craft, %s"] = "제작당 %s%s|r, %s",
    ["sold to a vendor"] = "상인에게 판매",
    ["%d listed"] = "%d개 등록됨",
    ["%d - %d, ~%d %s%s"] = "%d - %d, 약 %d %s%s",
    [", %d listed"] = ", %d개 등록됨",
    ["at %d, make one and keep it"] = "%d에서 하나 만들어 보관",
    ["nothing to buy"] = "살 것 없음",
    ["need %d, you have %d"] = "%d개 필요, %d개 보유",
    ["%s each"] = "개당 %s",
    ["not listed"] = "등록 없음",
    ["No crafting profession: nothing to buy for one."] = "제작 전문 기술 없음: 살 것이 없습니다.",
    ["%s: nothing to buy"] = "%s: 살 것 없음",
    ["Scan stopped: the prices it had got are in."] = "검색 중지: 가져온 가격은 반영되었습니다.",
    ["Nothing here to rescan."] = "여기에는 재검색할 것이 없습니다.",
    ["Every price here was searched in the last two minutes: nothing to ask again."] =
        "여기 모든 가격은 최근 2분 안에 조회했습니다: 다시 물을 것이 없습니다.",
    ["Scanning the auction house: 0 of %d items."] = "경매장 검색 중: 0 / %d개 아이템.",
    ["Searches the auction house for everything this list buys and sells, then puts the prices in the ladder." ..
        " It goes one item at a time, as the server allows: watch the line below. An item searched in the last" ..
        " two minutes is left alone."] = "이 목록이 사고파는 모든 것을 경매장에서 찾아 가격을 사다리에 넣습니다. 서버가 허용하는 대로 한 번에 하나씩 진행합니다:" ..
        " 아래 줄을 보세요. 최근 2분 안에 조회한 아이템은 건너뜁니다.",
    ["Crafts"] = "제작",
    ["A click on a step or a reagent searches it in Auctionator's Shopping tab."] = "단계나 재료를 클릭하면 Auctionator" ..
        " 구매 탭에서 찾습니다.",
    ["Craft Ladder"] = "Craft Ladder",
    ["%d %s for %s (%s each): click Confirm to buy."] = "%d개의 %s에 %s(개당 %s): 구매를 클릭하세요.",
    ["No price for %s: not enough listed, or not sold that way (try the Buy tab)."] =
        "%s의 가격 없음: 등록 수량이 부족하거나 그런 방식으로 팔지 않습니다(구매 탭을 보세요).",
    ["Bought %d %s."] = "%d개의 %s을(를) 구매했습니다.",
    ["The purchase failed (the price may have changed): ask again."] = "구매에 실패했습니다(가격이 바뀌었을 수 있습니다): 다시 시도하세요.",

    -- the camp view
    ["No profession"] = "전문 기술 없음",
    [" (skill %d)"] = " (숙련도 %d)",
    ["you know it"] = "이미 알고 있음",
    ["you can learn it"] = "지금 배울 수 있음",
    ["not your profession"] = "당신의 전문 기술이 아님",
    ["%d in your bags"] = "가방에 %d개",
    ["needs %s"] = "%s 필요",
    ["make %s"] = "%s 제작",
    ["no price"] = "가격 없음",
    ["AH %s"] = "경매 %s",
    ["  (not with %s)"] = "  (%s와(과) 함께는 불가)",
    ["Or, the same buff and more: %s"] = "또는 같은 효과에 그 이상: %s",
    ["Camp: the buffs a campfire gives, for a level %d %s"] = "야영지: 모닥불이 주는 효과, %d레벨 %s 기준",
    ["Holds %d camp features. %s; %s."] = "야영지 시설 %d개를 수용합니다. %s; %s.",
    ["A %s holds %d: the ones above. Then:"] = "%s은(는) %d개를 수용합니다: 위의 것들. 그다음:",
    ["Doesn't help a %s"] = "%s에게는 도움이 되지 않음",
    ["Camp features with no buff"] = "효과가 없는 야영지 시설",
    ["Build a campfire, place camp features around it and sit or craft nearby for a while: each feature gives" ..
        " everyone there its buff. A campfire holds only so many: here they are in the order your role wants" ..
        " them."] = "모닥불을 피우고 그 주위에 시설을 두고 근처에 잠시 앉거나 작업하세요: 각 시설이 그곳에 있는 모두에게 효과를 줍니다. 모닥불은 정해진 개수만 수용합니다:" ..
        " 당신의 역할이 원하는 순서대로 나열했습니다.",
    ["Campfire:"] = "모닥불:",

    -- the characters' buttons
    ["Level %d %s"] = "%d레벨 %s",
    ["Playing now"] = "지금 플레이 중",
    ["Last seen %s"] = "마지막 접속 %s",

    -- the menu
    ["Show the %s ladder."] = "%s 사다리 보기.",
    ["not learned"] = "배우지 않음",
    ["Disenchant"] = "마력 추출",
    ["Camp"] = "야영지",
    ["What's worth disenchanting on your whole account: what every character's bags and bank hold, what the" ..
        " auction house lists for less than disenchanting it brings, and what your crafting professions make" ..
        " that's worth more disenchanted than sold."] = "계정 전체에서 마력 추출할 가치가 있는 것: 각 캐릭터의 가방과 은행에 든 것, 경매장이 추출" ..
        " 가치보다 싸게 내놓은 것, 그리고 당신의 제작 전문 기술로 만들어 파는 것보다 추출하는 편이 나은 것.",
    ["What each camp feature gives around a campfire, in the order your role wants them, and how to get it."] =
        "모닥불 주위에서 각 야영지 시설이 주는 효과를 당신의 역할이 원하는 순서로, 그리고 얻는 방법까지.",

    -- the minimap button
    ["Earns most"] = "가장 많이 벌리는 곳",
    ["%s, %s an hour"] = "%s, 시간당 %s",
    ["Now"] = "지금",
    ["%s in %s to %d"] = "%s: %s에서 %d까지",
    ["fish"] = "낚시",
    ["mine"] = "채광",
    ["catches"] = "어획",
    ["nodes"] = "광맥",
    ["%s to %d"] = "%s: %d까지",
    ["~%d crafts, %s"] = "약 %d회 제작, %s",
    ["Eat"] = "먹기",
    ["%s, +%s a craft"] = "%s, 제작당 +%s",
    ["reach level %d"] = "%d레벨 도달",
    ["learn %s"] = "%s 배우기",
    ["Up to %d"] = "%d까지",
    ["Prices"] = "가격",
    ["Click: open or close the window"] = "클릭: 창 열기 또는 닫기",
    ["Drag: move the button"] = "드래그: 버튼 옮기기",
    ["minimap button hidden - /craft minimap shows it again."] = "미니맵 버튼을 숨겼습니다 - /craft minimap으로 다시 표시합니다.",
    ["minimap button shown."] = "미니맵 버튼을 표시했습니다.",

    -- the Settings menu
    ["Auction house prices from"] = "경매장 가격 출처",
    ["Its last full scan of your faction's auction house: the lowest price, the median and how many are" ..
        " listed."] = "해당 진영 경매장의 마지막 전체 검색: 최저가, 중앙값, 등록 수량.",
    ["Its last scan. It gives one price per item, so the median is that price."] = "마지막 검색. 아이템당 가격을 하나만 주므로" ..
        " 중앙값이 곧 그 가격입니다.",
    ["An ingredient costs"] = "재료 가격 기준",
    ["The median listed price"] = "등록가의 중앙값",
    ["Half of what's listed costs less. The cheapest listing is one auction, often gone minutes after the" ..
        " scan."] = "등록된 것의 절반은 이보다 쌉니다. 최저가는 경매 하나뿐이라 검색 후 몇 분이면 사라지는 일이 많습니다.",
    ["The cheapest listing"] = "최저 등록가",
    ["What the ladder cost before: the lowest price of the scan. Cheaper than what you will really pay, unless" ..
        " you are quick."] = "사다리가 예전에 쓰던 값: 검색에서 가장 낮은 가격. 빠르지 않다면 실제로 치를 값보다 쌉니다.",
    ["Language"] = "언어",
    ["Craft Ladder's own words. Item, recipe and zone names come from your game client, in its language. A few" ..
        " buttons take a /reload to change."] = "Craft Ladder 자체의 문구입니다. 아이템, 제조법, 지역 이름은 게임 클라이언트의 언어를 그대로" ..
        " 씁니다. 일부 버튼은 /reload가 필요합니다.",
    ["What you sell is always priced at the cheapest listing, the one you undercut."] =
        "당신이 파는 것은 항상 최저 등록가, 즉 당신이 깎아내릴 가격으로 계산합니다.",
    ["%s isn't installed: %s is read."] = "%s이(가) 설치되어 있지 않습니다: %s을(를) 읽습니다.",
    ["Neither addon is installed: no auction house prices."] = "두 애드온 모두 설치되어 있지 않습니다: 경매장 가격이 없습니다.",

    -- the Specialization view
    ["%s%d / %d|r  %s"] = "%s%d / %d|r  %s",
    ["level %d (you're %d)"] = "%d레벨 (당신은 %d)",
    ["%s %d (you have %d)"] = "%s %d (당신은 %d)",
    ["Needs %s."] = "%s 필요.",
    [" and "] = " 및",
    ["Or take it here instead:"] = "또는 여기서 대신 얻으세요:",
    ["Take the quest:"] = "퀘스트를 받으세요:",
    ["Take and hand in the quest:"] = "퀘스트를 받고 완료하세요:",
    ["Hand it in:"] = "완료하세요:",
    ["you have them all"] = "모두 가지고 있음",
    ["auction house %s"] = "경매장 %s",
    ["none at the auction house"] = "경매장에 없음",
    ["Make %d; some of its ingredients have no price; %s"] = "%d개 제작; 일부 재료에 가격이 없습니다; %s",
    ["Make %d for %s; %s"] = "%d개 제작, %s; %s",
    ["Buy %d: %s%s"] = "%d개 구매: %s%s",
    [", making them costs %s"] = ", 만들면 %s",
    ["Drops from %s"] = "%s에게서 드롭",
    ["Drops from %d kinds of creatures; "] = "%d종의 생물에게서 드롭;",
    ["none at the auction house now"] = "지금 경매장에 없음",
    [", learned at %d"] = ", %d에서 습득",
    ["its recipe drops from %d kinds of creatures, none at the auction house now"] = "제조법이 %d종의 생물에게서 드롭, 지금" ..
        " 경매장에 없음",
    ["no way to learn it for you now"] = "지금은 배울 방법이 없음",
    ["Buy the recipe:"] = "제조법을 구매하세요:",
    ["Learn it from the trainer:"] = "교관에게서 배우세요:",
    ["Bring to %s:"] = "%s에게 가져가세요:",
    ["the quest giver"] = "퀘스트 제공자",
    ["%s%d %s%s"] = "%s%d %s%s",
    ["smelt "] = "제련",
    [" (besides the %d you have)"] = " (가진 %d개 외에)",
    ["Make: %s"] = "제작: %s",
    ["Ingredients:"] = "재료:",
    ["buy %d: "] = "%d개 구매:",
    ["the smith"] = "대장장이",
    ["%d. Talk to %s"] = "%d. %s와(과) 대화",
    ["Talk to:"] = "대화 상대:",
    ["%d. Master a weapon: one of them"] = "%d. 무기 하나를 숙달: 그중 하나",
    ["%s: the quest %s"] = "%s: 퀘스트 %s",
    ["The recipes"] = "제조법",
    ["  %d to learn"] = "  %d개 배울 것",
    ["Click to fold or open."] = "클릭하면 접거나 펼칩니다.",
    ["Show the steps to %s."] = "%s까지의 단계 보기.",
    ["You have this specialization."] = "이 특화를 보유하고 있습니다.",
    ["Needs level %d and %s %d; you're level %d with %d."] = "%d레벨과 %s %d이(가) 필요합니다; 당신은 %d레벨에 %d입니다.",
    ["Unlocks %d recipes only this specialization can learn."] = "이 특화만 배울 수 있는 제조법 %d개를 엽니다.",
    ["You have %s: a character can have only one %s specialization."] = "%s을(를) 보유 중: 한 캐릭터는 %s 특화를 하나만 가질 수" ..
        " 있습니다.",
    ["Still to spend: %s, each item made or bought, whichever costs less%s."] = "아직 쓸 금액: %s, 각 아이템은 제작과 구매 중" ..
        " 싼 쪽으로%s.",
    ["; some have no price"] = "; 일부는 가격이 없음",
    ["You have %s"] = "%s 보유",
    ["To %s: about %s%s"] = "%s까지: 약 %s%s",
    [", some items unpriced"] = ", 일부 아이템은 가격 없음",

    -- the window: the list, its rows and their tooltips
    [" - %s%s %d|r"] = " - %s%s %d|r",
    ["%d days"] = "%d일",
    ["%d hours"] = "%d시간",
    ["~%d min"] = "약 %d분",
    ["All locks"] = "모든 자물쇠",
    ["Every lock a rogue picks, by the skill it needs, and its colour for you."] = "도적이 여는 모든 자물쇠를, 필요한 숙련도와" ..
        " 당신 기준 색으로 정리했습니다.",
    ["At %d your cap is the level x 5: %d at level %d."] = "%d에서 한계는 레벨 x 5입니다: %d레벨에 %d.",
    ["at %d, cap %d"] = "%d에서, 한계 %d",
    ["Skill"] = "숙련도",
    ["Smelt on the way"] = "가는 길에 제련",
    ["Trainer"] = "교관",
    ["Catches"] = "어획",
    ["Lure"] = "미끼",
    ["none"] = "없음",
    ["Cost"] = "비용",
    ["In your bags"] = "가방 안",
    [", soulbound"] = ", 귀속",
    ["One craft"] = "1회 제작",
    ["Disenchanted"] = "추출 시",
    ["Sold"] = "판매 시",
    [" at the auction house"] = " 경매장에서",
    [" at a vendor"] = " 상인에게",
    ["nobody buys it"] = "아무도 사지 않음",
    ["Best"] = "최선",
    ["Disenchanting one craft"] = "1회 제작분 추출",
    ["Cheapest listing"] = "최저 등록가",
    ["Gains"] = "수익",
    [", more %d%% of the time"] = ", %d%% 확률로 더 많음",
    ["Raises"] = "상승",
    ["Cook one"] = "하나 요리",
    ["Buy one"] = "하나 구매",
    ["Sells for"] = "판매가",
    ["Profit"] = "이익",
    ["Listed"] = "등록",
    ["%d - %d, ~%d %s"] = "%d - %d, 약 %d %s",
    ["%s of ~%d, from what you have (vendor reagents aside)"] = "%s / 약 %d개, 가진 재료로(상인 재료 제외)",
    ["%slvl %d|r - "] = "%s%d레벨|r -",
    ["known, make %d now"] = "습득함, 지금 %d개 제작 가능",
    ["learn now (skill %d)"] = "지금 배우기 (숙련도 %d)",
    ["skill %d (you %d)"] = "숙련도 %d (당신 %d)",
    ["level %d (you %d)"] = "레벨 %d (당신 %d)",
    ["%s ready"] = "%s 준비",
    ["chests, boxes and doors by skill"] = "숙련도별 상자, 함, 문",
    ["Reach level %d"] = "%d레벨 도달",
    ["at %d, raises your cap to %d%s"] = "%d에서 한계를 %d(으)로 올림%s",
    ["Fish in %s"] = "%s에서 낚시",
    ["your pick"] = "당신의 선택",
    ["an hour: ~%d catches, %s each%s%s"] = "한 시간: 약 %d회 어획, 개당 %s%s%s",
    ["%d - %d, ~%d catches%s"] = "%d - %d, 약 %d회 어획%s",
    ["%s%s, %s%s%s%s%s%s"] = "%s%s, %s%s%s%s%s%s",
    ["%s, %s, disenchanted ~%s, sold %s"] = "%s, %s, 추출 약 %s, 판매 %s",
    ["%s's %s - %s: ~%s disenchanted, %s sold%s"] = "%s, %s - %s: 추출 약 %s, 판매 %s%s",
    ["buy %s, ~%s disenchanted, pays %d%% of the time"] = "%s에 구매, 추출 약 %s, %d%% 확률로 이득",
    ["%d - %d%s: %s"] = "%d - %d%s: %s",
    ["keep them"] = "보관하세요",
    ["unconfirmed"] = "미확인",
    ["after %d%s, %sneeded for %s|r"] = "%d%s 이후, %s%s에 필요|r",
    ["%s%s, %smake one and keep it|r"] = "%s%s, %s하나 만들어 보관|r",
    ["%d favor"] = "호의 %d",
    ["? favor"] = "호의 ?",
    ["Open your %s window once so Craft Ladder knows which recipes you have."] = "%s 창을 한 번 열어 Craft Ladder가" ..
        " 어떤 제조법을 가졌는지 알게 하세요.",
    ["No %s found past %d with what Craft Ladder knows."] = "Craft Ladder가 아는 한 %s은(는) %d 이후로 없습니다.",
    ["zone"] = "지역",
    ["recipe"] = "제조법",
    ["Back to your ladder"] = "사다리로 돌아가기",
    ["Merchant's Favor recipes (%d)"] = "상인의 호의 제조법 (%d)",
    ["Dishes for this role, by what eating one raises. Click to fold or open."] = "이 역할을 위한 요리, 먹었을 때 오르는" ..
        " 능력치순. 클릭하면 접거나 펼칩니다.",
    ["Nothing here"] = "여기에는 없음",
    ["Nothing earns this way at today's prices."] = "오늘 가격으로는 이렇게 해서 남는 것이 없습니다.",
    ["Sell to a vendor"] = "상인에게 판매",
    ["These cost less to make than a vendor pays: vendors buy any number, no auction house needed. Click to" ..
        " fold or open."] = "이것들은 상인이 주는 값보다 싸게 만들 수 있습니다: 상인은 수량 제한 없이 사들이고 경매장이 필요 없습니다. 클릭하면 접거나 펼칩니다.",
    ["Sell at the auction house"] = "경매장에 판매",
    ["These earn more at the auction house: 5 or more listed (or however few when you searched it yourself)," ..
        " and it pays 1.5 times what a vendor does. How many sell, the auction house doesn't say."] =
        "이것들은 경매장에서 더 벌립니다: 5개 이상 등록(직접 검색했다면 수량 무관)되고, 상인가의 1.5배를 받습니다. 몇 개가 팔릴지는 경매장이 알려주지 않습니다.",
    ["nothing at today's prices"] = "오늘 가격으로는 없음",
    ["Disenchant, your whole account: no Enchanting needed"] = "마력 추출, 계정 전지: 마법부여 필요 없음",
    ["the ladder from %d to %d"] = "%d에서 %d까지의 사다리",
    ["the ladder to %d"] = "%d까지의 사다리",
    ["%s%s %d / %d, %s%s"] = "%s%s %d / %d, %s%s",
    ["as of %s"] = "%s 기준",
    ["%s has no %s yet"] = "%s은(는) 아직 %s이(가) 없습니다",
    ["No %s yet"] = "아직 %s 없음",
    ["Specialization"] = "특화",
    ["Skill %d"] = "숙련도 %d",
    ["No auction house prices: AuctionDB or Auctionator needed"] = "경매장 가격 없음: AuctionDB 또는 Auctionator가 필요합니다",
    [" %s prices scanned %s, costs may be off: scan at the auction house|r"] = " %s 가격은 %s에 검색됨, 비용이 어긋날 수" ..
        " 있습니다: 경매장에서 검색하세요|r",
    ["%s prices scanned %s: scan at the auction house|r"] = "%s 가격은 %s에 검색됨: 경매장에서 검색하세요|r",
    ["Prices: %s, scanned %s (%s)|r"] = "가격: %s, %s에 검색 (%s)|r",
    ["today"] = "오늘",
    ["yesterday"] = "어제",
    ["%d days ago"] = "%d일 전",
    ["Prices: Auctionator, newest prices from %s|r"] = "가격: Auctionator, %s의 최신 가격|r",
    ["Prices: %s"] = "가격: %s",
    ["%d Merchant's Favor recipes, %d you can learn now%s"] = "상인의 호의 제조법 %d개, 지금 배울 수 있는 것 %d개%s",
    ["; you have %d favor"] = "; 호의 %d 보유",
    ["%d dishes for your class; the cost is one dish from bought ingredients"] = "당신 직업을 위한 요리 %d개; 비용은 구매한" ..
        " 재료로 만든 요리 하나 기준",
    ["%d zones at skill %d; the best about %s an hour"] = "숙련도 %d에서 지역 %d곳; 가장 좋은 곳은 시간당 약 %s",
    ["Spend %s, catch about %s worth (%s, %s an hour)"] = "%s을(를) 쓰고 약 %s어치를 낚습니다 (%s, 시간당 %s)",
    ["Spend %s, %s about %s worth (%s an hour), about %d %s"] = "%s을(를) 쓰고 약 %s어치를 %s합니다 (시간당 %s), 약 %d %s",
    ["%s%d at the auction house; the best +%s a craft"] = "경매장에 %s%d개; 가장 좋은 것은 제작당 +%s",
    ["Total %s, about %d %s%s"] = "합계 %s, 약 %d %s%s",
    ["Total %s, about %d catches (%s)"] = "합계 %s, 약 %d회 어획 (%s)",
    ["Spend %s, about %s back from sales, about %d crafts"] = "%s을(를) 쓰고 판매로 약 %s 회수, 약 %d회 제작",
    ["Total %s, about %d crafts"] = "합계 %s, 약 %d회 제작",
    ["Plan the ladder to %d."] = "%d까지 사다리를 계획합니다.",
    ["Window size"] = "창 크기",
    ["Drag: make the window bigger."] = "드래그: 창을 크게 만듭니다.",
    ["Ctrl + mouse wheel: bigger or smaller text (now %d%%)."] = "Ctrl + 마우스 휠: 글자 크기 조절 (현재 %d%%).",
    ["Right-click: back to the normal size."] = "우클릭: 기본 크기로 되돌립니다.",
    ["Close"] = "닫기",
    ["Escape closes it too."] = "Esc로도 닫힙니다.",
    ["Settings"] = "설정",
    ["Which auction house addon the prices are read from, and which of its listed prices an ingredient costs."] =
        "가격을 어느 경매장 애드온에서 읽을지, 그리고 그 등록가 중 어느 것을 재료 값으로 삼을지.",
    ["Your hands are idle, adventurer."] = "모험가여, 손이 놀고 있군요.",
    ["The trainers are waiting: learn a profession."] = "교관들이 기다립니다: 전문 기술을 배우세요.",
    ["The steps to each of its specializations: the quests, what they ask for and what you have of it, the" ..
        " recipes, and what's still to make or buy."] = "각 특화까지의 단계: 퀘스트, 요구 사항과 보유분, 제조법, 그리고 아직 만들거나 사야 할 것.",
    ["Merchant's Favor recipes"] = "상인의 호의 제조법",
    ["What the supply camps' quartermaster sells for Merchant's Favor: its price and level (seen at a" ..
        " quartermaster), your skill, what you know and can make."] = "보급 야영지의 보급 장교가 상인의 호의로 파는 것: 가격과 레벨(보급" ..
        " 장교에게서 확인), 당신의 숙련도, 알고 있고 만들 수 있는 것.",
    ["Back to cheapest"] = "가장 싼 것으로 되돌리기",
    ["Use the cheapest recipe for this step again."] = "이 단계에 가장 싼 제조법을 다시 씁니다.",
    ["Search the auction house"] = "경매장에서 찾기",
    ["Auctionator's Shopping tab with this item. The auction house must be open."] = "이 아이템을 담은 Auctionator 구매" ..
        " 탭입니다. 경매장이 열려 있어야 합니다.",
    ["Also use recipes bought with Merchant's Favor."] = "상인의 호의로 사는 제조법도 사용합니다.",
    ["Reset"] = "초기화",
    ["The ladder from your skill to 300 again."] = "숙련도에서 300까지의 사다리를 다시 만듭니다.",
    ["No profession yet"] = "아직 전문 기술 없음",

    -- the menu's group headings
    ["PROFESSIONS"] = "전문 기술",
    ["SECONDARY"] = "보조 기술",
    ["CLASS"] = "직업",

    -- the modes over the list, and what each one plans (the names the tooltips use)
    ["Vendor sales"] = "상인 판매",
    ["AH sales"] = "경매장 판매",
    ["Food"] = "음식",
    ["Favor"] = "호의",
    ["done"] = "완료",
    ["in your quest log"] = "퀘스트 일지에 있음",

    -- one option's tooltip and its row
    ["Click: put a map pin and the arrow on it."] = "클릭: 지도에 표식과 화살표를 놓습니다.",
    ["%s that give points"] = "점수를 주는 %s",
    ["%s for this step"] = "이 단계에 필요한 %s",
    ["A %s is worth"] = "%s 하나의 값어치",
    ["Gold an hour"] = "시간당 골드",
    ["Click to %s here for this step."] = "클릭: 이 단계를 여기서 %s합니다.",
    ["Fish that land"] = "무는 물고기",
    ["all of them"] = "전부",
    ["none needed"] = "필요 없음",
    ["A catch is worth"] = "어획 하나의 값어치",
    ["Lures for this step"] = "이 단계의 미끼",
    ["Click to fish here for this step."] = "클릭: 이 단계를 여기서 낚습니다.",
    ["%s the %d you can make from what you have."] = "%s: 가진 재료로 만들 수 있는 %d개.",
    ["Ingredients"] = "재료",
    ["Learn"] = "배우기",
    ["Recipe"] = "제조법",
    ["Selling them brings back"] = "팔면 회수되는 금액",
    ["Per skill point"] = "숙련도 1점당",
    ["Click to use this recipe for this step."] = "클릭: 이 단계에 이 제조법을 씁니다.",
    ["~%d %s, %s a %s"] = "약 %d %s, %s당 %s",
    ["%s at the trainer"] = "교관에게 %s",
    ["no fish get away"] = "놓치는 물고기 없음",
    ["%d%% of casts land a fish"] = "던지기의 %d%%가 물고기를 올립니다",
    [", with %s"] = ", %s 사용",
    ["%s a catch%s"] = "어획당 %s%s",
    [", lures %s"] = ", 미끼 %s",
    [" / catch"] = " / 어획",
    ["%s for lures"] = "미끼에 %s",
    ["  with what you have"] = "  가진 재료로",
    ["from your bags"] = "가방에서",
    ["bought at the auction house"] = "경매장에서 구매",
    ["learn: %s"] = "배우기: %s",
    [" / point"] = " / 점",
    ["%s in all%s"] = "합계 %s%s",
    [", %s back"] = ", %s 회수",
    [" / hour"] = " / 시간",

    -- a folded list, the ingredients, the colours
    ["all %d %s"] = "전체 %d %s",
    ["and %d more %s"] = "그리고 %d %s 더",
    ["and %d more"] = "그리고 %d개 더",
    ["vendors"] = "상인",
    ["trainers"] = "교관",
    [" (you have them)"] = " (이미 보유)",
    ["  (you have %d%s)"] = "  (%d개 보유%s)",
    [", in the bank"] = ", 은행에",
    [", %d in the bank"] = ", %d개는 은행에",
    ["smelt"] = "제련",
    ["%s %d yourself from %s%s"] = "%s 직접 %d개, %s에서%s",
    [", buy the other %d"] = ", 나머지 %d개는 구매",
    ["you have enough"] = "충분히 가지고 있음",
    ["only %d listed - you need %d"] = "%d개만 등록됨 - %d개 필요",
    ["  your Cooking uses it"] = "  요리에 쓰입니다",
    ["%d%% of catches%s"] = "어획의 %d%%%s",
    [" each"] = " 개당",
    ["  creatures level %d+|r"] = "  생물 레벨 %d+|r",
    ["at the auction house, after its cut"] = "경매장에서, 수수료를 뺀 값",
    ["at a vendor"] = "상인에게",
    ["what's inside, on average"] = "안에 든 것, 평균",
    ["orange"] = "주황",
    ["yellow"] = "노랑",
    ["green"] = "초록",
    ["grey"] = "회색",
    ["from %d"] = "%d부터",
    ["Your pick."] = "당신의 선택.",

    -- the Craft bar
    ["An enchantment: enchant from the profession window, on the item."] = "마법부여입니다: 전문 기술 창에서 아이템에 부여하세요.",
    ["Learn the recipe first."] = "먼저 제조법을 배우세요.",
    ["Not in combat."] = "전투 중에는 안 됩니다.",
    ["Not enough reagents in your bags."] = "가방에 재료가 부족합니다.",
    ["Craft"] = "제작",
    ["Crafts as many as the box says; opens your profession window first if it's closed (the game crafts only" ..
        " with it open)."] = "입력한 수만큼 제작합니다; 전문 기술 창이 닫혀 있으면 먼저 엽니다(게임은 창이 열려 있어야 제작합니다).",
    [" Cooking needs a fire nearby."] = " 요리에는 근처에 불이 필요합니다.",
    ["Your bags allow %d"] = "가방으로 %d개 가능",
    ["; the step needs %d."] = "; 이 단계에는 %d개가 필요합니다.",
    ["Opening your %s window: crafting once it's ready."] = "%s 창을 여는 중: 준비되면 바로 제작합니다.",

    -- how to learn a recipe
    ["Learn it"] = "배우는 법",
    ["Buy the recipe from %s:"] = "%s에게서 제조법을 구매하세요:",
    ["one of these vendors"] = "이 상인들 중 하나",
    ["this vendor"] = "이 상인",
    ["%s Favor"] = "%s 호의",
    ["Merchant's"] = "상인의",
    ["Quest reward: %s%s"] = "퀘스트 보상: %s%s",
    ["(needs level %d)"] = "(%d레벨 필요)",
    ["quest giver"] = "퀘스트 제공자",
    ["Only these trainers teach it, for %s:"] = "이 교관들만 가르칩니다, %s:",
    ["trainer"] = "교관",
    ["None of them is of your faction."] = "그들 중 당신 진영은 없습니다.",
    ["Or buy it at the auction house: %s."] = "또는 경매장에서 구매하세요: %s.",
    ["Or %s."] = "또는 %s.",
    ["During %s: %s."] = "%s 기간: %s.",
    ["The price is an estimate: Craft Ladder learns the real one when you visit the %s."] =
        "가격은 추정값입니다: 직접 들르면 Craft Ladder가 실제 값을 알게 됩니다 (%s).",
    ["vendor"] = "상인",

    -- what it sells for, and one craft
    ["An enchantment: nothing to sell."] = "마법부여입니다: 팔 것이 없습니다.",
    ["%s%s at the auction house (after its cut%s)."] = "경매장에서 %s%s (수수료를 뺀 뒤%s).",
    ["Not on the auction house."] = "경매장에 없습니다.",
    ["%s%s at a vendor."] = "상인에게 %s%s.",
    ["Vendors don't buy it."] = "상인은 사지 않습니다.",
    ["One craft%s: %s"] = "1회 제작%s: %s",
    ["One craft: %s"] = "1회 제작: %s",
    [" (makes %d)"] = " (%d개 생산)",
    ["auction house"] = "경매장",
    ["%s yourself%s"] = "직접 %s%s",
    [" and %s"] = " 및 %s",
    ["%s each, %s"] = "개당 %s, %s",
    ["Each sells for "] = "개당 판매가",
    ["Sells for "] = "판매가",
    ["%d sell for "] = "%d개 판매가",

    -- a Merchant's Favor recipe
    ["You know it."] = "이미 알고 있습니다.",
    ["You can learn it now."] = "지금 배울 수 있습니다.",
    ["It needs %d %s (you: %d)."] = "%d %s이(가) 필요합니다 (당신: %d).",
    ["It needs level %d (you: %d)."] = "%d레벨이 필요합니다 (당신: %d).",
    ["Merchant's Favor"] = "상인의 호의",
    ["Costs %d Merchant's Favor%s."] = "상인의 호의 %d이(가) 듭니다%s.",
    [" (you have %d)"] = " (%d 보유)",
    ["Its price: open a quartermaster once and Craft Ladder remembers it."] = "가격: 보급 장교에게 한 번 들르면 Craft" ..
        " Ladder가 기억합니다.",
    ["From level %d (you: %d)."] = "%d레벨부터 (당신: %d).",
    ["Its level: open a quartermaster once and Craft Ladder remembers it."] = "레벨: 보급 장교에게 한 번 들르면 Craft" ..
        " Ladder가 기억합니다.",
    ["From %d %s (you: %d)."] = "%d %s부터 (당신: %d).",
    ["%s is %s from level %d (you: %d)."] = "%s은(는) %s, %d레벨부터 (당신: %d).",
    ["worn"] = "착용",
    ["used"] = "사용",
    ["Quartermaster"] = "보급 장교",
    ["The plan needs %s with %s."] = "이 계획에는 %s 평판이 필요합니다 (%s).",
    ["Only for %s."] = "%s 전용.",
    ["Hated"] = "증오",
    ["Hostile"] = "적대",
    ["Unfriendly"] = "비우호",
    ["Neutral"] = "중립",
    ["Friendly"] = "우호",
    ["Honored"] = "명예",
    ["Revered"] = "경애",
    ["Exalted"] = "숭배",

    -- a crafting step
    ["Skill %d - %d, about %d crafts, %s%s"] = "숙련도 %d - %d, 약 %d회 제작, %s%s",
    ["some prices missing"] = "일부 가격 없음",
    ["%s %s what you already have: %d crafts%s."] = "이미 가진 것으로 %s %s: %d회 제작%s.",
    [", plus a few vendor ingredients"] = ", 더해서 상인 재료 약간",
    [", nothing to buy"] = ", 살 것 없음",
    ["You can %s %d now with what you have."] = "%s: 지금 가진 것으로 %d개.",
    ["You have the reagents for %d."] = "%d개 분량의 재료가 있습니다.",
    ["You have the main ingredients for %d; the rest is sold by vendors."] = "%d개 분량의 주재료가 있습니다; 나머지는 상인이 팝니다.",
    ["The cheapest here is %s."] = "여기서 가장 싼 것은 %s입니다.",
    ["Needed for %s: %d recipes (%s, ...), and no vendor sells it. None of them is for leveling (a cooldown," ..
        " or learned at 300): make it once you're done."] = "%s에 필요: 제조법 %d개 (%s 등), 그리고 파는 상인이 없습니다. 그중 숙련도를" ..
        " 올리는 데 쓸 것은 없습니다(재사용 대기시간이 있거나 300에서 배움): 다 끝낸 뒤에 만드세요.",
    ["A tool: %d %s recipes need it, and no vendor sells it. Make one and keep it in your bags%s."] =
        "도구입니다: %d개의 %s 제조법이 필요로 하고, 파는 상인이 없습니다. 하나 만들어 가방에 두세요%s.",
    [" (it gives no skill point any more)"] = " (더는 숙련도를 주지 않습니다)",
    ["You have %s: the step takes them from your bags, so it pays less than that."] =
        "%s 보유: 이 단계는 가방에서 가져가므로 그보다 적게 듭니다.",
    ["Keep for later"] = "나중을 위해 보관",
    ["Keep %d %s: the steps at %d - %d use them."] = "%d개의 %s 보관: %d - %d 단계에서 씁니다.",
    ["Batch: %s"] = "묶음: %s",
    ["Craft counts are estimates: skill-ups are luck once a recipe is yellow."] = "제작 횟수는 추정값입니다: 제조법이 노란색이 되면" ..
        " 숙련도는 운에 달립니다.",
    ["Sell the rest"] = "나머지 판매",
    ["Sell what you make"] = "만든 것 판매",
    ["%d at the auction house, about %s each after its cut."] = "경매장에 %d개, 수수료를 뺀 뒤 개당 약 %s.",
    ["%d to a vendor, %s each."] = "상인에게 %d개, 개당 %s.",
    ["About %s back, so this step %s %s."] = "약 %s 회수되므로 이 단계는 %s %s.",
    ["earns"] = "벌립니다",
    ["costs"] = "듭니다",
    ["Vendor sales counts only what vendors pay: that money is sure. AH sales counts the auction house too."] =
        "상인 판매는 상인이 주는 값만 셉니다: 그 돈은 확실합니다. 경매장 판매는 경매장도 함께 셉니다.",
    ["The auction house counts only when it pays 1.5 times a vendor and 5 or more are listed, and for at most" ..
        " a quarter of what's listed."] = "경매장은 상인가의 1.5배를 주고 5개 이상 등록되었을 때만, 그리고 등록량의 4분의 1까지만 셉니다.",
    ["Or %s, from %d"] = "또는 %s, %d부터",
    ["Recipes you could use from %d"] = "%d부터 쓸 수 있는 제조법",
    ["No other recipe is open to you here."] = "여기서 당신에게 열린 다른 제조법은 없습니다.",

    -- Gold: one recipe's profit
    ["One craft%s costs about %s and sells for about %s: %s+%s|r"] = "1회 제작%s에 약 %s이(가) 들고 약 %s에 팔립니다: %s+%s|r",
    ["Sold to a vendor: vendors buy any number."] = "상인에게 판매: 상인은 수량 제한 없이 삽니다.",
    ["%d listed at the auction house now: sell a few at a time."] = "지금 경매장에 %d개 등록: 조금씩 파세요.",
    ["Making it needs %s %d, and yours is %d%s. It's here to level towards."] = "만들려면 %s %d이(가) 필요하고 당신은" ..
        " %d%s입니다. 목표로 올려둔 것입니다.",
    ["; the rank that lifts your cap to it asks level %d, and you're %d"] = "; 한계를 거기까지 올리는 등급은 %d레벨을 요구하는데" ..
        " 당신은 %d입니다",
    ["Learning it pays back after %d %s."] = "배우는 값은 %d%s 뒤에 회수됩니다.",
    ["craft"] = "회 제작",
    ["crafts"] = "회 제작",
    ["Once in %s: the recipe has a cooldown."] = "%s에 한 번: 이 제조법에는 재사용 대기시간이 있습니다.",
    ["You have %s: counted at their price too, since you could sell them."] = "%s 보유: 팔 수도 있으니 가격으로도 함께 셉니다.",
    ["Profit: what a vendor pays, less the ingredients at today's prices. How many you can make, the auction" ..
        " house's ingredients decide."] = "이익: 상인이 주는 값에서 오늘 가격의 재료비를 뺀 것. 몇 개를 만들 수 있는지는 경매장의 재료가 정합니다.",
    ["Profit: at the lowest listing after the auction house's cut, with 5 or more listed, or however few when" ..
        " you searched it yourself; it counts only when it pays 1.5 times what a vendor does. How many sell," ..
        " the auction house doesn't say. Prices change: look again before buying."] =
        "이익: 경매장 수수료를 뺀 최저 등록가 기준, 5개 이상 등록되었거나 직접 검색했다면 수량 무관; 상인가의 1.5배를 줄 때만 셉니다. 몇 개가 팔릴지는 경매장이 알려주지 않습니다." ..
        " 가격은 변합니다: 사기 전에 다시 확인하세요.",

    -- Disenchant
    ["Disenchant one: about %s"] = "하나 추출: 약 %s",
    ["%d%% of disenchants, %s each"] = "추출의 %d%%, 개당 %s",
    ["%s%d disenchanted: about %s, at least %s 9 times out of 10."] = "%s%d개 추출: 약 %s, 열 번 중 아홉 번은 최소 %s.",
    ["Your "] = "당신의",
    ["What it gives: from your %d disenchants of this item, recorded in game: it breaks unlike items of its" ..
        " kind."] = "주는 것: 게임에서 기록된 이 아이템 추출 %d회 기준: 같은 종류의 아이템과 다르게 분해됩니다.",
    ["What it gives: from %d disenchants of items like it, recorded in game."] = "주는 것: 게임에서 기록된 비슷한 아이템 추출" ..
        " %d회 기준.",
    ["You've disenchanted %d like it: %s in all. From %d, what you got replaces the table."] =
        "비슷한 것을 %d개 추출했습니다: 합계 %s. %d회부터는 당신의 결과가 표를 대신합니다.",
    ["Forever added this kind of item: what it gives is a guess, checked for one item: a green's of its level," ..
        " one more of each."] = "Forever가 이런 종류의 아이템을 추가했습니다: 주는 것은 추정이며 아이템 하나로 확인했습니다: 같은 레벨 녹색 아이템과 같고 각각" ..
        " 하나씩 더.",
    ["What a disenchant gives is luck%s. Materials at the auction house after its cut; 3 lesser essences make" ..
        " a greater one."] = "추출 결과는 운입니다%s. 재료는 경매장 수수료를 뺀 값; 하급 정수 3개로 상급 1개를 만듭니다.",
    [", from Classic's table (not checked in Forever yet): from %d of your disenchants of items like it, what" ..
        " you got replaces it"] = ", Classic의 표 기준(Forever에서는 아직 확인되지 않음): 비슷한 아이템을 %d회 추출하면 당신의 결과가 이를 대신합니다",
    ["One craft%s costs about %s; disenchanted, about %s on average: %s"] = "1회 제작%s에 약 %s이(가) 들고, 추출하면 평균 약" ..
        " %s: %s",
    ["A %s recipe %s knows."] = "%s 제조법이며 %s이(가) 알고 있습니다.",
    ["you"] = "당신",
    ["Making it costs more than disenchanting brings: disenchant it when you make it anyway, for skill."] =
        "만드는 값이 추출로 얻는 값보다 큽니다: 어차피 숙련도를 위해 만들 때 추출하세요.",
    ["Best: %s. %d in %s's %s: disenchanted, about %s on average; sold, %s."] = "최선: %s. %d개, %s의 %s에: 추출하면 평균" ..
        " 약 %s; 팔면 %s.",
    ["your"] = "당신의",
    ["bags"] = "가방",
    ["Soulbound: no auction house."] = "귀속: 경매장에 올릴 수 없습니다.",
    ["Or sell it"] = "또는 판매",
    ["Soulbound: the auction house won't take it."] = "귀속: 경매장이 받지 않습니다.",
    ["%s each at the auction house (after its cut%s)."] = "경매장에서 개당 %s (수수료를 뺀 뒤%s).",
    ["%s each at a vendor."] = "상인에게 개당 %s.",
    ["The auction house counts with 5 or more listed, or however few when you searched it yourself. What made" ..
        " it doesn't count: it's made."] = "경매장은 5개 이상 등록되었을 때, 또는 직접 검색했다면 수량 무관으로 셉니다. 무엇으로 만들었는지는 세지 않습니다:" ..
        " 이미 만들어진 것입니다.",
    ["Buy one for %s; disenchanted, about %s on average: %s"] = "%s에 하나 구매; 추출하면 평균 약 %s: %s",
    ["One disenchant brings more than it cost %d%% of the time."] = "한 번의 추출이 값을 넘기는 경우는 %d%%입니다.",
    ["Buy it"] = "구매",
    ["The cheapest listing: %s. %s."] = "최저 등록가: %s. %s.",
    ["Its level and quality are Classic's: Forever's client doesn't list it. "] = "레벨과 품질은 Classic 기준입니다:" ..
        " Forever 클라이언트에는 없습니다.",
    ["A random suffix (\"of the Monkey\") doesn't change what it breaks into. The listing may have sold since" ..
        " the scan."] = "무작위 접미사(\"원숭이의\")는 분해 결과를 바꾸지 않습니다. 해당 매물은 검색 이후 팔렸을 수 있습니다.",
    ["Nothing to disenchant"] = "추출할 것 없음",
    ["No character of yours holds anything to disenchant, and "] = "추출할 것을 가진 캐릭터가 없고,",
    ["none of the recipes they know makes something to disenchant: open a crafting profession's window once so" ..
        " Craft Ladder knows its recipes."] = "그들이 아는 제조법 중 추출할 것을 만드는 것도 없습니다: 제작 전문 기술 창을 한 번 열어 Craft" ..
        " Ladder가 제조법을 알게 하세요.",
    ["nothing they can make is worth more disenchanted than sold at today's prices."] =
        "오늘 가격으로는 그들이 만들 수 있는 것 중 추출이 판매보다 나은 것이 없습니다.",

    -- Cooking's Food
    [" (Well Fed). "] = " (포만감).",
    ["Needs level %d; you're %d."] = "%d레벨이 필요합니다; 당신은 %d입니다.",
    ["Level %d: you can eat it."] = "%d레벨: 먹을 수 있습니다.",
    ["Any level can eat it."] = "어느 레벨이든 먹을 수 있습니다.",
    ["Nobody sells its recipe now: look for it at the auction house."] = "지금은 제조법을 파는 곳이 없습니다: 경매장에서 찾아보세요.",
    ["No way to learn it for you now (a holiday's, or the other side's)."] = "지금은 배울 방법이 없습니다(축제용이거나 상대 진영의" ..
        " 것).",
    ["Learned at %s %d; you have %d."] = "%s %d에서 배웁니다; 당신은 %d입니다.",
    ["You have %s: cooking it takes them from your bags, so it costs you less than that."] =
        "%s 보유: 요리하면 가방에서 가져가므로 그보다 적게 듭니다.",
    ["Or buy it"] = "또는 구매",
    ["One at the auction house: %s."] = "경매장에 하나: %s.",
    ["None listed at the auction house now."] = "지금 경매장에 등록된 것이 없습니다.",
    ["What it raises is read from the game's files, not checked in game yet."] = "무엇을 올려주는지는 게임 파일에서 읽었으며 아직" ..
        " 게임에서 확인하지 않았습니다.",

    -- a rank step
    ["At skill %d. Your cap is your level x 5: %d at level %d."] = "숙련도 %d에서. 한계는 레벨 x 5입니다: %d레벨에 %d.",
    ["You're level %d."] = "당신은 %d레벨입니다.",
    ["Your level allows it already."] = "당신의 레벨이면 이미 가능합니다.",
    ["Lockpicking can't go past your level x 5: level up before you go on."] = "자물쇠 열기는 레벨 x 5를 넘지 못합니다: 계속하기" ..
        " 전에 레벨을 올리세요.",
    ["Learn %s%s"] = "%s%s 배우기",
    ["At skill %d, raises your cap to %d. %s"] = "숙련도 %d에서 한계를 %d(으)로 올립니다. %s",
    ["Needs character level %d."] = "캐릭터 레벨 %d이(가) 필요합니다.",
    ["How"] = "방법",
    ["Only these trainers teach it%s:"] = "이 교관들만 가르칩니다%s:",
    [", for %s"] = ", %s",
    ["Any %s trainer teaches it%s."] = "어느 %s 교관이든 가르칩니다%s.",
    [" for %s"] = " %s",
    ["Buy the %s and read it:"] = "%s을(를) 사서 읽으세요:",
    ["At the auction house: %s."] = "경매장에서: %s.",
    ["Or buy it at the auction house: %s.%s"] = "또는 경매장에서 구매하세요: %s.%s",
    [" Cheaper than the vendor, so the ladder counts this one."] = " 상인보다 싸므로 사다리는 이쪽을 셉니다.",
    ["1. Take the quest %s:"] = "1. 퀘스트 %s을(를) 받으세요:",
    ["start"] = "시작",
    ["2. Bring the ingredients below to %s for %s:"] = "2. 아래 재료를 %s에게 가져가 %s을(를) 받으세요:",
    ["hand in"] = "완료",
    ["Do the quest %s for %s:"] = "%s에게서 퀘스트 %s을(를) 수행하세요:",
    ["What to bring"] = "가져갈 것",
    ["Any %s trainer teaches Apprentice %s."] = "어느 %s 교관이든 수습 %s을(를) 가르칩니다.",

    -- fishing
    ["Fish to catch"] = "잡을 물고기",
    ["%s: %s, %s (fish bite from %d)"] = "%s: %s, %s (%d부터 물기 시작)",
    ["seen by GatherMate2"] = "GatherMate2가 발견",
    ["place known"] = "알려진 자리",
    ["places known"] = "알려진 자리",
    [" a catch"] = " 어획당",
    ["%d - %d catches before it's gone"] = "사라지기까지 %d - %d회 어획",
    ["No fish get away here."] = "여기서는 물고기를 놓치지 않습니다.",
    ["About %d%% of casts land a fish here."] = "여기서는 던지기의 약 %d%%가 물고기를 올립니다.",
    ["An hour at skill %d: about %d catches, %s each"] = "숙련도 %d에서 한 시간: 약 %d회 어획, 개당 %s",
    [" An hour's catches are worth about %s%s."] = " 한 시간의 어획은 약 %s 값어치입니다%s.",
    [", lures paid"] = ", 미끼 값 포함",
    ["Skill %d - %d, about %d catches (%s), %s"] = "숙련도 %d - %d, 약 %d회 어획 (%s), %s",
    [" Catches worth about %s (%s an hour)."] = " 어획 가치 약 %s (시간당 %s).",
    ["Craft Ladder's choice here is %s."] = "여기서 Craft Ladder의 선택은 %s입니다.",
    ["Its creatures are level %d - %d."] = "이곳 생물은 %d - %d레벨입니다.",
    ["Bring"] = "가져갈 것",
    ["Put %s on your pole: +%d fishing for %d minutes, so no fish get away."] = "낚싯대에 %s을(를) 다세요: %d분 동안 낚시" ..
        " +%d, 물고기를 놓치지 않습니다.",
    ["Fishing supplies vendors sell lures, in every capital."] = "미끼는 각 수도의 낚시 용품 상인이 팝니다.",
    ["No lure needed: your skill keeps the fish from getting away."] = "미끼가 필요 없습니다: 숙련도만으로도 물고기를 놓치지 않습니다.",
    ["What you catch here"] = "여기서 잡히는 것",
    ["Fishing pools here"] = "이곳의 물고기 떼",
    ["Fish pools when you see them: Craft Ladder counts a third of your catches here from pools. That makes a" ..
        " catch worth %s on average (%s in open water)."] = "물고기 떼가 보이면 거기서 낚으세요: Craft Ladder는 이곳 어획의 3분의 1을" ..
        " 떼에서 나온 것으로 셉니다. 그러면 어획 하나가 평균 %s 값어치입니다(트인 물에서는 %s).",
    ["No fishing pools known here yet. GatherMate2 adds the ones you fish, and Craft Ladder counts them."] =
        "이곳에는 아직 알려진 물고기 떼가 없습니다. GatherMate2가 당신이 낚은 곳을 추가하고 Craft Ladder가 그것을 셉니다.",
    ["Catches per point: from your %d catches, skill-ups come %d%% as often as Classic's rule says."] =
        "숙련도 1점당 어획: 당신의 %d회 어획 기준, 숙련도 상승은 Classic 규칙의 %d%% 빈도로 나옵니다.",
    ["Catches per point follow Classic's rule (at 150, one point in about 4 catches) until Craft Ladder has" ..
        " counted 50 of your catches (%d so far)."] = "숙련도 1점당 어획은 Classic 규칙을 따릅니다(150에서 약 4회당 1점). Craft" ..
        " Ladder가 당신의 어획 50회를 셀 때까지입니다(현재 %d회).",
    ["Zones and their fish come from Classic's world: Forever may differ."] = "지역과 그곳의 물고기는 Classic 세계 기준입니다:" ..
        " Forever는 다를 수 있습니다.",
    ["Other zones from %d"] = "%d부터의 다른 지역",
    ["No other zone is open to you here."] = "여기서 당신에게 열린 다른 지역은 없습니다.",

    -- skinning and mining
    ["about %d in the zone, %s %s each%s"] = "지역에 약 %d개, 개당 %s %s%s",
    [", worth %s"] = ", 가치 %s",
    ["needs %d"] = "%d 필요",
    ["%s  %slevel %d%s|r"] = "%s  %s레벨 %d%s|r",
    [", seen skinned"] = ", 가죽을 벗긴 적 있음",
    ["about %d in the zone, needs %d%s"] = "지역에 약 %d마리, %d 필요%s",
    [", %s a skin"] = ", 가죽당 %s",
    ["Skin in %s"] = "%s에서 가죽 벗기기",
    ["An hour at skill %d: about %d creatures, %s each"] = "숙련도 %d에서 한 시간: 약 %d마리, 마리당 %s",
    ["An hour's skins are worth about %s. Every creature you can skin counts, grey ones too."] =
        "한 시간의 가죽은 약 %s 값어치입니다. 벗길 수 있는 생물은 회색도 모두 셉니다.",
    ["Skill %d - %d, about %d creatures%s"] = "숙련도 %d - %d, 약 %d마리%s",
    [", trainer %s"] = ", 교관 %s",
    ["Worth about %s skinned (%s an hour)."] = "가죽으로 약 %s 값어치 (시간당 %s).",
    ["Skin every creature that still gives a point, of your level or below."] = "아직 점수를 주는, 당신 레벨 이하의 생물은 모두" ..
        " 가죽을 벗기세요.",
    ["Its creatures are well above your level."] = "이곳 생물은 당신 레벨보다 훨씬 높습니다.",
    ["Creatures to skin here"] = "여기서 가죽을 벗길 생물",
    ["Which creatures can be skinned and what one gives come from Classic; where they are and their levels" ..
        " from QuestieDB's Forever data. The skill one needs is Classic's rule from its level (level x 5 past" ..
        " 20), the colours Mining's (yellow 25, green 50, grey 100 above it). A creature new in Forever counts" ..
        " once you've skinned one."] = "어떤 생물의 가죽을 벗길 수 있고 한 마리가 무엇을 주는지는 Classic 기준이며, 위치와 레벨은 QuestieDB의" ..
        " Forever 데이터 기준입니다. 필요한 숙련도는 레벨로 계산한 Classic 규칙(20 이후 레벨 x 5), 색은 채광과 같습니다(노랑 25, 초록 50, 회색 100 위)." ..
        " Forever에 새로 생긴 생물은 한 마리 벗겨 봐야 셉니다.",
    ["Gold an hour assumes %d s a creature (kill, loot, skin) and a 60%% mount between them: about %d an hour" ..
        " here."] = "시간당 골드는 생물 한 마리에 %d초(처치, 전리품, 가죽)와 그 사이 60%% 탈것을 가정합니다: 여기서는 시간당 약 %d마리.",
    ["Other zones, from %d"] = "%d부터의 다른 지역",
    ["%s in %s"] = "%s: %s",
    ["An hour at skill %d: about %d %s, %s each"] = "숙련도 %d에서 한 시간: 약 %d %s, 개당 %s",
    ["An hour's worth about %s. Every %s you can reach counts, grey ones too. Creatures level %d - %d."] =
        "한 시간에 약 %s 값어치입니다. 닿을 수 있는 %s은(는) 회색도 모두 셉니다. 생물 레벨 %d - %d.",
    ["Skill %d - %d, about %d %s%s"] = "숙련도 %d - %d, 약 %d %s%s",
    ["Worth about %s (%s an hour). Creatures level %d - %d."] = "약 %s 값어치 (시간당 %s). 생물 레벨 %d - %d.",
    ["Creatures level %d - %d. %s every %s that still gives a point."] = "생물 레벨 %d - %d. 아직 점수를 주는 %s은(는) 모두" ..
        " %s하세요.",
    ["%s places come from GatherMate2's Forever data; what one gives and how often a rarer kind takes a place," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what one" ..
        " needs): Forever may differ."] = "%s 자리는 GatherMate2의 Forever 데이터 기준이며, 하나가 무엇을 주는지와 더 드문 종류가 얼마나 자주" ..
        " 자리를 차지하는지는 Classic 기준입니다. 숙련도 상승은 Classic 색을 따릅니다(노랑 25, 초록 50, 회색 100 위): Forever는 다를 수 있습니다.",
    ["Gold an hour assumes 15 s a %s, a third of the zone's places with one up and a 60%% mount: about %d an" ..
        " hour here."] = "시간당 골드는 %s 하나에 15초, 지역 자리의 3분의 1에 생성, 60%% 탈것을 가정합니다: 여기서는 시간당 약 %d개.",
    ["%s: about %d bars%s"] = "%s: 주괴 약 %d개%s",
    [", learn it from a Mining trainer for %s"] = ", 채광 교관에게 %s에 배우세요",
    ["Nothing you mine here still gives points when smelted."] = "여기서 캐는 것은 제련해도 더는 점수를 주지 않습니다.",
    ["Sell ore or bars"] = "광석 또는 주괴 판매",
    ["%s: %s each. Smelting it needs more skill."] = "%s: 개당 %s. 제련하려면 숙련도가 더 필요합니다.",
    ["sell the ore, smelt it only for the skill-ups"] = "광석을 팔고, 숙련도를 위해서만 제련하세요",
    ["smelt it and sell the bars"] = "제련해서 주괴를 파세요",
    [", %s as %s"] = ", %s(으)로 치면 %s",
    ["make %s and sell it"] = "%s을(를) 만들어 파세요",
    ["%s: %s as ore, %s as %s%s - %s."] = "%s: 광석으로 %s, %s(으)로 %s%s - %s.",
    ["%s: %s make %d %s, so per ore it's worth one of them; it takes both ores, as much as the scarcer one" ..
        " allows."] = "%s: %s(으)로 %d개의 %s을(를) 만들므로 광석당 그중 하나의 값어치입니다; 두 광석이 모두 필요하며 드문 쪽이 한도입니다.",
    ["Nothing mined here can be smelted."] = "여기서 캐는 것 중 제련할 수 있는 것은 없습니다.",
    ["Per ore, after the auction house's cut (only what's listed at least 5 times), or what a vendor pays."] =
        "광석당, 경매장 수수료를 뺀 값(5회 이상 등록된 것만) 또는 상인이 주는 값.",
    ["Smelting gives skill-ups too: Craft Ladder counts the ore you mine as smelted, so you mine fewer nodes."] =
        "제련도 숙련도를 줍니다: Craft Ladder는 캔 광석을 제련한 것으로 세므로 캐야 할 광맥이 줄어듭니다.",
    ["Node places come from GatherMate2's Forever data; how often rare veins appear and the ore a node gives," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what a node" ..
        " needs): Forever may differ."] = "광맥 자리는 GatherMate2의 Forever 데이터 기준이며, 희귀 광맥이 나오는 빈도와 광맥 하나의 광석량은" ..
        " Classic 기준입니다. 숙련도 상승은 Classic 색을 따릅니다(노랑 25, 초록 50, 회색 100 위): Forever는 다를 수 있습니다.",
    ["Gold an hour assumes 15 s a node, a third of the zone's node places with a node up and a 60%% mount:" ..
        " about %d nodes an hour here."] = "시간당 골드는 광맥 하나에 15초, 지역 자리의 3분의 1에 광맥, 60%% 탈것을 가정합니다: 여기서는 시간당 약" ..
        " %d개.",
    ["Other zones, or smelting, from %d"] = "%d부터의 다른 지역 또는 제련",

    -- Lockpicking
    ["%d a run, needs %d"] = "한 바퀴에 %d개, %d 필요",
    ["about %d in the zone, needs %d"] = "지역에 약 %d개, %d 필요",
    ["Humanoids drop it; the auction house sells it."] = "인간형 생물이 떨어뜨리며 경매장에서도 팝니다.",
    ["Fished up from pools."] = "물고기 떼에서 낚습니다.",
    ["Engineers make it."] = "기술자가 만듭니다.",
    ["Pick Pocket humanoids of level %d - %d."] = "%d - %d레벨 인간형 생물의 주머니를 터세요.",
    ["Pick Pocket humanoids."] = "인간형 생물의 주머니를 터세요.",
    ["Pick locks in %s"] = "%s에서 자물쇠 열기",
    ["Skill %d - %d, about %d locks"] = "숙련도 %d - %d, 약 %d개의 자물쇠",
    ["Creatures level %d - %d. Pick every lock that still gives a point: a chest gives one chance, and one" ..
        " more once it's back."] = "생물 레벨 %d - %d. 아직 점수를 주는 자물쇠는 모두 여세요: 상자는 한 번, 다시 생기면 한 번 더 기회를 줍니다.",
    ["The door round"] = "문 돌기",
    ["1. Go into Blackrock Depths (Blackrock Mountain, between Searing Gorge and Burning Steppes)."] =
        "1. 검은바위 나락으로 들어가세요(검은바위 산, 타오르는 협곡과 불타는 평원 사이).",
    ["2. Pick the locked doors on the way: the first on the left, through it the next on the right, then the" ..
        " first on the left again; the Shadowforge Lock under the big gear too, if nothing would pull."] =
        "2. 가는 길의 잠긴 문을 여세요: 왼쪽 첫 번째, 그 너머 오른쪽 다음 문, 그리고 다시 왼쪽 첫 번째; 아무도 끌려오지 않는다면 큰 톱니바퀴 아래 암흑불꽃 자물쇠도.",
    ["3. Leave, right-click your portrait, Reset all instances and go in again: the game lets you in 5 times" ..
        " an hour."] = "3. 나가서 초상화를 우클릭하고 모든 인스턴스 초기화 후 다시 들어가세요: 게임은 시간당 5번까지 허용합니다.",
    ["The round is zockify's Forever guide's: about 4 doors a run."] = "이 코스는 zockify의 Forever 가이드 기준입니다: 한" ..
        " 바퀴에 약 4개의 문.",
    ["Where"] = "위치",
    ["Most %ss are around here"] = "%s은(는) 대부분 이 근처에 있습니다",
    ["Chest places: GatherMate2's and QuestieDB's Forever data. Which lock a chest needs, and the colours" ..
        " (yellow 25, green 50, grey 100 above it), are Classic's: Forever may differ."] =
        "상자 자리: GatherMate2와 QuestieDB의 Forever 데이터. 상자에 필요한 자물쇠와 색(노랑 25, 초록 50, 회색 100 위)은 Classic 기준입니다:" ..
        " Forever는 다를 수 있습니다.",
    ["Other zones, or boxes, from %d"] = "%d부터의 다른 지역 또는 함",
    ["Pick %s"] = "%s 열기",
    ["Skill %d - %d, about %d boxes, %s"] = "숙련도 %d - %d, 약 %d개의 함, %s",
    ["Pick the ones in your bags: you have %d."] = "가방에 있는 것을 여세요: %d개 보유.",
    ["Boxes to buy: %s"] = "살 함: %s",
    ["A box gives one chance at a point, and what's inside is yours."] = "함 하나는 점수를 얻을 기회를 한 번 주고, 안에 든 것은 당신" ..
        " 것입니다.",
    ["Or pick locks in a zone, from %d"] = "또는 지역에서 자물쇠 열기, %d부터",
    ["Every lock a rogue picks, by the skill it needs; its colour at your %d."] = "도적이 여는 모든 자물쇠를 필요한 숙련도순으로;" ..
        " 당신의 %d 기준 색입니다.",
    ["Orange always gives a point, yellow mostly, green sometimes, grey never."] = "주황은 항상 1점, 노랑은 대개, 초록은 가끔," ..
        " 회색은 절대 주지 않습니다.",
    ["Chests in the world"] = "세계의 상자",
    ["Boxes from your bags"] = "가방 속 함",
    ["You have %d."] = "%d개 보유.",
    [" %s at the auction house."] = " 경매장에서 %s.",
    ["Dungeon doors"] = "던전의 문",
    ["%s: %d locked doors, from %d (%s)."] = "%s: 잠긴 문 %d개, %d부터 (%s).",
    ["Getting started"] = "시작하기",
    ["Pick Lock: any rogue trainer, from level 16, for %s. It needs Thieves' Tools in your bags (rogue" ..
        " supplies vendors, 15s). Your cap is your level x 5."] = "자물쇠 열기: 어느 도적 교관이든 16레벨부터 %s에 가르칩니다. 가방에" ..
        " 도둑의 도구가 필요합니다(도적 용품 상인, 15실버). 한계는 레벨 x 5입니다.",

    -- the cards with nothing to show, and the rest
    ["Nothing earns now"] = "지금은 남는 것이 없음",
    ["Nothing you can make sells for more than it costs at today's prices."] = "오늘 가격으로는 당신이 만들 수 있는 것 중 원가보다" ..
        " 비싸게 팔리는 것이 없습니다.",
    ["Nothing you can get here has a price yet: Craft Ladder needs auction house prices."] =
        "여기서 얻는 것에는 아직 가격이 없습니다: Craft Ladder에는 경매장 가격이 필요합니다.",
    ["Nothing to do here"] = "여기서 할 일이 없음",
    ["You've reached %d %s."] = "%d %s에 도달했습니다.",
    ["No recipe found for your skill."] = "숙련도에 맞는 제조법을 찾지 못했습니다.",
    [", Working Overtime %d/5: +%d%%"] = ", 초과 근무 %d/5: +%d%%",

    -- what the data itself says on a rank card (Professions.lua, Data/*.lua)
    ["Your class quests at 16"] = "16레벨 직업 퀘스트",
    ["They lead to the first practice chests and give you Thieves' Tools. Pick Lock itself is learned from any" ..
        " rogue trainer, quest or not."] = "첫 연습용 상자로 이어지며 도둑의 도구를 줍니다. 자물쇠 열기 자체는 퀘스트와 상관없이 어느 도적 교관에게서나" ..
        " 배웁니다.",
    ["Your class quests at 20"] = "20레벨 직업 퀘스트",
    ["The last one teaches Poisons (and Recipe: Thistle Tea). On the way you pick a lock: Lockpicking 70 for" ..
        " the Alliance's Duskwood Chest, 80 for the Horde's Gallywix's Lockbox (Classic's numbers, not" ..
        " confirmed in Forever)."] = "마지막 퀘스트가 독약(그리고 제조법: 엉겅퀴 차)을 가르칩니다. 가는 길에 자물쇠를 하나 엽니다: 얼라이언스는 황혼의 숲 상자에" ..
        " 자물쇠 열기 70, 호드는 갤리윅스의 금고에 80(Classic 수치, Forever 미확인).",
    ["Bring 12 Giant Egg, 10 Zesty Clam Meat and 20 Alterac Swiss to Dirge Quikcleave in Gadgetzan."] =
        "거대한 알 12개, 매콤한 조갯살 10개, 알터랙 스위스 치즈 20개를 가젯잔의 더지 퀵클리브에게 가져가세요.",
    ["Catch the four fish below and bring them to Nat Pagle; he then teaches Artisan Fishing for 1g."] =
        "아래 네 가지 물고기를 잡아 냇 페이글에게 가져가세요; 그러면 1골드에 숙련 낚시를 가르칩니다.",
    ["Hank the Hammer's (Alliance) or Aturk the Anvil's (Horde) quests lead to Galvan the Ancient and Trenton" ..
        " Lighthammer, whose quests teach the Ornate Mithril recipes the last quest asks for. Buy those 7" ..
        " items at the auction house and you can skip them."] = "망치 행크(얼라이언스)나 모루 아투르크(호드)의 퀘스트는 고대의 갈반과 트렌튼" ..
        " 라이트해머로 이어지고, 그들의 퀘스트가 마지막 퀘스트에서 요구하는 화려한 미스릴 제조법을 가르칩니다. 그 7개 아이템을 경매장에서 사면 건너뛸 수 있습니다.",
    ["It gives you a letter to hand in."] = "전달할 편지를 줍니다.",
    ["Right-click the pledge it gives you: that completes it."] = "받은 서약서를 우클릭하면 완료됩니다.",
    ["Save 15 wounded soldiers with the Triage Bandages the doctor gives you, before 6 of them die."] =
        "의사가 주는 응급 붕대로 부상병 6명이 죽기 전에 15명을 살리세요.",
    ["Then learn the mastery from the trainer who gave you the quest."] = "그런 다음 퀘스트를 준 교관에게서 숙련을 배우세요.",
}
