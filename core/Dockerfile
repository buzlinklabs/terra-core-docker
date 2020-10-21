FROM cosmwasm/go-ext-builder:0.8.2-alpine AS build

WORKDIR /go/src

RUN apk add --no-cache git libusb-dev linux-headers && \
    git clone https://github.com/terra-project/core/

WORKDIR /go/src/core

ARG TERRA_VERSION=v0.4.0

RUN git checkout ${TERRA_VERSION} && \
    go mod download github.com/CosmWasm/go-cosmwasm && \
    export GO_WASM_DIR=$(go list -f "{{ .Dir }}" -m github.com/CosmWasm/go-cosmwasm) && \
    cd ${GO_WASM_DIR} && \
    cargo build --release --features backtraces --example muslc && \
    mv ${GO_WASM_DIR}/target/release/examples/libmuslc.a /lib/libgo_cosmwasm_muslc.a

WORKDIR /go/src/core

RUN BUILD_TAGS=muslc make update-swagger-docs build


FROM alpine:3

EXPOSE 26656
EXPOSE 26657
EXPOSE 1317
EXPOSE 26660

ARG GENESIS=""

ENV GENESIS=${GENESIS}
ENV ADDRESS_BOOK=""
ENV MONIKER=""
ENV MIN_GAS_PRICES="0.00506uluna,0.0015uusd,0.00102usdr,1.7805ukrw,4.31626umnt"
ENV SEEDS=""
ENV LCD_ENABLE="false"
ENV LCD_CHAIN_ID=""
ENV LCD_REMOTE_NODE="tcp://localhost:26657"
ENV LCD_ADDRESS="tcp://0.0.0.0:1317"
ENV LCD_TRUST_NODE="false"

RUN [ -z "${GENESIS}" ] && (echo "Required \$GENESIS"; exit 1) || echo "Build with ${GENESIS}"
RUN apk add --no-cache curl && \
    adduser terra --disabled-password --uid 1000

USER terra
WORKDIR /home/terra
VOLUME [ "/home/terra/.terrad" ]

COPY --from=build /go/src/core/build/terrad /usr/local/bin/terrad
COPY --from=build /go/src/core/build/terracli /usr/local/bin/terracli
COPY run-terrad.sh /usr/local/bin/run-terrad.sh

RUN curl -o ~/genesis.json ${GENESIS}

CMD ["run-terrad.sh"]