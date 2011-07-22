all: gnx_syntax.html mnx_syntax.html

gnx_syntax.html: gnx_syntax.txt
	asciidoc --attribute=tabsize=4 -n gnx_syntax.txt

mnx_syntax.html: mnx_syntax.txt
	asciidoc --attribute=tabsize=4 -n mnx_syntax.txt

clean: 
	/bin/rm -f gnx_syntax.html 
	/bin/rm -f mnx_syntax.html
