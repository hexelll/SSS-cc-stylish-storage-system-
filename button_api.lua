local button = {
    text = "button",
    x = 1,
    y = 1,
    bg_color = colors.gray,
    text_color = colors.white,
    switch = false,
    order = false,
    push_color = colors.gray,
    push_text_color = colors.white,
    current_color = colors.gray,
    current_text_color = colors.white,
    pressed = false
}
function button.new()
    local self = setmetatable({},button)
    return self
end
function button:set_text(text)
    self.text = text
end
function button:set_pos(bx,by)
    self.x = bx
    self.y = by
end
function button:base_color(bg_color,text_color)
    self.bg_color = bg_color
    self.text_color = text_color
end
function button:set_color(bg_color,text_color)
    self.current_color = bg_color
    self.current_text_color = text_color
end
function button:is_in(mx,my)
    return mx >= self.x and my == self.y and mx <= self.x+string.len(self.text)
end
function button:_interact(mx,my,command,args,command2,args2)
    if self:is_in(mx,my) and down then
        self:set_color(self.push_color,self.push_text_color)
        if command ~= nil and self.order == false then
            command(args)
        end
        self.order = true
    elseif down == false then
        if command2 ~= nil and self.order == true then
            command2(args)
        end
        self:set_color(self.bg_color,self.text_color)
        self.order = false
    end
    self:draw()
end
function button:set_switch(switch)
    self.switch = switch
end
function button:set_push_color(push_color,push_text_color)
    self.push_color = push_color
    self.push_text_color = push_text_color
end
function button:_switch(mx,my,command,args,command2,args2)
    if self:is_in(mx,my) and down then
        if not self.switch and not self.pressed then
            if command ~= nil then 
                command(args)
            end
            self.switch = true
        elseif self.switch and not self.pressed then
            if command2 ~= nil then 
                command2(args2)
            end
            self.switch = false
        end
    end

    if down then
        self.pressed = true 
    else
        self.pressed = false
    end
    
    if self.switch == false then
        self:set_color(self.bg_color,self.text_color)
    else
        self:set_color(self.push_color,self.push_text_color)
    end
    self:draw()
end
function button:draw()
    term.setCursorPos(self.x,self.y)
    term.setBackgroundColor(self.current_color)
    term.setTextColor(self.current_text_color)
    term.write(self.text)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end
function button:color_draw(col,text_col)
    term.setCursorPos(self.x,self.y)
    term.setBackgroundColor(col)
    term.setTextColor(text_col)
    term.write(self.text)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end
function button.__index(tab, key)
    return button[key]
end
down = false
return button


