-- Helper file for The Cranking of Isaiah
-- Contains scene logic for the main menu
-- TODO: Split main menu logic into its own file

import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/nineslice"
import "gameScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('MainMenuScene').extends(gfx.sprite)

-- main menu variables
local mainMenu = pd.ui.gridview.new(0, 32)
local mainMenuSprite = gfx.sprite.new()
local menuOptions = {"New Run", "Continue", "Settings", "Credits"}

-- Constructor
function MainMenuScene:init()
   -- local backgroundImage = gfx.image.new("img/background.png")
   -- gfx.sprite.setBackgroundDrawingCallback(function()
   --    backgroundImage:draw(0, 0)
   -- end)

   mainMenu:setNumberOfRows(#menuOptions)
   mainMenu:setCellPadding(2, 2, 2, 2)

   mainMenu.backgroundImage = gfx.nineSlice.new("img/gridBox.png", 7, 7, 18, 18)
   mainMenu:setContentInset(5, 5, 5, 5)

   mainMenu:setSectionHeaderHeight(24)

   mainMenuSprite:setCenter(0, 0)
   mainMenuSprite:moveTo(110, 20)
   mainMenuSprite:add()

   self:add()
end

-- Function override for gridview headers
function mainMenu:drawSectionHeader(section, x, y, width, height)
   local fontHeight = gfx.getSystemFont():getHeight()
   gfx.drawTextAligned("*The Cranking of Isaiah*", x + width / 2, y + (height/2 - fontHeight/2) + 2, kTextAlignment.center)
end

-- Function override for drawing each gridview cell
function mainMenu:drawCell(section, row, column, selected, x, y, width, height)
   if selected then
      gfx.fillRoundRect(x, y, width, height, 4)
      gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
   else
      gfx.setImageDrawMode(gfx.kDrawModeCopy)
   end

   local fontHeight = gfx.getSystemFont():getHeight()
   gfx.drawTextInRect(menuOptions[row], x, y + (height/2 - fontHeight/2) + 2, width, height, nil, nil, kTextAlignment.center)
end

-- Handle all button inputs
function MainMenuScene:processButtons()
   -- handle menu navigation
   if pd.buttonJustPressed("up") then
      mainMenu:selectPreviousRow(true)
   elseif pd.buttonJustPressed("down") then
      mainMenu:selectNextRow(true)
   end

   -- handle A/B buttons
   if (pd.buttonJustPressed("B")) then
      SCENE_MANAGER:switchScene(GameScene, "fade")
   end
end

-- Update function to be run every tick
function MainMenuScene:update()
   gfx.clear()
   self:processButtons()

   -- draw main menu
   if mainMenu.needsDisplay then
      local mainMenuImage = gfx.image.new(180, 200)
      gfx.pushContext(mainMenuImage)
         mainMenu:drawInRect(0, 0, 180, 200)
      gfx.popContext()
      mainMenuSprite:setImage(mainMenuImage)
   end

   gfx.sprite.update()
end
