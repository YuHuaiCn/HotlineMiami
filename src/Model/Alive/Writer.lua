
Writer = class("Writer", Player)

Writer._bodyShape = {shape = "rect", value = {width = 15, height = 26}}

-- 对应动画名称Table
Writer._animTable = nil

function Writer:ctor(args)
	Writer.super.ctor(self, args)
	local writerLeg = self:getChildByName("Leg")
	local writerBody = self:getChildByName("Body")
	AM:addAnimation(writerLeg, 'PlayerWriterLeg', true)
	AM:addAnimation(writerBody, 'PlayerWriterWalkUnarmed', true)
	self._weapon = "Punch"
end

local function onStartAttack(ndWriter)
	local animName = "PlayerWriterAttack" .. ndWriter._weapon
	AM:addAnimation(ndWriter:getChildByName("Body"), animName)
	AM:runAnimation(ndWriter)
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