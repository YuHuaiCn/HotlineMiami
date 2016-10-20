
local nineMM = class("nineMM", Weapon.RangeWeapon)

function nineMM:ctor(...)
	Weapon.nineMM.super.ctor(self, ...)
	self:setSpriteFrame("Atlases/Weapon/9mm.png")
	return self
end

Weapon.nineMM = nineMM