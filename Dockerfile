FROM moosivp/moos-ivp:r9526

USER root
RUN apt install -y git
RUN git clone https://github.com/protocolbuffers/protobuf.git
