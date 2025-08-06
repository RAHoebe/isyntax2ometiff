FROM ubuntu:18.04
ENV LANG=C.UTF-8
RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    git \
    libblosc-dev \
    libcurl4 \
    libegl1-mesa \
    libgles2-mesa \
    libjpeg-turbo8 \
    libpng16-16 \
    libtinyxml2.6.2v5 \
    python3 \
    python3-setuptools \
    python3-pip \
    unzip \
    python3-dev \
    openjdk-11-jdk-headless \
    g++ 

RUN curl -sS  https://bootstrap.pypa.io/pip/3.6/get-pip.py | python3

# Your SDK + tools
COPY philips-pathologysdk.zip /tmp
COPY convert.sh /opt
RUN chmod +x /opt/convert.sh
RUN unzip /tmp/philips*.zip -d /tmp

# Core SDK
RUN dpkg -i /tmp/pathologysdk-modules/philips-pathologysdk-pixelengine*.deb && \
    dpkg -i /tmp/pathologysdk-modules/philips-pathologysdk-softwarerenderer*.deb

# Python 3.8–specific bindings
RUN dpkg -i /tmp/pathologysdk-python36-modules/philips-pathologysdk-python3-pixelengine*.deb && \
    dpkg -i /tmp/pathologysdk-python36-modules/philips-pathologysdk-python3-softwarerendercontext*.deb && \
    dpkg -i /tmp/pathologysdk-python36-modules/philips-pathologysdk-python3-softwarerenderbackend*.deb

RUN rm -rf /tmp/philips*
RUN pip install --no-cache-dir isyntax2raw
COPY raw2ometiff*.zip /tmp
RUN unzip /tmp/raw2ometiff*.zip -d /opt
RUN rm -rf /tmp/raw2ometiff*
RUN ln -s /opt/raw2ometiff*/bin/raw2ometiff /usr/bin/raw2ometiff

ENTRYPOINT ["/opt/convert.sh"]
