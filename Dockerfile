FROM moosivp/moos-ivp:r9526

USER root
# All RUN commands start in this directory; state is not maintained between.
WORKDIR /home/moos
ENV MOOS_DIR=/home/moos/moos-ivp/build/MOOS/MOOSCore

RUN apt install -y git
# Protobuf dependencies
RUN apt install -y autoconf automake libtool curl make g++ unzip

RUN git clone https://github.com/protocolbuffers/protobuf.git
RUN cd protobuf && git submodule update --init --recursive && ./autogen.sh
RUN cd protobuf && ./configure && make && make check && make install && ldconfig
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib

# TODO: Also python moos directories?

# Our test repo
RUN apt install -y libboost-all-dev
RUN git clone https://github.com/lindzey/moos_experiments.git
RUN cd moos_experiments && mkdir build && cd build && cmake .. && make && make install
ENV PATH=${PATH}:/home/moos/moos_experiments/devel/bin
