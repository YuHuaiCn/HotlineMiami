
local BaseWeapon = class("BaseWeapon", function (...)
	return cc.Sprite:create(...)
end)

function BaseWeapon:ctor(...)
	AM:addWeaponImgToCache()
	return self
end

function BaseWeapon:dtor(...)
	
end

Weapon.BaseWeapon = BaseWeapon