
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
	layer:addChild(nickeLeg)
	nickeLeg:setPosition(300, 250)
	local nicke = cc.Sprite:create()
	AM:runAnimation(nicke, 'PlayerNickeAttackKnifeFlameThrower', true)
	layer:addChild(nicke)
	nicke:setPosition(300, 250)
end

Levels.FirstBloodScene = FirstBloodScene