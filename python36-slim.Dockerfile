FROM python:3.6-slim

# install linux packages
COPY linux/debian/packages.txt /install/
WORKDIR /install
RUN apt-get update \
    && xargs -a packages.txt apt-get install -y --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# swig install
WORKDIR /install
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN wget http://prdownloads.sourceforge.net/swig/swig-3.0.12.tar.gz && tar -xzvf swig-3.0.12.tar.gz
RUN mkdir -p /sw/swigtool && cd /install/swig-3.0.12 && ./configure --prefix=/sw/swigtool && make && make install
ENV PATH="/sw/swigtool/bin:${PATH}"

# Install python packages
WORKDIR /install
COPY python36/requirements.txt /install/
RUN pip install -r requirements.txt

# tests
RUN python --version
RUN pip list
RUN unpaper -V
