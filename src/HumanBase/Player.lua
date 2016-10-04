
Player = class("Player", Alive)
Player[".isclass"] = true

Player._preFollowedPoint = nil
Player._isFollowing = false
Player._followEntry = nil

function Player:ctor(...)
	self.super:ctor(...)

end

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
	if self._preFollowedPoint.x - point.x <= 10 and
		self._preFollowedPoint.y - point.y <= 10 then
		return
	end
	self._preFollowedPoint = point
	local curPos = cc.p(self:getPosition())
	local speed  = self:getRunSpeed()
	local pixcelSpeed = math.floor(speed * PixcelPerMeter)
	local l = cc.pGetDistance(curPos, point)
	local ratioX = (point.x - curPos.x) / l
	local ratioY = (point.y - curPos.y) / l
	local dPixcel = 0.05 * pixcelSpeed
	local dX = dPixcel * ratioX
	local dY = dPixcel * ratioY
	-- update player's position
	local function moveToNext(dt)
		if not self._isFollowing then
			if self._followEntry then
				Schedule:unscheduleScriptEntry(self._followEntry)
			end
			self._followEntry = nil
		end
		curPos = cc.p(curPos.x + dX, curPos.y + dY)
		self:setPosition(curPos)
	end
	if not self._followEntry then
		self._followEntry = Schedule:scheduleScriptFunc(moveToNext, 0.05)
	end
end

function Player:endFollow()
	self._isFollowing = false
end
