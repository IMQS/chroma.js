
ifdef SystemRoot
   RM = del /Q
else
   ifeq ($(shell uname), Linux)
      RM = rm -f
   endif
endif

all: chroma.min.js

clean:
	$(RM) chroma.js chroma.min.js license.coffee

license.coffee: LICENSE
ifdef SystemRoot	
	@echo ###* > $@
	echo * @license >> $@
	echo * >> $@
	type LICENSE >> $@
	echo ### >> $@
else
    @echo "###*" > $@          \
    echo " * @license" >> $@  \
    echo " *" >> $@           \
    while read i              \
    do                        \
       echo " * $i"  >> $@    \
    done < LICENSE            \
    echo "###" >> $@
endif

chroma.js: license.coffee src/api.coffee src/color.coffee src/conversions/*.coffee  src/scale.coffee src/limits.coffee src/colors/*.coffee src/utils.coffee src/interpolate.coffee
	@coffee -o . -j $@ $^

chroma.min.js: chroma.js
	@uglifyjs --comments "@license" chroma.js > $@

test: chroma.js
	@npm test