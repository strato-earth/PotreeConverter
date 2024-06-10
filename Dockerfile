FROM ubuntu:jammy AS builder

RUN apt-get update && apt-get install -y g++ git cmake libboost-all-dev
RUN mkdir /data

WORKDIR /data

RUN git clone https://github.com/m-schuetz/LAStools.git
WORKDIR /data/LAStools/LASzip
RUN mkdir build
RUN cd build && cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cd build && make

RUN mkdir ./PotreeConverter
WORKDIR /data/PotreeConverter
COPY . /data/PotreeConverter
RUN mkdir build
RUN cd build && cmake -DCMAKE_BUILD_TYPE=Release -DLASZIP_INCLUDE_DIRS=/data/LAStools/LASzip/dll -DLASZIP_LIBRARY=/data/LAStools/LASzip/build/src/liblaszip.so .. 
RUN cd build && make
RUN cp -R /data/PotreeConverter/PotreeConverter/resources/ /data

FROM ubuntu:jammy

RUN apt-get update && apt-get install -y libtbb-dev && rm -rf /var/lib/apt/lists/*

COPY --from=builder /data/PotreeConverter/build/PotreeConverter /PotreeConverter/build
COPY LICENSE /PotreeConverter/LICENSE
COPY README.md /PotreeConverter/README.md
COPY --from=builder /data/LAStools/LASzip/dll /data/LAStools/LASzip/dll
COPY --from=builder /data/LAStools/LASzip/build/src/liblaszip.so /data/LAStools/LASzip/build/src/liblaszip.so

WORKDIR /PotreeConverter/build

ENV PATH="/PotreeConverter/build:${PATH}"
