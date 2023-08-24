FROM alpine as one
#WORKDIR /app
#COPY package.json yarn.lock ./
#RUN yarn install --production
#COPY . .
#RUN yarn install --production
#RUN apk add tcl mariadb-connector-c-dev
#CMD ["/bin/sh"]


## installs tcl8.6.11 
## expect 5.45.4  (for tclreadline)
## tls            (for hopeful creation of secure sockets)
## mariadb-connecgtor-j    (to connect to mysql).
##
## don't remember why I added mariadb-connector-c-dev.
## maybe a typo or something?

## remove 'work' and extra dependencies when done.
RUN  \
	apk add build-base openssl-dev \
	&& apk add mariadb-connector-c-dev

RUN \
	mkdir /work && cd /work \
	&& touch /newer \
	&& wget -O- https://prdownloads.sourceforge.net/tcl/tcl8.6.12-src.tar.gz | tar zxvf - 

RUN  \
  	cd /work/tcl8.6.12/unix \
	&& ./configure --enable-threads \
	&& make && make install  


# RUN 	\
# 	cd /work \
# 	&& wget -O- https://sourceforge.net/projects/expect/files/Expect/5.45.4/expect5.45.4.tar.gz/download  | tar zxvf - \
 # 	&& cd expect5.45.4 \
# 	&& ./configure && make && make install 

RUN \
	cd /work \
	&& wget -O- https://core.tcl-lang.org/tcltls/uv/tcltls-1.7.22.tar.gz | tar zxvf - \
	&& cd tcltls-1.7.22 \
	&& ./configure && make  && make install  \
	&& cd {/usr/local/lib\} && mv tcltls1.7.22 /usr/local/lib 

RUN \
	cd /work \
	&& wget -O- http://www.xdobry.de/mysqltcl/mysqltcl-3.052.tar.gz | tar zxvf - \
	&& cd mysqltcl-3.052 \
	&& ./configure && make  && make install 
#	&& cd {/usr/local/lib\} && mv mysqltcl-3.052 /usr/local/lib 


RUN \
	ln -sf /usr/local/bin/tclsh8.6 /usr/local/bin/tclsh 		\
	&& find /usr -newer /newer \! -type d  > /work/filename.txt	\
	&& tar c -T work/filename.txt -f - | (cd /work && tar xvf -)

#	&& apk del build-base openssl-dev \
#	&& rm -rf /work \
#	&& ln -sf /usr/local/bin/tclsh8.6 /usr/local/bin/tclsh


FROM alpine
COPY --from=one /work/usr ./usr
COPY readline.tcl ./

RUN  \
	apk add mariadb-connector-c

#COPY readline.tcl readline.tcl

#CMD ["tclsh8.6","readline.tcl"]
CMD ["/bin/sh"]



## fun way to run under cygwin, and allow mounting current directory:

#  docker run --rm -it  -v "`cygpath -am .`:/work" mburns/alpine-tcl

