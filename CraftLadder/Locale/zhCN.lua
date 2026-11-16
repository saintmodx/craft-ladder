-- Craft Ladder in Simplified Chinese. The key is the English string as it stands in the code; what's missing here is shown in
-- English. Item, recipe and zone names come from the game itself, so they are not here.
-- The %s and %d of a line must stay in the same order as in the English one: the game fills them in that order.
local _, ns = ...

ns.Locales = ns.Locales or {}
ns.Locales.zhCN = {
    -- the auction house tab
    ["The items' names are still loading: click again."] = "物品名称仍在加载：请再点一次。",
    ["Stop"] = "停止",
    ["Full Rescan"] = "全部重新扫描",
    ["Scanning %s: %d of %d items."] = "正在扫描%s：%d / %d 件物品。",
    ["the auction house"] = "拍卖行",
    ["Scan done: %d of %d items searched."] = "扫描完成：已找到 %d / %d 件物品。",
    ["A scan is already running: stop it first."] = "已有扫描在进行：请先停止。",
    ["Nothing to scan here."] = "这里没有可扫描的内容。",
    ["Scanning %s: 0 of %d items."] = "正在扫描%s：0 / %d 件物品。",
    ["this step"] = "这一步",
    ["Confirm %s"] = "以 %s 购买",
    ["Asking..."] = "查询中...",
    ["Buying %d %s..."] = "正在购买 %d 个%s...",
    ["The auction house is busy: try again in a moment."] = "拍卖行正忙：请稍后再试。",
    ["Asking the price of %d %s..."] = "正在查询 %d 个%s的价格...",
    ["Scan"] = "扫描",
    ["Asks the auction house what this one goes for now, and puts that price in the ladder. However fresh the" ..
        " price already is."] = "向拍卖行查询这件物品现在的价格，并把该价格放进阶梯。无论现有价格多新。",
    ["Asks the auction house about what this step makes and everything it takes, then puts those prices in the" ..
        " ladder."] = "向拍卖行查询这一步制作的物品和所需的全部材料，并把这些价格放进阶梯。",
    ["Search"] = "搜索",
    ["Auctionator's Shopping tab with what this step buys, and how many."] = "Auctionator" ..
        " 的购物标签页，列出这一步要买的物品和数量。",
    ["Learn %s"] = "学习%s",
    ["at %d, raises your cap to %d"] = "在 %d，把上限提升到 %d",
    ["%s%s|r a craft, %s"] = "每次制作 %s%s|r，%s",
    ["sold to a vendor"] = "卖给商人",
    ["%d listed"] = "%d 件在售",
    ["%d - %d, ~%d %s%s"] = "%d - %d，约 %d %s%s",
    [", %d listed"] = "，%d 件在售",
    ["at %d, make one and keep it"] = "在 %d，做一个留着",
    ["nothing to buy"] = "没有要买的",
    ["need %d, you have %d"] = "需要 %d，你有 %d",
    ["%s each"] = "每个 %s",
    ["not listed"] = "无人出售",
    ["No crafting profession: nothing to buy for one."] = "没有制造专业：没有要为此购买的东西。",
    ["%s: nothing to buy"] = "%s：没有要买的",
    ["Scan stopped: the prices it had got are in."] = "扫描已停止：已取得的价格都已写入。",
    ["Nothing here to rescan."] = "这里没有可重新扫描的内容。",
    ["Every price here was searched in the last two minutes: nothing to ask again."] =
        "这里的每个价格都在最近两分钟内查过：无需再问。",
    ["Scanning the auction house: 0 of %d items."] = "正在扫描拍卖行：0 / %d 件物品。",
    ["Searches the auction house for everything this list buys and sells, then puts the prices in the ladder." ..
        " It goes one item at a time, as the server allows: watch the line below. An item searched in the last" ..
        " two minutes is left alone."] = "在拍卖行搜索这个清单买入和卖出的所有物品，然后把价格放进阶梯。它按服务器允许的速度逐件查询：请看下面一行。最近两分钟内查过的物品会跳过。",
    ["Crafts"] = "制作次数",
    ["A click on a step or a reagent searches it in Auctionator's Shopping tab."] = "点击某一步或某个材料，会在 Auctionator" ..
        " 的购物标签页中搜索它。",
    ["Craft Ladder"] = "Craft Ladder",
    ["%d %s for %s (%s each): click Confirm to buy."] = "%d 个%s共 %s（每个 %s）：点击购买。",
    ["No price for %s: not enough listed, or not sold that way (try the Buy tab)."] =
        "没有%s的价格：在售数量不足，或不是这样出售的（试试购买标签页）。",
    ["Bought %d %s."] = "已购买 %d 个%s。",
    ["The purchase failed (the price may have changed): ask again."] = "购买失败（价格可能已变动）：请再试一次。",

    -- the camp view
    ["No profession"] = "没有专业",
    [" (skill %d)"] = "（技能 %d）",
    ["you know it"] = "你已学会",
    ["you can learn it"] = "你可以学",
    ["not your profession"] = "不是你的专业",
    ["%d in your bags"] = "背包里有 %d 个",
    ["needs %s"] = "需要%s",
    ["make %s"] = "制作%s",
    ["no price"] = "没有价格",
    ["AH %s"] = "拍卖 %s",
    ["  (not with %s)"] = "  （不与%s同时）",
    ["Or, the same buff and more: %s"] = "或者同样的效果且更好：%s",
    ["Camp: the buffs a campfire gives, for a level %d %s"] = "营地：篝火提供的增益，适用于 %d 级%s",
    ["Holds %d camp features. %s; %s."] = "可容纳 %d 个营地设施。%s；%s。",
    ["A %s holds %d: the ones above. Then:"] = "%s可容纳 %d 个：上面那些。然后：",
    ["Doesn't help a %s"] = "对%s没有帮助",
    ["Camp features with no buff"] = "没有增益的营地设施",
    ["Build a campfire, place camp features around it and sit or craft nearby for a while: each feature gives" ..
        " everyone there its buff. A campfire holds only so many: here they are in the order your role wants" ..
        " them."] = "点起篝火，把设施摆在四周，然后在附近坐下或工作一会儿：每个设施都会把增益给在场的所有人。篝火只能容纳有限几个：这里按你的角色所需顺序列出。",
    ["Campfire:"] = "篝火：",

    -- the characters' buttons
    ["Level %d %s"] = "%d 级%s",
    ["Playing now"] = "正在游戏",
    ["Last seen %s"] = "最后一次见到 %s",

    -- the menu
    ["Show the %s ladder."] = "显示%s的阶梯。",
    ["not learned"] = "未学会",
    ["Disenchant"] = "分解",
    ["Camp"] = "营地",
    ["What's worth disenchanting on your whole account: what every character's bags and bank hold, what the" ..
        " auction house lists for less than disenchanting it brings, and what your crafting professions make" ..
        " that's worth more disenchanted than sold."] = "在你整个账号中值得分解的东西：每个角色背包和银行里有什么，拍卖行上卖得比分解所得还便宜的有哪些，以及你的制" ..
        "造专业做出来后分解比卖掉更值钱的有哪些。",
    ["What each camp feature gives around a campfire, in the order your role wants them, and how to get it."] =
        "每个营地设施在篝火旁提供什么，按你的角色所需的顺序排列，以及如何获得。",

    -- the minimap button
    ["Earns most"] = "收益最高",
    ["%s, %s an hour"] = "%s，每小时 %s",
    ["Now"] = "现在",
    ["%s in %s to %d"] = "%s：在%s，到 %d",
    ["fish"] = "钓鱼",
    ["mine"] = "采矿",
    ["catches"] = "渔获",
    ["nodes"] = "矿脉",
    ["%s to %d"] = "%s到 %d",
    ["~%d crafts, %s"] = "约 %d 次制作，%s",
    ["Eat"] = "进食",
    ["%s, +%s a craft"] = "%s，每次制作 +%s",
    ["reach level %d"] = "达到 %d 级",
    ["learn %s"] = "学习%s",
    ["Up to %d"] = "最高 %d",
    ["Prices"] = "价格",
    ["Click: open or close the window"] = "点击：打开或关闭窗口",
    ["Drag: move the button"] = "拖动：移动按钮",
    ["minimap button hidden - /craft minimap shows it again."] = "小地图按钮已隐藏 - /craft minimap 可重新显示。",
    ["minimap button shown."] = "小地图按钮已显示。",

    -- the Settings menu
    ["Auction house prices from"] = "拍卖行价格来自",
    ["Its last full scan of your faction's auction house: the lowest price, the median and how many are" ..
        " listed."] = "它对你所属阵营拍卖行的最后一次完整扫描：最低价、中位价以及在售数量。",
    ["Its last scan. It gives one price per item, so the median is that price."] = "它的最后一次扫描。每件物品只给一个价格，所以中位价就" ..
        "是该价格。",
    ["An ingredient costs"] = "一个材料的价格按",
    ["The median listed price"] = "在售价格的中位数",
    ["Half of what's listed costs less. The cheapest listing is one auction, often gone minutes after the" ..
        " scan."] = "在售物品中有一半比它便宜。最低价只是单独一笔拍卖，常常在扫描后几分钟就没了。",
    ["The cheapest listing"] = "最低在售价",
    ["What the ladder cost before: the lowest price of the scan. Cheaper than what you will really pay, unless" ..
        " you are quick."] = "阶梯以前的算法：扫描中的最低价。比你实际会付的要便宜，除非你手快。",
    ["Language"] = "语言",
    ["Craft Ladder's own words. Item, recipe and zone names come from your game client, in its language. A few" ..
        " buttons take a /reload to change."] = "Craft Ladder 自己的文字。物品、配方和区域的名称来自你的游戏客户端，使用客户端的语言。少数按钮需要" ..
        " /reload 才会变化。",
    ["What you sell is always priced at the cheapest listing, the one you undercut."] =
        "你卖出的东西始终按最低在售价计算，也就是你要压价的那个。",
    ["%s isn't installed: %s is read."] = "未安装 %s：改读取 %s。",
    ["Neither addon is installed: no auction house prices."] = "两个插件都未安装：没有拍卖行价格。",

    -- the Specialization view
    ["%s%d / %d|r  %s"] = "%s%d / %d|r  %s",
    ["level %d (you're %d)"] = "%d 级（你是 %d 级）",
    ["%s %d (you have %d)"] = "%s %d（你有 %d）",
    ["Needs %s."] = "需要%s。",
    [" and "] = "和",
    ["Or take it here instead:"] = "或者改在这里取得：",
    ["Take the quest:"] = "接取任务：",
    ["Take and hand in the quest:"] = "接取并交付任务：",
    ["Hand it in:"] = "交付它：",
    ["you have them all"] = "你都有了",
    ["auction house %s"] = "拍卖行 %s",
    ["none at the auction house"] = "拍卖行上没有",
    ["Make %d; some of its ingredients have no price; %s"] = "制作 %d 个；部分材料没有价格；%s",
    ["Make %d for %s; %s"] = "制作 %d 个，花费 %s；%s",
    ["Buy %d: %s%s"] = "购买 %d 个：%s%s",
    [", making them costs %s"] = "，自己做要花 %s",
    ["Drops from %s"] = "由%s掉落",
    ["Drops from %d kinds of creatures; "] = "由 %d 种生物掉落；",
    ["none at the auction house now"] = "目前拍卖行上没有",
    [", learned at %d"] = "，在 %d 学会",
    ["its recipe drops from %d kinds of creatures, none at the auction house now"] = "它的配方由 %d 种生物掉落，目前拍卖行上没有",
    ["no way to learn it for you now"] = "你现在无法学会它",
    ["Buy the recipe:"] = "购买配方：",
    ["Learn it from the trainer:"] = "向训练师学习：",
    ["Bring to %s:"] = "带到%s处：",
    ["the quest giver"] = "任务发布者",
    ["%s%d %s%s"] = "%s%d %s%s",
    ["smelt "] = "熔炼",
    [" (besides the %d you have)"] = "（除了你已有的 %d 个）",
    ["Make: %s"] = "制作：%s",
    ["Ingredients:"] = "材料：",
    ["buy %d: "] = "购买 %d 个：",
    ["the smith"] = "铁匠",
    ["%d. Talk to %s"] = "%d. 与%s对话",
    ["Talk to:"] = "对话对象：",
    ["%d. Master a weapon: one of them"] = "%d. 精通一种武器：其中之一",
    ["%s: the quest %s"] = "%s：任务%s",
    ["The recipes"] = "配方",
    ["  %d to learn"] = "  %d 个待学",
    ["Click to fold or open."] = "点击可折叠或展开。",
    ["Show the steps to %s."] = "显示通往%s的步骤。",
    ["You have this specialization."] = "你拥有这个专精。",
    ["Needs level %d and %s %d; you're level %d with %d."] = "需要 %d 级和%s %d；你是 %d 级，技能 %d。",
    ["Unlocks %d recipes only this specialization can learn."] = "解锁 %d 个只有该专精才能学的配方。",
    ["You have %s: a character can have only one %s specialization."] = "你已有%s：一个角色在%s中只能拥有一个专精。",
    ["Still to spend: %s, each item made or bought, whichever costs less%s."] = "还需花费：%s，每件物品按制作或购买中较便宜的计算%s。",
    ["; some have no price"] = "；部分没有价格",
    ["You have %s"] = "你有 %s",
    ["To %s: about %s%s"] = "到 %s：约 %s%s",
    [", some items unpriced"] = "，部分物品没有价格",

    -- the window: the list, its rows and their tooltips
    [" - %s%s %d|r"] = " - %s%s %d|r",
    ["%d days"] = "%d 天",
    ["%d hours"] = "%d 小时",
    ["~%d min"] = "约 %d 分钟",
    ["All locks"] = "所有锁",
    ["Every lock a rogue picks, by the skill it needs, and its colour for you."] = "盗贼能开的每一把锁，按所需技能和它对你的颜色排列。",
    ["At %d your cap is the level x 5: %d at level %d."] = "在 %d 时你的上限是等级 x 5：%d 级时为 %d。",
    ["at %d, cap %d"] = "在 %d，上限 %d",
    ["Skill"] = "技能",
    ["Smelt on the way"] = "路上顺便熔炼",
    ["Trainer"] = "训练师",
    ["Catches"] = "渔获",
    ["Lure"] = "鱼饵",
    ["none"] = "无",
    ["Cost"] = "成本",
    ["In your bags"] = "在你的背包里",
    [", soulbound"] = "，灵魂绑定",
    ["One craft"] = "一次制作",
    ["Disenchanted"] = "分解",
    ["Sold"] = "出售",
    [" at the auction house"] = " 在拍卖行",
    [" at a vendor"] = " 卖给商人",
    ["nobody buys it"] = "没人收购",
    ["Best"] = "最佳",
    ["Disenchanting one craft"] = "分解一次制作所得",
    ["Cheapest listing"] = "最低在售价",
    ["Gains"] = "收益",
    [", more %d%% of the time"] = "，有 %d%% 的概率更高",
    ["Raises"] = "提升",
    ["Cook one"] = "烹饪一个",
    ["Buy one"] = "购买一个",
    ["Sells for"] = "售价",
    ["Profit"] = "利润",
    ["Listed"] = "在售",
    ["%d - %d, ~%d %s"] = "%d - %d，约 %d %s",
    ["%s of ~%d, from what you have (vendor reagents aside)"] = "%s / 约 %d，用你现有的材料（商人材料除外）",
    ["%slvl %d|r - "] = "%s%d 级|r -",
    ["known, make %d now"] = "已学会，现在可做 %d 个",
    ["learn now (skill %d)"] = "现在可学（技能 %d）",
    ["skill %d (you %d)"] = "技能 %d（你 %d）",
    ["level %d (you %d)"] = "等级 %d（你 %d）",
    ["%s ready"] = "%s就绪",
    ["chests, boxes and doors by skill"] = "按技能排列的宝箱、箱子和门",
    ["Reach level %d"] = "达到 %d 级",
    ["at %d, raises your cap to %d%s"] = "在 %d，把上限提升到 %d%s",
    ["Fish in %s"] = "在%s钓鱼",
    ["your pick"] = "你的选择",
    ["an hour: ~%d catches, %s each%s%s"] = "一小时：约 %d 次渔获，每个 %s%s%s",
    ["%d - %d, ~%d catches%s"] = "%d - %d，约 %d 次渔获%s",
    ["%s%s, %s%s%s%s%s%s"] = "%s%s，%s%s%s%s%s%s",
    ["%s, %s, disenchanted ~%s, sold %s%s"] = "%s，%s，分解约 %s，出售 %s%s",
    ["%s's %s - %s: ~%s disenchanted, %s sold%s%s"] = "%s，%s - %s：分解约 %s，出售 %s%s%s",
    ["buy %s, ~%s disenchanted, pays %d%% of the time%s"] = "购买 %s，分解约 %s，有 %d%% 的概率划算%s",
    ["%d - %d%s: %s"] = "%d - %d%s：%s",
    ["keep them"] = "留着它们",
    ["unconfirmed"] = "未确认",
    ["after %d%s, %sneeded for %s|r"] = "在 %d 之后%s，%s%s需要|r",
    ["%s%s, %smake one and keep it|r"] = "%s%s，%s做一个留着|r",
    ["%d favor"] = "%d 点恩惠",
    ["? favor"] = "? 点恩惠",
    ["Open your %s window once so Craft Ladder knows which recipes you have."] = "请打开一次你的%s窗口，让 Craft Ladder" ..
        " 知道你会哪些配方。",
    ["No %s found past %d with what Craft Ladder knows."] = "以 Craft Ladder 所知，%s 在 %d 之后就没有了。",
    ["zone"] = "区域",
    ["recipe"] = "配方",
    ["Back to your ladder"] = "返回你的阶梯",
    ["Merchant's Favor recipes (%d)"] = "商人恩惠配方（%d）",
    ["Dishes for this role, by what eating one raises. Click to fold or open."] = "适合该角色的菜肴，按食用后提升的属性排列。点击可折叠或" ..
        "展开。",
    ["Nothing here"] = "这里没有内容",
    ["Nothing earns this way at today's prices."] = "按今天的价格，这样没有任何收益。",
    ["Sell to a vendor"] = "卖给商人",
    ["These cost less to make than a vendor pays: vendors buy any number, no auction house needed. Click to" ..
        " fold or open."] = "这些的制作成本低于商人出价：商人收购任意数量，不需要拍卖行。点击可折叠或展开。",
    ["Sell at the auction house"] = "在拍卖行出售",
    ["These earn more at the auction house: 5 or more listed (or however few when you searched it yourself)," ..
        " and it pays 1.5 times what a vendor does. How many sell, the auction house doesn't say."] =
        "这些在拍卖行收益更高：在售 5 件或以上（若是你自己搜索的则不限数量），且价格是商人出价的 1.5 倍。能卖出多少，拍卖行不会告诉你。",
    ["nothing at today's prices"] = "按今天的价格没有收益",
    ["Disenchant, your whole account: %s"] = "分解，你的整个账号：%s",
    ["your Enchanting %d is the best of yours"] = "你的附魔 %d 是你最高的",
    ["%s has the most Enchanting, %d"] = "%s的附魔最高，%d",
    ["no character of yours has Enchanting yet"] = "你还没有角色学会附魔",
    ["the ladder from %d to %d"] = "从 %d 到 %d 的阶梯",
    ["the ladder to %d"] = "到 %d 的阶梯",
    ["%s%s %d / %d, %s%s"] = "%s%s %d / %d，%s%s",
    ["as of %s"] = "截至 %s",
    ["%s has no %s yet"] = "%s还没有%s",
    ["No %s yet"] = "还没有%s",
    ["Specialization"] = "专精",
    ["Skill %d"] = "技能 %d",
    ["No auction house prices: AuctionDB or Auctionator needed"] = "没有拍卖行价格：需要 AuctionDB 或 Auctionator",
    [" %s prices scanned %s, costs may be off: scan at the auction house|r"] = " %s 的价格扫描于 %s，成本可能不准：请到拍卖行扫描|r",
    ["%s prices scanned %s: scan at the auction house|r"] = "%s 的价格扫描于 %s：请到拍卖行扫描|r",
    ["Prices: %s, scanned %s (%s)|r"] = "价格：%s，扫描于 %s（%s）|r",
    ["today"] = "今天",
    ["yesterday"] = "昨天",
    ["%d days ago"] = "%d 天前",
    ["Prices: Auctionator, newest prices from %s|r"] = "价格：Auctionator，最新价格来自 %s|r",
    ["Prices: %s"] = "价格：%s",
    ["%d Merchant's Favor recipes, %d you can learn now%s"] = "%d 个商人恩惠配方，其中 %d 个你现在就能学%s",
    ["; you have %d favor"] = "；你有 %d 点恩惠",
    ["%d dishes for your class; the cost is one dish from bought ingredients"] = "适合你职业的 %d 道菜；成本按用购买的材料做一道菜计算",
    ["%d zones at skill %d; the best about %s an hour"] = "技能 %d 时有 %d 个区域；最好的约每小时 %s",
    ["Spend %s, catch about %s worth (%s, %s an hour)"] = "花费 %s，钓到价值约 %s 的渔获（%s，每小时 %s）",
    ["Spend %s, %s about %s worth (%s an hour), about %d %s"] = "花费 %s，%s价值约 %s（每小时 %s），约 %d %s",
    ["%s%d at the auction house; the best +%s a craft"] = "%s%d 件在拍卖行；最好的每次制作 +%s",
    ["Total %s, about %d %s%s"] = "总计 %s，约 %d %s%s",
    ["Total %s, about %d catches (%s)"] = "总计 %s，约 %d 次渔获（%s）",
    ["Spend %s, about %s back from sales, about %d crafts"] = "花费 %s，出售约可收回 %s，约 %d 次制作",
    ["Total %s, about %d crafts"] = "总计 %s，约 %d 次制作",
    ["Plan the ladder to %d."] = "规划到 %d 的阶梯。",
    ["Window size"] = "窗口大小",
    ["Drag: make the window bigger."] = "拖动：把窗口变大。",
    ["Ctrl + mouse wheel: bigger or smaller text (now %d%%)."] = "Ctrl + 滚轮：文字放大或缩小（现在 %d%%）。",
    ["Right-click: back to the normal size."] = "右键点击：恢复正常大小。",
    ["Close"] = "关闭",
    ["Escape closes it too."] = "按 Esc 也可关闭。",
    ["Settings"] = "设置",
    ["Which auction house addon the prices are read from, and which of its listed prices an ingredient costs."] =
        "价格读取自哪个拍卖行插件，以及材料按它的哪个在售价计算。",
    ["Your hands are idle, adventurer."] = "你的双手闲着呢，冒险者。",
    ["The trainers are waiting: learn a profession."] = "训练师们在等着：去学一门专业吧。",
    ["The steps to each of its specializations: the quests, what they ask for and what you have of it, the" ..
        " recipes, and what's still to make or buy."] = "通往它每个专精的步骤：任务、任务的要求和你已有的部分、配方，以及还需制作或购买的东西。",
    ["Merchant's Favor recipes"] = "商人恩惠配方",
    ["What the supply camps' quartermaster sells for Merchant's Favor: its price and level (seen at a" ..
        " quartermaster), your skill, what you know and can make."] = "补给营地的军需官用商人恩惠出售的东西：价格和等级（在军需官处见到的）、你的技能" ..
        "、你已学会和能制作的内容。",
    ["Back to cheapest"] = "回到最便宜的",
    ["Use the cheapest recipe for this step again."] = "重新为这一步选用最便宜的配方。",
    ["Search the auction house"] = "在拍卖行搜索",
    ["Auctionator's Shopping tab with this item. The auction house must be open."] = "Auctionator" ..
        " 的购物标签页，带上这件物品。拍卖行必须是打开的。",
    ["Also use recipes bought with Merchant's Favor."] = "也使用以商人恩惠购买的配方。",
    ["Reset"] = "重置",
    ["The ladder from your skill to 300 again."] = "重新规划从你的技能到 300 的阶梯。",
    ["No profession yet"] = "还没有专业",

    -- the menu's group headings
    ["PROFESSIONS"] = "专业",
    ["SECONDARY"] = "副专业",
    ["CLASS"] = "职业",

    -- the modes over the list, and what each one plans (the names the tooltips use)
    ["Vendor sales"] = "卖给商人",
    ["AH sales"] = "拍卖行出售",
    ["Food"] = "食物",
    ["Favor"] = "恩惠",
    ["done"] = "已完成",
    ["in your quest log"] = "在你的任务日志中",

    -- one option's tooltip and its row
    ["Click: put a map pin and the arrow on it."] = "点击：在地图上放置标记并指向它的箭头。",
    ["%s that give points"] = "能给技能点的%s",
    ["%s for this step"] = "这一步需要的%s",
    ["A %s is worth"] = "一个%s值",
    ["Gold an hour"] = "每小时金币",
    ["Click to %s here for this step."] = "点击：在这里为这一步%s。",
    ["Fish that land"] = "上钩的鱼",
    ["all of them"] = "全部",
    ["none needed"] = "不需要",
    ["A catch is worth"] = "一次渔获值",
    ["Lures for this step"] = "这一步的鱼饵",
    ["Click to fish here for this step."] = "点击：在这里为这一步钓鱼。",
    ["%s the %d you can make from what you have."] = "用你现有的材料%s %d 个。",
    ["Ingredients"] = "材料",
    ["Learn"] = "学习",
    ["Recipe"] = "配方",
    ["Selling them brings back"] = "卖掉它们可收回",
    ["Per skill point"] = "每点技能",
    ["Click to use this recipe for this step."] = "点击：为这一步使用该配方。",
    ["~%d %s, %s a %s"] = "约 %d %s，%s 每%s",
    ["%s at the trainer"] = "在训练师处 %s",
    ["no fish get away"] = "没有鱼脱钩",
    ["%d%% of casts land a fish"] = "%d%% 的抛竿能钓上鱼",
    [", with %s"] = "，使用%s",
    ["%s a catch%s"] = "每次渔获 %s%s",
    [", lures %s"] = "，鱼饵 %s",
    [" / catch"] = " / 次渔获",
    ["%s for lures"] = "鱼饵 %s",
    ["  with what you have"] = "  用你现有的材料",
    ["from your bags"] = "来自你的背包",
    ["bought at the auction house"] = "在拍卖行购买",
    ["learn: %s"] = "学习：%s",
    [" / point"] = " / 点",
    ["%s in all%s"] = "共 %s%s",
    [", %s back"] = "，收回 %s",
    [" / hour"] = " / 小时",

    -- a folded list, the ingredients, the colours
    ["all %d %s"] = "全部 %d %s",
    ["and %d more %s"] = "还有 %d %s",
    ["and %d more"] = "还有 %d 个",
    ["vendors"] = "商人",
    ["trainers"] = "训练师",
    [" (you have them)"] = "（你都有了）",
    ["  (you have %d%s)"] = "  （你有 %d%s）",
    [", in the bank"] = "，在银行",
    [", %d in the bank"] = "，%d 个在银行",
    ["smelt"] = "熔炼",
    ["%s %d yourself from %s%s"] = "自己%s %d 个，用%s%s",
    [", buy the other %d"] = "，另外 %d 个购买",
    ["you have enough"] = "你有足够的数量",
    ["only %d listed - you need %d"] = "只有 %d 件在售 - 你需要 %d",
    ["  your Cooking uses it"] = "  你的烹饪用得上",
    ["%d%% of catches%s"] = "%d%% 的渔获%s",
    [" each"] = " 每个",
    ["  creatures level %d+|r"] = "  生物等级 %d+|r",
    ["at the auction house, after its cut"] = "在拍卖行，扣除手续费后",
    ["at a vendor"] = "卖给商人",
    ["what's inside, on average"] = "里面的东西，平均值",
    ["orange"] = "橙色",
    ["yellow"] = "黄色",
    ["green"] = "绿色",
    ["grey"] = "灰色",
    ["from %d"] = "从 %d 起",
    ["Your pick."] = "你的选择。",

    -- the Craft bar
    ["An enchantment: enchant from the profession window, on the item."] = "这是附魔：请在专业窗口中对物品施放。",
    ["Learn the recipe first."] = "请先学会配方。",
    ["Not in combat."] = "不能在战斗中进行。",
    ["Not enough reagents in your bags."] = "背包里的材料不足。",
    ["Craft"] = "制作",
    ["Crafts as many as the box says; opens your profession window first if it's closed (the game crafts only" ..
        " with it open)."] = "按输入框中的数量制作；若专业窗口是关着的会先打开它（游戏只有在窗口打开时才能制作）。",
    [" Cooking needs a fire nearby."] = " 烹饪需要附近有火。",
    ["Your bags allow %d"] = "你的背包够做 %d 个",
    ["; the step needs %d."] = "；这一步需要 %d 个。",
    ["Opening your %s window: crafting once it's ready."] = "正在打开你的%s窗口：就绪后立即制作。",

    -- how to learn a recipe
    ["Learn it"] = "如何学习",
    ["Buy the recipe from %s:"] = "向%s购买配方：",
    ["one of these vendors"] = "这些商人之一",
    ["this vendor"] = "这个商人",
    ["%s Favor"] = "%s恩惠",
    ["Merchant's"] = "商人",
    ["Quest reward: %s%s"] = "任务奖励：%s%s",
    ["(needs level %d)"] = "（需要 %d 级）",
    ["quest giver"] = "任务发布者",
    ["Only these trainers teach it, for %s:"] = "只有这些训练师教授，费用 %s：",
    ["trainer"] = "训练师",
    ["None of them is of your faction."] = "他们都不属于你的阵营。",
    ["Or buy it at the auction house: %s."] = "或者在拍卖行购买：%s。",
    ["Or %s."] = "或者%s。",
    ["During %s: %s."] = "在%s期间：%s。",
    ["The price is an estimate: Craft Ladder learns the real one when you visit the %s."] =
        "价格为估算值：你去过一次后 Craft Ladder 就会知道真实价格（%s）。",
    ["vendor"] = "商人",

    -- what it sells for, and one craft
    ["An enchantment: nothing to sell."] = "这是附魔：没有可卖的东西。",
    ["%s%s at the auction house (after its cut%s)."] = "%s%s在拍卖行（扣除手续费后%s）。",
    ["Not on the auction house."] = "拍卖行上没有。",
    ["%s%s at a vendor."] = "%s%s卖给商人。",
    ["Vendors don't buy it."] = "商人不收购它。",
    ["One craft%s: %s"] = "一次制作%s：%s",
    ["One craft: %s"] = "一次制作：%s",
    [" (makes %d)"] = "（产出 %d 个）",
    ["auction house"] = "拍卖行",
    ["%s yourself%s"] = "自己%s%s",
    [" and %s"] = " 和 %s",
    ["%s each, %s"] = "每个 %s，%s",
    ["Each sells for "] = "每个售价",
    ["Sells for "] = "售价",
    ["%d sell for "] = "%d 个售价",

    -- a Merchant's Favor recipe
    ["You know it."] = "你已学会它。",
    ["You can learn it now."] = "你现在就能学它。",
    ["It needs %d %s (you: %d)."] = "需要 %d %s（你：%d）。",
    ["It needs level %d (you: %d)."] = "需要 %d 级（你：%d）。",
    ["Merchant's Favor"] = "商人恩惠",
    ["Costs %d Merchant's Favor%s."] = "需要 %d 点商人恩惠%s。",
    [" (you have %d)"] = "（你有 %d）",
    ["Its price: open a quartermaster once and Craft Ladder remembers it."] = "它的价格：去军需官处看一次，Craft Ladder" ..
        " 就会记住。",
    ["From level %d (you: %d)."] = "从 %d 级起（你：%d）。",
    ["Its level: open a quartermaster once and Craft Ladder remembers it."] = "它的等级：去军需官处看一次，Craft Ladder" ..
        " 就会记住。",
    ["From %d %s (you: %d)."] = "从 %d %s起（你：%d）。",
    ["%s is %s from level %d (you: %d)."] = "%s%s，从 %d 级起（你：%d）。",
    ["worn"] = "可穿戴",
    ["used"] = "可使用",
    ["Quartermaster"] = "军需官",
    ["The plan needs %s with %s."] = "该计划需要声望 %s（%s）。",
    ["Only for %s."] = "仅限%s。",
    ["Hated"] = "仇恨",
    ["Hostile"] = "敌对",
    ["Unfriendly"] = "冷淡",
    ["Neutral"] = "中立",
    ["Friendly"] = "友善",
    ["Honored"] = "尊敬",
    ["Revered"] = "崇敬",
    ["Exalted"] = "崇拜",

    -- a crafting step
    ["Skill %d - %d, about %d crafts, %s%s"] = "技能 %d - %d，约 %d 次制作，%s%s",
    ["some prices missing"] = "缺少部分价格",
    ["%s %s what you already have: %d crafts%s."] = "%s用你已有的材料%s：%d 次制作%s。",
    [", plus a few vendor ingredients"] = "，外加少量商人材料",
    [", nothing to buy"] = "，无需购买",
    ["You can %s %d now with what you have."] = "%s：现在用你有的材料可做 %d 个。",
    ["You have the reagents for %d."] = "你的材料够做 %d 个。",
    ["You have the main ingredients for %d; the rest is sold by vendors."] = "你有做 %d 个所需的主要材料；其余的由商人出售。",
    ["The cheapest here is %s."] = "这里最便宜的是%s。",
    ["Needed for %s: %d recipes (%s, ...), and no vendor sells it. None of them is for leveling (a cooldown," ..
        " or learned at 300): make it once you're done."] = "%s需要它：%d 个配方（%s 等），而且没有商人出售。它们都不适合升级（有冷却，或在 300" ..
        " 才学）：等你练完再做。",
    ["A tool: %d %s recipes need it, and no vendor sells it. Make one and keep it in your bags%s."] =
        "一件工具：有 %d 个%s配方需要它，而且没有商人出售。做一个放在背包里%s。",
    [" (it gives no skill point any more)"] = "（它不再提供技能点）",
    ["You have %s: the step takes them from your bags, so it pays less than that."] =
        "你有 %s：这一步会从你的背包中取用，所以实际花费更少。",
    ["Keep for later"] = "留着备用",
    ["Keep %d %s: the steps at %d - %d use them."] = "留下 %d 个%s：%d - %d 的步骤要用。",
    ["Batch: %s"] = "一批：%s",
    ["Craft counts are estimates: skill-ups are luck once a recipe is yellow."] = "制作次数为估算值：配方变黄之后技能点就要看运气了。",
    ["Sell the rest"] = "卖掉剩下的",
    ["Sell what you make"] = "卖掉你做出来的东西",
    ["%d at the auction house, about %s each after its cut."] = "%d 个在拍卖行，扣除手续费后每个约 %s。",
    ["%d to a vendor, %s each."] = "%d 个卖给商人，每个 %s。",
    ["About %s back, so this step %s %s."] = "约可收回 %s，所以这一步%s %s。",
    ["earns"] = "赚",
    ["costs"] = "花费",
    ["Vendor sales counts only what vendors pay: that money is sure. AH sales counts the auction house too."] =
        "“卖给商人”只计算商人支付的金额：这笔钱是稳的。“拍卖行出售”也会计入拍卖行。",
    ["The auction house counts only when it pays 1.5 times a vendor and 5 or more are listed, and for at most" ..
        " a quarter of what's listed."] = "只有当拍卖行的价格是商人出价的 1.5 倍且在售 5 件或以上时才计入，并且最多只计在售数量的四分之一。",
    ["Or %s, from %d"] = "或者%s，从 %d 起",
    ["Recipes you could use from %d"] = "从 %d 起可用的配方",
    ["No other recipe is open to you here."] = "这里没有其他配方对你开放。",

    -- Gold: one recipe's profit
    ["One craft%s costs about %s and sells for about %s: %s+%s|r"] = "一次制作%s约花费 %s，售价约 %s：%s+%s|r",
    ["Sold to a vendor: vendors buy any number."] = "卖给商人：商人收购任意数量。",
    ["%d listed at the auction house now: sell a few at a time."] = "目前拍卖行上有 %d 件在售：每次卖几个。",
    ["Making it needs %s %d, and yours is %d%s. It's here to level towards."] = "制作它需要%s %d，而你是" ..
        " %d%s。它放在这里是作为目标。",
    ["; the rank that lifts your cap to it asks level %d, and you're %d"] = "；把上限提升到那里的等级需要 %d 级，而你是 %d 级",
    ["Learning it pays back after %d %s."] = "学会它在 %d 次%s后回本。",
    ["craft"] = "次制作",
    ["crafts"] = "次制作",
    ["Once in %s: the recipe has a cooldown."] = "每 %s 一次：该配方有冷却时间。",
    ["You have %s: counted at their price too, since you could sell them."] = "你有 %s：它们也按价格计入，因为你本可以卖掉。",
    ["Profit: what a vendor pays, less the ingredients at today's prices. How many you can make, the auction" ..
        " house's ingredients decide."] = "利润：商人支付的金额，减去按今天价格计算的材料成本。能做多少个，由拍卖行的材料决定。",
    ["Profit: at the lowest listing after the auction house's cut, with 5 or more listed, or however few when" ..
        " you searched it yourself; it counts only when it pays 1.5 times what a vendor does. How many sell," ..
        " the auction house doesn't say. Prices change: look again before buying."] =
        "利润：按扣除拍卖行手续费后的最低在售价计算，需在售 5 件或以上，若是你自己搜索的则不限数量；只有当价格是商人出价的 1.5 倍时才计入。能卖出多少，拍卖行不会告诉你。价格会变动：购买前请再看一次。",

    -- Disenchant
    ["Disenchant one: about %s"] = "分解一个：约 %s",
    ["%d%% of disenchants, %s each"] = "%d%% 的分解结果，每个 %s",
    ["%s%d disenchanted: about %s, at least %s 9 times out of 10."] = "%s分解 %d 个：约 %s，十次里至少有九次不低于 %s。",
    ["Your "] = "你的",
    ["What it gives: from your %d disenchants of this item, recorded in game: it breaks unlike items of its" ..
        " kind."] = "它会给出什么：根据你在游戏中记录的 %d 次对该物品的分解：它的分解结果与同类物品不同。",
    ["What it gives: from %d disenchants of items like it, recorded in game."] = "它会给出什么：根据游戏中记录的 %d 次同类物品分解。",
    ["You've disenchanted %d like it: %s in all. From %d, what you got replaces the table."] =
        "你已分解过 %d 件同类物品：共 %s。达到 %d 次后，你的结果将取代该表。",
    ["Forever added this kind of item: what it gives is a guess, checked for one item: a green's of its level," ..
        " one more of each."] = "Forever 新增了这类物品：它的分解结果是推测值，只在一件物品上验证过：与同等级绿装相同，每种多一个。",
    ["What a disenchant gives is luck%s. Materials at the auction house after its cut; 3 lesser essences make" ..
        " a greater one."] = "分解能得到什么全看运气%s。材料按拍卖行扣除手续费后计算；3 个小魔棒可合成 1 个大的。",
    [", from Classic's table (not checked in Forever yet): from %d of your disenchants of items like it, what" ..
        " you got replaces it"] = "，来自 Classic 的表格（尚未在 Forever 中验证）：当你对同类物品的分解达到 %d 次后，你的结果将取代它",
    ["One craft%s costs about %s; disenchanted, about %s on average: %s"] = "一次制作%s约花费 %s；分解后平均约 %s：%s",
    ["Disenchanting it needs Enchanting %d; the best of yours is %d."] = "分解它需要附魔 %d；你最高的是 %d。",
    ["A %s recipe %s knows."] = "%s的配方，%s会做。",
    ["you"] = "你",
    ["Making it costs more than disenchanting brings: disenchant it when you make it anyway, for skill."] =
        "制作成本高于分解所得：当你本来就要为技能而制作时再分解它。",
    ["Best: %s. %d in %s's %s: disenchanted, about %s on average; sold, %s."] = "最佳：%s。%d 个在%s的%s里：分解后平均约" ..
        " %s；出售则为 %s。",
    ["your"] = "你的",
    ["bags"] = "背包",
    ["Soulbound: no auction house."] = "灵魂绑定：不能上拍卖行。",
    ["%s has the most Enchanting of yours, %d: mail it there."] = "%s的附魔在你的角色中最高，%d：把它邮寄过去。",
    ["Or sell it"] = "或者卖掉它",
    ["Soulbound: the auction house won't take it."] = "灵魂绑定：拍卖行不会收。",
    ["%s each at the auction house (after its cut%s)."] = "每个 %s 在拍卖行（扣除手续费后%s）。",
    ["%s each at a vendor."] = "每个 %s 卖给商人。",
    ["The auction house counts with 5 or more listed, or however few when you searched it yourself. What made" ..
        " it doesn't count: it's made."] = "拍卖行需在售 5 件或以上才计入，若是你自己搜索的则不限数量。它由什么做成并不计入：它已经做好了。",
    ["Buy one for %s; disenchanted, about %s on average: %s"] = "以 %s 购买一个；分解后平均约 %s：%s",
    ["Disenchanting it needs Enchanting %d; the best of yours is %d: no character of yours can.|r"] =
        "分解它需要附魔 %d；你最高的是 %d：你没有角色能做到。|r",
    ["One disenchant brings more than it cost %d%% of the time."] = "一次分解有 %d%% 的概率收回成本还有盈余。",
    ["Buy it"] = "购买它",
    ["The cheapest listing: %s. %s."] = "最低在售价：%s。%s。",
    ["Its level and quality are Classic's: Forever's client doesn't list it. "] = "它的等级和品质来自 Classic：Forever" ..
        " 的客户端没有列出。",
    ["A random suffix (\"of the Monkey\") doesn't change what it breaks into. The listing may have sold since" ..
        " the scan."] = "随机后缀（“猴子的”）不会改变它的分解结果。该商品可能在扫描后已被买走。",
    ["Nothing to disenchant"] = "没有可分解的东西",
    ["No character of yours holds anything to disenchant, and "] = "你没有任何角色持有可分解的物品，而且",
    ["none of the recipes they know makes something to disenchant: open a crafting profession's window once so" ..
        " Craft Ladder knows its recipes."] = "他们所知的配方都做不出可分解的东西：请打开一次某个制造专业的窗口，让 Craft Ladder 知道它的配方。",
    ["nothing they can make is worth more disenchanted than sold at today's prices."] =
        "按今天的价格，他们能做的东西分解都不比卖掉更值钱。",

    -- Cooking's Food
    [" (Well Fed). "] = "（饱食）。",
    ["Needs level %d; you're %d."] = "需要 %d 级；你是 %d 级。",
    ["Level %d: you can eat it."] = "%d 级：你可以食用。",
    ["Any level can eat it."] = "任何等级都能食用。",
    ["Nobody sells its recipe now: look for it at the auction house."] = "目前无人出售它的配方：到拍卖行找找看。",
    ["No way to learn it for you now (a holiday's, or the other side's)."] = "你现在无法学会它（节日配方，或属于对方阵营）。",
    ["Learned at %s %d; you have %d."] = "在%s %d 学会；你有 %d。",
    ["You have %s: cooking it takes them from your bags, so it costs you less than that."] =
        "你有 %s：烹饪会从你的背包中取用，所以花费更少。",
    ["Or buy it"] = "或者购买",
    ["One at the auction house: %s."] = "拍卖行上有一个：%s。",
    ["None listed at the auction house now."] = "目前拍卖行上没有在售的。",
    ["What it raises is read from the game's files, not checked in game yet."] = "它提升的属性读取自游戏文件，尚未在游戏中验证。",

    -- a rank step
    ["At skill %d. Your cap is your level x 5: %d at level %d."] = "技能 %d 时。你的上限是等级 x 5：%d 级时为 %d。",
    ["You're level %d."] = "你是 %d 级。",
    ["Your level allows it already."] = "你的等级已经允许了。",
    ["Lockpicking can't go past your level x 5: level up before you go on."] = "开锁不能超过你的等级 x 5：先升级再继续。",
    ["Learn %s%s"] = "学习%s%s",
    ["At skill %d, raises your cap to %d. %s"] = "技能 %d 时，把上限提升到 %d。%s",
    ["Needs character level %d."] = "需要角色等级 %d。",
    ["How"] = "方法",
    ["Only these trainers teach it%s:"] = "只有这些训练师教授%s：",
    [", for %s"] = "，费用 %s",
    ["Any %s trainer teaches it%s."] = "任何%s训练师都教授%s。",
    [" for %s"] = " 费用 %s",
    ["Buy the %s and read it:"] = "购买%s并阅读：",
    ["At the auction house: %s."] = "在拍卖行：%s。",
    ["Or buy it at the auction house: %s.%s"] = "或者在拍卖行购买：%s。%s",
    [" Cheaper than the vendor, so the ladder counts this one."] = " 比商人便宜，所以阶梯按这个计算。",
    ["1. Take the quest %s:"] = "1. 接取任务%s：",
    ["start"] = "起点",
    ["2. Bring the ingredients below to %s for %s:"] = "2. 把下面的材料带给%s，换取%s：",
    ["hand in"] = "交付",
    ["Do the quest %s for %s:"] = "完成任务%s，交给%s：",
    ["What to bring"] = "要带的东西",
    ["Any %s trainer teaches Apprentice %s."] = "任何%s训练师都教授学徒级%s。",

    -- fishing
    ["Fish to catch"] = "要钓的鱼",
    ["%s: %s, %s (fish bite from %d)"] = "%s：%s，%s（从 %d 起上钩）",
    ["seen by GatherMate2"] = "由 GatherMate2 发现",
    ["place known"] = "已知地点",
    ["places known"] = "已知地点",
    [" a catch"] = " 每次渔获",
    ["%d - %d catches before it's gone"] = "%d - %d 次渔获后消失",
    ["No fish get away here."] = "这里没有鱼脱钩。",
    ["About %d%% of casts land a fish here."] = "这里约 %d%% 的抛竿能钓上鱼。",
    ["An hour at skill %d: about %d catches, %s each"] = "技能 %d 时一小时：约 %d 次渔获，每个 %s",
    [" An hour's catches are worth about %s%s."] = " 一小时的渔获价值约 %s%s。",
    [", lures paid"] = "，鱼饵已计入",
    ["Skill %d - %d, about %d catches (%s), %s"] = "技能 %d - %d，约 %d 次渔获（%s），%s",
    [" Catches worth about %s (%s an hour)."] = " 渔获价值约 %s（每小时 %s）。",
    ["Craft Ladder's choice here is %s."] = "Craft Ladder 在这里的选择是%s。",
    ["Its creatures are level %d - %d."] = "这里的生物是 %d - %d 级。",
    ["Bring"] = "携带",
    ["Put %s on your pole: +%d fishing for %d minutes, so no fish get away."] = "把%s装在鱼竿上：钓鱼 +%d，持续 %d" ..
        " 分钟，这样鱼就不会脱钩。",
    ["Fishing supplies vendors sell lures, in every capital."] = "各大主城的渔具商人都出售鱼饵。",
    ["No lure needed: your skill keeps the fish from getting away."] = "不需要鱼饵：你的技能已经足以让鱼不脱钩。",
    ["What you catch here"] = "你在这里能钓到什么",
    ["Fishing pools here"] = "这里的鱼群",
    ["Fish pools when you see them: Craft Ladder counts a third of your catches here from pools. That makes a" ..
        " catch worth %s on average (%s in open water)."] = "看到鱼群就去钓：Craft Ladder 按这里三分之一的渔获来自鱼群计算。这样一次渔获平均值" ..
        " %s（在开阔水域为 %s）。",
    ["No fishing pools known here yet. GatherMate2 adds the ones you fish, and Craft Ladder counts them."] =
        "这里还没有已知的鱼群。GatherMate2 会记录你钓过的鱼群，Craft Ladder 会把它们计入。",
    ["Catches per point: from your %d catches, skill-ups come %d%% as often as Classic's rule says."] =
        "每点技能的渔获次数：根据你的 %d 次渔获，技能点出现的频率是 Classic 规则的 %d%%。",
    ["Catches per point follow Classic's rule (at 150, one point in about 4 catches) until Craft Ladder has" ..
        " counted 50 of your catches (%d so far)."] = "每点技能的渔获次数遵循 Classic 的规则（150 时约 4 次渔获 1 点），直到 Craft" ..
        " Ladder 统计满 50 次你的渔获为止（目前 %d 次）。",
    ["Zones and their fish come from Classic's world: Forever may differ."] = "区域及其鱼类来自 Classic 的世界：Forever" ..
        " 可能不同。",
    ["Other zones from %d"] = "从 %d 起的其他区域",
    ["No other zone is open to you here."] = "这里没有其他区域对你开放。",

    -- skinning and mining
    ["about %d in the zone, %s %s each%s"] = "该区域约 %d 个，每个 %s %s%s",
    [", worth %s"] = "，价值 %s",
    ["needs %d"] = "需要 %d",
    ["%s  %slevel %d%s|r"] = "%s  %s%d 级%s|r",
    [", seen skinned"] = "，已剥过皮",
    ["about %d in the zone, needs %d%s"] = "该区域约 %d 个，需要 %d%s",
    [", %s a skin"] = "，每张皮 %s",
    ["Skin in %s"] = "在%s剥皮",
    ["An hour at skill %d: about %d creatures, %s each"] = "技能 %d 时一小时：约 %d 只生物，每只 %s",
    ["An hour's skins are worth about %s. Every creature you can skin counts, grey ones too."] =
        "一小时的皮革价值约 %s。你能剥皮的每只生物都计入，灰色的也算。",
    ["Skill %d - %d, about %d creatures%s"] = "技能 %d - %d，约 %d 只生物%s",
    [", trainer %s"] = "，训练师 %s",
    ["Worth about %s skinned (%s an hour)."] = "剥皮价值约 %s（每小时 %s）。",
    ["Skin every creature that still gives a point, of your level or below."] = "剥下每一只仍能给技能点、等级不高于你的生物的皮。",
    ["Its creatures are well above your level."] = "这里的生物远高于你的等级。",
    ["Creatures to skin here"] = "这里可剥皮的生物",
    ["Which creatures can be skinned and what one gives come from Classic; where they are and their levels" ..
        " from QuestieDB's Forever data. The skill one needs is Classic's rule from its level (level x 5 past" ..
        " 20), the colours Mining's (yellow 25, green 50, grey 100 above it). A creature new in Forever counts" ..
        " once you've skinned one."] = "哪些生物可以剥皮以及一只能给什么来自 Classic；它们在哪里、等级多少来自 QuestieDB 的 Forever 数据。所需技能按" ..
        " Classic 规则从等级推算（20 级以上为等级 x 5），颜色沿用采矿的规则（黄 25、绿 50、灰 100）。Forever 中新增的生物在你剥过一只后才会计入。",
    ["Gold an hour assumes %d s a creature (kill, loot, skin) and a 60%% mount between them: about %d an hour" ..
        " here."] = "每小时金币按每只生物 %d 秒（击杀、拾取、剥皮）和中间 60%% 坐骑计算：这里约每小时 %d 只。",
    ["Other zones, from %d"] = "从 %d 起的其他区域",
    ["%s in %s"] = "%s：%s",
    ["An hour at skill %d: about %d %s, %s each"] = "技能 %d 时一小时：约 %d %s，每个 %s",
    ["An hour's worth about %s. Every %s you can reach counts, grey ones too. Creatures level %d - %d."] =
        "一小时价值约 %s。你够得着的每个%s都计入，灰色的也算。生物等级 %d - %d。",
    ["Skill %d - %d, about %d %s%s"] = "技能 %d - %d，约 %d %s%s",
    ["Worth about %s (%s an hour). Creatures level %d - %d."] = "价值约 %s（每小时 %s）。生物等级 %d - %d。",
    ["Creatures level %d - %d. %s every %s that still gives a point."] = "生物等级 %d - %d。%s每一个仍能给技能点的%s。",
    ["%s places come from GatherMate2's Forever data; what one gives and how often a rarer kind takes a place," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what one" ..
        " needs): Forever may differ."] = "%s的位置来自 GatherMate2 的 Forever 数据；一个能给多少以及更稀有的种类多久占据一个位置来自" ..
        " Classic。技能点遵循 Classic 的颜色（黄 25、绿 50、灰 100）：Forever 可能不同。",
    ["Gold an hour assumes 15 s a %s, a third of the zone's places with one up and a 60%% mount: about %d an" ..
        " hour here."] = "每小时金币按每个%s 15 秒、区域三分之一的位置有产出以及 60%% 坐骑计算：这里约每小时 %d 个。",
    ["%s: about %d bars%s"] = "%s：约 %d 个锭%s",
    [", learn it from a Mining trainer for %s"] = "，向采矿训练师学习，费用 %s",
    ["Nothing you mine here still gives points when smelted."] = "你在这里采到的东西熔炼后都不再给技能点了。",
    ["Sell ore or bars"] = "出售矿石或锭",
    ["%s: %s each. Smelting it needs more skill."] = "%s：每个 %s。熔炼它需要更高的技能。",
    ["sell the ore, smelt it only for the skill-ups"] = "卖矿石，只为技能点而熔炼",
    ["smelt it and sell the bars"] = "熔炼后卖锭",
    [", %s as %s"] = "，%s 作为%s",
    ["make %s and sell it"] = "制作%s再卖掉",
    ["%s: %s as ore, %s as %s%s - %s."] = "%s：作为矿石 %s，作为%s %s%s - %s。",
    ["%s: %s make %d %s, so per ore it's worth one of them; it takes both ores, as much as the scarcer one" ..
        " allows."] = "%s：%s 可做 %d 个%s，所以按矿石算它相当于其中一个；它需要两种矿石，以较稀缺的那种为限。",
    ["Nothing mined here can be smelted."] = "这里采到的东西都不能熔炼。",
    ["Per ore, after the auction house's cut (only what's listed at least 5 times), or what a vendor pays."] =
        "按每块矿石计算，扣除拍卖行手续费（仅计在售至少 5 件的），或按商人出价计算。",
    ["Smelting gives skill-ups too: Craft Ladder counts the ore you mine as smelted, so you mine fewer nodes."] =
        "熔炼也给技能点：Craft Ladder 把你采到的矿石按已熔炼计算，所以你要采的矿脉更少。",
    ["Node places come from GatherMate2's Forever data; how often rare veins appear and the ore a node gives," ..
        " from Classic. Skill-ups follow Classic's colours (yellow 25, green 50, grey 100 above what a node" ..
        " needs): Forever may differ."] = "矿脉位置来自 GatherMate2 的 Forever 数据；稀有矿脉出现的频率和一个矿脉产出多少矿石来自" ..
        " Classic。技能点遵循 Classic 的颜色（黄 25、绿 50、灰 100）：Forever 可能不同。",
    ["Gold an hour assumes 15 s a node, a third of the zone's node places with a node up and a 60%% mount:" ..
        " about %d nodes an hour here."] = "每小时金币按每个矿脉 15 秒、区域三分之一的位置有矿以及 60%% 坐骑计算：这里约每小时 %d 个矿脉。",
    ["Other zones, or smelting, from %d"] = "从 %d 起的其他区域或熔炼",

    -- Lockpicking
    ["%d a run, needs %d"] = "每轮 %d 个，需要 %d",
    ["about %d in the zone, needs %d"] = "该区域约 %d 个，需要 %d",
    ["Humanoids drop it; the auction house sells it."] = "由人型生物掉落；拍卖行有售。",
    ["Fished up from pools."] = "从鱼群中钓起。",
    ["Engineers make it."] = "由工程师制作。",
    ["Pick Pocket humanoids of level %d - %d."] = "偷取 %d - %d 级人型生物。",
    ["Pick Pocket humanoids."] = "偷取人型生物。",
    ["Pick locks in %s"] = "在%s开锁",
    ["Skill %d - %d, about %d locks"] = "技能 %d - %d，约 %d 把锁",
    ["Creatures level %d - %d. Pick every lock that still gives a point: a chest gives one chance, and one" ..
        " more once it's back."] = "生物等级 %d - %d。开每一把仍能给技能点的锁：一个宝箱给一次机会，刷新后再给一次。",
    ["The door round"] = "开门路线",
    ["1. Go into Blackrock Depths (Blackrock Mountain, between Searing Gorge and Burning Steppes)."] =
        "1. 进入黑石深渊（黑石山，位于灼热峡谷和燃烧平原之间）。",
    ["2. Pick the locked doors on the way: the first on the left, through it the next on the right, then the" ..
        " first on the left again; the Shadowforge Lock under the big gear too, if nothing would pull."] =
        "2. 沿途开锁：第一扇在左边，穿过它后下一扇在右边，然后再回到左边第一扇；如果不会拉怪，大齿轮下的黑铁之锁也开。",
    ["3. Leave, right-click your portrait, Reset all instances and go in again: the game lets you in 5 times" ..
        " an hour."] = "3. 出来，右键点击你的头像，重置所有副本，再进去：游戏允许每小时进入 5 次。",
    ["The round is zockify's Forever guide's: about 4 doors a run."] = "这条路线来自 zockify 的 Forever 攻略：每轮约 4 扇门。",
    ["Where"] = "位置",
    ["Most %ss are around here"] = "大多数%s在这附近",
    ["Chest places: GatherMate2's and QuestieDB's Forever data. Which lock a chest needs, and the colours" ..
        " (yellow 25, green 50, grey 100 above it), are Classic's: Forever may differ."] =
        "宝箱位置：GatherMate2 和 QuestieDB 的 Forever 数据。宝箱需要哪种锁，以及颜色（黄 25、绿 50、灰 100），来自 Classic：Forever 可能不同。",
    ["Other zones, or boxes, from %d"] = "从 %d 起的其他区域或箱子",
    ["Pick %s"] = "开%s",
    ["Skill %d - %d, about %d boxes, %s"] = "技能 %d - %d，约 %d 个箱子，%s",
    ["Pick the ones in your bags: you have %d."] = "开你背包里的：你有 %d 个。",
    ["Boxes to buy: %s"] = "要购买的箱子：%s",
    ["A box gives one chance at a point, and what's inside is yours."] = "一个箱子给一次获得技能点的机会，里面的东西归你。",
    ["Or pick locks in a zone, from %d"] = "或者在某个区域开锁，从 %d 起",
    ["Every lock a rogue picks, by the skill it needs; its colour at your %d."] = "盗贼能开的每一把锁，按所需技能排列；以你的 %d" ..
        " 显示颜色。",
    ["Orange always gives a point, yellow mostly, green sometimes, grey never."] = "橙色必给一点，黄色多半会给，绿色偶尔给，灰色永远不给" ..
        "。",
    ["Chests in the world"] = "世界中的宝箱",
    ["Boxes from your bags"] = "你背包里的箱子",
    ["You have %d."] = "你有 %d 个。",
    [" %s at the auction house."] = " 拍卖行 %s。",
    ["Dungeon doors"] = "地下城的门",
    ["%s: %d locked doors, from %d (%s)."] = "%s：%d 扇上锁的门，从 %d 起（%s）。",
    ["Getting started"] = "如何开始",
    ["Pick Lock: any rogue trainer, from level 16, for %s. It needs Thieves' Tools in your bags (rogue" ..
        " supplies vendors, 15s). Your cap is your level x 5."] = "开锁：任何盗贼训练师，16 级起，费用 %s。背包里需要有盗贼工具（盗贼用品商人，15" ..
        " 银）。你的上限是等级 x 5。",

    -- the cards with nothing to show, and the rest
    ["Nothing earns now"] = "目前没有收益",
    ["Nothing you can make sells for more than it costs at today's prices."] = "按今天的价格，你能做的东西没有一样卖得比成本高。",
    ["Nothing you can get here has a price yet: Craft Ladder needs auction house prices."] =
        "你在这里得到的东西还没有价格：Craft Ladder 需要拍卖行价格。",
    ["Nothing to do here"] = "这里没什么可做的",
    ["You've reached %d %s."] = "你已达到 %d 点%s。",
    ["No recipe found for your skill."] = "没有找到适合你技能的配方。",
    [", Working Overtime %d/5: +%d%%"] = "，加班 %d/5：+%d%%",

    -- what the data itself says on a rank card (Professions.lua, Data/*.lua)
    ["Your class quests at 16"] = "你 16 级的职业任务",
    ["They lead to the first practice chests and give you Thieves' Tools. Pick Lock itself is learned from any" ..
        " rogue trainer, quest or not."] = "它们会带你找到最初的练习宝箱，并给你盗贼工具。开锁本身可以向任何盗贼训练师学习，做不做任务都行。",
    ["Your class quests at 20"] = "你 20 级的职业任务",
    ["The last one teaches Poisons (and Recipe: Thistle Tea). On the way you pick a lock: Lockpicking 70 for" ..
        " the Alliance's Duskwood Chest, 80 for the Horde's Gallywix's Lockbox (Classic's numbers, not" ..
        " confirmed in Forever)."] = "最后一个教授毒药（以及配方：蓟茶）。途中你要开一把锁：联盟是暮色森林宝箱需要开锁 70，部落是加里维克斯的保险箱需要 80（Classic" ..
        " 的数值，Forever 未确认）。",
    ["Bring 12 Giant Egg, 10 Zesty Clam Meat and 20 Alterac Swiss to Dirge Quikcleave in Gadgetzan."] =
        "把 12 个巨蛋、10 块美味蚌肉和 20 块阿尔特拉克瑞士奶酪带给加基森的迪尔格·奎克里弗。",
    ["Catch the four fish below and bring them to Nat Pagle; he then teaches Artisan Fishing for 1g."] =
        "钓到下面四种鱼并交给纳特·帕格；他随后会以 1 金教授专家级钓鱼。",
    ["Hank the Hammer's (Alliance) or Aturk the Anvil's (Horde) quests lead to Galvan the Ancient and Trenton" ..
        " Lighthammer, whose quests teach the Ornate Mithril recipes the last quest asks for. Buy those 7" ..
        " items at the auction house and you can skip them."] = "汉克·锤子（联盟）或阿图克·铁砧（部落）的任务会引向远古的加尔文和特伦顿·轻锤，他们的任务" ..
        "教授最后一个任务所需的华丽秘银配方。在拍卖行买下那 7 件物品就可以跳过它们。",
    ["It gives you a letter to hand in."] = "它会给你一封要交付的信。",
    ["Right-click the pledge it gives you: that completes it."] = "右键点击它给你的誓言：这样就完成了。",
    ["Save 15 wounded soldiers with the Triage Bandages the doctor gives you, before 6 of them die."] =
        "在 6 名伤兵死去之前，用医生给你的急救绷带救活 15 名伤兵。",
    ["Then learn the mastery from the trainer who gave you the quest."] = "然后向发布该任务的训练师学习精通。",
}
