cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require "init"

local function init()
	-- Director:getOpenGLView():setFrameSize(480, 320)
	-- VisibleSize = Director:getVisibleSize()
end

local function main()
	init()
    local scene = Levels.FirstBloodScene.new()
    DM:storeValue("CurrentScene", scene)
    cc.Director:getInstance():replaceScene(scene)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
