-- Helper file for The Cranking of Isaiah
-- Contains logic for managing multiple scenes

local pd <const> = playdate
local gfx <const> = pd.graphics

class('SceneManager').extends()

local transitionTypes = {"fade", "wipe"}

-- Constructor
function SceneManager:init()
   self.transitionTime = 500
   self.transitioning = false
end

-- Top level function for switching between different scenes
-- Parameters: scene - scene object to switch to
--             transitionType - string representing what kind of transition to use
--             ... - any additional info needed by a scene (ie. text to display)
function SceneManager:switchScene(scene, transitionType, ...)
   if self.transitioning then
      return
   end
   self.transitioning = true

   self.newScene = scene
   self.sceneArgs = ...

   local containsType = table.indexOfElement(transitionTypes, transitionType)
   if containsType then
      self:startTransition(transitionType)
   else
      self:loadNewScene()
   end
end

-- Cleans up current scene, then establishes new scene
function SceneManager:loadNewScene()
   self:cleanupScene()
   self.newScene(self.sceneArgs)
end

-- Handles visual transistion between scenes
-- Parameters: transitionType - string representing what kind of transition to use
function SceneManager:startTransition(transitionType)
   if transitionType == "wipe" then
      local transitionTimer = self:wipeTransition(0, 400)

      transitionTimer.timerEndedCallback = function()
         self:loadNewScene()
         transitionTimer = self:wipeTransition(400, 0)
         transitionTimer.timerEndedCallback = function()
            self.transitioning = false
         end
      end
   elseif transitionType == "fade" then
      local transitionTimer = self:fadeTransition(0, 1)

      transitionTimer.timerEndedCallback = function()
         self:loadNewScene()
         transitionTimer = self:fadeTransition(1, 0)
         transitionTimer.timerEndedCallback = function()
            self.transitioning = false
         end
      end
   end
end

-- Visual effect for performing a wipe transition
-- Parameters: startValue - x coordinate to start transition at
--             endValue - x coordinate to end transition at
-- Returns: timer object used to run current transition
function SceneManager:wipeTransition(startValue, endValue)
   local transitionSprite = self:createTransitionSprite()
   transitionSprite:setClipRect(0, 0, startValue, 240)

   -- TODO: test other easing functions
   local transitionTimer = pd.timer.new(self.transitionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
   transitionTimer.updateCallback = function(timer)
      transitionSprite:setClipRect(0, 0, timer.value, 240)
   end

   return transitionTimer
end

-- Visual effect for performing a wipe transition
-- Parameters: startValue - alpha value to start transition at
--             endValue - alpha value to end transition at
-- Returns: timer object used to run current transition
function SceneManager:fadeTransition(startValue, endValue)
   local transitionSprite = self:createTransitionSprite()
   transitionSprite:setImage(self:getFadedImage(startValue))

   -- TODO: test other easing functions
   local transitionTimer = pd.timer.new(self.transitionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
   transitionTimer.updateCallback = function(timer)
      transitionSprite:setImage(self:getFadedImage(timer.value))
   end

   return transitionTimer
end

-- Creates a partial fade depending on input alpha value
-- Parameters: alpha - alpha value to create image at
-- Returns: image faded at the given alpha value
function SceneManager:getFadedImage(alpha)
   local fadedImage = gfx.image.new(400, 240)

   gfx.pushContext(fadedImage)
      local filledRect = gfx.image.new(400, 240, gfx.kColorBlack)
      -- TODO: test other dither types
      filledRect:drawFaded(0, 0, alpha, gfx.image.kDitherTypeBayer8x8)
   gfx.popContext()

   return fadedImage
end

-- Creates a transition image and assigns it to a sprite
-- Returns: sprite containing a transition image
function SceneManager:createTransitionSprite()
   local filledRect = gfx.image.new(400, 240, gfx.kColorBlack)
   local transitionSprite = gfx.sprite.new(filledRect)

   transitionSprite:moveTo(200, 120)
   transitionSprite:setZIndex(9999)
   transitionSprite:setIgnoresDrawOffset(true)
   transitionSprite:add()

   return transitionSprite
end

-- Does all necessary cleanup of the scene being switched from
function SceneManager:cleanupScene()
   gfx.sprite.removeAll()
   self:removeAllTimers()
   gfx.setDrawOffset(0, 0)
end

-- Loops through all current timers and removes them
function SceneManager:removeAllTimers()
   local allTimers = pd.timer.allTimers()
   for _, timer in ipairs(allTimers) do
      timer:remove()
   end
end
