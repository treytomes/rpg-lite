FadeController = {}
FadeController.duration = 0.5

FadeController.fadeOut = function(duration = null)
    if duration == null then duration = self.duration

    display(DisplayType.TEXT).mode = displayMode.solidColor
    if duration == 0 then
        display(DisplayType.TEXT).color = color.black
        return
    end if

    startTime = time
    endTime = time + duration
    while time <= endTime
        display(DisplayType.TEXT).color = color.lerp(color.clear, color.black, (time - startTime) / duration)
    end while
end function

FadeController.fadeIn = function(duration = null)
    if duration == null then duration = self.duration

    if duration == 0 then
        display(DisplayType.TEXT).color = color.clear
        return
    end if

    startTime = time
    endTime = time + duration
    while time <= endTime
        display(DisplayType.TEXT).color = color.lerp(color.black, color.clear, (time - startTime) / duration)
    end while

    display(DisplayType.TEXT).mode = displayMode.text
end function

return FadeController