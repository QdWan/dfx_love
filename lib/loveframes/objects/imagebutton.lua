--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------
-- get the current require path
local path = string.sub(..., 1, string.len(...) - string.len(".objects.imagebutton"))
local loveframes = require(path .. ".libraries.common")

-- imagebutton object
local newobject = loveframes.NewObject("imagebutton", "loveframes_object_imagebutton", true)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function newobject:initialize()

	self.type = "imagebutton"
	self.text = "Image Button"
	self.width = 50
	self.height = 50
  self.draw_width = 50  --图片显示尺寸
  self.draw_height = 50
	self.internal = false
  self.hover = false
	self.down = false
	self.clickable = true
	self.enabled = true
	self.image = nil  --正常显示的图片
  self.image_hover = nil  --鼠标接触时显示的图片
  self.image_down = nil --按钮按下时显示的图片
	self.imagecolor = {255, 255, 255, 255}
	self.OnClick = nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function newobject:update(dt)
	
	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if not visible then
		if not alwaysupdate then
			return
		end
	end
	
	self:CheckHover()
	
	local hover = self.hover
	local downobject = loveframes.downobject
	local down = self.down
	local parent = self.parent
	local base = loveframes.base
	local update = self.Update
	
	if not hover then
		self.down = false
	else
		if downobject == self then
			self.down = true
		end
	end
	
	if not down and downobject == self then
		self.hover = true
	end
	
	-- move to parent if there is a parent
	if parent ~= base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if update then
		update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function newobject:draw()
	
	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local skins = loveframes.skins.available
	local skinindex = loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = skins[selfskin] or skins[skinindex]
	local drawfunc = skin.DrawImageButton or skins[defaultskin].DrawImageButton
	local draw = self.Draw
	local drawcount = loveframes.drawcount
	
	-- set the object's draw order
	self:SetDrawOrder()
		
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function newobject:mousepressed(x, y, button)

	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover = self.hover
	
	if hover and button == 1 then
		local baseparent = self:GetBaseParent()
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		self.down = true
		loveframes.downobject = self
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function newobject:mousereleased(x, y, button)
	
	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover = self.hover
	local down = self.down
	local clickable = self.clickable
	local enabled = self.enabled
	local onclick = self.OnClick

	if hover and down and clickable and button == 1 then
		if enabled then
			if onclick then
				onclick(self, x, y)
			end
		end
	end
	
	self.down = false

end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function newobject:SetText(text)

	self.text = text
	return self
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the object's text
--]]---------------------------------------------------------
function newobject:GetText()

	return self.text
	
end

--[[---------------------------------------------------------
	- func: SetClickable(bool)
	- desc: sets whether the object can be clicked or not
--]]---------------------------------------------------------
function newobject:SetClickable(bool)

	self.clickable = bool
	return self
	
end

--[[---------------------------------------------------------
	- func: GetClickable(bool)
	- desc: gets whether the object can be clicked or not
--]]---------------------------------------------------------
function newobject:GetClickable()

	return self.clickable
	
end

--[[---------------------------------------------------------
	- func: SetClickable(bool)
	- desc: sets whether the object is enabled or not
--]]---------------------------------------------------------
function newobject:SetEnabled(bool)

	self.enabled = bool
	return self
	
end

--[[---------------------------------------------------------
	- func: GetEnabled()
	- desc: gets whether the object is enabled or not
--]]---------------------------------------------------------
function newobject:GetEnabled()

	return self.enabled
	
end

--[[---------------------------------------------------------
	- func: SetImage(image)
	- desc: sets the object's image
--]]---------------------------------------------------------
function newobject:SetImage(image, image_hover, image_down)

	if type(image) == "string" then
		self.image = love.graphics.newImage(image)
    if image_hover then
      self.image_hover = love.graphics.newImage(image_hover)  --鼠标接触时显示的图片
    end
    if image_down then
      self.image_down = love.graphics.newImage(image_down) --按钮按下时显示的图片
    end
	else
		self.image = image
    self.image_hover = image_hover  --鼠标接触时显示的图片
    self.image_down = image_down --按钮按下时显示的图片
	end
  self.draw_width = self.image:getWidth()  --图片显示尺寸
  self.draw_height = self.image:getHeight()
  
	
	return self

end

--[[---------------------------------------------------------
	- func: GetImage()
	- desc: gets whether the object is enabled or not
--]]---------------------------------------------------------
function newobject:GetImage()

	return self.image

end

--[[---------------------------------------------------------
	- func: SizeToImage()
	- desc: makes the object the same size as its image
--]]---------------------------------------------------------
function newobject:SizeToImage()

	local image = self.image
	
	if image then
		self.width = self.draw_width
		self.height = self.draw_height
	end
	
	return self
	
end

--[[---------------------------------------------------------
	- func: SetImgSize(width, height)
	- desc: Set image draw Size
--]]---------------------------------------------------------
function newobject:SetImgSize(width, height)
    
  self.draw_width = width
  self.draw_height = height
    
	return self
	
end

--[[---------------------------------------------------------
	- func: GetImageSize()
	- desc: gets the size of the object's image
--]]---------------------------------------------------------
function newobject:GetImageSize()

	local image = self.image
	
	if image then
		return image:getWidth(), image:getHeight()
	end
	
end

--[[---------------------------------------------------------
	- func: GetImageWidth()
	- desc: gets the width of the object's image
--]]---------------------------------------------------------
function newobject:GetImageWidth()

	local image = self.image
	
	if image then
		return image:getWidth()
	end
	
end

--[[---------------------------------------------------------
	- func: GetImageWidth()
	- desc: gets the height of the object's image
--]]---------------------------------------------------------
function newobject:GetImageHeight()

	local image = self.image
	
	if image then
		return image:getHeight()
	end
	
end

--[[---------------------------------------------------------
	- func: SetColor(r, g, b, a)
	- desc: sets the object's color 
--]]---------------------------------------------------------
function newobject:SetColor(r, g, b, a)

	self.imagecolor = {r, g, b, a}
	return self
	
end

--[[---------------------------------------------------------
	- func: GetColor()
	- desc: gets the object's color 
--]]---------------------------------------------------------
function newobject:GetColor()

	return unpack(self.imagecolor)
	
end
