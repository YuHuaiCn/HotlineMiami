
Writer = class("Writer", Player)

function Writer:ctor()
	AM:runAnimation(self, 'PlayerWriterWalkUnarmed', true)
	local writerLeg = cc.Sprite:create()
	AM:runAnimation(writerLeg, 'PlayerWriterLeg', true)
	writerLeg:setAnchorPoint(0, 0)
	self:addChild(writerLeg, -1)
	CurrentHero = self
end

-- function Writer:startFollow(...)
-- 	-- body
-- end
