%: src/%.asm
	avra -I src $< -o build/$@.hex -e build/$@.eep.hex
	rm src/$@.obj

%_lst: src/%.asm
	avra -I src $< -o build/$@.hex -e build/$@.eep.hex -l build/$@.lst
	rm src/$@.obj

%_write: build/%.hex
	avrdude -c ft232r -p m48 -b2400 -U flash:w:$<:a

erase:
	avrdude -c ft232r -p m48 -b2400 -e

probe:
	avrdude -c ft232r -p m48 -b2400
