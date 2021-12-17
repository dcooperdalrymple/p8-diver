return {
    open=false,
    areas=split("21_2_6_4_buy something_will ya?,33_82_4_3_security comp_access granted,38_99_4_3_core facility_access granted"), -- x_y_w_h_text1_text2
    items=split("life_16,harpoon_5,bomb_5"),
    key=nil,
    init=function(self)
        if type(self.areas[1])=="string" then
            for k,i in pairs(self.areas) do
                i=split(i,"_",true)
                self.areas[k]={
                    x=i[1],
                    y=i[2],
                    w=i[3],
                    h=i[4],
                    text1=i[5],
                    text2=i[6]
                }
            end
            for k,i in pairs(self.items) do
                i=split(i,"_")
                self.items[k]={
                    name=i[1],
                    amount=tonum(i[2])
                }
            end
        end
    end,
    update=function(self)
        self._open=self.open
        if self.open and btnp(5) then
            if self.key and Inventory:remove_item("coin",5) then
                Inventory:add_item(self.item.name,self.item.amount)
            end
            self.key=nil
            self.open=not self.open
            Paused=self.open
        elseif self.open and btnp(4) then
            self.key,self.item=next(self.items,self.key)
        elseif Paused then
            return
        elseif btnp(5) then
            for area in all(self.areas) do
                if collide(Player,area) then
                    self.area=area
                    self.open=not self.open
                    Paused=self.open
                    break
                end
            end
        end
    end,
    draw=function(self)
        if self.open then
            rectfill(32,32,96,96,1)
            rect(32,32,96,96,7)
            print(self.area.text1,36,36,7)
            print(self.area.text2,36,44,7)
            for k,i in pairs(self.items) do
                if self.key==k then
                    circfill(37,46+k*12,1,8)
                end
                Inventory:draw_item(i.name,42,42+k*12)
                print(i.name,53,44+k*12,7)
            end

            Inventory:draw_item("coin",84,84)
            print("5",80,86,7)
        end
    end
}
