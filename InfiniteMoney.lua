local InfiniteMoney = function()
	local function BuySupplies(): boolean
		local Items = {
			"Ice-Fruit Bag",
			"Ice-Fruit Cupz",
			"FijiWater",
			"FreshWater",
		}

		for It = 1, #Items do
			local ItemStock = SharedStorage.ExoticStock:FindFirstChild(Items[It])
			if not ItemStock or ItemStock.Value == 0 then
				return false
			end
		end

		for It = 1, #Items do
			InvokeServer(GameRemotes.ExoticShopRemote, Items[It])
			Thread.Sleep(1250)
		end

		for It = 1, #Items do
			if not Utility.FindItem(Items[It]) then
				return false
			end
		end

		return true
	end

	local function GetCookingPot(): Model?
		for _, Pot: Model in ipairs (World.CookingPots:GetChildren()) do
			if not (Pot.ClassName == "Model") then
				continue
			end

			local OwnerTag = Utility.FindPath(Pot, "Owner")
			local Progress = Utility.FindPath(Pot, "CookPart/Steam/LoadUI")

			if not OwnerTag or not Progress or OwnerTag.Value or Progress.Enabled then
				continue
			end

			return Pot
		end
	end

	local function FakeExit()
		Ui.Notify("Infinite Money failed: This server has datastores GLITCHED. Please join a different server!", "Server Hop Required", 10) -- Read the function name to understand. Kinda pointless now that it's leaked.

		Thread.Sleep(250)
		Rio.InfiniteMoney = false
	end

	if Utility.GetMoney() < 2750 then
		if Utility.GetBankMoney() >= 2750 then
			Actions.WithdrawCash(2750)
		else
			Ui.Notify("You do not have enough money to buy the Kool-Aid supplies. You need at least $2,750 to proceed.", "Insufficient Funds", 5)
			return Thread.Sleep(250);
		end
	end

	if BuySupplies() == false then
		return FakeExit()
	end

	local CookingPot = GetCookingPot()
	if not CookingPot then
		return FakeExit()
	end

	local CookPart     = CookingPot.CookPart
	local CookPrompt   = CookPart.ProximityPrompt
	local CookProgress = CookPart.Steam.LoadUI

	local FijiWater    = Utility.FindItem("FijiWater")
	local FreshWater   = Utility.FindItem("FreshWater")
	local IceFruitBag  = Utility.FindItem("Ice-Fruit Bag")
	local IceFruitCupz = Utility.FindItem("Ice-Fruit Cupz")

	local CookOrder = { FijiWater, FreshWater, IceFruitBag }

	local SellPart   = World["IceFruit Sell"]
	local SellPrompt = SellPart.ProximityPrompt

	Utility.Teleport(CookPart.Position)
	Thread.Sleep(250)

	fireproximityprompt(CookPrompt, 0)
	Thread.Sleep(250)

	for It = 1, #CookOrder do
		warn(CookOrder[It])

		LocalCharacter.Humanoid:EquipTool(CookOrder[It])
		Thread.Sleep(500)

		fireproximityprompt(CookPrompt, 0)

		Thread.WaitForAny({
			Thread.WaitForDelay(5000),
			LocalCharacter.ChildRemoved,
		})
	end

	while CookProgress.Enabled do
		Thread.WaitForAny({
			Thread.WaitForDelay(2035),
			CookProgress:GetPropertyChangedSignal("Enabled")
		})
	end

	Utility.Teleport(CookPart.Position)
	Thread.Sleep(250)

	LocalCharacter.Humanoid:EquipTool(IceFruitCupz)
	Thread.Sleep(100)

	fireproximityprompt(CookPrompt, 0)
	Thread.Sleep(1000)

	Utility.Teleport(SellPart.Position)
	Thread.Sleep(250)

	for _ = 1, 2000 do
		fireproximityprompt(SellPrompt, 0)
	end
end
