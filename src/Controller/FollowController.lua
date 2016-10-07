
FollowController = class("FollowController")

FollowController._instance = nil

function FollowController.new(...)
	if FollowController._instance == nil then
		FollowController._instance = FollowController:ctor(...)
	end
	return FollowController._instance
end

FollowController._touchPanel = nil

function FollowController:ctor()
	local touchLayer = cc.Layer:create()
	local oneByOneListener = cc.EventListenerTouchOneByOne:create()
	oneByOneListener:registerScriptHandler(self.touchBegin, cc.Handler.EVENT_TOUCH_BEGAN)
    oneByOneListener:registerScriptHandler(self.touchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    oneByOneListener:registerScriptHandler(self.touchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	EventDispatcher:addEventListenerWithSceneGraphPriority(oneByOneListener, touchLayer)
	self._touchPanel = touchLayer
	return self
end

function FollowController.touchBegin(touch, event)
	local woldLocation = touch:getLocation()
	CurrentHero:startFollow(woldLocation)
	return true
end

function FollowController.touchMoved(touch, event)
	local touchPanel = event:getCurrentTarget()
	local woldLocation = touch:getLocation()
	-- print('(' .. woldLocation.x .. ', ' .. woldLocation.y .. ')')
	CurrentHero:updateFollow(woldLocation)
end

function FollowController.touchEnded(touch, event)
	CurrentHero:endFollow()
end