cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require "init"

local function touchBegin(layer, touch, event)
    -- local sprWriter = cc.Sprite:create()
    local woldLocation = touch:getLocation()
    -- sprWriter:setPosition(woldLocation.x, woldLocation.y)
    -- layer:addChild(sprWriter)

    local sp = cc.Sprite:create("Ball.png")  
    local body = cc.PhysicsBody:createCircle(sp:getContentSize().width / 2)
    body:setContactTestBitmask(0x1) 
--	body:setCategoryBitmask(0x2)
--  body:setCollisionBitmask(0x2)
    sp:setPhysicsBody(body)   
    sp:setPosition(woldLocation)
    layer:addChild(sp)
    return false
end

local function touchController(touchLayer)
	local oneByOneListener = cc.EventListenerTouchOneByOne:create()
	oneByOneListener:registerScriptHandler(function(...) return touchBegin(touchLayer, ...) end,
											cc.Handler.EVENT_TOUCH_BEGAN)
	oneByOneListener:setSwallowTouches(true)
	EventDispatcher:addEventListenerWithSceneGraphPriority(oneByOneListener, touchLayer)

	local collisionListener = cc.EventListenerPhysicsContact:create()
	collisionListener:registerScriptHandler(function (...) print("onContactBegin") return true end,
                                        	cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    collisionListener:registerScriptHandler(function (...) print("preSolve") return true end, cc.Handler.EVENT_PHYSICS_CONTACT_PRESOLVE)
    collisionListener:registerScriptHandler(function (...) print("postSolve") end, cc.Handler.EVENT_PHYSICS_CONTACT_POSTSOLVE)
    collisionListener:registerScriptHandler(function (...) print("separate") end, cc.Handler.EVENT_PHYSICS_CONTACT_SEPARATE)
	EventDispatcher:addEventListenerWithSceneGraphPriority(collisionListener, touchLayer)
end

local function test()
	local scene = cc.Scene:createWithPhysics()
	scene:getPhysicsWorld():setGravity(cc.p(0, -100))
	--scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
	local layer = cc.Layer:create()
	local edgeNode = cc.Node:create()
	local body = cc.PhysicsBody:createEdgeBox(VisibleSize, {density = 1.0, friction = 0.5, restitution = 1.0}, 0)
	edgeNode:setPhysicsBody(body)
	edgeNode:setPosition(VisibleSize.width / 2, VisibleSize.height / 2)
	layer:addChild(edgeNode)
	touchController(layer)
	scene:addChild(layer)
	Director:replaceScene(scene)
end

local function main()
    local scene = Levels.FirstBloodScene.new()
    DM:storeValue("CurrentScene", scene)
    cc.Director:getInstance():replaceScene(scene)
    -- test()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
