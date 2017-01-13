all: latte compiler

latte: 
	cd ./src && bnfc -m -haskell Latte.cf && $(MAKE)
compiler:
	export LDFLAGS='-m32 -L/usr/lib32'
	cd ./src && ghc Main.hs -XRankNTypes -o latc_x86
	mv ./src/latc_x86 .

clean:
	cd ./src && $(MAKE) clean
	cd ./src && rm -f *.tex *.txt *.x *.y *Latte.hs *.bak ErrM.hs TestLatte Makefile
	rm -f latc_x86

.PHONY: all clean
