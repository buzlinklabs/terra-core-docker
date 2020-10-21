docker build -t buzlinklabs/terra-core:tequila-0004-snapshot \
    --build-arg TARGET_HEIGHT=$1 \
    --build-arg CHAIN_ID=tequila-0004 \
    --build-arg ENV_MONIKER=terra-docker \
    --build-arg ENV_MIN_GAS_PRICES=0.15uluna,0.15uusd,0.1018usdr,178.05ukrw,431.6259umnt \
    --build-arg ENV_SEEDS=b8d00ea1a68092f2963f8bfb8bf3dd7010e688f8@public-seed2.terra.dev:36656 \
    .