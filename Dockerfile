FROM moosivp/moos-ivp:r9526

USER root
# All RUN commands start in this directory; state is not maintained between.
WORKDIR /home/moos
ENV MOOS_DIR=/home/moos/moos-ivp/build/MOOS/MOOSCore

# Builts were failing with "Unable to fetch some archives, maybe run apt-get update or try with --fix-missing"
RUN apt update

# We also use the tf2 library
RUN apt install -y libeigen3-dev 
RUN apt install -y libtf2-dev 
RUN apt install -y libtf2-eigen-dev

# Install pymoos
RUN apt install -y git
RUN apt install -y python3
RUN apt install -y python3-setuptools
RUN git clone https://github.com/msis/python-moos.git
RUN cd python-moos && python3 setup.py build && python3 setup.py install

# Protobuf dependencies; do protobuf last because it's so slow.
RUN apt install -y autoconf automake libtool curl make g++ unzip

RUN git clone https://github.com/protocolbuffers/protobuf.git
RUN cd protobuf && git submodule update --init --recursive && ./autogen.sh
# For some reason, make check fails when building on hub.docker.com, but not locally.
#RUN cd protobuf && ./configure && make && make check && make install && ldconfig
RUN cd protobuf && ./configure && make && make install && ldconfig
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib

# TODO: Also python moos directories?


# Our test repo
RUN apt install -y libboost-all-dev
RUN git clone https://github.com/lindzey/moos_experiments.git
RUN cd moos_experiments && mkdir build && cd build && cmake .. && make && make install
ENV PATH=${PATH}:/home/moos/moos_experiments/devel/bin
