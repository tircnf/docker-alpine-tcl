FROM alpine
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

COPY readline.tcl readline.tcl
## remove 'work' and extra dependencies when done.
RUN  \
	apk add build-base openssl-dev \
	&& apk add mariadb-connector-c-dev \
	&& mkdir /work && cd /work \
	&& wget https://prdownloads.sourceforge.net/tcl/tcl8.6.11-src.tar.gz \
	&& tar zxvf tcl8.6.11-src.tar.gz \	
  	&& cd tcl8.6.11/unix \
	&& ./configure --enable-threads \
	&& make && make install  \
	&& cd /work \
	&& wget https://sourceforge.net/projects/expect/files/Expect/5.45.4/expect5.45.4.tar.gz/download \
  	&& mv download  expect5.45.4.tgz \
  	&& tar zxvf expect5.45.4.tgz \
  	&& cd expect5.45.4 \
	&& ./configure && make && make install \
	&& cd /work \
	&& wget https://core.tcl-lang.org/tcltls/uv/tcltls-1.7.22.tar.gz \
        && tar zxvf tcltls-1.7.22.tar.gz \
	&& cd tcltls-1.7.22 \
	&& ./configure && make  && make install  \
	&& cd {/usr/local/lib\} && mv tcltls1.7.22 /usr/local/lib \
	&& apk del build-base openssl-dev \
	&& rm -rf /work \
	&& ln -sf /usr/local/bin/tclsh8.6 /usr/local/bin/tclsh



#CMD ["tclsh8.6","readline.tcl"]
CMD ["/bin/sh"]
