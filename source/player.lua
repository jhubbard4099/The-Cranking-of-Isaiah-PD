local pd <const> = playdate
local gfx <const> = pd.graphics

local playerSpriteImage = gfx.image.new("img/aimTest.png")
class('Player').extends(gfx.sprite)

function Player:init(x, y)
    Player.super.init(self)
	self:setImage(playerSpriteImage)
	self:setScale(2)

    self:moveTo(x, y)
	self:setCollideRect( 0, 0, self:getSize() )

	-- establish original dimensions for later collision calculations
	local width, height = self:getSize()
	self.baseWidth = width
	self.baseHeight = height
end

function Player:collisionResponse(other)
	print(other:getRotation())
	return "overlap"
	-- if other:isA(Projectile) then
	-- 	return "overlap"
	-- else
	-- 	return "freeze"
	-- end
end

function Player:update()
	-- Do nothing if crank is docked
	if (not pd.isCrankDocked()) then
		local crankAngle = pd.getCrankPosition()
		-- local newImage = playerSpriteImage:rotatedImage(crankAngle)
		-- isaiahSprite:setImage(newImage)

		-- set rotation and adjust collision box
		self:setRotation(crankAngle)
		local _, _, offsetX, offsetY = self:getBounds()
    	offsetX, offsetY = offsetX * 0.5 - (self.baseWidth/2), offsetY * 0.5 - (self.baseHeight/2)
    	self:setCollideRect( offsetX, offsetY, self.baseWidth, self.baseHeight )

		return crankAngle
	else
		self:setRotation(0)
	end

    return 0
end
