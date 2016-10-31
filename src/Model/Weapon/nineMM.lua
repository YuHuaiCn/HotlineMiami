
local nineMM = class("nineMM", Weapon.RangeWeapon)

function nineMM:ctor(...)
	Weapon.nineMM.super.ctor(self, ...)
	self._imgName = "Atlases/Weapon/9mm.png"
	return self
end

Weapon.nineMM = nineMM