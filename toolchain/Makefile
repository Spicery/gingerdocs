all: toolchain.html

clean:
	/bin/rm -f toolchain.html

toolchain.html: toolchain.txt
	asciidoc -a icons --attribute=tabsize=4 -n toolchain.txt

