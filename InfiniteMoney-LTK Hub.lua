-- The creator of this file is "wtwcaws" on Discord, owner of LTK Hub.
-- The same license applies, this code was posted with his consent.

for i = 1, 999 do
                fireproximityprompt(workspace["IceFruit Sell"].ProximityPrompt)
            end
            task.wait(4.5) do
                if LocalPlayer.stored.FilthyStack.Value == LocalPlayer:GetAttribute("MaxMoney") then
                    CoreGui.RobloxGui.Backpack.Visible =           true
                    LocalPlayer.PlayerGui.Hunger.Enabled =         true
                    LocalPlayer.PlayerGui.HealthGui.Enabled =      true
                    LocalPlayer.PlayerGui.Run.Enabled =            true
                    LocalPlayer.PlayerGui.SleepGui.Enabled =       true
                    LocalPlayer.PlayerGui.MoneyGui.Enabled =       true
                    LocalPlayer.PlayerGui.NewMoneyGui.Enabled =    true
                    LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
                    Notifications:Notify("[ LTK: Hub ] Money Dupe has been completed, you can now go wash your money & repeat.", 10, "success")
                    
                end
            end
