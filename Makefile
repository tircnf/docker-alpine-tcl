
default: docker


docker:
	docker build -t mburns/alpine-tcl .



runtcl:
	docker run --rm -it  -v "`cygpath -am .`:/work" mburns/alpine-tcl

runtclmac:
	docker run --rm -it  -v "`pwd`:/work" mburns/alpine-tcl
	
