FROM alpine
#WORKDIR /app
#COPY package.json yarn.lock ./
#RUN yarn install --production
#COPY . .
#RUN yarn install --production
#RUN apk add tcl mariadb-connector-c-dev
#CMD ["/bin/sh"]

## required to compile.  remove from the image when done.
## along with 'work'
RUN apk add build-base
RUN mkdir /work && cd /work \
	&& wget https://prdownloads.sourceforge.net/tcl/tcl8.6.11-src.tar.gz \
	&& tar zxvf tcl8.6.11-src.tar.gz \	
  	&& cd tcl8.6.11/unix \
	&& ./configure --enable-threads \
	&& make && make install 

RUN	cd /work \
	&& wget https://sourceforge.net/projects/expect/files/Expect/5.45.4/expect5.45.4.tar.gz/download \
  	&& mv download  expect5.45.4.tgz \
  	&& tar zxvf expect5.45.4.tgz \
  	&& cd expect5.45.4 \
	&& ./configure && make && make install



RUN cd /work \
	&& wget https://core.tcl-lang.org/tcltls/uv/tcltls-1.7.22.tar.gz \
        && tar zxvf tcltls-1.7.22.tar.gz \
	&& cd tcltls-1.7.22 \
        && apk add openssl-dev \
	&& ./configure && make  && make install  \
	&& cd {/usr/local/lib\} && mv tcltls1.7.22 /usr/local/lib

CMD ["/bin/sh"]
##  82 apk add openssl-devel
##  83 apk add openssl-develsaf
##  84 apk add makeupshit
##  85 apk add libssl-dev
##  86 apk add libssl
##  87 apk add pkg-config
##  88 apk add openssl-dev
##  88 apk add openssl-dev
##  89 ./configure
##  90 make
##  91 make install
##  92 tclsh
##  93 tclsh8.6
##  94 cd ..
##  95 tclsh8.6
##  96 ls -al
##  97 cd tcltls-1.7.22/
##  98 ls -al
##  99 ./configure
## 100 make
## 101 make install
## 102 ls -al
## 103 cd {
## 104 ls -al
## 105 cd usr/
## 106 ls -al
## 107 cd local/
## 108 ls -al
## 109 cd lib\}/
## 110 ls -al
## 111 mv tcltls1.7.22/ /usr/local/lib
##
