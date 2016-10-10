
Player = class("Player", Alive)

Player._preFollowedPoint = nil
Player._isFollowing = false
Player._followEntry = nil

function Player:startFollow(point)
	if point.x == nil or point.y == nil then
		printError("Player:startFollow: point is nil")
		return
	end
	self._isFollowing = true
	self._preFollowedPoint = cc.p(-1000, -1000)
	self:updateFollow(point)
end

function Player:updateFollow(point)
	if point.x == nil or point.y == nil then
		printError("Player:updateFollow: point is nil")
		return
	end
	-- point delt too small then return
	if math.abs(self._preFollowedPoint.x - point.x) <= 10 and
		math.abs(self._preFollowedPoint.y - point.y) <= 10 then
		return
	end
	
	self._preFollowedPoint = point
	local curPos = cc.p(self:getPosition())
	local speed  = self:getRunSpeed()
	local pixcelSpeed = math.floor(speed * PIXCEL_PER_METER)
	local l = cc.pGetDistance(curPos, point)
	local ratioX = (point.x - curPos.x) / l
	local ratioY = (point.y - curPos.y) / l
	local dPixcel = pixcelSpeed * Director:getAnimationInterval()
	-- dX and dY should not collected by GC when updateFollow is ended
	-- so moveToNext can get changed dX and dY
	self.dX = dPixcel * ratioX
	self.dY = dPixcel * ratioY
	self.remainMoveTimes = math.floor(math.abs((curPos.x-point.x)/self.dX))
	-- update player's position
	local function moveToNext(dt)
		if not self._isFollowing then
			if self._followEntry then
				Scheduler:unscheduleScriptEntry(self._followEntry)
			end
			self._followEntry = nil
			return
		end
		-- if not reach tarPoint then move
		if self.remainMoveTimes > 0 then
			self.remainMoveTimes = self.remainMoveTimes - 1
			curPos = {x = curPos.x + self.dX, y = curPos.y + self.dY}
			self:setPosition(curPos)
		end
	end
	if not self._followEntry then
		self._followEntry = Scheduler:scheduleScriptFunc(moveToNext, 0, false)
	end
end

function Player:endFollow()
	self._isFollowing = false
end
