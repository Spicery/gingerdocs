all: overview.html

overview.html: overview.txt
	asciidoc --attribute=tabsize=4 -n overview.txt

clean: 
	/bin/rm -f overview.html 
