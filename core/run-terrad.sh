#! /bin/sh

if [ -z "${MONIKER}" ]
then
    echo "Required \$MONIKER environment variable"
    exit 1
fi

if [ -z "${SEEDS}" ]
then
    echo "Required \$SEEDS environment variable"
    exit 1
fi

if [ ! -e "/home/terra/.terrad/config/genesis.json" ]
then
    echo "Initialize terrad"
    terrad init ${MONIKER}
    rm ~/.terrad/config/genesis.json
    ln -s ~/genesis.json ~/.terrad/config/genesis.json
fi

if [ ! -z "${ADDRESS_BOOK}" ] 
then
    curl -o ~/.terrad/config/addrbook.json ${ADDRESS_BOOK}
else
    echo "No address book"
fi

sed -i "s/minimum-gas-prices = \"\"/minimum-gas-prices = \"${MIN_GAS_PRICES}\"/" ~/.terrad/config/app.toml
sed -i "s/seeds = \"\"/seeds = \"${SEEDS}\"/" ~/.terrad/config/config.toml

terrad start &

if [ "${LCD_ENABLE}" = "true" ]
then
    if [ -z "${LCD_CHAIN_ID}" ]
    then
        echo "Required \$LCD_CHAIN_ID environment variable"
        exit 1
    fi

    sleep 5;

    terracli rest-server --chain-id=${LCD_CHAIN_ID} \
        --node=${LCD_REMOTE_NODE} \
        --trust-node=${LCD_TRUST_NODE} &
fi

for job in $(jobs -p)
do
    wait $job
done