
FollowController.__cname = "FollowController"

FollowController._oneByOnePoints = {}   -- struct: type: point type
										--         entryTime: the time of point pushed
										--         entryPos:  the position of entry point
										--         curPos:    the position of current point
										-- hasFollowPoint 
FollowController._touchLayer = nil

local POINT_TYPE_NULL   = 0
local POINT_TYPE_ATTACK = 1
local POINT_TYPE_FOLLOW = 2

function FollowController:getInstance(...)
    if FollowController._instance == nil then
        FollowController._instance = FollowController:ctor(...)
    end
    return FollowController._instance
end

function FollowController:ctor()
	local touchLayer = cc.Layer:create()
	local oneByOneListener = cc.EventListenerTouchOneByOne:create()
	oneByOneListener:registerScriptHandler(function (...) return self:touchBegin(...) end, 
											cc.Handler.EVENT_TOUCH_BEGAN)
    oneByOneListener:registerScriptHandler(function (...) self:touchMoved(...) end, 
    										cc.Handler.EVENT_TOUCH_MOVED)
    oneByOneListener:registerScriptHandler(function (...) self:touchEnded(...) end,
    										cc.Handler.EVENT_TOUCH_ENDED)
	EventDispatcher:addEventListenerWithSceneGraphPriority(oneByOneListener, touchLayer)
	self._touchLayer = touchLayer
    DM:storeValue("TouchLayer", touchLayer)
	return self
end

function FollowController:dtor(...)
    DM:removeValue("TouchLayer")
    FollowController._instance = nil
    FollowController = nil
end

function FollowController:touchBegin(touch, event)
    local woldLocation = touch:getLocation()
--test
    local writer1 = cc.Sprite:create()
    local body1 = cc.PhysicsBody:createCircle(25)
    local writer2 = cc.Sprite:create()
    local body2 = cc.PhysicsBody:createCircle(25)
    writer1:setPhysicsBody(body1)
    writer2:setPhysicsBody(body2)
    writer1:setPosition(cc.p(woldLocation.x, woldLocation.y))
    writer2:setPosition(cc.p(woldLocation.x + 50, woldLocation.y))
    local joint = cc.PhysicsJointDistance:construct(body1, body2, cc.p(25, 0), cc.p(0, 0))
    DM:getValue("PhysicsWorld"):addJoint(joint)
    DM:getValue("CollisionLayer"):addChild(writer1)
    DM:getValue("CollisionLayer"):addChild(writer2)
--test

    woldLocation = cc.p(math.floor(woldLocation.x), math.floor(woldLocation.y))
    --print(string.format("touchBeigin: (%2d, %2d)", woldLocation.x, woldLocation.y))
    local oneByOnePoint = {entryPos = woldLocation, entryTime = os.clock(), 
    						curPos = woldLocation, type = POINT_TYPE_NULL}
    self._oneByOnePoints[#self._oneByOnePoints + 1] = oneByOnePoint
    -- CurrentHero:startFollow(woldLocation)
    local judgerEntry = nil
    local function judger()
    	if judgerEntry then
    		Scheduler:unscheduleScriptEntry(judgerEntry)
    		judgerEntry = nil
    	end
    	-- find self point in _oneByOnePoints
    	local pointIndex = nil
	    for i = 1, #self._oneByOnePoints do
	    	if self._oneByOnePoints[i].entryPos.x == woldLocation.x and
	    	   self._oneByOnePoints[i].entryPos.y == woldLocation.y then
	    		pointIndex = i
	    		break
	    	end
	    end
	    if pointIndex then
	    	-- if type is POINT_TYPE_NULL then this point is not ended
	    	if self._oneByOnePoints[pointIndex].type == POINT_TYPE_NULL then
	    		if not self._oneByOnePoints.hasFollowPoint then
	    			self._oneByOnePoints.hasFollowPoint = true
					self._oneByOnePoints[pointIndex].type = POINT_TYPE_FOLLOW
					CurrentHero:startFollow(self._oneByOnePoints[pointIndex].curPos)
				else
    				--print("ATTACK point: (" .. woldLocation.x .. ', ' .. woldLocation.y .. ')')
					self._oneByOnePoints[pointIndex].type = POINT_TYPE_ATTACK
				end
			end
	    end
    end
    judgerEntry = Scheduler:scheduleScriptFunc(judger, POINT_TYPE_JUDGE_TIME, false)
    return true
end

-- find target point
local function findTargetPoint(self, nodePoint)
    local pointIndex = nil
    local minDif = 100000
    for i = 1, #self._oneByOnePoints do
    	-- find cloest point to nodePoint in _oneByOnePoints
    	local curDif = math.abs(nodePoint.x - self._oneByOnePoints[i].curPos.x) + 
    					math.abs(nodePoint.y - self._oneByOnePoints[i].curPos.y)
    	if curDif < minDif then
    		minDif = curDif
    		pointIndex = i
    	end
    end
    return pointIndex
end

function FollowController:touchMoved(touch, event)
    local touchPanel = event:getCurrentTarget()
    local woldLocation = touch:getLocation()
    woldLocation = cc.p(math.floor(woldLocation.x), math.floor(woldLocation.y))
    -- update curPos
    local pointIndex = findTargetPoint(self, woldLocation)
    if pointIndex then
    	self._oneByOnePoints[pointIndex].curPos = woldLocation
    end

    --print(string.format("touchMoved: (%2d, %2d)", woldLocation.x, woldLocation.y))
	if self._oneByOnePoints[pointIndex].type == POINT_TYPE_FOLLOW then
		CurrentHero:updateFollow(woldLocation)
	end
end

function FollowController:touchEnded(touch, event)
    local woldLocation = touch:getLocation()
    woldLocation = cc.p(math.floor(woldLocation.x), math.floor(woldLocation.y))
    local pointIndex = findTargetPoint(self, woldLocation)
    if pointIndex then
    	-- if type is POINT_TYPE_NULL then point exist less then POINT_TYPE_JUDGE_TIME
    	-- this is ATTACK point
    	if self._oneByOnePoints[pointIndex].type == POINT_TYPE_NULL then
			self._oneByOnePoints[pointIndex].type = POINT_TYPE_ATTACK
		end
    end
    --print(string.format("touchEnded: (%2d, %2d)", woldLocation.x, woldLocation.y))
    if self._oneByOnePoints[pointIndex].type == POINT_TYPE_FOLLOW then
    	self._oneByOnePoints.hasFollowPoint = false
    	CurrentHero:endFollow()
    	print("Follow point: (" .. woldLocation.x .. ', ' .. woldLocation.y .. ')')
    	print("Click time: " .. (os.clock() - self._oneByOnePoints[pointIndex].entryTime))
    	table.remove(self._oneByOnePoints, pointIndex)
    else
    	print("ATTACK point: (" .. woldLocation.x .. ', ' .. woldLocation.y .. ')')
    	print("Click time: " .. (os.clock() - self._oneByOnePoints[pointIndex].entryTime))
    	table.remove(self._oneByOnePoints, pointIndex)
    end
end
