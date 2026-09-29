FROM ubuntu:24.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    qtbase5-dev \
    qtdeclarative5-dev \
    qml-module-qtquick-controls2 \
    qml-module-qtwebsockets \
    qml-module-qtwebchannel \
    qttools5-dev \
    qttools5-dev-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN git clone --branch 5.6.6 --depth 1 \
    https://github.com/mhogomchungu/media-downloader.git .

RUN mkdir build \
    && cd build \
    && cmake .. -DCMAKE_BUILD_TYPE=Release \
    && make -j"$(nproc)" \
    && make install


FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99

RUN apt-get update && apt-get install -y \
    libqt5core5t64 \
    libqt5gui5t64 \
    libqt5widgets5t64 \
    libqt5network5t64 \
    xvfb \
    x11vnc \
    novnc \
    fluxbox \
    ffmpeg \
    ca-certificates \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/media-downloader /usr/local/bin/media-downloader
COPY --from=builder /usr/local/share/media-downloader /usr/local/share/media-downloader

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /downloads

EXPOSE 6080

ENTRYPOINT ["/entrypoint.sh"]
