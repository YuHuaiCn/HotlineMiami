
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
	local nickeLeg = cc.Sprite:create()
	AM:runAnimation(nickeLeg, 'PlayerNickeLeg', true)
	nickeLeg:setAnchorPoint(0, 0)
	local nicke = cc.Sprite:create()
	AM:runAnimation(nicke, 'PlayerNickeAttackKnifeFlameThrower', true)
	AM:setSpeed(nicke, 10)
	nicke:addChild(nickeLeg, -1)
	layer:addChild(nicke)
	nicke:setPosition(300, 250)
end

Levels.FirstBloodScene = FirstBloodScene