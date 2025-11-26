-- Main file for The Cranking of Isaiah
-- Contains main game parameters and logic

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"
import "CoreLibs/timer"

import "sceneManager"
import "gameScene"

SCENE_MANAGER = SceneManager()

MainMenuScene()

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

-- debug info
globalDebugDisplay = true


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
      globalDebugDisplay = true
   else
      globalDebugDisplay = false
   end
end


--------------------
-- MAIN FUNCTIONS --
--------------------

-- Main PD functionality performed every refresh
function pd.update()
   pd.timer.updateTimers()
   gfx.sprite.update()
end


-------------------
-- INIT FUNCTION --
-------------------

function init()
   -- set global properties
   pd.display.setRefreshRate(50)
   pd.drawFPS(380, 0)

   -- create system menu options
   local menu = pd.getSystemMenu()
   menu:addCheckmarkMenuItem("Debug", true, toggleDebug)
end

init()
