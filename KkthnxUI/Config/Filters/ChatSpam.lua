﻿local K, C, L, _ = select(2, ...):unpack()
if C.Chat.Enable ~= true or C.Chat.Spam ~= true then return end

K.ChatSpamList = {
	"$%d+.+%d+g",
	"%.c0m%f[%A]",
	"%S+#%d+",
	"%[dirge%]",
	"%d%s?eur%f[%A]",
	"%d%s?usd%f[%A]",
	"%d+e.?u.?r.+%d+g",
	"%d+g.+$%d+",
	"%d+g.+%d+e.?u.?r",
	"%d+g.+\194\163%d+",
	"%d+g.+\226\130\172%d+",
	"%d+g.+e.?u.?r%d+",
	"%d/%d cm gold",
	"%f[%a]arena",
	"%f[%a]cap%f[%A]",
	"%f[%a]carry%f[%A]",
	"%f[%a]cr%f[%A]",
	"%f[%a]ebay",
	"%f[%d][235]s%f[%A]",
	"[235]v[235]",
	"\194\163%d+.+%d+g",
	"\226\130\172%d+.+%d+g",
	"a?m[eu]rican?",
	"account",
	"account.?share", "accshare",
	"an[au][ls]e?r?%f[%L]",
	"anal",
	"argument",
	"aussie",
	"australi",
	"bacon",
	"bewbs",
	"bitch",
	"boobs",
	"boost",
	"christian",
	"chuck ?norris",
	"conqu?e?s?t? cap",
	"conqu?e?s?t? points",
	"cs[:;]go%f[%A]",
	"delivery",
	"diablo",
	"elite gear",
	"for %ds",
	"g0ld",
	"game ?time",
	"girl",
	"hippogryph hatchling",
	"kiss",
	"lf %ds",
	"loot.*team.*leprest[o0]re",
	"lootcloud.*paypal",
	"low mmr",
	"mad ?bro",
	"mottled drake",
	"mudda",
	"muslim",
	"mythic.*price.*perfectway[%.,]one",
	"mythicstore[%.,]com.*skype",
	"name change",
	"nigg[ae]r?",
	"obama",
	"partner",
	"paypal",
	"paypal.*ok4gold.*skype",
	"points cap",
	"preorder.*leprest[o0]re",
	"professional",
	"punktecap",
	"pussy",
	"pvp ?mate",
	"qq",
	"qq%d+",
	"ranking",
	"rating",
	"rbg",
	"realm",
	"rocket chicken",
	"s%A*k%A*y%A*p%Ae",
	"s.?k.?p.?y.?e?",
	"season",
	"self ?play",
	"server",
	"sexy",
	"share",
	"shut ?up",
	"tits",
	"transfer",
	"twitch%.tv",
	"webcam",
	"weekly cap",
	"wins? mount",
	"wow gold",
	"wts%d+kfor%d+euro",
	"wts.*boost.*amazingprice.*gua?rantee.*only.*info",
	"wts.*boost.*dungeon.*pvp.*emerald.*info",
	"wts.*gear.*loot.*levell?ing.*info",
	"wts.*mythic.*day.*glory.*more.*info",
	"wts.*power.*levell?ing.*loot.*info",
	"wts.+guild",
	"wtsgold.*mount.*tar?bard.*acc",
	"xbox",
	"y?o?ur? m[ao]mm?a",
	"y?o?ur? m[ou]th[ae]r",
	"youtu%.?be",
	"youtube",
}