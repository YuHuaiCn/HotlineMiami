
--AnimationManager = class("AnimationManager")

--AnimationManager.animConfig = require "AnimationConfig"

local AnimationManager = {}
function AnimationManager:getAnimConfig(animName)
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
	
end

function AnimationManager:runAnimation(node, animName, loop)
	animName = 'PlayerWriterWalkUnarmed'
	local config = {}

end

AnimationManager:getAnimConfig('PlayerWriterWalkUnarmed')