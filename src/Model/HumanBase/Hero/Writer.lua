
Writer = class("Writer", Player)

function Writer:ctor(contSize, args)
	Writer.super.ctor(self, contSize, args)
	local writerLeg = self:getChildByName("Leg")
	local writerBody = self:getChildByName("Body")
	AM:addAnimation(writerLeg, 'PlayerWriterLeg', true)
	AM:addAnimation(writerBody, 'PlayerWriterWalkUnarmed', true)
end
