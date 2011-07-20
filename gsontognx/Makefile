all: gson2gnx.html

clean:
	/bin/rm -f gson2gnx.html

gson2gnx.html: gson2gnx.txt
	asciidoc -a icons --attribute=tabsize=4 -n gson2gnx.txt

