--!strict
type GunSettings = FeatureObject & {
	SetupListeners: (this: GunSettings) -> ();
	SetMods: (this: GunSettings, Mods: {[string]: any}) -> ();
	ModifyWeapon: (this: GunSettings, Weapon: Tool) -> ();
	FreeWeapon: (this: GunSettings, Weapon: Tool?) -> ();

	Binder: Binder;
	Cache: {[Tool]: {[string]: any}};
	Mods: {[string]: any};
}

local InstantEquip = class "InstantEquip" (GunSettings) {
	constructor = function(this: GunSettings, ...)
		return this:super(...)
	end;

	Protected = {
		EntryPoint = function(this: GunSettings): ()
			this:SetMods({
				["EquipTime"] = 0;
			})
			
			return this:super()
		end;
	}
}
