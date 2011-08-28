all: gson2gnx.html gson.html gson_background.html

clean:
	/bin/rm -f gson2gnx.html

gson2gnx.html: gson2gnx.txt
	asciidoc -a icons --attribute=tabsize=4 -n gson2gnx.txt

gson.html: gson.txt
	asciidoc -a icons --attribute=tabsize=4 -n gson.txt

gson_background.html: gson_background.txt
	asciidoc -a icons --attribute=tabsize=4 -n gson_background.txt
