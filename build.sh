#!/bin/bash
set +x
COLOR_BOLD="\033[1m"
COLOR_BLACK="\033[1;30m"
COLOR_RED="\033[1;31m"
COLOR_GREEN="\033[1;32m"
COLOR_BLUE="\033[1;34m"
COLOR_YELLOW="\033[1;33m"
COLOR_MAGENTA="\033[1;35m"
COLOR_CYAN="\033[1;36m"
COLOR_OFF="\033[0m" # \e[0m vs \e[m, unclear


barf()
{
    echo -ne "${COLOR_RED}"
    echo -e "$@" >&2
    echo -ne "${COLOR_OFF}"
    exit 1
}

banner()
{
    local LINE='+-------------'
    echo
    echo -e "${COLOR_BOLD}${LINE}"
    echo -e "| $@ "
    echo -e "${LINE}${COLOR_OFF}"
}

NEW_LAYOUT=$1

LAYOUT="keyboards/kinesis/keymaps/seabadger/seabadger.json"
KEYMAP="keyboards/kinesis/keymaps/seabadger/keymap.c"

if [ ! -z "$NEW_LAYOUT" ]; then
    [ -f "$NEW_LAYOUT" ] || barf "layout not found: $NEW_LAYOUT"
    if diff -q "$NEW_LAYOUT" "$LAYOUT" >/dev/null; then
        banner "Layout unchanged"
    else
        banner "New layout: $NEW_LAYOUT"
        cp "$NEW_LAYOUT" "$LAYOUT" || barf "failed to copy $NEW_LAYOUT to $LAYOUT"
    fi
fi

[ -f "$LAYOUT" ] || barf "layout missing: $LAYOUT"
if [ "$LAYOUT" -nt "$KEYMAP" ]; then
    banner "converting layout $LAYOUT"
    qmk json2c -o $KEYMAP $LAYOUT || barf "failed to convert layout $LAYOUT"
fi
banner "building keymap"
qmk compile -j 8 || barf "failed to build keymap $KEYMAP"

banner "Ready to flash. Please enter programming mode."
teensy_loader_cli -w --mcu TEENSY2PP kinesis_kint2pp_seabadger.hex
