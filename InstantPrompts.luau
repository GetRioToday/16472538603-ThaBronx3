--!strict
-- Built on a class & feature system apart of an OOP framework, using strict types.

type InstantPrompts = FeatureObject & {
	Binder: Binder;
	Cache: {[ProximityPrompt]: number};

	SetupListeners: (this: InstantPrompts) -> ();
	SetState: (this: InstantPrompts, State: boolean) -> ();
}

local InstantPrompts = class "InstantPrompts" (Feature) {
		constructor = function(this: InstantPrompts, ...)
			this:super(...)
			this.Binder = Binder.new()
			this.Cache = {};
		end;

		Protected = {
			Binder = false, Cache = false, State = false;

			EntryPoint = function(this: InstantPrompts): ()
				local Cache = this.Cache;
				for _, Obj in World:GetDescendants() do
					if Obj:IsA("ProximityPrompt") then
						Cache[Obj] = Obj.HoldDuration;
						this.Binder:Once(Obj.Destroying, function()
							Cache[Obj] = null;
						end)
					end
				end

				this:SetupListeners()
				return this:SetState(true)
			end;

			Shutdown = function(this: InstantPrompts): ()
				this:SetState(false)
				this.Binder:Destroy()
				table.clear(this.Cache)

				this.Cache = false :: any;
				this.Binder = false :: any;
				return this:super()
			end;

			SetupListeners = function(this: InstantPrompts): ()
				local Cache = this.Cache;
				local Binder = this.Binder;

				-- this callback is not a class member so we need to store references as upvalues
				this.Binder:Connect(World.DescendantAdded, function(Obj: Instance)
					if Obj:IsA("ProximityPrompt") and not Cache[Obj] then
						Cache[Obj] = Obj.HoldDuration;
						Obj.HoldDuration = 0;
						Binder:Once(Obj.Destroying, function()
							Cache[Obj] = null;
						end)
					end
				end)
			end;

			SetState = function(this: InstantPrompts, State: boolean): ()
				for Prompt, Duration in this.Cache do
					Prompt.HoldDuration = if State then 0 else Duration;
				end
			end;
		},
	}
