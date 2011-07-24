all:
	$(MAKE) welcome.html
	$(MAKE) -C appginger $@
	$(MAKE) -C get_started $@
	$(MAKE) -C gnx $@
	$(MAKE) -C gson $@
	$(MAKE) -C introduction $@
	$(MAKE) -C language $@
	$(MAKE) -C lnx $@
	$(MAKE) -C lnx2mnx $@
	$(MAKE) -C mnx $@
	$(MAKE) -C toolchain $@

clean:
	/bin/rm -f welcome.html
	$(MAKE) -C appginger $@
	$(MAKE) -C get_started $@
	$(MAKE) -C gnx $@
	$(MAKE) -C gson $@
	$(MAKE) -C introduction $@
	$(MAKE) -C language $@
	$(MAKE) -C lnx $@
	$(MAKE) -C lnx2mnx $@
	$(MAKE) -C mnx $@
	$(MAKE) -C toolchain $@

%.html: %.txt
	asciidoc -a icons --attribute=tabsize=4 -n $<
