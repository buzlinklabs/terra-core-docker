#! /bin/sh

TERRA_VERSION='v0.4.0'
CHAIN_ID="columbus-4"
TAG="$CHAIN_ID"
GENESIS='https://columbus-genesis.s3-ap-northeast-1.amazonaws.com/columbus-4-genesis.json'

docker build -t buzlinklabs/terra-core:$TAG \
    --build-arg TERRA_VERSION="$TERRA_VERSION" \
    --build-arg GENESIS="$GENESIS" \
    .