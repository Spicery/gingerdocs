all: mnx_syntax.html

mnx_syntax.html: mnx_syntax.txt
	asciidoc --attribute=tabsize=4 -n mnx_syntax.txt

clean: 
	/bin/rm -f mnx_syntax.html
