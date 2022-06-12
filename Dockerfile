FROM ubuntu:18.04
LABEL Description="Image for building and debugging arm-embedded projects from git"
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
    && apt-get install -y python3-pip python3-dev \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && pip3 install --upgrade pip

RUN wget -qO- https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 | tar -xj

ENV PATH "/work/gcc-arm-none-eabi-9-2019-q4-major/bin:$PATH"