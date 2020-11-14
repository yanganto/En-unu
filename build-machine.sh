#!/usr/bin/env sh
Error() {
    echo -e "\e[38;5;202m$1\e[0m"
}
Msg() {
    echo -e "\e[38;5;82m$1\e[0m"
}
Check() {
    if [ $1 == 0 ]; then
        Msg "$2"
    else
        Error "$3"
        exit $4
    fi
}

SCRIPT=$(realpath $0)
if [ $# -lt 1 ]; then
    Error "Error: machine name not found, possible mahcines are:"
    echo `ls $(dirname $SCRIPT)/machines`
    exit 1
fi

MACHINE_NAME=$1
SRC_CONFIG_FILE=$(realpath "$(dirname $SCRIPT)/configuration.nix")
CONFIG_FILE=$(realpath "$(dirname $SCRIPT)/machines/$MACHINE_NAME/configuration.nix")
Check $? "Use ${MACHINE_NAME} configure" "Machaine name is not correct" 2

cp  $SRC_CONFIG_FILE $CONFIG_FILE

if ! [ -e $CONFIG_FILE ]; then
    Error "machine $MACHINE_NAME not foundError: machine name not found, possible mahcines are:"
    exit 3
fi

echo "Configuration file: $CONFIG_FILE"

if [ $# -gt 1 ]; then
    Msg "Exec nixos-rebuild $2"
    NIXOS_CONFIG=$CONFIG_FILE nixos-rebuild $2
    # --max-jobs 1
else
    Msg "Exec nixos-rebuild switch"
    NIXOS_CONFIG=$CONFIG_FILE nixos-rebuild switch
fi
Check $? "Ok" "NixOs rebuild fail"

rm -f $CONFIG_FILE
