FROM debian:stable-slim as zokratesenv

SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

# Install prerequisites
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        curl \
        build-essential \
        pkg-config \
        python3 \
        apt-transport-https && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain none -y \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs && npm i -g solc \
    && curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh \
    && rustup --version; cargo --version; rustc --version; wasm-pack --version; echo nodejs $(node -v);

FROM zokratesenv as builder

WORKDIR /build

ARG VERSION=0.8.8
ADD https://github.com/Zokrates/ZoKrates/archive/refs/tags/${VERSION}.tar.gz .
RUN mkdir -p /build/ZoKrates && tar -zxf ${VERSION}.tar.gz -C /build
WORKDIR /build/ZoKrates-${VERSION}

RUN ./build_release.sh

FROM debian:stable-slim

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt install -y -q --no-install-recommends \
    npm build-essential git curl gnupg2 \
    ca-certificates apt-transport-https \
    sudo ripgrep && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*


RUN useradd -u 1000 --create-home -s /bin/bash -m zokrates
RUN usermod -a -G sudo zokrates
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV ZOKRATES_HOME=/home/zokrates/.zokrates

USER zokrates
WORKDIR /home/zokrates

ARG VERSION=0.8.7
COPY --from=builder --chown=zokrates:zokrates /build/ZoKrates-${VERSION}/target/release/zokrates $ZOKRATES_HOME/bin/
COPY --from=builder --chown=zokrates:zokrates /build/ZoKrates-${VERSION}/zokrates_cli/examples $ZOKRATES_HOME/examples
COPY --from=builder --chown=zokrates:zokrates /build/ZoKrates-${VERSION}/zokrates_stdlib/stdlib $ZOKRATES_HOME/stdlib

ENV PATH "$ZOKRATES_HOME/bin:$PATH"
ENV ZOKRATES_STDLIB "$ZOKRATES_HOME/stdlib"

WORKDIR /workspaces/zokratescrucible

COPY --chown=zokrates:zokrates . .

RUN ~/cargo test --release -- --nocapture
