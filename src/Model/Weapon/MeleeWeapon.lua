
local MeleeWeapon = class("MeleeWeapon", Weapon.Weapon)

MeleeWeapon._type = "Melee"

function MeleeWeapon:ctor(...)
	-- body
end

function MeleeWeapon:dtor(...)
	-- body
end

Weapon.MeleeWeapon = MeleeWeapon