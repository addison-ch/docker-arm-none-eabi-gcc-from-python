FROM ubuntu:18.04
LABEL Description="Image for building and debugging arm-embedded projects (including Python3, pip, cppcheck2.8 👍)"
WORKDIR /work

ADD . /work

# Install any needed packages specified in requirements.txt
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
# Development files
      build-essential \
      git \
      bzip2 \
      wget && \
    apt-get clean \
# Add Python3
    && apt-get install -y python3-pip python3-dev \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && pip3 install --upgrade pip \
# Linter set up
    && apt-get install -y build-essential libpcre3 libpcre3-dev 

RUN wget -qO- https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 | tar -xj
RUN wget -O /tmp/cppcheck-2.8.tar.gz https://github.com/danmar/cppcheck/archive/2.8.tar.gz
RUN cd /tmp/ && tar xvzf cppcheck-2.8.tar.gz
RUN cd /tmp/cppcheck-2.8 \
    # && make install SRCDIR=build CFGDIR=/cfg HAVE_RULES=yes
    && make MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck CFGDIR=/usr/bi/cfg HAVE_RULES=yes CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function" install


ENV PATH "/work/gcc-arm-none-eabi-9-2019-q4-major/bin:$PATH"