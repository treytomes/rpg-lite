ConversationUI = {}

// Conversation management variables.
ConversationUI.conversationWindow = null
ConversationUI.visibleText = ""
ConversationUI.index = 0
ConversationUI.lastTextRender = 0

ConversationUI.isConversationRunning = function
    return self.conversationWindow != null
end function

ConversationUI.isTextDone = function
    return self.index == self.conversationText.len
end function

ConversationUI.isTextWaiting = function
    return self.visibleText.len > 0 and self.visibleText.splitLines.len % 6 == 0
end function

// The window can hold 6 lines of text.
ConversationUI.renderText = function(txt, blinkMessage = null)
    oldGfx = gfx
    globals.gfx = gui.scratchDisp
    gui.scratchDisp.clear color.blue

    lines = txt.splitLines
    lines.reverse // Because we render bottom-to-top.

    margin = 16
    x = 0
    y = 0

    count = 0
    for line in lines
        for ch in line
            gui.largeFont.print ch, margin + x, margin + y, 1, color.white
            x += gui.largeFont.chars[ch].width
        end for
        x = 0
        y += gui.largeFont.chars["X"].height

        count += 1
        if count > 6 then break // Don't bother continuing to draw invisible characters.
    end for

    // Draw the "Continue" indicator.
    if blinkMessage != null then
        size = math.measureString(blinkMessage, gui.smallFont)
        gui.smallFont.print blinkMessage, gfx.width - size.w, size.h
    end if

    self.conversationWindow.setContent gui.scratchDisp.getImage(0, 0, self.conversationWindow.width, self.conversationWindow.height), false
    globals.gfx = oldGfx
end function

ConversationUI.beginConversation = function(name, txt)
    if self.conversationWindow != null then return false

    // print "beginConversation"

    self.conversationWindow = gui.Window.make(WINDOW_WIDTH, WINDOW_HEIGHT, 25, 150, name)
    self.conversationWindow.goTo PIXEL_DISPLAY_WIDTH / 2, PIXEL_DISPLAY_HEIGHT - self.conversationWindow.height / 2 - 20
    self.conversationWindow.moveToFront

    self.conversationText = txt
    self.visibleText = ""
    self.index = 0
    self.lastTextRender = 0
    return true
end function

ConversationUI.manageConversation = function
    if self.isTextWaiting then
        // Good to keep typing.
        self.visibleText = ""
    else if self.isTextDone then
        self.conversationWindow.close
        self.conversationWindow = null
    end if
end function

ConversationUI.draw = function
    if self.isTextWaiting or self.isTextDone then
        blink = floor(time / 0.5) % 2 == 0
        if blink then
            if self.isTextWaiting then
                self.renderText self.visibleText, "Continue? <Enter>"
            else
                self.renderText self.visibleText, "Done. <Enter>"
            end if
        else
            self.renderText self.visibleText
        end if
    else
        if time - self.lastTextRender >= TEXT_RENDER_SPEED and self.index < self.conversationText.len then
            self.lastTextRender = time
            self.visibleText += self.conversationText[self.index]
            self.index += 1
            Sounds.click.play
            self.renderText self.visibleText, false
        end if
    end if
end function

globals.beginConversation = function(name, txt)
    ConversationUI.beginConversation name, txt
end function

return ConversationUI
