
local FirstBloodScene = class("FirstBloodScene", function ( ... )
	return cc.Scene:create(...)
end)

function FirstBloodScene:ctor( )
	local layer = cc.Layer:create()
	local map = cc.TMXTiledMap:create("res/Atlases/Levels/FirstBlood/FirstBloodSmall.tmx")
	local map = cc.TMXTiledMap:create("res/Maps/Test/TestLevel.tmx")
	layer:addChild(map)
	self:addChild(layer)
	-- run anim
	local nodeBossBear = cc.CSLoader:createNode('Atlases/Boss/Bear/aniBossBear.csb')
	local aniBossBear  = cc.CSLoader:createTimeline('Atlases/Boss/Bear/aniBossBear.csb')
	aniBossBear:play("eat", true)
	nodeBossBear:runAction(aniBossBear)
	layer:addChild(nodeBossBear)
	nodeBossBear:setPosition(400, 200)
end

Levels.FirstBloodScene = FirstBloodScene