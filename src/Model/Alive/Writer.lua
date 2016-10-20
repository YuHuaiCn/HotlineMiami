
Writer = class("Writer", Player)

Writer._bodyShape = {shape = "rect", value = {width = 15, height = 26}}

function Writer:ctor(args)
	Writer.super.ctor(self, args)
	local writerLeg = self:getChildByName("Leg")
	local writerBody = self:getChildByName("Body")
	AM:addAnimation(writerLeg, 'PlayerWriterLeg', true)
	AM:addAnimation(writerBody, 'PlayerWriterWalkUnarmed', true)
end
