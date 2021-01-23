FROM moosivp/moos-ivp:r9526

USER root
# All RUN commands start in this directory; state is not maintained between.
WORKDIR /home/moos

RUN apt install -y git
# Protobuf dependencies
RUN apt install -y autoconf automake libtool curl make g++ unzip

RUN git clone https://github.com/protocolbuffers/protobuf.git
RUN cd protobuf && git submodule update --init --recursive && ./autogen.sh
RUN cd protobuf && ./configure && make && make check && make install && ldconfig

# Our test repo
# RUN git clone https://github.com/lauralindzey/moos_experiments.git
# RUN cd moos_experiments && mkdir build && cd build && cmake .. && make && make install
