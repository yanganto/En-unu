#!/usr/bin/env sh

SCRIPT=$(realpath -s $0)

if [ $# -lt 1 ]; then
    echo "Error: machine name not found, possible mahcines are:"
    echo ""
    echo `ls $(dirname $SCRIPT)/machines`
    exit -1
fi

MACHINE_NAME=$1
CONFIG_FILE=$(realpath "$(dirname $SCRIPT)/machines/$MACHINE_NAME/configuration.nix")
SRC_CONFIG_FILE=$(realpath "$(dirname $SCRIPT)/configuration.nix")

cp  $SRC_CONFIG_FILE $CONFIG_FILE

if ! [ -e $CONFIG_FILE ]; then
    echo "machine $MACHINE_NAME not found"
    exit -1
fi

echo "Configuration file: $CONFIG_FILE"

if [ $# -gt 1 ]; then
    echo "nixos-rebuild $2"
    NIXOS_CONFIG=$CONFIG_FILE nixos-rebuild $2 --max-jobs 1
else
    echo "nixos-rebuild switch"
    NIXOS_CONFIG=$CONFIG_FILE nixos-rebuild switch --max-jobs 1
fi

rm -f $CONFIG_FILE
