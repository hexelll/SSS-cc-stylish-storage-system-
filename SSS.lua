local button_api = {
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
function button_api.new()
    local self = setmetatable({},button_api)
    return self
end
function button_api:set_text(text)
    self.text = text
end
function button_api:set_pos(bx,by)
    self.x = bx
    self.y = by
end
function button_api:base_color(bg_color,text_color)
    self.bg_color = bg_color
    self.text_color = text_color
end
function button_api:set_color(bg_color,text_color)
    self.current_color = bg_color
    self.current_text_color = text_color
end
function button_api:is_in(mx,my)
    return mx >= self.x and my == self.y and mx <= self.x+string.len(self.text)
end
function button_api:_interact(mx,my,command,args,command2,args2)
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
function button_api:set_switch(switch)
    self.switch = switch
end
function button_api:set_push_color(push_color,push_text_color)
    self.push_color = push_color
    self.push_text_color = push_text_color
end
function button_api:_switch(mx,my,command,args,command2,args2)
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
function button_api:draw()
    term.setCursorPos(self.x,self.y)
    term.setBackgroundColor(self.current_color)
    term.setTextColor(self.current_text_color)
    term.write(self.text)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end
function button_api:color_draw(col,text_col)
    term.setCursorPos(self.x,self.y)
    term.setBackgroundColor(col)
    term.setTextColor(text_col)
    term.write(self.text)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end
function button_api.__index(tab, key)
    return button_api[key]
end
down = false

p = peripheral
tx,ty = term.getSize()
mx,my = 0,0

inv_names = {}
function update_invs()
    local invs = p.getNames()
    for i,inv in pairs(invs) do
        if inv_names[inv] == nil then
            inv_names[inv] = inv
        end
    end
    for inv,name in pairs(inv_names) do
        if p.wrap(inv) == nil then
            inv_names[inv] = nil
        end
    end
end

function inv_list(mx,my,startx,starty,color)
    local selected_storage = ""
    local selected_name = ""
    i = 0
    page = 0
    for inv,name in pairs(inv_names) do
        if p.hasType(inv,"inventory") then
            if starty+i >= ty-2 then
                page = page + 1
                i = 0    
            end
            inv_name = name
            name = button_api.new()
            name:set_text(tostring(inv_name))
            name:base_color(colors.black,colors.lightGray)
            name:set_color(name.bg_color,name.text_color)
            name:set_push_color(colors.black,colors.blue)
            name:set_pos(startx+p1*100-page*100,i+starty)
            term.setCursorPos(startx+20,i+starty)
            term.setTextColor(color)
            term.write('\127')
            name:draw()
            name:_switch(mx,my)
            if name.switch == true then
                selected_storage = p.wrap(inv)
                selected_name = inv_name
            end
            i= i +1
        end
    end
    return selected_storage,selected_name
end

function get_mouse_down()
    event,_button,mx,my = os.pullEvent("mouse_click")
    down = true
end
function get_mouse_up()
    event,_button,mx,my = os.pullEvent("mouse_up")
    down = false
end

update = button_api.new()
update:base_color(colors.gray,colors.white)
update:set_push_color(colors.lightGray,colors.black)
update:set_text("update")
update:set_pos(27,1)

rename = button_api.new()
rename:base_color(colors.gray,colors.white)
rename:set_push_color(colors.lightGray,colors.black)
rename:set_text("rename")
rename:set_pos(20,1)

open = button_api.new()
open:base_color(colors.gray,colors.white)
open:set_push_color(colors.lightGray,colors.black)
open:set_text("open")
open:set_pos(2,1)

move = button_api.new()
move:base_color(colors.gray,colors.white)
move:set_push_color(colors.lightGray,colors.black)
move:set_text("move")
move:set_pos(7,1)

display = button_api.new()
display:base_color(colors.black,colors.blue)
display:set_color(display.bg_color,display.text_color)
display:set_pos(1,2)
display:set_text(">-")

display2 = button_api.new()
display2:base_color(colors.black,colors.red)
display2:set_color(display2.bg_color,display2.text_color)
display2:set_pos(1,3)
display2:set_text(">-")

number_display = button_api.new()
number_display:base_color(colors.black,colors.yellow)
number_display:set_color(number_display.bg_color,number_display.text_color)
number_display:set_pos(1,11)

deposit = button_api.new()
deposit:base_color(colors.gray,colors.white)
deposit:set_color(deposit.bg_color,deposit.text_color)
deposit:set_push_color(colors.lightGray,colors.black)
deposit:set_text("deposit")
deposit:set_pos(12,1)

pu = button_api.new()
pu:base_color(colors.black,colors.lightGray)
pu:set_color(pu.bg_color,pu.text_color)
pu:set_push_color(colors.black,colors.gray)
pu:set_text(">")
pu:set_pos(tx,ty)

pd = button_api.new()
pd:base_color(colors.black,colors.lightGray)
pd:set_color(pu.bg_color,pu.text_color)
pd:set_push_color(colors.black,colors.gray)
pd:set_text("<")
pd:set_pos(tx-2,ty)

page_display = button_api.new()
page_display:base_color(colors.black,colors.lightGray)
page_display:set_color(page_display.bg_color,page_display.text_color)
page_display:set_text(0)
page_display:set_pos(tx-4,ty)

b1 = button_api.new() b2 = button_api.new() b3 = button_api.new()
b1:set_text("1")     b2:set_text("2")     b3:set_text("3")
b1:set_pos(1,8)       b2:set_pos(3,8)       b3:set_pos(5,8)
b1:set_push_color(colors.black,colors.lightGray) b2:set_push_color(colors.black,colors.lightGray) b3:set_push_color(colors.black,colors.lightGray)

b4 = button_api.new() b5 = button_api.new() b6 = button_api.new()
b4:set_text("4")     b5:set_text("5")     b6:set_text("6")
b4:set_pos(1,7)       b5:set_pos(3,7)       b6:set_pos(5,7)
b4:set_push_color(colors.black,colors.lightGray) b5:set_push_color(colors.black,colors.lightGray) b6:set_push_color(colors.black,colors.lightGray)

b7 = button_api.new() b8 = button_api.new() b9 = button_api.new() 
b7:set_text("7")     b8:set_text("8")     b9:set_text("9")
b7:set_pos(1,6)       b8:set_pos(3,6)       b9:set_pos(5,6)
b7:set_push_color(colors.black,colors.lightGray) b8:set_push_color(colors.black,colors.lightGray) b9:set_push_color(colors.black,colors.lightGray)

be = button_api.new() b0 = button_api.new() bR = button_api.new()
be:set_text("=")     b0:set_text("0")     bR:set_text("R")
be:set_pos(1,9)       b0:set_pos(3,9)       bR:set_pos(5,9)
be:set_push_color(colors.black,colors.lightGray) b0:set_push_color(colors.black,colors.lightGray) bR:set_push_color(colors.black,colors.lightGray)

item_display = button_api.new()
item_display:base_color(colors.black,colors.green)
item_display:set_color(item_display.bg_color,item_display.text_color)
item_display:set_text(">-")
item_display:set_pos(1,4)

function _deposit(args)
    if args.storage ~= "" and args.storage2 ~= "" then 
    for slot,item in pairs(args.storage.list()) do
        args.storage.pushItems(p.getName(args.storage2),slot)
    end
    end
end

function on_move(storage,storage2,number)
    item = show_inv(sel_storage,8,5)
    
    if item_ ~= "" then
        item_ = item
        item_display:set_text(">-"..item_)
    end

    if b0.order then number = number..0 end
    if b1.order then number = number..1 end
    if b2.order then number = number..2 end
    if b3.order then number = number..3 end
    if b4.order then number = number..4 end
    if b5.order then number = number..5 end
    if b6.order then number = number..6 end
    if b7.order then number = number..7 end
    if b8.order then number = number..8 end
    if b9.order then number = number..9 end
    if be.order then request = number end
    if item_ ~= "" and be.order and storage ~= "" and storage2 ~= "" then 
        move_items(item_,tonumber(request),storage,storage2) 
        term.clear()
    end
    if bR.order then number = "" end

    b1:_interact(mx,my) b2:_interact(mx,my) b3:_interact(mx,my)
    b4:_interact(mx,my) b5:_interact(mx,my) b6:_interact(mx,my)
    b7:_interact(mx,my) b8:_interact(mx,my) b9:_interact(mx,my)
    be:_interact(mx,my) b0:_interact(mx,my) bR:_interact(mx,my)

    number_display:set_text(number)
    number_display:draw()
    item_display:draw()
    sleep()
    return number
end

function move_items(_item,amount,input,output)
    for slot,item in pairs(input.list()) do
        if input.getItemDetail(slot).name == _item and amount >= 0 then
            input.pushItems(p.getName(output),slot,amount)
            amount = amount-item.count
        end
    end
end

function _rename(storage)
    if storage ~= "" then
        term.setCursorPos(1,2)
        term.clearLine()
        term.write(">-")
        input = read()
        inv_names[p.getName(storage)] = input
        update_invs()
    end
end

function display_list(storage)
    local inv_display = {}
    if storage.list() ~= nil then
    for slot,item in pairs(storage.list()) do
        if inv_display[item.name] == nil then
            inv_display[item.name] = item.count
        else
        inv_display[item.name] = inv_display[item.name]+item.count    
        end
    end
    end
    return inv_display
end

item_ = ""

function show_inv(storage,x,y)
    inc = 0
    page = 0
    if storage ~= "" then
    for item,count in pairs(display_list(storage)) do
        if y+inc >= ty-2 then
            page = page + 1 
            inc = 0   
        end
        item_button = item
        item_button = button_api.new()
        item_button:base_color(colors.black,colors.green)
        item_button:set_push_color(colors.black,colors.gray)
        item_button:set_pos(x+p1*100-page*100,y+1+inc)
        item_button:set_text("-"..item) 
        item_button:set_color(item_button.bg_color,item_button.text_color)
        item_button:_interact(mx,my)
        term.setTextColor(colors.lightGray)
        term.write(": "..count)
        inc = inc + 1
        if item_button.order then
            item_ = item 
        end
    end
    return item_
    end
end
sel_storage = ""
sel_storage2 = ""
sel_name = ""
sel_name2 = ""
number = ""
monitors = {}
win = ""
monitors_ = {}


function get_monitors()
    monitors_ = {}
    for i,name in pairs(p.getNames()) do
        if p.hasType(name,"monitor") then
            x,y = p.wrap(name).getSize()
            monitors_[name] = {p.wrap(name),window.create(p.wrap(name),1,1,x,y)} 
        end
    end
    monitors = monitors_[1]
    win = monitors_[2]
end

function get_invs()
    local inventories = {}
    for i,name in pairs(p.getNames()) do
        if p.hasType(name,"inventory") then
            inventories[name] = p.wrap(name)
        end
    end
    return inventories
end

p1 = 0
t1 = 0
j1 = 0

function monitor_display(wins,storage)
    if storage ~= "" then 
        local list = {}
        winx,winy = wins.getSize()
        wins.setVisible(false)
        wins.clear()
        for item,count in pairs(display_list(storage)) do
            table.insert(list,1,{item,count})
        end
        if t1 > 100000 then
            t1 = 0
        end
        wins.setCursorPos(1,1)
        wins.setTextColor(colors.blue)
        wins.write(p.getName(storage))
        for j=2,winy do
            wins.setCursorPos(1,j)
            if math.fmod(j+t1,table.maxn(list)+1) > 0 then
                wins.setTextColor(colors.green)
                wins.write(list[math.fmod(j+t1,table.maxn(list)+1)][1]..":")
                wins.setTextColor(colors.lightGray)
                wins.write(list[math.fmod(j+t1,table.maxn(list)+1)][2])
            end
            j1 = j
        end
        t1 = t1+1
        wins.setVisible(true)
    end
end
update_invs()
presentation = "storage system"
get_monitors()
t = 1

function move_page(page)
    if p1+page >= 0 then
        p1 = p1 + page
        page_display:set_text(p1)
    end
end

function unsequentials3()
    while true do
    
    for k,l in pairs(monitors_) do
        if l[1].getSize() ~= nil then
        monx,mony = l[1].getSize()
        if mony <= 5 then
            l[1].clear()
            l[1].setTextColor(colors.green)
            l[1].setTextScale(4)
            l[1].setCursorPos(t,1)
            l[1].write(presentation)
            if t > monx then
                t = -string.len(presentation)
            else 
                t = t + 1
            end
        end
        end
    end
    sleep(0.2)
    end
end

function unsequentials2()
    while true do
    for k,l in pairs(monitors_) do
        if l[1].getSize() ~= nil then
        monx,mony = l[1].getSize()
        if mony > 5 then
            monitor_display(l[2],sel_storage)
        end
        end
    end
    previous_storage = sel_storage
    sleep(1)
    end
end

function unsequentials()
    term.clear()
    while true do
        if not open.switch and not move.switch then
            storage,storage_name = inv_list(mx,my,1,5,colors.blue)
            storage2,storage_name2 = inv_list(mx,my,23,5,colors.red)
        end
        if open.switch then        
            show_inv(sel_storage,1,4)
        end
        if storage ~= ""  then
            sel_storage = storage
        end
        if storage_name ~= "" then
            sel_name = storage_name
        end
        if storage2 ~= "" then
            sel_storage2 = storage2
        end
        if storage_name2 ~= "" then
            sel_name2 = storage_name2
        end
        if move.switch then
            number = on_move(sel_storage,sel_storage2,number)
        end    
        if sel_name ~= "" and sel_name ~= nil then
            term.setCursorPos(1,2)
            term.clearLine()
            if sel_name == sel_storage then
                display:set_text(">-"..p.getName(sel_name))
            else
                display:set_text(">-"..sel_name)
            end
        end
        if sel_name2 ~= "" and sel_name2 ~= nil then
        term.setCursorPos(1,3)
        term.clearLine()
        if sel_name2 == sel_storage2 then
            display2:set_text(">-"..p.getName(sel_name2))
        else
            display2:set_text(">-"..sel_name2)
        end
        end
        display:draw()
        display2:draw()
        
        deposit:_interact(mx,my,_deposit,{["storage"]=sel_storage,["storage2"]=sel_storage2})
        rename:_interact(mx,my,_rename,sel_storage)
        update:_interact(mx,my,update_invs,_,get_monitors)
        open:_switch(mx,my)    
        move:_switch(mx,my)
        pu:_interact(mx,my,move_page,1)
        pd:_interact(mx,my,move_page,-1)
        page_display:draw()
        sleep()
    end
end

function calls()
    parallel.waitForAll(get_mouse_up,get_mouse_down)
end

term.clear()

while true do
    parallel.waitForAny(calls,unsequentials,unsequentials2,unsequentials3)
end
