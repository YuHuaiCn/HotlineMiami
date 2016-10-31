
local RangeWeapon = class("RangeWeapon", Weapon.BaseWeapon)

RangeWeapon._type = "range"

function RangeWeapon:ctor(...)
	Weapon.RangeWeapon.super.ctor(self, ...)
	return self
end

function RangeWeapon:dtor(...)
	-- body
end

Weapon.RangeWeapon = RangeWeapon