
Writer = class("Writer", Player)

function Writer:ctor()
	local writerLeg = cc.Sprite:create()
	AM:runAnimation(writerLeg, 'PlayerWriterLeg', true)
	self:addChild(writerLeg)
	local writerBody = cc.Sprite:create()
	AM:runAnimation(writerBody, 'PlayerWriterWalkUnarmed', true)
	AM:setSpeed(writerBody, 0.5)
	self:addChild(writerBody)
	local bodySize = writerBody:getContentSize()
    local body = cc.PhysicsBody:createCircle(bodySize.width / 2, 
                                {density = 10.0, friction = 1, restitution = 0.1})
	body:setContactTestBitmask(0x1)
	self:setPhysicsBody(body)
	CurrentHero = self
end
