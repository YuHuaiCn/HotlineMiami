
AnimationManager = class("AnimationManager")

AnimationManager._animConfig = require "Manager.AnimationConfig"

local function getAnimConfigByPath(self, path)
    local config = self._animConfig
    -- get config  path is start with 'Atlases/' so remove it
    for subPath in path:sub(9, -1):gmatch("%a+") do
        config = config[subPath]
        if not config then
            break
        end
    end
    return config
end

local function getPathListFromString(animName)
    local upIndex = {}  -- capital letters' index in animName
    local path = {}     -- sub pathes split from animName
    local pngPath = ''
    local index = 0
    for _, nChar in ipairs({animName:byte(1, -1)}) do
        index = index + 1
        -- if this Char is upper save it
        if nChar >= 65 and nChar <= 90 then
            upIndex[#upIndex + 1] = index
        end
    end
    local lastIndex = 1
    for i = 2, #upIndex do
        path[#path + 1] = animName:sub(lastIndex, upIndex[i] - 1)
        lastIndex = upIndex[i]
    end
    -- push last sub path
    path[#path + 1] = animName:sub(lastIndex, -1)

    return path
end

local function getFramesFromPath(path)
    -- create animation
    local animation = nil
    local frameList = {}
    local animPathHome = "Atlases/" .. table.concat(path, '/', 1, 2)  -- path of anim eg: Atlases/Player/Write
    local plistName = string.format("%s/%s.plist", animPathHome, path[1] .. path[2])
    local frameCache = cc.SpriteFrameCache:getInstance()
    frameCache:addSpriteFrames(plistName)

    -- load Frames from FrameCache
    local frames = 0
    -- find frames and store it to frameList
    local function createInPath(path)
        for i = 0, 999 do
            local pngName = string.format("%s/%03d.png", path, i)
            local spriteFrame = frameCache:getSpriteFrame(pngName)
            if spriteFrame then
                --animation:addSpriteFrame(spriteFrame)
                frameList[#frameList + 1] = spriteFrame
                frames = frames + 1
            else
                return frames
            end
        end
    end

    -- get target path
    local function getAnimPath(pathName)
        local animPath
        if pathName == 'normal' then
            if #path < 3 then
                printError("Can't find anim: " .. table.concat(path, '/'))
                return
            end
            animPath = animPathHome .. '/' .. table.concat(path, '/', 3)
        elseif pathName == 'father' then
            if #path < 4 then
                printError("Can't find anim: " .. table.concat(path, '/'))
                return
            end
            animPath = animPathHome .. '/' .. table.concat(path, '/', 3, #path - 1) .. path[#path]
        elseif pathName == "grand" then
            if #path < 5 then
                printError("Can't find anim: " .. table.concat(path, '/'))
                return
            end
            animPath = animPathHome .. '/' .. table.concat(path, '/', 3, #path - 2) .. path[#path - 1] .. path[#path]
        end
        return animPath
    end

    -- first find in normal path
    local tarPath = nil
    tarPath = getAnimPath('normal')
    if tarPath then
        createInPath(tarPath)
        if frames == 0 then   -- can't find in normal path
            -- find in father path
            tarPath = getAnimPath('father')
            if tarPath then
                createInPath(tarPath)
                if frames == 0 then  -- can't find in father path
                    -- find in grand path
                    tarPath = getAnimPath('grand')
                    createInPath(tarPath)  -- if frames stil 0, can't find in grand path
                end
            end
        end
    end
    return frameList, tarPath
end


-------------------------------------------class function-------------------------------------------

function AnimationManager:runAnimation(node, animName, loop, speed)
    loop = loop or false
    speed = speed or 1
    local path = getPathListFromString(animName)
    local frameList, tarPath = getFramesFromPath(path)
    if frameList then
        node:setSpriteFrame(frameList[1])
        local config = getAnimConfigByPath(self, tarPath)
        if not config then
            config = {gap = 5, offset = {0, 0}}
        end
        -- set offset
        local offset = config.offset
        node:setPosition(offset[1], offset[2])
        -- create animation
        local animation = cc.Animation:createWithSpriteFrames(frameList, config.gap / 60)
        animation:setRestoreOriginalFrame(true)
        -- crate action
        local action = cc.Animate:create(animation)
        if loop then
            action = cc.RepeatForever:create(action)
        end
        local actSpeed = cc.Speed:create(action, speed)
        node:runAction(actSpeed)
        node._animation = actSpeed
    else
        printError("Can't find anim: " .. animName)
    end       
end

function AnimationManager:setSpeed(node, speed)
    speed = speed or 1
    local action = node._animation
    if action then
        action:setSpeed(speed)
    end
end

AM = AnimationManager