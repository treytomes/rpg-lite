TiledObject = {}

TiledObject.load = function(object)
    self.gid = object.gid
    self.height = object.height
    self.id = object.id
    self.name = object.name
    self.type = object.type
    self.visible = object.visible
    self.width = object.width
    self.x = object.x
    self.y = object.y
    return self
end function

return TiledObject
