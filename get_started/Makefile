all: get_started.html

clean:
	/bin/rm -f get_started.html

get_started.html: get_started.txt
	asciidoc -a icons --attribute=tabsize=4 -n get_started.txt

