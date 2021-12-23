-- diver manual
-- by coopersnout, 2021

tdelta=1/60
Print=false

function prepare_text(text)
    return split(text,"~")
end

Pages={
    {
        bg=0,
        title="diver",
        text=prepare_text("game manual")
    },
    {
        bg=1,
        title="introduction",
        text=prepare_text("jUST OFF THE COAST OF A~DESERTED CARIBBEAN ISLAND, A~LONE ADVENTURER YEARNS FOR FAME~AND FORTUNE. tHEY WERE TOLD NOT~TO DIVE INTO THE DANGEROUS~CAVES OF THIS FORGOTTEN ISLAND,~BUT THAT FURTHER STOKED THE~FIRE WITHIN OUR PROTAGONIST.~hAVING RECENTLY DISCOVERED AN~ANCIENT TOME OF UNKNOWN DECENT,~THEY WILL DESCEND WILLINGLY~INTO THE MENACING YET ENTICING"),
        image={
            f=16,
            w=2,
            h=1.25,
            s=2
        }
    },
    {
        bg=1,
        text=prepare_text("DEPTHS BELOW. wITH YOUR HELP,~THEY MAY BE THE ONE TO DISCOVER~SOMETHING INCREDIBLE... OR THEY~MAY FOREVER PERISH.")
    },
    {
        bg=2,
        title="controls",
        text=prepare_text("dIVER IS A ONE-PLAYER GAME,~SO ONLY ONE CONTROLLER IS~SUPPORTED AT A TIME. yOU~CAN PLAY dIVER USING ALL OF~THE SUPPORTED pico-8~CONTROLLERS. tHE MOST~SIMPLE WAY OF PLAYING IS BY~USING A COMPUTER KEYBOARD.~yOU CAN CHECK THE~KEYBINDINGS USING THE~COMMAND \"KEYCONFIG\" WITHIN~THE pico-8 COMMAND LINE.~pRESS eSC AT ANY POINT~TO ENTER THE COMMAND LINE.")
    },
    {
        bg=2,
        title="swimming",
        text=prepare_text("tO MAKE YOUR CHARACTER SWIM~AROUND THE MAP, USE THE~D-PAD ON YOUR CONTROLLER~(\139\148\131\145 ON KEYBOARD) IN~THE DIRECTION THAT YOU'D~LIKE TO GO. aNY ITEMS YOU~HAVE WILL ACTIVATE IN THE~DIRECTION YOU'RE FACING."),
        image={
            f=103,
            w=2,
            h=1.5,
            s=2
        }
    },
    {
        bg=2,
        title="inventory",
        text=prepare_text("iN ORDER TO USE ITEMS AFTER~YOU'VE PICKED THEM UP,~PRESS \151 TO OPEN YOUR~INVENTORY. wITH YOUR~INVENTORY OPEN, YOU CAN~PRESS \142 TO CHANGE YOUR~SELECTION. tHE CURRENT ITEM~YOU'VE SELECTED WILL APPEAR~WITH A FILLED IN CIRCLE~RATHER THAN AN OUTLINE. yOU~CAN ALSO HAVE NO ITEM~SELECTED. oNCE YOU'RE READY,~PRESS \151 AGAIN TO CONTINUE~THE GAME. tHE ITEM YOU'VE~SELECTED SHOULD APPEAR IN")
    },
    {
        bg=2,
        text=prepare_text("THE UPPER-LEFT CORNER TO~THE RIGHT OF YOUR COIN COUNT.~iF THE ITEM HAS A QUANTITY,~IT WILL BE DISPLAYED TO THE~RIGHT OF THE ITEM.")
    },
    {
        bg=2,
        title="shop",
        text=prepare_text("tO ACCESS THE SHOP, YOU MUST~BE WITHIN THE AREA OF A~DESIGNATED SHOP ZONE. tHIS~INCLUDES THE BOAT AT THE~BEGINNING OF THE GAME, BUT~THERE ARE OTHER SHOP AREAS~TO FIND AS YOU DIVE FURTHER~IN. pRESS THE \151 BUTTON TO~OPEN THE SHOP DIALOG. yOU"),
        image={
            f=11,
            w=4,
            h=2,
            s=2
        }
    },
    {
        bg=2,
        text=prepare_text("WILL BE GIVEN THREE~OPTIONS TO PICK FROM: LIFE,~HARPOON, AND BOMB. iF YOU~ARE NOT YET ABLE TO PURCHASE~ONE OF THESE OPTIONS, IT~WILL APPEAR GREYED OUT AND~YOU WON'T BE ABLE TO SELECT~IT. tO SELECT AN ITEM TO~PURCHASE, PRESS THE \142~BUTTON UNTIL A RED DOT~APPEARS NEXT TO THE DESIRED~ITEM. tO PURCHASE IT, PRESS~THE \151 BUTTON ONCE AGAIN.~tHIS WILL REMOVE 5 COINS~FROM YOUR INVENTORY. iF YOU~DON'T HAVE ENOUGH COINS,")
    },
    {
        bg=2,
        text=prepare_text("THE TRANSACTION WILL BE~CANCELED. iF YOU PURCHASE~LIFE, YOUR HEARTS WILL BE~FULLY REPLENISHED. iF YOU~PURCHASE HARPOON OR BOMB,~YOU WILL RECEIVE 5 OF THAT~ITEM UP TO THE MAXIMUM~AMOUNT YOU CAN CARRY.")
    },
    {
        bg=3,
        title="items",
        text=prepare_text("tHERE ARE A MANY ITEMS~SCATTERED THROUGHOUT THE~GAME. uSE THEM TO YOUR~ADVANTAGE TO HELP YOU DELVE~FURTHER UNDER THE OCEAN~SURFACE."),
        images=split("43,46,45,47,44,40,56,77,85,101")
    },
    {
        bg=3,
        title="chests",
        text=prepare_text("sCATTERED THROUGHOUT THE~WORLD, THERE ARE A NUMBER~OF UNDERWATER CHESTS. tHESE~DIFFER FROM FLOATING ITEMS~BECAUSE THEY WILL GIVE YOU~A LARGER REWARD OR EXTEND~THE MAXIMUM AMOUNT YOU CAN~CARRY OF AN ITEM. fLOATING~ITEMS WILL ONLY ADD TO YOUR~INVENTORY BY 1 AND BE~LIMITED TO THEIR MAXIMUM."),
        image={
            f=25,
            w=2,
            h=2
        }
    },
    {
        bg=3,
        title="breathing tube",
        text=prepare_text("aS YOU MOVE AROUND, YOU WILL~NOTICE THE BAR AT THE~TOP-CENTER OF THE SCREEN~CHANGING. tHIS IS A METER~OF THE AMOUNT OF BREATHING~TUBE YOU ARE USING. wHEN~YOU DIVE DEEPER INTO THE~DEPTHS BELOW, YOUR BREATHING~TUBE WILL KEEP YOU ATTACHED~TO THE BOAT AT THE BEGINNING~OF THE GAME. yOU MAY FIND"),
        image={
            f=45,
            w=1,
            h=1,
            s=2
        }
    },
    {
        bg=3,
        text=prepare_text("THAT IT WILL KEEP YOU FROM~PROGRESSING FURTHER IF YOU~RUN OUT OF CORD. mAKE SURE~TO LOOK AROUND FOR MORE~LENGTHS OF CORD TO EXTEND~YOUR BREATHING TUBE AND~THEREFORE HOW FAR YOU CAN~EXPLORE.")
    },
    {
        bg=3,
        title="coins",
        text=prepare_text("eVERYONE LOVES MONEY! aND~THERE'S PLENTY OF IT TO BE~FOUND IN THE DEPTHS BELOW.~yOU CAN USE THE COINS YOU~COLLECT IN THE SHOPS~THROUGHOUT THE MAP TO~REPLENISH YOUR INVENTORY.~tHERE IS NO LIMIT TO THE~NUMBER OF COINS YOU CAN~COLLECT."),
        image={
            f=43,
            w=1,
            h=1,
            s=2
        }
    },
    {
        bg=3,
        title="hearts",
        text=prepare_text("yOU BEGIN THE GAME WITH ONLY~3 HEARTS AT YOUR DISPOSAL.~aNY TIME YOU RECEIVE DAMAGE~FROM AN ENEMY OR DANGEROUS~ENVIRONMENT, YOU WILL LOSE~1 HEART. iF YOU LOSE YOUR~LAST HEART, YOU WILL PERISH~AND WILL HAVE TO START AGAIN~FROM THE BEGINNING. yOU CAN~REPLENISH YOUR HEALTH BY~FINDING FLOATING HEARTS OR"),
        image={
            f=46,
            w=1,
            h=1,
            s=2
        }
    },
    {
        bg=3,
        text=prepare_text("UNCOVERING A CHEST WITH A~HEART WITHIN IT TO GAIN AN~EXTRA HEART.")
    },
    {
        bg=3,
        title="swimming flippers",
        text=prepare_text("fLIPPERS ARE A GREAT WAY TO~INCREASE YOUR SPEED~UNDERWATER. iF YOU PICK UP~A SET WITHIN A CHEST OR~FLOATING AROUND, YOUR SPEED~WILL INCREASE."),
        image={
            f=47,
            w=1,
            h=1,
            s=2
        }
    },
    {
        bg=3,
        title="keys",
        text=prepare_text("yOU WILL DOUBTLESSLY FIND A~NUMBER OF LOCKED DOORS~BELOW THE WATER'S SURFACE~LEADING TO UNKNOWN~LOCATIONS. eVERY DOOR MUST~HAVE A KEY! yOU CAN USE~THESE KEYS TO UNLOCK DOORS~AND OPEN THE WAY TO NEW~DISCOVERIES."),
        image={
            f=85,
            w=1,
            h=1,
            s=2
        }
    },
    {
        bg=3,
        title="harpoons",
        text=prepare_text("tHERE ARE A NUMBER OF~DANGEROUS CREATURES LURKING~BELOW JUST WAITING FOR A~TASTY HUMAN TREAT. tHESE~TRUSTY HARPOONS ARE A GREAT~WAY TO SHOW THEM WHO'S~BOSS! wHEN YOU USE A~HARPOON, IT WILL FIRE~STRAIGHT AHEAD OF YOU WITH~GREAT SPEED. uSE IT TO~ATTACK ENEMIES WHO ARE FAR~AWAY."),
        image={
            f=44,
            w=1,
            h=1,
            s=2
        }
    },
    {
        bg=3,
        title="bombs",
        text=prepare_text("tHESE CAN BE A GREAT TOOL~TO CLEAR DEBRIS FOUND BELOW~AND UNCOVER HIDDEN SECRETS.~tHEIR EXPLOSION CAN BE~QUITE DEADLY TOO! jUST MADE~SURE TO BACK AWAY QUICKLY~BEFORE A BOMB GOES OFF. aND~BE CAREFUL, BECAUSE BOMBS~WILL GO OFF IMMEDIATELY~WHEN THEY COME IN CONTACT~WITH A DANGEROUS CREATURE."),
        image={
            f=40,
            w=0.875,
            h=0.875,
            s=2
        }
    },
    {
        bg=3,
        title="dagger",
        text=prepare_text("tHIS RELIC OF AN UNKNOWN~TIME HAS SEEN BETTER DAYS.~iT NO LONGER HAS THE SHINE~OR EDGE THAT IT ONCE HAD.~iT MAY STILL PROVE USEFUL~TO SMALLER ENEMIES. wHEN~YOU USE A DAGGER, IT WILL~ATTACK WITHIN A SMALL AREA~JUST IN FRONT OF YOU.~yOU'LL NEED TO GET CLOSE,~BUT NOT TOO CLOSE!"),
        image={
            f=77,
            w=1,
            h=1,
            s=2
        }
    },
    {
        bg=3,
        title="enviro suit",
        text=prepare_text("tHIS HIGHLY ADVANCED~WEARABLE TECHNOLOGY WILL~PROTECT YOU UNDER THE~RISING PRESSURE AND~TEMPERATURE OF THE DEPTHS~BELOW. yOU'LL HAVE TO FIND~IT FIRST BEFORE YOU VENTURE~TOO FAR. oNCE EQUIPPED, YOU~WILL WEAR IT FOR THE REST~OF YOUR JOURNEY."),
        image={
            f=126,
            w=2,
            h=1,
            s=2
        }
    },
    {
        bg=3,
        title="unknown artifact",
        text=prepare_text("tHIS ARTIFACT IMMEDIATELY~SPARKED YOUR CURIOUSITY.~tHERE MUST BE SOME~KNOWLEDGE IN THE DEPTHS~BELOW WHICH WOULD HINT AT~THIS ARTIFACT'S EXISTANCE.~cURRENTLY, IT SERVES YOU NO~PURPOSE, BUT THAT MAY~CHANGE..."),
        image={
            f=56,
            w=1,
            h=1,
            s=2
        }
    },
    {
        bg=4,
        title="enemies",
        text=prepare_text("sCATTERED THROUGHOUT THE~OCEANIC ROCK ARE A NUMBER~OF CREATURES WHICH STAND IN~YOUR WAY OF DISCOVERING THE~RICHES BENEATH. yOU MAY BE~ABLE TO AVOID A NUMBER OF~THEM, BUT AT SOME POINT,~YOU'LL HAVE TO USE THE~TOOLS AT YOUR DISPOSAL TO~CLEAR THE WAY.")
    },
    {
        bg=4,
        title="urchin",
        text=prepare_text("tHESE CREATURES WILL KEEP~TO THEMSELVES FOR THE MOST~PART, BUT THEIR PRICKLY~SPINES MAY HARM THE MOST~FOOLISH OF ADVENTURERS. iT~MAY BE A GOOD IDEA TO TAKE~CARE OF THEM TO CLEAR THE~PATH."),
        image={
            f=39,
            w=1,
            h=1,
            s=2
        }
    },
    {
        bg=4,
        title="fish",
        text=prepare_text("mINDLESSLY SWIMMING AROUND,~THE TYPICAL FISH WON'T~CAUSE YOU TOO MUCH HARM...~tHAT IS UNLESS YOU GET IN~THEIR WAY. kEEP OUT OF~THEIR PATH, AND IF THEY'RE~BLOCKING YOURS, DO WHAT~MUST BE DONE."),
        image={
            f=23,
            w=2,
            h=1,
            s=2
        }
    },
    {
        bg=4,
        title="squid",
        text=prepare_text("tHE HUMBLE SQUID CAN BE~QUITE GRACEFUL AS IT TAKES~GREAT STRIDES WITH THE WAKE~OF THE WATER. tIMID AS THEY~ARE, THEY MAY STILL ATTACK~YOU IF YOU DRAW NEAR. tHERE~ARE RUMOURS OF LARGER SQUID~POSSESSING UNIQUE~ABILITIES."),
        image={
            f=59,
            w=2,
            h=2,
            s=2
        }
    },
    {
        bg=4,
        title="angler fish",
        text=prepare_text("tRAPPED WITHIN THE LONELY~CONFINES OF THE OCEAN~DEPTHS, THESE FISH GROW~HUNGRY FOR THE NEXT MEAL.~iF THEY SEE YOU, THEY MAY~CHARGE! iT'LL TAKE QUITE A~FEW BLOWS TO TAKE OUT THIS~ANGRY BEAST."),
        image={
            f=71,
            w=2,
            h=1.875,
            s=2
        }
    },
    {
        bg=0,
        text=prepare_text("cREATED BY~cOOPER dALRYMPLE, 2021~~sPECIAL THANKS TO~sAM eARLEY")
    }
}

function _init()
    restart()
    menuitem(1,"restart",restart)
end

function restart()
    reload()
    Time=0
    PageNum=1
    PrevPage=false
    NextPage=false

    if not Print then
        music(0,2000,0b0111)
        Fade:_in()
    end
end

function _update60()
    Time+=tdelta

    -- Page Turning
    Fade:update()
    if not NextPage and not PrevPage and PageNum<#Pages and btnp(1) then
        NextPage=true
        if not Print then
            sfx(0,3)
            Fade:out()
        end
    elseif not NextPage and not PrevPage and PageNum>1 and btnp(0) then
        PrevPage=true
        if not Print then
            sfx(0,3)
            Fade:out()
        end
    elseif not Fade.state and (NextPage or PrevPage) then
        if NextPage then
            PageNum+=1
        else
            PageNum-=1
        end
        bubbles={}
        NextPage=false
        PrevPage=false
        if (not Print) Fade:_in()
    end

    -- Map
    for y=0,15 do -- Reset
        for x=0,15 do
            mset(x,y,0)
        end
    end
    if Pages[PageNum].bg==0 then -- Cover
        --?
    elseif Pages[PageNum].bg==1 then -- Wave
        local f=Time%4+3
        if (Print) f=PageNum%4+3
        for x=0,15 do
            mset(x,0,2)
            mset(x,1,f)
            mset(x,15,51)
        end
    elseif Pages[PageNum].bg==2 then -- Cave Border
        mset(0,0,18)
        mset(15,0,20)
        mset(15,15,52)
        mset(0,15,50)
        for x=1,14 do
            mset(x,0,19)
            mset(x,15,51)
        end
        for y=1,14 do
            mset(0,y,34)
            mset(15,y,36)
        end
    elseif Pages[PageNum].bg==3 then -- Lava Border
        mset(0,0,18)
        mset(15,0,20)
        mset(0,15,117)
        mset(15,15,118)
        for x=1,14 do
            mset(x,0,19)
            mset(x,15,112)
        end
        for y=1,14 do
            mset(0,y,34)
            mset(15,y,36)
        end
        local f=Time%4+113
        if (Print) f=PageNum%4+113
        for x=1,14 do
            mset(x,14,f)
        end
    elseif Pages[PageNum].bg==4 then -- Ancient Border
        mset(0,0,18)
        mset(15,0,20)
        for x=1,14 do
            mset(x,0,19)
        end
        for y=1,15 do
            mset(0,y,34)
            mset(15,y,36)
        end
        for x=3,12 do
            mset(x,15,94)
        end
        mset(2,15,93)
        mset(13,15,95)
    end

end

function reset_pal()
    pal()
    palt(14, true)
    palt(0, false)
end

bubbles={}
bubbles_max=64
function _draw()
    reset_pal()
    camera()

    local page=Pages[PageNum]

    -- Background
    bgc=7
    fgc=6
    buc=6
    if page.bg==0 then
        bgc=1
        fgc=2
        buc=12
    end

    cls(bgc)
    for i=0,16 do
        fillp(Fade.pat[16-i])
        rectfill(0,96+32/16*i,128,96+32/16*(i+1),fgc)
    end
    fillp()

    local first=#bubbles==0
    while #bubbles<bubbles_max do
        local y=128
        if first then y=rnd(128) end
        local b={
            x=rnd(128),
            y=y,
            dy=(rnd(1)*-0.1-0.1)*30*tdelta,
            dx=0,
            seed=rnd(1)
        }
        add(bubbles,b)
    end
    for b in all(bubbles) do
        if not Print then
            b.dx=cos(b.seed+Time)/10
            b.x+=b.dx
            b.y+=b.dy
        end
        if b.x<0 or b.x>128 or b.y<0 then
            del(bubbles,b)
        else
            pset(b.x,b.y,buc)
        end
    end

    -- Map
    map(0,0,0,0,16,16)

    -- Page Number
    local pn="pAGE:"..(PageNum-1)
    if (page.bg==0) pn=""

    local nav="pREV/nEXT:\139\145"
    if PageNum==1 then
        nav="nEXT:\145"
    elseif PageNum==#Pages then
        nav="pREV:\139"
    end
    if (Print==true) nav=""

    local t1,t2,tl2
    local c1,c2=0,2
    if PageNum%2==0 then
        t1,t2=pn,nav
        tl2=#t2+1
        if (tl2>7) tl2+=1
    else
        t1,t2=nav,pn
        tl2=#t2
        c1,c2=2,0
    end
    if page.bg==0 then
        if PageNum==1 then
            t1,t2=pn,nav
            tl2=#t2+1
        elseif PageNum==#Pages then
            t1,t2=nav,pn
        end
        c1,c2=7,7
    end

    local pad=9
    local y=114
    if (Pages[PageNum].bg==0) y,pad=121,2
    if (Pages[PageNum].bg==1) pad=2
    if (Pages[PageNum].bg==3) y-=3
    if (Pages[PageNum].bg==4) y-=1

    print(t1,pad,y,c1)
    print(t2,129-pad-tl2*4,y,c2)

    -- Page Content
    local x=9
    local y=10
    if page.bg==1 then
        x=8
        y=11
        if page.image then
            y=5
        end
    end

    if page.image then
        image=page.image
        image.s=image.s or 1
        sspr(image.f%16*8,flr(image.f/16)*8,image.w*8,image.h*8,64-image.w*image.s*4,y,image.w*image.s*8,image.h*image.s*8)
        y+=image.h*image.s*8+2*image.s
    end

    if page.images then
        local _x=64-#page.images*4.5
        for f in all(page.images) do
            spr(f,_x,y,1,1)
            _x+=9
        end
        y+=11
    end

    if page.title then
        if page.bg==0 then
            local s=cos(Time/3-0.5)*1.5+4.1
            if (Print) s=5.6
            y=64-4*s
            prints(page.title,64-#page.title*1.95*s,y,s,s,0)
            y=64+7*5.6 --s
            if page.text then
                y=86-#page.text*5
            end
        else
            printo(page.title,64-#page.title*2,y)
            y+=7
        end
    end

    if page.bg==0 and not page.title and page.text then
        y=64-#page.text*3
    end

    if page.bg==1 and not page.image and not page.images and not page.title then
        y+=7
    end

    if (page.bg==1) x=2
    if page.text and #page.text>0 then
        for l=1,#page.text do
            if page.bg==0 then
                print(page.text[l],64-#page.text[l]*1.95,y,7)
            else
                print(page.text[l],x,y,0)
            end
            y+=6
        end
    end

    Fade:draw()
end

-- Global Functions

Fade = {

    _in=function (self,ticks)
        self:init("in",ticks)
    end,

    out=function (self,ticks)
        self:init("out",ticks)
    end,

    init=function (self,state,ticks)
        ticks = ticks or 1

        self.state=state
        self.index=17
        self.ticks=ticks
        self.tick=ticks
    end,

    update=function (self)
        if self.state then

            self._index=self.index
            if self.state=="in" then
                self._index=18-self._index
            end

            self.tick-=1
            if self.tick<=0 then
                self.tick=self.ticks

                self.index-=1
                if self.index<=0 then
                    self.state=false
                end
            end

        end
    end,

    draw=function (self)
        if self.state then
            fillp(tonum(self.pat[self._index]))
            rectfill(0,0,127,127,0)
            fillp()
        end
    end,

    pat=split("0x0000.8,0x8000.8,0x8020.8,0xa020.8,0xa0a0.8,0xa4a0.8,0xa4a1.8,0xa5a1.8,0xa5a5.8,0xe5a5.8,0xe5b5.8,0xf5b5.8,0xf5f5.8,0xfdf5.8,0xfdf7.8,0xfff7.8,0xffff.8")

}

-- String

function pad(str,len)
    if (#str>=len) return str
    return "0"..pad(str,len-1)
end

-- Print text with outline
function printo(s,x,y,c,o)
    c=c or 7
    o=o or 0
    print(s,x-1,y,o)
    print(s,x+1,y,o)
    print(s,x,y-1,o)
    print(s,x,y+1,o)
    print(s,x,y,c)
end

-- Print text with scale
function prints(text,tlx,tly,sx,sy,col)
    -- get buffer
    local b={}
    for y=0,5 do
        b[y]={}
        for x=0,#text*4 do
            b[y][x]=pget(x,y)
        end
    end

    print(text,0,0,14)
    for y=0,5 do
        for x=0,#text*4 do
            local _col=pget(x,y)
            if _col==14 then
                local nx=x*sx+tlx
                local ny=y*sy+tly
                rectfill(nx,ny,nx+sx,ny+sy,col)
            end
        end
    end

    -- reload buffer
    for y=0,5 do
        for x=0,#text*4 do
            pset(x,y,b[y][x])
        end
    end
end
