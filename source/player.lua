-- Helper file for The Cranking of Isaiah
-- Contains class files for the player

local pd <const> = playdate
local gfx <const> = pd.graphics

local playerSpriteImage = gfx.image.new("img/aimTest.png")
class('Player').extends(gfx.sprite)

-- Player init function
-- Parameters: x, y - coordinates to initialize the player
function Player:init(x, y)
   Player.super.init(self)
   self:setImage(playerSpriteImage)
   self:setScale(2)

   self:moveTo(x, y)
   self:setCollideRect( 0, 0, self:getSize() )
   self.playerSpeed = 2

   -- establish original dimensions for later collision calculations
   local width, height = self:getSize()
   self.baseWidth = width
   self.baseHeight = height
end

-- Player collision handler
-- Parameters: other - object being collided with
-- Return: string representing what sort of collision to use
function Player:collisionResponse(other)
   return "overlap"
   -- if other:isA(Projectile) then
   -- 	return "overlap"
   -- else
   -- 	return "freeze"
   -- end
end

-- Player update function
-- Return: rotation angle of the player if crank isn't docked, 0 otherwise
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
