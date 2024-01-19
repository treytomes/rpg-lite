import "stringUtil"
import "textUtil"

Dialog = textUtil.Dialog
DialogButton = textUtil.DialogButton

SoundEditorDialog = new Dialog
SoundEditorDialog.make = function(message="Your message here.")
	dlog = new SoundEditorDialog
	dlog.title = "Sound Editor"
	dlog.message = message
	dlog.height = 24
	
	dlog.okBtn = new DialogButton
	dlog.okBtn.caption = "OK"
	dlog.okBtn.visible = true
	dlog.okBtn.key = char(10)  // (return key)
	
	dlog.altBtn = new DialogButton
	
	dlog.playBtn = new DialogButton
	dlog.playBtn.caption = "Play"
	dlog.playBtn.visible = true
	dlog.playBtn.key = "P"
	dlog.playBtn.x = dlog.left + 2
	dlog.playBtn.y = dlog.top - 1
	
	dlog.cancelBtn = new DialogButton
	dlog.cancelBtn.caption = "Cancel"
	dlog.cancelBtn.key = char(27) // (escape key)
	dlog.cancelBtn.visible = true
	
	dlog.msgLines = message.wrap(dlog.width-4)
	// dlog.height = dlog.msgLines.len + 4
	return dlog
end function

SoundEditorDialog.playSound = function()
	pew = new Sound
	pew.init 0.3, [8000,100], [1,0]
	pew.play
end function

SoundEditorDialog.handleKey = function(k)
	if k.code == code("p") then
		self.playSound
		return true	
	end if
	return false
end function

SoundEditorDialog.handleMouse = function()
	if self.playBtn.visible and self.playBtn.contains(mouse) then
		if self.playBtn.trackHit then
			// text.color = self.textColor
			text.backColor = self.backColor
			text.color = "#CCCCCC"  // (button color)
			self.playBtn.draw
			self.playSound
			return true
		end if
	end if
end function

SoundEditorDialog.drawContent = function(cols, rows)
	// text.color = self.textColor
	text.backColor = self.backColor
	text.color = "#CCCCCC"  // (button color)
	self.playBtn.draw
end function

if locals == globals then
	dlg = SoundEditorDialog.make("This is my message.")
	dlg.show
end if
