all: gnx_syntax.html

gnx_syntax.html: gnx_syntax.txt
	asciidoc --attribute=tabsize=4 -n gnx_syntax.txt

clean: 
	/bin/rm -f gnx_syntax.html 
