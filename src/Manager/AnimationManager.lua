
AnimationManager = class("AnimationManager")

AnimationManager.animConfig = require "Manager.AnimationConfig"

local function getAnimConfig(animName)

end

local function getPath(animName)
    local upIndex = {}  -- capital letters' index in animName
    local path = {}     -- sub pathes split from animName
    local pngPath = ''
    local index = 0
    for _, nChar in ipairs({string.byte(animName, 1, -1)}) do
        index = index + 1
        -- if this Char is upper save it
        if nChar >= 65 and nChar <= 90 then
            table.insert(upIndex, index)
        end
    end
    local lastIndex = 1
    for i = 2, #upIndex do
        table.insert(path, string.sub(animName, lastIndex, upIndex[i] - 1))
        lastIndex = upIndex[i]
    end
    -- push last sub path
    table.insert(path, string.sub(animName, lastIndex, -1))

    return path
end

local function createAnimationFromPath(path)
    -- create animation
    local animation = nil
    local frameList = {}
    local animPathHome = string.format("Atlases/%s/%s", path[1], path[2])  -- path of anim eg: Atlases/Player/Write
    local plistName = string.format("%s/%s.plist", animPathHome, path[1] .. path[2])
    local frameCache = cc.SpriteFrameCache:getInstance()
    frameCache:addSpriteFrames(plistName)

    -- load Frames from FrameCache
    local frames = 0
    -- find frames and store it to frameList
    local function createInPath(path)
        for i = 0, 999 do
            local pngName = string.format("%s/%03d.png", path, i)
            print(pngName)
            local spriteFrame = frameCache:getSpriteFrameByName(pngName)
            if spriteFrame then
                --animation:addSpriteFrame(spriteFrame)
                table.insert(frameList, spriteFrame)
                frames = frames + 1
            else
                return frames
            end
        end
    end

    -- get target path
    local function getAnimPath(pathName)
        local animPath = animPathHome
        if pathName == 'normal' then
            if #path < 3 then
                print("Can't find anim: " .. animName)
                return
            end
            for i = 3, #path do
                animPath = animPath .. '/' .. path[i]
            end
        elseif pathName == 'father' then
            if #path < 4 then
                print("Can't find anim: " .. animName)
                return
            end
            for i = 3, #path - 1 do
                animPath = animPath .. '/' .. path[i]
            end
            animPath = animPath .. path[#path]
        elseif pathName == "grand" then
            if #path < 5 then
                print("Can't find anim: " .. animName)
                return
            end
            for i = 3, #path - 2 do
                animPath = animPath .. '/' .. path[i]
            end
            animPath = animPath .. path[#path - 1] .. path[#path]
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
    -- create animation
    if frames ~= 0 then  -- finded
        animation = cc.Animation:createWithSpriteFrames(frameList, 5/40)
        animation:setRestoreOriginalFrame(true)
    end
    return animation, frameList[1]
end

function AnimationManager:runAnimation(node, animName, loop)
    loop = loop or false
    local path = getPath(animName)
    local animation, firstFrame = createAnimationFromPath(path)
    if animation then
        node:setSpriteFrame(firstFrame)
        local action = cc.Animate:create(animation)
        if loop then
            node:runAction(cc.RepeatForever:create(action))
        else
            node:runAction(action)
        end
    else
        print("Can't find anim: " .. animName)
    end       
end

AM = AnimationManager