
default: docker


docker:
	docker build -t mburns/alpine-tcl .



runtcl:
	docker run --rm -it  -v "`cygpath -am .`:/work" tcl

	
