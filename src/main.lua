cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require "init"

local function test()
	local scene = cc.Scene:create()
	local layer = cc.Layer:create()
	local sp1 = cc.Sprite:create("sprBearWalkAllFour.png")
	local sp2 = cc.Sprite:create("sprBearWalkAllFour2.png")
	sp1:setAnchorPoint(1,1)
	-- sp2:setAnchorPoint(0,0)
	sp2:addChild(sp1)
	sp2:setPosition(0, 0)
	layer:addChild(sp2)
	scene:addChild(layer)
	cc.Director:getInstance():replaceScene(scene)
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
