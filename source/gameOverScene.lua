-- Helper file for The Cranking of Isaiah
-- Contains scene logic for the game over screen

import "mainMenuScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameOverScene').extends(gfx.sprite)

-- Constructor
-- Parameters: text - string to display
function GameOverScene:init(text)
   local gameOverImage = gfx.image.new(gfx.getTextSize(text))

   gfx.pushContext(gameOverImage)
      gfx.drawText(text, 0, 0)
   gfx.popContext()

   local gameOverSprite = gfx.sprite.new(gameOverImage)
   gameOverSprite:moveTo(200, 120)
   gameOverSprite:add()

   self:add()
end

-- Handle all button inputs
function GameOverScene:processButtons()
   if (pd.buttonJustPressed("B")) then
      SCENE_MANAGER:switchScene(MainMenuScene, "none")
   end
end

-- Update function to be run every tick
function GameOverScene:update()
   gfx.clear()
   self:processButtons()
   gfx.sprite.update()
end

