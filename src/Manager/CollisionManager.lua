
CollisionManager = class("CollisionManager")

CollisionManager._collisionLayer = nil

function CollisionManager:getInstance(...)
    if CollisionManager._instance == nil then
        CollisionManager._instance = CollisionManager:ctor(...)
    end
    return CollisionManager._instance
end

function CollisionManager:ctor(...)
    local collisionLayer = cc.Layer:create()
	local contactListener = cc.EventListenerPhysicsContact:create()
	contactListener:registerScriptHandler(function (...) return self:onContactBegin(...) end,
                                            cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
	contactListener:registerScriptHandler(function (...) return self:onContactPreSolve(...) end,
                                            cc.Handler.EVENT_PHYSICS_CONTACT_PRESOLVE)
    contactListener:registerScriptHandler(function (...) self:onContactPostSolve(...) end,
                                            cc.Handler.EVENT_PHYSICS_CONTACT_POSTSOLVE)
    contactListener:registerScriptHandler(function (...) self:onContactSeperate(...) end,
                                            cc.Handler.EVENT_PHYSICS_CONTACT_SEPARATE)
	EventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, collisionLayer)
    DM:storeValue("CollisionLayer", collisionLayer)
    self._collisionLayer = collisionLayer
	return self
end

function CollisionManager:dtor(...)
    DM:removeValue("CollisionLayer")
end

function CollisionManager:onContactBegin(contact)
    print("onContactBegin")
    return true
end

function CollisionManager:onContactPreSolve(contact)
    -- print("onContactPreSolve")
    return true
end

function CollisionManager:onContactPostSolve(contact)
    -- print("onContactPostSolve")
end

function CollisionManager:onContactSeperate(contact)
    print("onContactSeperate")
end

CM = CollisionManager
