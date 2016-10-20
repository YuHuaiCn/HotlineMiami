
local RangeWeapon = class("RangeWeapon", Weapon.BaseWeapon)

RangeWeapon._type = "range"

function RangeWeapon:ctor(...)
	print("RangeWeapon super: " .. self.super.__cname)
	Weapon.RangeWeapon.super.ctor(self, ...)

	return self
end

function RangeWeapon:dtor(...)
	-- body
end

Weapon.RangeWeapon = RangeWeapon