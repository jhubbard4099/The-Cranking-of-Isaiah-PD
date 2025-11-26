-- Helper file for The Cranking of Isaiah
-- Contains scene logic for main gameplay

import "mainMenuScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameOverScene').extends(gfx.sprite)

-- Game over screne init function
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

function GameOverScene:processButtons()
   if (pd.buttonJustPressed("B")) then
      SCENE_MANAGER:switchScene(MainMenuScene)
   end
end

-- Game scene update function
function GameOverScene:update()
   gfx.clear()
   self:processButtons()
   gfx.sprite.update()
end

