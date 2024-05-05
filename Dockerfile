FROM ubuntu:jammy as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    libtbb-dev

WORKDIR /

COPY CMakeLists.txt /PotreeConverter/
COPY Converter /PotreeConverter/Converter
COPY resources /PotreeConverter/resources
COPY LICENSE /PotreeConverter/LICENSE
COPY README.md /PotreeConverter/README.md

WORKDIR /PotreeConverter

RUN mkdir build && cd build && cmake .. && make

FROM ubuntu:jammy

RUN apt-get update && apt-get install -y libtbb-dev && rm -rf /var/lib/apt/lists/*

COPY --from=builder /PotreeConverter /PotreeConverter

WORKDIR /PotreeConverter/build

ENV PATH="/PotreeConverter/build:${PATH}"
ENV PATH="/PotreeConverter:${PATH}"
