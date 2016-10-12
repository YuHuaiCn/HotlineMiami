
local FirstBloodScene = class("FirstBloodScene", function ( ... )
	local scene = cc.Scene:createWithPhysics()
	scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
	scene:getPhysicsWorld():setGravity(cc.p(0, 0))
	return scene
end)

FirstBloodScene._landLayer = nil

function FirstBloodScene:ctor()
	local followController = FollowController.new()
	self:addChild(followController._touchPanel, 100)
	local collisionManager = CollisionManager.new() 
	--local layer = collisionManager._collisionPanel
	local map = cc.TMXTiledMap:create("res/Maps/Test/TestLevel.tmx")
	collisionManager._collisionPanel:addChild(map)
	local body = cc.PhysicsBody:createEdgeBox(VisibleSize, {density = 1.0, friction = 0.5, restitution = 1.0})
	local edgeNode = cc.Node:create()
	edgeNode:setPosition(cc.p(VisibleSize.width / 2, VisibleSize.height / 2))
	edgeNode:setPhysicsBody(body)
	collisionManager._collisionPanel:addChild(edgeNode)
	self:addChild(collisionManager._collisionPanel)
	self._landLayer = collisionManager._collisionPanel
	self:test()
end

function FirstBloodScene:test()
	-- run anim
	local sprWriter = Writer.new()
	sprWriter:setPosition(300, 100)
	self._landLayer:addChild(sprWriter)

	local sprWriter1 = Writer.new()
	sprWriter1:setPosition(300, 200)
	self._landLayer:addChild(sprWriter1)
end

Levels.FirstBloodScene = FirstBloodScene