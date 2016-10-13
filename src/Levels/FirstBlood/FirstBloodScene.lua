
local FirstBloodScene = class("FirstBloodScene", function ( ... )
	local scene = cc.Scene:createWithPhysics()
	local world = scene:getPhysicsWorld()
	--world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
	world:setSpeed(50)
	scene:getPhysicsWorld():setGravity(cc.p(0, 0))
	DM:storeValue("PhysicsWorld", world)
	return scene
end)

FirstBloodScene._landLayer = nil

function FirstBloodScene:ctor()
	local followController = FollowController:getInstance()
	self:addChild(followController._touchLayer, 100)
	local collisionManager = CollisionManager:getInstance()
	local map = cc.TMXTiledMap:create("res/Maps/Test/TestLevel.tmx")
	collisionManager._collisionLayer:addChild(map)
	local body = cc.PhysicsBody:createEdgeBox(VisibleSize, {density = 1.0, friction = 0.5, restitution = 1.0})
	local edgeNode = cc.Node:create()
	edgeNode:setPosition(cc.p(VisibleSize.width / 2, VisibleSize.height / 2))
	edgeNode:setPhysicsBody(body)
	collisionManager._collisionLayer:addChild(edgeNode)
	self:addChild(collisionManager._collisionLayer)
	self._landLayer = collisionManager._collisionLayer
	DM:aliasValue("CollisionLayer", "LandLayer")
	self:test()
end

function FirstBloodScene:dtor()
	DM:removeValue("PhysicsWorld")
end

function FirstBloodScene:test()
	-- run anim
	local sprWriter = Writer.new()
	sprWriter:setPosition(60, 100)
	self._landLayer:addChild(sprWriter)
	DM:storeValue("CurrentHero", sprWriter)

	-- local sprWriter1 = Writer.new()
	-- sprWriter1:setPosition(300, 200)
	-- self._landLayer:addChild(sprWriter1)
end

Levels.FirstBloodScene = FirstBloodScene
