key.clear

text.clear
gfx.clear
display(DisplayType.TILE_DECO).clear
display(DisplayType.TILE_BASE).clear
display(DisplayType.SPRITE).clear
display(DisplayType.SOLID).color = color.black
display(DisplayType.UI).clear
display(DisplayType.UI_PIXEL).clear
text.color = color.orange

print "Goodbye!"
reset
