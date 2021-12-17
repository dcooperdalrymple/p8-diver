return {
    open=false,
    timer=0,
    timer_max=0.25,
    items=split("coin_43,life_46,cord_45,harpoon_44,bomb_40,key_85,dagger_77,unknown_56"), -- name_frame, used to reduce tokens
    init=function(self)
        if type(self.items[1]) == "string" then
            for k,i in pairs(self.items) do
                i=split(i,"_")
                self.items[k]={
                    name=i[1],
                    f=tonum(i[2])
                }
            end
        end
        for i in all(self.items) do
            i.quantity=0
            i.max=0
            if i.name=="life" then
                i.quantity=3
                i.max=3
            elseif i.name=="cord" then
                i.max=32
            end
        end
        self.equipped_items={}
        self.equipped_item=nil
        self.equipped_key=nil
    end,
    update=function(self)
        if (Dialog.active_key!=false or Shop.open or Shop._open) return

        if btnp(5) then
            self.open=not self.open
            State.paused=self.open
        end

        if self.open and self.timer<self.timer_max then
            -- animation timer
            self.timer+=tdelta
        elseif not self.open and self.timer>0 then
            self.timer-=tdelta
        end

        -- item selection logic
        if self.open and btnp(4) then
            self.equipped_key,self.equipped_item=next(self.equipped_items,self.equipped_key)
        end
    end,
    draw=function(self)

        -- coins
        self:draw_item("coin",0,1,3)

        -- equipped item
        self:draw_item(self.equipped_item,25,1,2)

        -- cord left
        local item=self:get_item("cord")
        self:draw_item(item,45,1)
        rectfill(54,3,80,6,0)
        rectfill(55,4,79,5,7)
        rectfill(55,4,55+24*max(min(item.quantity/item.max,1)),5,2)

        -- life hearts
        item=self:get_item("life")
        local i=1
        for y=0,flr((item.max-1)/5) do
            for x=16-min(item.max-y*5,5),15 do
                if item.quantity<i then
                    pal(Graphics.palbw)
                end
                spr(46,x*9-16,y*9+1,1,1)
                Graphics.reset_pal()
                i+=1
            end
        end

        -- Inventory Selector
        if self.timer>0 then
            local a=min(self.timer/self.timer_max,1)
            circfill(Player.x*8-Camera.x,Player.y*8-Camera.y,a*14,11)
            circfill(Player.x*8-Camera.x,Player.y*8-Camera.y,a*10,3)

            -- display items, a is distance
            a*=14 -- 14=radius
            for k,i in pairs(self.equipped_items) do
                local x=Player.x*8+cos(k/#self.equipped_items)*a-Camera.x
                local y=Player.y*8+sin(k/#self.equipped_items)*a-Camera.y
                if self.equipped_key==k then
                    circfill(x,y,6,7)
                else
                    circ(x,y,6,7)
                end
                self:draw_item(i,x-4,y-4)
            end
        end
    end,
    get_item=function(self, name)
        for item in all(self.items) do
            if item.name==name then
                return item
            end
        end
    end,
    set_item=function(self, name, quantity)
        --quantity=quantity or 0
        local item=self:get_item(name)
        item.quantity=quantity
        -- no max?
    end,
    add_item=function(self, item, amount, max)
        if type(item)=="string" then
            item=self:get_item(item)
        end
        amount=amount or 1
        item.quantity+=amount
        if max then
            if item.max<=0 and not in_table(item.name, split("life,cord,coin")) then
                add(self.equipped_items, item)
            end
            item.max+=amount
        elseif item.name!="coin" and item.quantity>item.max then
            item.quantity=item.max
            return false
        end
        return true
    end,
    remove_item=function(self,item,amount)
        if type(item)=="string" then
            item=self:get_item(item)
        end
        amount=amount or 1
        if (item.quantity-amount<0) return false
        item.quantity-=amount
        return true
    end,
    draw_item=function(self,item,x,y,digits)
        if in_table(type(item),split("string,number")) then
            item=self:get_item(item)
        end
        if item==nil then return end
        spr(item.f,x,y)
        if type(digits)=="number" and not in_table(item.name, split("dagger,unknown")) then
            printo(pad(tostr(item.quantity),digits),x+10,y+2)
        end
    end
}
