
Writer = class("Writer", Player)

function Writer:ctor( ... )
	self.super:ctor(...)
	-- add anim
	AM:runAnimation(self, 'PlayerWriterWalkUnarmed', true)
	local writerLeg = cc.Sprite:create()
	AM:runAnimation(writerLeg, 'PlayerWriterLeg', true)
	writerLeg:setAnchorPoint(0, 0)
	self:addChild(writerLeg)
	CurrentHero = self
end

-- function Writer:startFollow( ... )
-- 	-- body
-- end
