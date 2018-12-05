FROM ubuntu:16.04

MAINTAINER "Adrian Gersbach"

ARG LIBPATH=/usr/local
ENV PATH="${PATH}:${LIBPATH}/lib"

# Get g++ for compiling, wget to download Boost, git to clone source code repo,
# and make to automate program compilation with Makefile provided
RUN apt-get update \
  && apt-get install -y git \
                        autoconf \
                        automake \
                        cmake \
                        g++ \                        
                        libtool \
                        make \
                        wget

# Download boost, untar, setup install with bootstrap and only do the Program Options library,
# and then install

ARG BOOST_VERSION=1.68.0
ARG BOOST_VERSION_=1_68_0

RUN cd /home && wget https://dl.bintray.com/boostorg/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_}.tar.gz \
  && tar xfz boost_${BOOST_VERSION_}.tar.gz \
  && rm boost_${BOOST_VERSION_}.tar.gz \
  && cd boost_${BOOST_VERSION_} \
  && ./bootstrap.sh --prefix=${LIBPATH} --with-libraries=atomic,chrono,date_time,filesystem,program_options,random,regex,serialization,signals,system,thread \
  && ./b2 -j8 install \
  && ldconfig ${LIBPATH}/lib \
  && cd /home \
  && rm -rf boost_${BOOST_VERSION_}

ARG GRPC_VERSION=1.16.1

RUN cd /home && mkdir grpc_${GRPC_VERSION} && cd grpc_${GRPC_VERSION} \
  && git clone -b v${GRPC_VERSION} https://github.com/grpc/grpc \
  && cd grpc \
  && git submodule update --init \
  && cd /home/grpc_${GRPC_VERSION}/grpc/third_party/protobuf \
  && ./autogen.sh \
  && ./configure --prefix=${LIBPATH} \
  && make -j8 \
  && make install \
  && cd /home/grpc_${GRPC_VERSION}/grpc \
  && make -j8 \
  && make prefix=${LIBPATH} install \
  && ldconfig ${LIBPATH}/lib \
  && cd /home \
  && rm -rf grpc_${GRPC_VERSION}

ARG POCO_VERSION=1.9.0

RUN cd /home && wget http://pocoproject.org/releases/poco-${POCO_VERSION}/poco-${POCO_VERSION}-all.tar.gz \
  && tar xfz poco-${POCO_VERSION}-all.tar.gz \
  && rm poco-${POCO_VERSION}-all.tar.gz \
  && cd poco-${POCO_VERSION}-all \
  && mkdir cmake_build \
  && cd cmake_build \
  && cmake -DWT_CPP_11_MODE='-std=c++11' -DENABLE_NETSSL=OFF -DENABLE_DATA_SQLITE=OFF -DENABLE_DATA_ODBC=OFF -DENABLE_DATA_MYSQL=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${LIBPATH} .. \
  && make -j8 \
  && make install \
  && ldconfig ${LIBPATH}/lib \
  && cd /home \
  && rm -rf poco-${POCO_VERSION}-all

ARG WT_VERSION=4.0.4

RUN cd /home && wget https://github.com/emweb/wt/archive/${WT_VERSION}.tar.gz \
  && tar xfz ${WT_VERSION}.tar.gz \
  && rm ${WT_VERSION}.tar.gz \
  && cd wt-${WT_VERSION} \
  && mkdir cmake_build \
  && cd cmake_build \
  && cmake -DWT_CPP_11_MODE='-std=c++11' -DBOOST_ROOT=${LIBPATH} -DCMAKE_INSTALL_PREFIX=${LIBPATH} -DENABLE_SQLITE=OFF -DENABLE_POSTGRES=OFF -DENABLE_FIREBIRD=OFF -DENABLE_MYSQL=OFF -DENABLE_MSSQLSERVER=OFF .. \
  && make -j8 \
  && make install \
  && ldconfig ${LIBPATH}/lib \
  && cd /home \
  && rm -rf wt-${WT_VERSION}
