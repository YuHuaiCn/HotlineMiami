
Writer = class("Writer", Player)

Writer._bodyShape = {shape = "rect", value = {width = 15, height = 26}}

-- 存储动画
Writer._animPool = {}
Writer._preAnimName = "" -- 缓存动画名
-- 状态机
Writer.StateMachine = nil

local ANIM_PREFIX = "PlayerWriter"

function Writer:ctor(args)
	Writer.super.ctor(self, args)
	AM:addAnimation(self._spLeg, 'PlayerWriterLeg', true)
	AM:addAnimation(self._spBody, 'PlayerWriterWalkUnarmed', true)
	self._animName = "WalkUnarmed"
	self._weapon = "Punch"
	self:initStateMachine()
end

function Writer:initStateMachine()
	local StateMachine = require("Manager.StateMachine").new()
	StateMachine:setupState({
		initial = "walk",
		events = {
			{name = "Attack", from = "walk", to = "attack"},
			-- {name = "Attack", from = "attack", to = "attack"},
			{name = "Walk", from = "attack", to = "walk"}
		},
		callbacks = {
			onbeforeAttack = function(event) print("onbeforeAttack") end,
			onleavewalk    = function(event) print("onleavewalk") end,
			onleaveattack  = function(event) print("onleaveattack") end,
			onattack       = function(event) 
				print("onattack")
				self:addAttackAnim()
				AM:runAnimation(self._spBody)
			end,
			onAttack       = function(event)
				print("onAttack")
			end,

			onbeforeWalk   = function(eveint) print("onbeforeWalk") end,
			onwalk         = function(eveint)
				print("onwalk")
				self:addWalkAnim()
				AM:runAnimation(self._spBody)
			end,
			onWalk         = function(event)
				print("onWalk")
			end
		}
	})
	self.StateMachine = StateMachine
end

function Writer:addWalkAnim()
	local animName
	if self._weapon == "Punch" then
		animName = "PlayerWriterWalkUnarmed"
	else
		animName = "PlayerWriterWalk" .. self._weapon
	end
	AM:addAnimation(self._spBody, animName)
end

-- 更新self._animation中的动画
local isFirstAttack = true
function Writer:addAttackAnim()
	local animName = "PlayerWriterAttack" .. self._weapon
	-- 需要反转X轴获得第二个动画
	if self._weapon == "Punch" then
		-- loop == false则播放一次之后就会被释放掉
		AM:addAnimation(self._spBody, animName)
		self._animName = "Attack" .. self._weapon
		-- 切换动画1和动画2
		if isFirstAttack then
			self._spBody:setFlippedY(true)
			isFirstAttack = false
		else
			self._spBody:setFlippedY(false)
			isFirstAttack = true
		end
	end
end

local function startAttackCallback(self)
	-- add anim to animPool
	self:addAttackAnim()
	AM:runAnimation(self._spBody)
end

function Writer:startAttack(touchPoint)
	-- self._preAnimName = self._animName
	-- self.startAttackCallback = startAttackCallback
	-- self.super.startAttack(self, touchPoint)
	if self.StateMachine:isFinishedState() then
		self.StateMachine:doEvent("Attack")
	end
end

local function updateAttackCallback(...)
	print("updateAttackCallback")
end

function Writer:updateAttack(touchPoint)
	self.updateAttackCallback = updateAttackCallback
	self.super.updateAttack(self, touchPoint)
end

local function endAttackCallback(...)
	print("endAttackCallback")
end

function Writer:endAttack()
	-- self.endAttackCallback = endAttackCallback
	-- self.super.endAttack(self)
	-- AM:addAnimation(self._spBody, ANIM_PREFIX .. self._preAnimName)
	-- -- self._preAnimName = self._animName
	-- self._animName = self._preAnimName
	if self.StateMachine then
		self.StateMachine:doEvent("Walk")
	end
end