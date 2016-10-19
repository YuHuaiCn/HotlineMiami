
local FirstBloodScene = class("FirstBloodScene", Levels.BaseScene)

function FirstBloodScene:ctor()
	self.super.ctor(self, "res/Maps/Test/TestLevel.tmx")
	self._landLayer:setScale(2)
	self:test()
end

function FirstBloodScene:dtor()
	DM:removeValue("PhysicsWorld")
end

function FirstBloodScene:test()
	-- run anim
	local sprWriter = Writer.new()
	sprWriter:setPosition(480, 100)
	local landLayer = DM:getValue("LandLayer")
	landLayer:addChild(sprWriter)
	local layerSize = landLayer:getContentSize()
	local scaleX = landLayer:getScaleX()
	local scaleY = landLayer:getScaleY()
	layerSize = {width = scaleX * layerSize.width, height = scaleY * layerSize.height}
	-- 当sprWriter超出rect的范围则不跟踪。
	-- 关于rect的计算：
	-- layer:setScale(2)是以Scene的中心为基准进行放缩的。
	-- 所以放缩后的layer原点坐标如下。Follow的rect原点也应该是下点。
	-- cc.p(VisibleSize.width / 2 - layerSize.width / 2, VisibleSize.height / 2 - layerSize.height / 2)
	local actFollow = cc.Follow:create(sprWriter, 
						cc.rect(VisibleSize.width / 2 - layerSize.width / 2, 
							VisibleSize.height / 2 - layerSize.height / 2, layerSize.width, layerSize.height))
	landLayer:runAction(actFollow)
	DM:storeValue("CurrentHero", sprWriter)
end

Levels.FirstBloodScene = FirstBloodScene
