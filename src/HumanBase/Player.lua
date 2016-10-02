
Player = class("Player", Alive)


function Player:ctor(...)
	self.super:ctor(...)

end

-- move follow touch point
function Player:moveFollow(point)
	local curPos = self:getPosition()
	local speed  = self:getRunSpeed()
	
end
