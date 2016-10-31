
local BaseWeapon = class("BaseWeapon", function (...)
	return cc.Node:create(...)
end)

BaseWeapon._imgName = nil

local frameCache = cc.SpriteFrameCache:getInstance()

function BaseWeapon:ctor(...)
	--AM:addImgToCache("Weapon")
	return self
end

function BaseWeapon:dtor(...)
	
end

-- 武器躺在地上稳定后调用
function BaseWeapon:runAnimLandedWeapon()
	local spriteFrame = frameCache:getSpriteFrameByName(self._imgName)
	if not spriteFrame then
		AM:addImgToCache("Weapon")
		spriteFrame = frameCache:getSpriteFrameByName(self._imgName)
	end
	local posX, posY = self:getPosition()
	local bg = cc.Sprite:createWithSpriteFrame(spriteFrame)
	local body = cc.Sprite:createWithSpriteFrame(spriteFrame)
	self:addChild(bg, -1, "Background")
	self:addChild(body, -1, "Body")
	AM:runAnimLandedWeapon(self)
end

Weapon.BaseWeapon = BaseWeapon