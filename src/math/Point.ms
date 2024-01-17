Point = {}

Point.init = function(x, y)
	self.x = x
	self.y = y
	return self
end function

Point.make = function(x, y=null)
    if x isa map then
        // Turn anything with x and y fields into a Point.
        return Point.make(x.x, x.y)
    end if
	return (new Point).init(x, y)
end function

Point.str = function()
	return "({0}, {1})".fill([ self.x, self.y ])
end function

Point.equals = function(other)
	return self.x == other.x and self.y == other.y
end function

Point.multiply = function(n)
	return (new Point).init(n * self.x, n * self.y)
end function

Point.negate = function()
	return (new Point).init(-self.x, -self.y)
end function

Point.add = function(pnt)
	return (new Point).init(self.x + pnt.x, self.y + pnt.y)
end function

Point.subtract = function(pnt)
	return (new Point).init(self.x - pnt.x, self.y - pnt.y)
end function

Point.sign = function(pnt)
	return (new Point).init(sign(self.x), sign(self.y))
end function

Point.scale = function(v)
	return (new Point).init(v * self.x, v * self.y)
end function

Point.floor = function()
	return (new Point).init(floor(self.x), floor(self.y))
end function

Point.length = function()
	return (self.x * self.x + self.y * self.y) ^ 0.5
end function

Point.zero = function()
	return (new Point).init(0, 0)
end function

Point.unitX = function()
	return (new Point).init(1, 0)
end function

Point.unitY = function()
	return (new Point).init(0, 1)
end function

return Point
