NAME   = diver
LUA    = ?;?.lua;./src/utils/?.lua;./src/?.lua;./src/graphics/?.lua;./src/actor/?.lua;./src/actor/enemies/?.lua;./src/actor/projectiles/?.lua;./src/actor/rewards/?.lua;./src/hud/?.lua
ASSETS = assets.p8

all: $(NAME).p8

$(NAME).p8: clean build format

build:
	p8tool build $(NAME).p8 --lua main.lua --lua-path="$(LUA)" --gfx $(ASSETS) --gff $(ASSETS) --map $(ASSETS) --sfx $(ASSETS) --music $(ASSETS)

format:
	p8tool luafmt --indentwidth=1 $(NAME).p8
	mv $(NAME)_fmt.p8 $(NAME).p8

minify:
	p8tool luamin $(NAME).p8
	mv $(NAME)_fmt.p8 $(NAME).p8

stats:
	p8tool stats $(NAME).p8

test:
	pico8 -run $(NAME).p8

clean:
	rm $(NAME).p8 || true
