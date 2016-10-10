
local FirstBloodScene = class("FirstBloodScene", function ( ... )
	return cc.Scene:create(...)
end)

function FirstBloodScene:ctor( )
	local layer = cc.Layer:create()
	local map = cc.TMXTiledMap:create("res/Maps/Test/TestLevel.tmx")
	layer:addChild(map)
	self:addChild(layer)
	-- run anim
	local followController = FollowController.new()
	self:addChild(followController._touchPanel, 100)
	local sprWriter = Writer.new()
	layer:addChild(sprWriter)
	sprWriter:setPosition(300, 100)
end

Levels.FirstBloodScene = FirstBloodScene