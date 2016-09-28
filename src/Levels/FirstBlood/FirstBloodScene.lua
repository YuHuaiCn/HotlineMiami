
local FirstBloodScene = class("FirstBloodScene", function ( ... )
	return cc.Scene:create(...)
end)

function FirstBloodScene:ctor( )
	local layer = cc.Layer:create()
	-- local map = cc.TMXTiledMap:create("res/Atlases/Levels/FirstBlood/FirstBloodSmall.tmx")
	local map = cc.TMXTiledMap:create("res/Maps/Test/TestLevel.tmx")
	layer:addChild(map)
	self:addChild(layer)
end

Levels.FirstBloodScene = FirstBloodScene