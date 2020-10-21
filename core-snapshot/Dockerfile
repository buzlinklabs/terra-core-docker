ARG CHAIN_ID
ARG CORE_TAG=${CHAIN_ID}

FROM buzlinklabs/terra-core:${CORE_TAG}

ARG CHAIN_ID
ARG TARGET_HEIGHT=0
ARG ENV_MONIKER
ARG ENV_MIN_GAS_PRICES
ARG ENV_SEEDS

ENV MONIKER=${ENV_MONIKER}
ENV MIN_GAS_PRICES=${ENV_MIN_GAS_PRICES}
ENV SEEDS=${ENV_SEEDS}
ENV LCD_CHAIN_ID=${CHAIN_ID}

COPY wait-sync.sh /usr/local/bin/wait-sync.sh

USER root
RUN touch /tmp/check_user && [ "$(id -u terra-snapshot 2> /tmp/check_user)" ] || adduser terra-snapshot --disabled-password --uid 2000
WORKDIR /home/terra-snapshot
USER terra-snapshot

RUN [ -e "genesis.json" ] || cp /home/terra/genesis.json ~/genesis.json
RUN LCD_ENABLE=true && run-terrad.sh | wait-sync.sh $TARGET_HEIGHT

USER terra
WORKDIR /home/terra

CMD mv /home/terra-snapshot/.terrad/* /home/terra/.terrad/ && run-terrad.sh