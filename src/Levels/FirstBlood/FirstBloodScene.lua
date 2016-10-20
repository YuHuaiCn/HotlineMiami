
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
	landLayer:addChild(sprWriter, 10)
	FC:initCamera(landLayer, sprWriter)
	DM:storeValue("CurrentHero", sprWriter)
	-- add Weapon
	local spr9mm = Weapon.nineMM.new()
	spr9mm:setPosition(500, 100)
	landLayer:addChild(spr9mm, 9)
end

Levels.FirstBloodScene = FirstBloodScene
