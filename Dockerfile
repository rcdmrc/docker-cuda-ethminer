FROM nvidia/cuda:11.0-devel as builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt -y update 
RUN apt -y install build-essential cmake git libdbus-1-dev mesa-common-dev
RUN git clone https://github.com/ethereum-mining/ethminer.git
WORKDIR /ethminer
RUN git submodule update --init --recursive
RUN cmake -S . -B .build_dir -D CMAKE_INSTALL_PREFIX=/opt/ethminer -DETHASHCUDA=ON -DAPICORE=ON -DETHASHCL=OFF
RUN cmake --build .build_dir -j $(nproc)
RUN cmake --install .build_dir

FROM nvidia/cuda:11.0-base
ARG DEBIAN_FRONTEND=noninteractive
COPY --from=builder /opt/ethminer /opt/ethminer
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

EXPOSE 8080

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]