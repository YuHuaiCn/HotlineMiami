
Writer = class("Writer", Player)

Writer._bodyShape = {shape = "rect", value = {width = 15, height = 26}}

-- 存储动画
Writer._animPool = {}

function Writer:ctor(args)
	Writer.super.ctor(self, args)
	local writerLeg = self:getChildByName("Leg")
	local writerBody = self:getChildByName("Body")
	AM:addAnimation(writerLeg, 'PlayerWriterLeg', true)
	AM:addAnimation(writerBody, 'PlayerWriterWalkUnarmed', true)
	self._animName = "WalkUnarmed"
	self._weapon = "Punch"
end

function Writer:addWalkAnim()
	
end

-- 更新self._animation中的动画
function Writer:updateAttackAnimation()
	local animName = "PlayerWriterAttack" .. self._weapon
	local spBody = self:getChildByName("Body")
	-- 需要反转X轴获得第二个动画
	if self._weapon == "Punch" then
		-- loop == false则播放一次之后就会被释放掉
		AM:addAnimation(spBody, animName)
		-- 切换动画1和动画2
		if self._animName == self._weapon .. "1" then
			spBody:setFlippedY(true)
			self._animName = self._weapon .. "2"
		else
			spBody:setFlippedY(false)
			self._animName = self._weapon .. "1"
		end
	end
end

local function onStartAttack(self)
	-- add anim to animPool
	self:updateAttackAnimation()
	local spBody = self:getChildByName("Body")
	AM:runAnimation(spBody)
end

function Writer:startAttack(touchPoint)
	self.onStartAttack = onStartAttack
	self.super.startAttack(self, touchPoint)
end

local function onUpdateAttack(...)
	print("onUpdateAttack")
end

function Writer:updateAttack(touchPoint)
	self.onUpdateAttack = onUpdateAttack
	self.super.updateAttack(self, touchPoint)
end

local function onUpdateAttack( ... )
	print("onUpdateAttack")
end

function Writer:endAttack()
	self.onEndAttack = onEndAttack
	self.super.endAttack(self)
end