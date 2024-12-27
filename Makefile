.PHONY: clean

DIRS=bin
REDLABEL=redlabel

defender:
	$(shell mkdir -p $(DIRS))

	# Build Main Code + Attract
	./asm6809/src/asm6809 -B src/phr6.src src/defa7.src src/defb6.src src/amode1.src\
	 		-l bin/defa7-defb6-amode1.lst -o bin/defa7-defb6-amode1.o

	# Build Sam Explosions and Appearances
	./asm6809/src/asm6809 -B src/phr6.src src/samexap7.src\
	    -l bin/samexap7.lst -o bin/samexap7.o

	# Build Main Code - Attract
	./asm6809/src/asm6809 -B src/phr6.src src/defa7.src src/defb6.src\
 			-l bin/defa7-defb6.lst -o bin/defa7-defb6.o

	# Build game terrain
	./asm6809/src/asm6809 -B --6309 src/blk71.src -l bin/blk71.lst -o bin/blk71.o

	# Build game ROMs
	./asm6809/src/asm6809 -B src/mess0.src src/romf8.src src/romc0.src src/romc8.src\
	 		-l bin/roms.lst -o bin/roms.o

	# Build game sound
	./vasm/vasm6800_oldstyle -Fbin -ast -unsshift src/vsndrm1.src\
	 		-L bin/vsndrm1.lst -o bin/vsndrm1.o

redlabel: defender
	$(shell mkdir -p $(REDLABEL))

	# defend.1
	./rom_chain.py redlabel/defend.1 0x800\
		bin/defa7-defb6-amode1.o,0xb001,0x0000,0x0800,"defa7"

	echo "c9eb365411ca8452debe66e7b7657f44 redlabel/defend.1" | md5sum -c

	# defend.2
	./rom_chain.py redlabel/defend.2 0x1000\
		bin/defa7-defb6-amode1.o,0xc001,0x0000,0x1000,"defa7"

	./rom_patch.py redlabel/defend.2 0x07c5,'27fc'

	echo "5e85f9851217645508c36cf33762342f redlabel/defend.2" | md5sum -c

	# defend.3

	./rom_chain.py redlabel/defend.3 0x1000\
		bin/defa7-defb6-amode1.o,0xd001,0x0000,0x0c60,"defa7"\
		bin/samexap7.o,0x0001,0x0c60,0x02f8,"samexap"\
		bin/defa7-defb6-amode1.o,0xdf59,0x0f58,0x0230,"defa7"

	echo "f20a652ed2f1497fe899c414d15245a8 redlabel/defend.3" | md5sum -c

	# defend.4

	./rom_chain.py redlabel/defend.4 0x0800\
		bin/defa7-defb6-amode1.o,0xb801,0x0000,0x0800,"defa7"

	echo "a652dd9a550e1d33f55e76ba954f8999 redlabel/defend.4" | md5sum -c

	# defend.6

	./rom_chain.py redlabel/defend.6 0x0800\
		bin/blk71.o,0x0001,0x0000,0x0772,"blk71"\
		bin/roms.o,0xa779,0x0778,0x0088,"romc0"

	./rom_patch.py redlabel/defend.6\
	 	0x0772,'000000000000'\
	 	0x00de,'afb4'\
	 	0x07f0,'17'

	echo "fadaacee0e506f701ea3e61dfa23c548 redlabel/defend.6" | md5sum -c

	# defend.7

	./rom_chain.py redlabel/defend.7 0x0800\
		bin/roms.o,0xa001,0x0000,0x0800,"roms"

	echo "5b9d4e0664e01c48560b05d5941ee908 redlabel/defend.7" | md5sum -c

	# defend.8
	./rom_chain.py redlabel/defend.8 0x0800\
		bin/roms.o,0x0001,0x0000,0x0800,"roms"

	echo "dd4d18f5d3d14ab94f09b05335da3bf4 redlabel/defend.8" | md5sum -c

	# defend.9
	./rom_chain.py redlabel/defend.9 0x0800\
		bin/defa7-defb6-amode1.o,0x0001,0x0000,0x0800,"defa7"

	echo "3de0cf05f6ee1fd7da6ccaba93fce3fc redlabel/defend.9" | md5sum -c

	# defend.10
	./rom_chain.py redlabel/defend.10 0x0800\
		bin/roms.o,0xa801,0x0000,0x0800,"roms"
	
	./rom_patch.py redlabel/defend.10 0x07f0,'4a'

	echo "7bd2ddcb4ce8c5ceb8150b61cb2a2335 redlabel/defend.10" | md5sum -c

	# defend.11
	./rom_chain.py redlabel/defend.11 0x0800\
		bin/roms.o,0x0801,0x0000,0x0800,"roms"\
		src/unknown.bin,0x0001,0x0450,0x0800,"roms"

	echo "0fda70334d594b58cd26ad032be16c4b redlabel/defend.11" | md5sum -c

	# defend.12
	./rom_chain.py redlabel/defend.12 0x0800\
		bin/defa7-defb6-amode1.o,0x0801,0x0000,0x0800,"defa7"\
		bin/defa7-defb6-amode1.o,0xaeea,0x06e9,0x0117,"amode tail"

	echo "8115fdb8540e93d38e036f007e19459a redlabel/defend.12" | md5sum -c

	# defend.snd
	./rom_chain.py redlabel/defend.snd 0x0800\
		bin/vsndrm1.o,0xf801,0x0000,0x0800,"vsndrm1"
	
	./rom_patch.py redlabel/defend.snd 0x05b6,'8b'

	echo "ec5b36f80f7bd93ba9e6269f0376efd6  redlabel/defend.snd" | md5sum -c

clean:
	-rm bin/*.o
	-rm bin/*.lst
