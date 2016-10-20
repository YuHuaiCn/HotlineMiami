
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

function FollowController:init(layer)
	local oneByOneListener = cc.EventListenerTouchOneByOne:create()
	oneByOneListener:registerScriptHandler(function (...) return self:touchBegin(...) end, 
											cc.Handler.EVENT_TOUCH_BEGAN)
    oneByOneListener:registerScriptHandler(function (...) self:touchMoved(...) end, 
    										cc.Handler.EVENT_TOUCH_MOVED)
    oneByOneListener:registerScriptHandler(function (...) self:touchEnded(...) end,
    										cc.Handler.EVENT_TOUCH_ENDED)
	EventDispatcher:addEventListenerWithSceneGraphPriority(oneByOneListener, layer)
	return self
end

function FollowController:dtor(...)
    FollowController._instance = nil
    FollowController = nil
end

function FollowController:touchBegin(touch, event)
    touch._entryTime = os.clock()
    touch._type = POINT_TYPE_NULL
    self._oneByOnePoints[#self._oneByOnePoints + 1] = touch

    local judgerEntry
    local function judger()
    	if judgerEntry then
    		Scheduler:unscheduleScriptEntry(judgerEntry)
    		judgerEntry = nil
    	end
        -- if touch not exist do nothing
        if touch then
            for _, point in ipairs(self._oneByOnePoints) do
                if point._type == POINT_TYPE_FOLLOW then
                    -- if exist FOLLOW_POINT set touch's type POINT_TYPE_ATTACK
                    touch._type = POINT_TYPE_ATTACK
                    -- set body rotation
                    DM:getValue("CurrentHero"):startAttack(touch)
                    break
                end
            end
            -- if not exist FOLLOW_POINT set touch's type POINT_TYPE_FOLLOW
            if touch._type == POINT_TYPE_NULL then
                touch._type = POINT_TYPE_FOLLOW
                local hero = DM:getValue("CurrentHero")
                hero:startFollow(touch)
                -- 添加_synMoveEntry定时器，用于同步touch和mouse
                local synMoveEntry
                local function synMovePoint()
                    if touch._type ~= POINT_TYPE_FOLLOW and synMoveEntry then
                        Scheduler:unscheduleScriptEntry(synMoveEntry)
                        synMoveEntry = nil
                        return
                    end
                    hero:updateFollow(touch)
                end
                synMoveEntry = Scheduler:scheduleScriptFunc(synMovePoint, 0.2, false)
            end
        end 
    end
    judgerEntry = Scheduler:scheduleScriptFunc(judger, POINT_TYPE_JUDGE_TIME, false)
    return true
end

function FollowController:touchMoved(touch, event)
	if touch._type == POINT_TYPE_FOLLOW then
		DM:getValue("CurrentHero"):updateFollow(touch)
	elseif touch._type == POINT_TYPE_ATTACK then
        DM:getValue("CurrentHero"):updateAttack(touch)
    end
end

function FollowController:touchEnded(touch, event)
    local hero = DM:getValue("CurrentHero")
    for i, point in ipairs(self._oneByOnePoints) do
        if point == touch then
        	if point._type == POINT_TYPE_FOLLOW then
                hero:endFollow()
    		elseif point._type == POINT_TYPE_ATTACK then
                hero:endAttack()
            else
                hero:startAttack(touch)
                hero:endAttack()
            end
            table.remove(self._oneByOnePoints, i)
            break
        end
    end
end

-- 设置跟随摄像机
function FollowController:initCamera(layer, followNode)
    local layerSize = layer:getContentSize()
    local scaleX = layer:getScaleX()
    local scaleY = layer:getScaleY()
    layerSize = {width = scaleX * layerSize.width, height = scaleY * layerSize.height}
    -- 当sprWriter超出rect的范围则不跟踪。
    -- 关于rect的计算：
    -- layer:setScale(2)是以Scene的中心为基准进行放缩的。
    -- 所以放缩后的layer原点坐标如下。Follow的rect原点也应该是下点。
    -- cc.p(VisibleSize.width / 2 - layerSize.width / 2, VisibleSize.height / 2 - layerSize.height / 2)
    local actFollow = cc.Follow:create(followNode, 
                        cc.rect(VisibleSize.width / 2 - layerSize.width / 2, 
                            VisibleSize.height / 2 - layerSize.height / 2, layerSize.width, layerSize.height))
    layer:runAction(actFollow)
end

FC = FollowController