local pd <const> = playdate
local gfx <const> = pd.graphics

local projectileSpriteImage = gfx.image.new("img/shotTest.png")
class('Projectile').extends(gfx.sprite)

function Projectile:init(x, y, angle, speed)
    Projectile.super.init(self)
	self:setImage(projectileSpriteImage)

	-- local width, height = self:getSize()
	self:setCollideRect( 0, 0, self:getSize() )
    self:moveTo(x, y)

	-- establish original dimensions for later collision calculations
	local width, height = self:getSize()
	local baseWidth = width
	local baseHeight = height

	self:setRotation(angle)
	self.speed = speed

	-- set rotation and adjust collision box
	local width, height = self:getSize()
	local _, _, offsetX, offsetY = self:getBounds()
	offsetX, offsetY = offsetX * 0.5 - (baseWidth/2), offsetY * 0.5 - (baseHeight/2)
	self:setCollideRect( offsetX, offsetY, baseWidth, baseHeight )
end

function Projectile:collisionResponse(other)
	print(other:getRotation())
	return "overlap"
	-- if other:isA(Projectile) then
	-- 	return "overlap"
	-- else
	-- 	return "freeze"
	-- end
end

function Projectile:update()
	-- get rotation angle, adjust for PD, and get movement amount based off that
	local selfRotation = math.rad(self:getRotation() - 90)
	rawX = math.cos(selfRotation) * self.speed
	rawY = math.sin(selfRotation) * self.speed

	-- move, then check if out of bounds
	self:moveWithCollisions(self.x + rawX, self.y + rawY)
	if isOutOfBounds(self.x, MIN_X, MAX_X) or isOutOfBounds(self.y, MIN_Y, MAX_Y) then
		self:remove()
	end
end
