-- Main file for The Cranking of Isaiah
-- Contains main game parameters and logic

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

import "player"
import "projectile"


---------------------------
-- VARIABLES & CONSTANTS --
---------------------------

-- shorthand constants
local pd <const> = playdate
local gfx <const> = pd.graphics

-- constraint constants
MIN_X, MAX_X = 0, 400
MIN_Y, MAX_Y = 0, 240
MIN_SIZE, MAX_SIZE = 1, 50
MIN_SPEED, MAX_SPEED = 0, 10

-- player info
local isaiahSprite = Player(200, 120)
local playerX, playerY = 200, 120
local playerAngle = 180
local playerSpeed = 2

-- forward declarations
local inputHandlerGameplay
local inputHandlerPause

-- debug info
local displayDebug = true


--------------------
-- INPUT HANDLERS --
--------------------

-- Input handler for main gameplay
inputHandlerGameplay = {
   AButtonDown = function()
      local projectile = Projectile(playerX, playerY, playerAngle, playerSpeed)
      projectile:add()
   end,

   BButtonHeld = function()
      pd.stop()
      pd.inputHandlers.pop()
      pd.inputHandlers.push(inputHandlerPause)
   end
}

-- Input handler for when the game is paused
inputHandlerPause = {
   BButtonHeld = function()
      pd.start()
      pd.inputHandlers.pop()
      pd.inputHandlers.push(inputHandlerGameplay)
   end
}


----------------------
-- HELPER FUNCTIONS --
----------------------

-- Ensures a number doesn't go outside a given range
-- Parameters:	value - number to check
--             min - minimum value of the range
--             max - maxiumum value of the range
-- Return: the input number or the min/max if it exceeded one
function clamp(value, min, max)
   return math.max(math.min(value, max), min)
end

-- Simple function to report if a value is out of the given bounds
-- Parameters:	value - number to check
--             min - minimum bounds value
--             max - maxiumum bounds value
-- Return: true if the value is out of bounds, false otherwise
function isOutOfBounds(value, min, max)
   local bool = false;
   if value > max or value < min then
      bool = true
   end
   return bool
end


---------------------
-- DEBUG FUNCTIONS --
---------------------

-- Toggles the debug text display
-- Used for the system menu checkbox item
-- Parameters:	toggleBool - bool for if debug is enabled already
function toggleDebug(toggleBool)
   if (toggleBool) then
      displayDebug = true
   else
      displayDebug = false
   end
end

-- Prints out debug text if displayDebug is true
function debugText()
   if (displayDebug) then
      gfx.setColor(gfx.kColorWhite)
      gfx.fillRect(0, 0, 150, 80)
      gfx.setColor(gfx.kColorBlack)
      gfx.drawRect(0, 0, 150, 80)

      gfx.drawText("speed:", 2, 0)
      gfx.drawText(playerSpeed, 60, 0)

      gfx.drawText("angle:", 2, 20)
      gfx.drawText(playerAngle, 60, 20)

      gfx.drawText("coordX:", 2, 40)
      gfx.drawText(playerX, 60, 40)

      gfx.drawText("coordY:", 2, 60)
      gfx.drawText(playerY, 60, 60)
   end

   pd.drawFPS(380, 0)
end


--------------------
-- MAIN FUNCTIONS --
--------------------

-- Checks if any buttons are pressed and performs the
-- expected actions for ones that are
function updateButtons()
   -- check for speed updates
   -- if (pd.buttonIsPressed("a")) then
   -- 	playerSpeed += 0.05
   -- end
   -- if (pd.buttonIsPressed("b")) then
   -- 	playerSpeed -= 0.05
   -- end
   -- playerSpeed = clamp(playerSpeed, MIN_SPEED, MAX_SPEED)

   -- check for player movement
   if (pd.buttonIsPressed("right")) then
      playerX += playerSpeed
   end
   if (pd.buttonIsPressed("left")) then
      playerX -= playerSpeed
   end
   playerX = clamp(playerX, MIN_X, MAX_X)

   if (pd.buttonIsPressed("down")) then
      playerY += playerSpeed
   end
   if (pd.buttonIsPressed("up")) then
      playerY -= playerSpeed
   end
   playerY = clamp(playerY, MIN_Y, MAX_Y)
end

-- Main PD functionality performed every refresh
function pd.update()
   -- reset graphics
   gfx.clear()

   -- run button checks
   updateButtons()

   -- main test function
   playerAngle = isaiahSprite:update()

   -- draw player
   gfx.sprite.update()
   isaiahSprite:moveTo(playerX, playerY)

   -- draw debug info
   debugText()
end


-------------------
-- INIT FUNCTION --
-------------------

function init()
   -- set global properties
   pd.display.setRefreshRate(50)

   -- create system menu options
   local menu = pd.getSystemMenu()
   menu:addCheckmarkMenuItem("Debug", true, toggleDebug)

   -- initate gameplay handlers
   pd.inputHandlers.push(inputHandlerGameplay)

   -- add initial sprites
   isaiahSprite:add()
end

init()
