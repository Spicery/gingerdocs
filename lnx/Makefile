all: lnx.html

clean:
	/bin/rm -f lnx.html

lnx.html: lnx.txt
	asciidoc -a icons --attribute=tabsize=4 -n lnx.txt

