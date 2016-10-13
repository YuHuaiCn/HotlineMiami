
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
                                {density = 1.0, friction = 0, restitution = 0.1})
	body:setContactTestBitmask(0x1)
	body:setLinearDamping(0.5)
	body:setAngularDamping(0.5)
	self:setPhysicsBody(body)
	CurrentHero = self
end
