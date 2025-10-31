--!strict
--!strict
-- Built on a class & feature system apart of an OOP framework, using strict types.

type InstantPrompts = FeatureObject & {
    Binder: Binder;
    Cache: {[ProximityPrompt]: number};
    State: boolean;
    
    _SetupListener: (this: InstantPrompts) -> ();
    SetState: (this: InstantPrompts, State: boolean) -> ();
    GetState: (this: InstantPrompts) -> boolean;
}

local InstantPrompts = class "InstantPrompts" (Feature) {
	constructor = function(this: InstantPrompts, ...)
		this:super(...)
		this.Binder = Binder.new()
		this.Cache  = {}
		this:_SetupListener()
	end;

	Protected = {
		Binder = false, Cache = false, State = false;

		EntryPoint = function(this: InstantPrompts): ()
			local Cache = this.Cache;
			for _, Obj in World:GetDescendants() do
				if Obj:IsA("ProximityPrompt") then
					Cache[Obj] = Obj.HoldDuration;
				end
			end

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

		_SetupListener = function(this: InstantPrompts): ()
			local Cache = this.Cache;
			local GetState = this.GetState;	-- function in Connect() is not a class member, so we store func ref here

			this.Binder:Connect(World.DescendantAdded, function(Obj: Instance)
				if Obj:IsA("ProximityPrompt") and not Cache[Obj] then
					Cache[Obj] = Obj.HoldDuration;
					if GetState(this) then
						Obj.HoldDuration = 0;
					end
				end
			end)
		end;

		GetState = function(this: InstantPrompts): boolean
			return this.State;
		end;

		SetState = function(this: InstantPrompts, State: boolean): ()
			this.State = State;
			for Prompt, Duration in this.Cache do
				Prompt.HoldDuration = if State then 0 else Duration;
			end
		end;
	}
}
