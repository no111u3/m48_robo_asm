%: src/%.asm
	avra -I src $< -o build/$@.hex -e build/$@.eep.hex
	rm src/$@.obj