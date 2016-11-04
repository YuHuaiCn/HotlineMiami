
Player = class("Player", Alive)

Player._preFollowedPoint = cc.p(-1000, -1000)
Player._mouse = nil
Player._bodyShape = nil  -- {shape = "rect", value = {width = 15, height = 26}, offset = cc.p(-2, 0)}
Player._weapon = nil
Player._animation = nil
Player._spBody = nil
Player._spLeg = nil
-- 回调函数
Player.startAttackCallback = nil
Player.updateAttackCallback = nil
Player.endAttackCallback = nil
Player._animName = ""  -- 当前_animation中动画的名称
Player._state = 0

-- player state
local PLAYER_STATE_ATTACKING = 1
local PALYER_STATE_NULL = 0

local PLAYER_CONTACT_MASK   = 0x1
local PLAYER_CATEGORY_MASK  = 0x1
local PLAYER_COLLISION_MASK = 0x1

local PLAYER_MATERIAL = {density = 0.1, friction = 0, restitution = 0.1}

function Player:ctor(args)
    Player.super.ctor(self, args)
    local spLeg = cc.Sprite:create()
    local spBody = cc.Sprite:create()
    self:addChild(spLeg, 0, "Leg")
    self:addChild(spBody, 0, "Body")
    self._spBody = spBody
    self._spLeg  = spLeg
    local body
    if self._bodyShape.shape == "rect" then
        body = cc.PhysicsBody:createBox(self._bodyShape.value, PLAYER_MATERIAL)
    elseif self._bodyShape.shape == "circle" then
        body = cc.PhysicsBody:createBox(self._bodyShape.value, PLAYER_MATERIAL)
    else
        body = cc.PhysicsBody:createBox(16, PLAYER_MATERIAL)
    end
    body:setContactTestBitmask(PLAYER_CONTACT_MASK)
    body:setCategoryBitmask(PLAYER_CATEGORY_MASK)
    body:setCollisionBitmask(PLAYER_COLLISION_MASK)
    body:setLinearDamping(26.8)
    body:setAngularDamping(10)
    body:setMoment(50000)
    self:setPhysicsBody(body)
end

function Player:startFollow(touchPoint)
	local lcPosition = self:getParent():convertToNodeSpace(touchPoint)
	-- creat follow point: mouse
    local mouse = cc.Sprite:create("Atlases/Weapon/Bat.png")
    local mouseBody = cc.PhysicsBody:create(PHYSICS_INFINITY, PHYSICS_INFINITY)
    local spBody = self:getChildByName("Body")
    mouseBody:setDynamic(false)
    mouse:setPhysicsBody(mouseBody)
    mouse:setPosition(lcPosition)
    self:getParent():addChild(mouse)
    self._mouse = mouse
    -- create joint
    local selfBody = self:getPhysicsBody()
    local joint = cc.PhysicsJointPin:construct(selfBody, mouseBody, cc.p(0, 0), cc.p(0, 0))
    joint:setMaxForce(self._runSpeed * selfBody:getMass())
    DM:getValue("PhysicsWorld"):addJoint(joint)
    -- run leg animation
    AM:runAnimation(self:getChildByName("Leg"))
    -- run body anim
    AM:runAnimation(spBody)
    -- init leg rotation
    self._preFollowedPoint = cc.p(-1000, -1000)
    self:updateLegRotation(lcPosition)
end

function Player:updateFollow(touchPoint)
	local lcPosition = self:getParent():convertToNodeSpace(touchPoint)
	self._mouse:setPosition(lcPosition)
    self:updateLegRotation(lcPosition)
end

function Player:endFollow()
	self._mouse:removeFromParent()
	self._mouse = nil
    self._preFollowedPoint = cc.p(-1000, -1000)
    -- pause leg animation
    AM:pauseAnimation(self:getChildByName("Leg"))
    -- pause body anim
    AM:pauseAnimation(self:getChildByName("Body"))
end

function Player:startAttack(touchPoint)
    local lcPosition = self:getParent():convertToNodeSpace(touchPoint)
    -- local spBody = self:getChildByName("Body")
    local curRotation = self:getRotation()
    local angle = self:calRotationDegree(lcPosition)
    -- calculate turn degree
    local trueTurn = math.abs(angle - curRotation)
    trueTurn = trueTurn - 360 * (math.floor(trueTurn / 360))
    if trueTurn > 180 then
        trueTurn = 360 - trueTurn
    end
    local rotTime = trueTurn / (self._turnSpeed * 180 / math.pi)
    local action = cc.RotateTo:create(rotTime, angle)
    local acf = cc.CallFunc:create(self.startAttackCallback)
    local seq = cc.Sequence:create(action, acf)
    self._state = PLAYER_STATE_ATTACKING
    self:runAction(seq)
end

function Player:turnToPoint(touchPoint)
    local lcPosition = self:getParent():convertToNodeSpace(touchPoint)
    -- local spBody = self:getChildByName("Body")
    local curRotation = self:getRotation()
    local angle = self:calRotationDegree(lcPosition)
    -- calculate turn degree
    local trueTurn = math.abs(angle - curRotation)
    trueTurn = trueTurn - 360 * (math.floor(trueTurn / 360))
    if trueTurn > 180 then
        trueTurn = 360 - trueTurn
    end
    local rotTime = trueTurn / (self._turnSpeed * 180 / math.pi)
    local action = cc.RotateTo:create(rotTime, angle)
    local acf = cc.CallFunc:create(self.turnEndCallback)
    local seq = cc.Sequence:create(action, acf)
    self._state = PLAYER_STATE_ATTACKING
    self:runAction(seq)
end

function Player:updateAttack(touchPoint)
    -- print("Player:updateAttack(touch)")
    local lcPosition = self:getParent():convertToNodeSpace(touchPoint)
    self:updateBodyRotation(lcPosition)
end

function Player:endAttack()
    
end

function Player:updateBodyRotation(tarPoint)
    -- print("Player:updateBodyRotation()")
    if not tarPoint then
        printError("tarPoint is a nil value")
        return
    end
    local angle = self:calRotationDegree(tarPoint)
    self:setRotation(angle)  -- lockwise
end

function Player:updateLegRotation(tarPoint)
    if not tarPoint then
        printError("tarPoint is a nil value")
        return
    end
    if math.abs(tarPoint.x - self._preFollowedPoint.x) < 10 and
       math.abs(tarPoint.y - self._preFollowedPoint.y) < 10 then
        return
    end
    local angle = self:calRotationDegree(tarPoint)  -- tarPoint相对于self的角度
    local selfRot = self:getRotation()
    local spLeg = self:getChildByName("Leg")
    if spLeg then
        spLeg:setRotation(angle - selfRot)  -- leg相对于self的角度
    end
end

function Player:calRotationDegree(tarPoint)
    if not tarPoint then
        printError("tarPoint is a nil value")
        return
    end
    local selfPoint = cc.p(self:getPosition())
    local v2_self2tar = cc.pSub(tarPoint, selfPoint)
    local angle = cc.pGetAngle(cc.p(1, 0), v2_self2tar)  -- anticlockwise
    angle = angle * 180 / math.pi
    return -angle   -- clockwise
end
