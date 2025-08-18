--// This is an old No Ragdoll that only blocks fall damage ragdoll; it does not block ragdoll requests from the networking script in Replicated First (for vehicles & other ragdolls)

local function NoRagdoll()
	while Rio.NoRagdoll do
		if Rio.IsDead then
			Rio.Signals.CharacterRespawned.Event:Wait()
		end

		local RagdollLogic = LocalCharacter:WaitForChild("FallDamageRagdoll", 30)
		if RagdollLogic then
			RagdollLogic:Destroy() end

		Thread.WaitForAny({
			Rio.Signals.FeatureDisabled.Event;
			Rio.Signals.CharacterRespawned.Event;
		})
	end
end
