all: common_syntax.html

common_syntax.html: common_syntax.txt
	asciidoc --attribute=tabsize=4 -n common_syntax.txt

clean: 
	/bin/rm -f gnx_syntax.html 
	/bin/rm -f mnx_syntax.html
