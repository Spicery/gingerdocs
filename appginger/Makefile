all: appginger.html

clean:
	/bin/rm -f appginger.html

appginger.html: appginger.txt
	asciidoc -a icons --attribute=tabsize=4 -n appginger.txt

