
Player = class("Player", Alive)

Player._preFollowedPoint = nil
Player._isFollowing = false
Player._followEntry = nil

function Player:startFollow(wdPoint)
	if wdPoint.x == nil or wdPoint.y == nil then
		printError("Player:startFollow: point is nil")
		return
	end
	self._isFollowing = true
	self._preFollowedPoint = cc.p(-1000, -1000)
	self:updateFollow(wdPoint)
end

function Player:updateFollow(wdPoint)
	if wdPoint.x == nil or wdPoint.y == nil then
		printError("Player:updateFollow: point is nil")
		return
	end
	local lcPoint = self:getParent():convertToNodeSpace(wdPoint)
	-- point delt too small then return
	if math.abs(self._preFollowedPoint.x - lcPoint.x) <= 10 and
		math.abs(self._preFollowedPoint.y - lcPoint.y) <= 10 then
		return
	end
	
	self._preFollowedPoint = lcPoint
	local curPos = cc.p(self:getPosition())
	local speed  = self:getRunSpeed()
	-- 计算单位向量
	local v_distance = cc.pSub(lcPoint, curPos)   -- 距离向量
	local lengthSQ = cc.pGetLength(v_distance)
	local maxSQ = (VisibleSize.width * VisibleSize.width) / 9 -- 距离大于1/3的宽度，则全速前进
	if lengthSQ < maxSQ then
		speed = speed * math.sqrt(lengthSQ / maxSQ)
	end
	local e_v2 = cc.pNormalize(v_distance)
	local velocity = cc.p(e_v2.x * speed, e_v2.y * speed)
	self:getPhysicsBody():setVelocity(velocity)
end

function Player:endFollow()
	self._isFollowing = false
end
