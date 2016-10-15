
local animConfig = {}


-- animConfig format: gap = 5, offset = (0, 0)
animConfig.Player = {}
	animConfig.Player.Writer = {}	
		animConfig.Player.Writer.Walk = {}
			animConfig.Player.Writer.Walk.Unarmed = {gap = 10, offset = {0, 0}}

	animConfig.Player.Nicke = {}
		animConfig.Player.Nicke.Leg = {gap = 5, offset = {-5, 0}}
		animConfig.Player.Nicke.Attack = {}
			animConfig.Player.Nicke.Attack.KnifeFlameThrower = {gap = 5, offset = {0, 0}}

return animConfig