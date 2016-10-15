
Player = class("Player", Alive)

Player._preFollowedPoint = cc.p(-1000, -1000)
Player._mouse = nil

function Player:ctor(contSize, args)
    Player.super.ctor(self, args)
    if not contSize or not contSize.width or not contSize.height then
        contSize = {width = 32, height = 32}
    end
    local writerLeg = cc.Sprite:create()
    local writerBody = cc.Sprite:create()
    self:addChild(writerLeg, 0, "Leg")
    self:addChild(writerBody, 0, "Body")
    local body = cc.PhysicsBody:createCircle(contSize.width / 2, 
                            {density = 0.1, friction = 0, restitution = 0.1})
    body:setContactTestBitmask(0x1)
    body:setLinearDamping(26.8)
    body:setAngularDamping(10)
    self:setPhysicsBody(body)
end

function Player:startFollow(touch)
	local wdPosition = touch:getLocation()
	local lcPosition = self:getParent():convertToNodeSpace(wdPosition)
	-- creat follow point: mouse
    local mouse = cc.Node:create()
    local mouseBody = cc.PhysicsBody:create(PHYSICS_INFINITY, PHYSICS_INFINITY)
    mouseBody:setDynamic(false)
    mouse:setPhysicsBody(mouseBody)
    mouse:setPosition(lcPosition)
    self:getParent():addChild(mouse)
    self._mouse = mouse
    -- create joint
    local selfBody = self:getPhysicsBody()
    local selfSize = self:getContentSize()
    local joint = cc.PhysicsJointPin:construct(selfBody, mouseBody, cc.p(0, 0), cc.p(0, 0))
    joint:setMaxForce(self._runSpeed * selfBody:getMass() / 2)
    DM:getValue("PhysicsWorld"):addJoint(joint)
    -- run leg animation
    AM:runAnimation(self:getChildByName("Leg"))
    -- init leg rotation
    self._preFollowedPoint = cc.p(-1000, -1000)
    self:updateLegRotation(lcPosition)
end

function Player:updateFollow(touch)
	local wdPosition = touch:getLocation()
	local lcPosition = self:getParent():convertToNodeSpace(wdPosition)
	self._mouse:setPosition(lcPosition)
    self:updateLegRotation(lcPosition)
end

function Player:endFollow()
	self._mouse:removeFromParent()
	self._mouse = nil
    self._preFollowedPoint = cc.p(-1000, -1000)
    -- pause leg animation
    AM:pauseAnimation(self:getChildByName("Leg"))
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
    local selfPoint = cc.p(self:getPosition())
    local v2_self2tar = cc.pSub(tarPoint, selfPoint)
    local angle = cc.pGetAngle(cc.p(1, 0), v2_self2tar)  -- anticlockwise
    angle = angle * 180 / math.pi
    local spLeg = self:getChildByName("Leg")
    if spLeg then
        spLeg:setRotation(-angle)  -- lockwise
    end
end


function Player:startAttack(touch)
    -- print("Player:startAttack(touch)")
    local wdPosition = touch:getLocation()
    local lcPosition = self:getParent():convertToNodeSpace(wdPosition)
    self:updateBodyRotation(lcPosition)
end

function Player:updateAttack(touch)
    -- print("Player:updateAttack(touch)")
    local wdPosition = touch:getLocation()
    local lcPosition = self:getParent():convertToNodeSpace(wdPosition)
    self:updateBodyRotation(lcPosition)
end

function Player:endAttack()
    -- print("Player:endAttack()")

end

function Player:updateBodyRotation(tarPoint)
    -- print("Player:updateBodyRotation()")
    if not tarPoint then
        printError("tarPoint is a nil value")
        return
    end
    local selfPoint = cc.p(self:getPosition())
    local v2_self2tar = cc.pSub(tarPoint, selfPoint)
    local angle = cc.pGetAngle(cc.p(1, 0), v2_self2tar)  -- anticlockwise
    angle = angle * 180 / math.pi
    local spBody = self:getChildByName("Body")
    if spBody then
        spBody:setRotation(-angle)  -- lockwise
    end
end
