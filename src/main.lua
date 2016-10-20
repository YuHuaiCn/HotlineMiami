cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require "init"

local function init()
	local winSize = Director:getWinSize()
	Director:getOpenGLView():setFrameSize(winSize.width, winSize.height)
	VisibleSize = winSize
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
