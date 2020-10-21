#! /bin/sh

TERRA_VERSION='v0.4.0'
CHAIN_ID="tequila-0004"
TAG="$CHAIN_ID"
GENESIS='https://raw.githubusercontent.com/terra-project/testnet/master/tequila-0004/genesis.json'

docker build -t terra-core:$TAG \
    --build-arg TERRA_VERSION="$TERRA_VERSION" \
    --build-arg GENESIS="$GENESIS" \
    .