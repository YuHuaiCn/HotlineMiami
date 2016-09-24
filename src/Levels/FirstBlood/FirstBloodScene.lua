
local FirstBloodScene = class("FirstBloodScene", function ( ... )
	return cc.Scene:create(...)
end)

-- function FirstBloodScene:ctor( )
-- 	local layer = cc.Layer:create()
-- 	-- local map = cc.TMXTiledMap:create("res/Atlases/Levels/FirstBlood/FirstBloodSmall.tmx")
-- 	local map = cc.TMXTiledMap:create("res/Atlases/Levels/FirstBlood/FirstBlood.tmx")
-- 	layer:addChild(map)
-- 	self:addChild(layer)
-- end

function FirstBloodScene:ctor( )
	local layer = cc.Layer:create()
	local spr = cc.Sprite:create('res/Atlases/Levels/FirstBlood/Furniture/sprElisChairWood001.png')
	spr:setPosition(200, 300)
	layer:addChild(spr)
	self:addChild(layer)
end

Levels.FirstBloodScene = FirstBloodScene