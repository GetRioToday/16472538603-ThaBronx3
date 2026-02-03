--[[
Things you must implement:
- class (function): Apart of the class system, creates and can inherit from classes
- Teleport (function): Takes a positional value or an instance with a positional value as the "where" argument.
- Feature (class): A class that was created from the class function, representing a feature object.
- Thread (module): A wrapper around most of the task library with some custom implementations such as WaitForPath()
- Binder (module): A maid module but for signals & connections specifically

Things your executor must have:
- fireproximityprompt: Can be reimplemented in Luau without any detection worries but never nearly as good.
--]]

StudioFarm = class "StudioFarm" (Feature) {
	constructor = function(this, ...)
		local Container = Thread.WaitForPath(World, "StudioPay/Money") :: Folder
		local Stacks = {
			Container:WaitForChild("StudioPay1") :: Model,
			Container:WaitForChild("StudioPay2") :: Model,
			Container:WaitForChild("StudioPay3") :: Model,
		}
		local Prompts = {
			Stacks[1]:FindFirstChild("Prompt", true),
			Stacks[2]:FindFirstChild("Prompt", true),
			Stacks[3]:FindFirstChild("Prompt", true),
		}

		this._Binder = Binder.new()
		this._Stacks = Stacks
		this._Prompts = Prompts

		return this:super(...)
	end,

	destructor = function(this: FeatureObject)
		this:Shutdown()
		this:InternalShutdown()
	end,

	Protected = {
		EntryPoint = function(this)
			for It, Prompt in this._Prompts :: {ProximityPrompt} do
				if Prompt.Enabled then
					this:_StealCash(It)
				end

				this._Binder:Connect(Prompt:GetPropertyChangedSignal("Enabled"), this._StealCash, this, It)
			end
		end,

		Shutdown = function(this)
			this._Binder:Destroy()
			table.clear(this._Stacks)
			table.clear(this._Prompts)

			this._Binder = false :: any
			this._Stacks = false :: any
			this._Prompts = false :: any
		end
	},

	Private = {
		_Binder = false,
		_Stacks = false,
		_Prompts = false,

		_StealCash = function(this, Idx: number)
			local Prompt = this._Prompts[Idx] :: ProximityPrompt
			local Model = this._Stacks[Idx] :: Model

			while Prompt.Enabled do
				Teleport(Model)
				fireproximityprompt(Prompt)
				Thread.Heartbeat()
			end
		end,
	}
}
