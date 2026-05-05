#!/bin/bash

# ==========================================================
# Skrip Pemanggil Otomatis untuk Bot
# by FreeZeeHost Official
# ==========================================================

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

if [ -f /etc/needrestart/needrestart.conf ]; then
    sudo sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
    sudo sed -i "s/\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
fi

if ! command -v jq &> /dev/null; then
    sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get update -y > /dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get install -y jq > /dev/null 2>&1
fi

GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
REPO="FreeZeeHostProject/protect"
KEY="FreeZeeHostgege"
MAIN_SCRIPT_NAME="antirusuh.sh"

run_remote_cmd() {
    bash <(curl -H "Authorization: token $GITHUB_TOKEN" -fsSL "https://api.github.com/repos/$REPO/contents/$MAIN_SCRIPT_NAME" | jq -r '.content' | base64 -d)
}

PILIHAN_MENU="$1"
ARGUMEN_KEDUA="$2"
ARGUMEN_KETIGA="$3"
ARGUMEN_KEEMPAT="$4"

MENU="${PILIHAN_MENU,,}"

if [[ "$MENU" == "u" ]]; then
    run_remote_cmd << EOF
u
y
x
EOF
    exit 0
fi

if [[ "$MENU" == "c" ]]; then
    if [[ -z "$ARGUMEN_KEDUA" || -z "$ARGUMEN_KETIGA" || -z "$ARGUMEN_KEEMPAT" ]]; then
        echo "Error: Mode custom membutuhkan 3 argumen (ID Admin, Proteksi Dasar, Proteksi Tambahan)."
        exit 1
    fi

    run_remote_cmd << EOF
c
$KEY
$ARGUMEN_KEDUA
$ARGUMEN_KETIGA
$ARGUMEN_KEEMPAT
y
x
EOF
    exit 0
fi

if [[ "$MENU" =~ ^[0-9]+$ ]]; then
    if [[ -z "$ARGUMEN_KEDUA" ]]; then
        echo "Error: ID Admin (argumen kedua) wajib diisi untuk instalasi standar."
        exit 1
    fi

    run_remote_cmd << EOF
$MENU
$KEY
$ARGUMEN_KEDUA
y
x
EOF
    exit 0
fi

echo "Error: Pilihan menu tidak valid."
echo "Gunakan:"
echo "  1-9  → Instalasi standar"
echo "  c    → Instalasi custom"
echo "  u    → Uninstall"
exit 1
