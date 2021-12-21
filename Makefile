NAME   = diver
LUA    = ?;?.lua
ASSETS = assets.p8

all: clean $(NAME).p8 $(NAME)-manual.p8

manual: $(NAME)-manual.p8

$(NAME).p8: build format

$(NAME)-manual.p8: manual-build

build:
	p8tool build $(NAME).p8 --lua main.lua --lua-path="$(LUA)" --gfx $(ASSETS) --gff $(ASSETS) --map $(ASSETS) --sfx $(ASSETS) --music $(ASSETS)

manual-build:
	p8tool build $(NAME)-manual.p8 --lua manual.lua --lua-path="$(LUA)" --gfx $(ASSETS) --gff $(ASSETS) --map $(ASSETS) --sfx $(ASSETS) --music $(ASSETS)

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

manual-test:
	pico8 -run $(NAME)-manual.p8

assets:
	pico8 assets.p8

clean:
	rm $(NAME).p8 || true
	rm $(NAME)-manual.p8 || true
