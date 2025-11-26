-- Helper file for The Cranking of Isaiah
-- Contains scene logic for main gameplay

import "player"
import "projectile"
import "gameOverScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameScene').extends(gfx.sprite)
local player = Player(200, 120)

-- Constructor
function GameScene:init()
   -- local backgroundImage = gfx.image.new("img/background.png")
   -- gfx.sprite.setBackgroundDrawingCallback(function()
   --    backgroundImage:draw(0, 0)
   -- end)

   player:add()
   self:add()
end

-- Handle all button inputs
function GameScene:processButtons()
   local tempX, tempY = player:getPosition(0)

   -- handle X-axis
   if (pd.buttonIsPressed("right")) then
      tempX += player.playerSpeed
   end
   if (pd.buttonIsPressed("left")) then
      tempX -= player.playerSpeed
   end
   tempX = clamp(tempX, MIN_X, MAX_X)

   -- handle Y-axis
   if (pd.buttonIsPressed("down")) then
      tempY += player.playerSpeed
   end
   if (pd.buttonIsPressed("up")) then
      tempY -= player.playerSpeed
   end
   tempY = clamp(tempY, MIN_Y, MAX_Y)

   -- actually update player location
   player:moveTo(tempX, tempY)

   -- handle A/B buttons
   if (pd.buttonJustPressed("B")) then
      SCENE_MANAGER:switchScene(GameOverScene, "wipe", "*YOU DIED*")
   end
   if (pd.buttonJustPressed("A")) then
      tempX, tempY = player:getPosition(0)
      local projectile = Projectile(tempX, tempY, player:getRotation(), player.playerSpeed)
      projectile:add()
   elseif (pd.buttonJustPressed("B")) then
      -- TODO
      -- pd.stop()
   end
end

-- Update function to be run every tick
function GameScene:update()
   gfx.clear()
   self:processButtons()
   self:displayDebug()
   gfx.sprite.update()
end


---------------------
-- DEBUG FUNCTIONS --
---------------------

-- Prints out debug text if globalDebugDisplay is true
-- TODO: figure out why this isn't displaying
function GameScene:displayDebug()
   if (globalDebugDisplay) then
      gfx.setColor(gfx.kColorWhite)
      gfx.fillRect(0, 0, 150, 80)
      gfx.setColor(gfx.kColorBlack)
      gfx.drawRect(0, 0, 150, 80)

      gfx.drawText("speed:", 2, 0)
      gfx.drawText(player.playerSpeed, 60, 0)

      gfx.drawText("angle:", 2, 20)
      gfx.drawText(player:getRotation(), 60, 20)

      tempX, tempY = player:getPosition(0)
      gfx.drawText("coordX:", 2, 40)
      gfx.drawText(tempX, 60, 40)

      gfx.drawText("coordY:", 2, 60)
      gfx.drawText(tempY, 60, 60)

      pd.drawFPS(380, 0)
   end
end
