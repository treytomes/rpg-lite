Rectangle = {}

Rectangle.make = function(x, y, width, height)
	return Rectangle.make(x, y, width, height)
end function

Rectangle.make = function(x, y, width, height)
	r = new Rectangle
	r.x = x
	r.y = y
	r.width = width
	r.height = height
	return r
end function

Rectangle.left = function()
	return self.x
end function

Rectangle.right = function()
	return self.x + self.width - 1
end function

Rectangle.bottom = function()
	return self.y
end function

Rectangle.top = function()
	return self.y + self.height - 1
end function

Rectangle.bottomLeft = function()
	return point.make(self.left, self.top)
end function

Rectangle.bottomRight = function()
	return point.make(self.right, self.top)
end function

Rectangle.topLeft = function()
	return point.make(self.left, self.bottom)
end function

Rectangle.topRight = function()
	return point.make(self.right, self.bottom)
end function

Rectangle.corners = function()
	return [ self.bottomLeft, self.bottomRight, self.topLeft, self.topRight ]
end function

Rectangle.centerX = function()
	return floor(self.x + self.width / 2)
end function

Rectangle.centerY = function()
	return floor(self.y + self.height / 2)
end function

// `thing` can be a Rectangle, Point, or list of Rectangles or Points recursively.
Rectangle.contains = function(thing)
	if thing isa math.Point or (thing.indexes.contains("x") and thing.indexes.contains("y")) then
        // Duck type it if necessary.
		return math.isInRange(thing.x, self.left, self.right) and math.isInRange(thing.y, self.top, self.bottom)
	else if thing isa Rectangle then
		return self.contains(self.corner)
	else if thing isa list then
		for pnt in thing
			if not self.contains(pnt) then return false
		end for
		return true
	end if
    return false
end function

// `thing` can be a Rectangle, Point, or list of Rectangles or Points recursively.
Rectangle.intersects = function(thing)
	if thing isa point.Point then
		return self.contains(thing)
	else if thing isa Rectangle then
		return self.left <= thing.right and thing.left <= self.right and self.top <= thing.bottom and thing.top <= self.bottom
	else if thing isa list then
		for pnt in thing
			if pnt.contains(thing) then return true
		end for
		return false
	end if
end function

return Rectangle