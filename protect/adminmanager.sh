#!/bin/bash

# ============================================================
# SKRIP INI DIBUAT OLEH FreeZeeHost OFFICIAL (TELEGRAM: @FreeZeeHostofc)
# DILARANG UNTUK MEMPERJUALBELIKAN SKRIP INI, APALAGI MEMBAGIKANNYA SECARA GRATIS!
# KETAHUAN NGEYEL? LIHAT SAJA AKIBATNYA NANTI.
# ============================================================

BOLD='\033[1m'
MERAH='\033[0;31m'
KUNING='\033[0;33m'
HIJAU='\033[0;32m'
BIRU='\033[0;34m'
OREN='\033[0;33m'
CYAN='\033[0;36m'
PUTIH='\033[1;37m'
NC='\033[0m' # No Color

FILE_PATH="/var/www/pterodactyl/app/Http/Controllers/FreeZeeHostganteng.json"

if [ ! -f "$FILE_PATH" ]; then
    clear
    echo -e "\n${BOLD}${MERAH}✖ ERROR: Sistem whitelist tidak ditemukan.${NC}"
    echo -e "${KUNING}   Ini berarti fitur proteksi 'Anti Admin Panel Ilegal' belum terpasang."
    echo -e "${KUNING}   Silakan jalankan skrip instalasi terlebih dahulu.${NC}\n"
    exit 1
fi

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

_id_exists() {
    local id_to_check="$1"
    if jq -r '.[]' "$FILE_PATH" | grep -qFx "$id_to_check"; then
        return 0
    else
        return 1
    fi
}

_add_ids() {
    local ids_input="$1"
    if [[ -z "$ids_input" ]]; then echo -e "${BOLD}${MERAH}✖ Error: Input ID tidak boleh kosong.${NC}"; return 1; fi
    IFS=',' read -ra id_array <<< "$ids_input"
    
    echo ""
    for id in "${id_array[@]}"; do
        trimmed_id=$(echo "$id" | xargs)
        if [[ -n "$trimmed_id" ]]; then
            if _id_exists "$trimmed_id"; then
                echo -e "${KUNING} ℹ️ ID ${PUTIH}$trimmed_id${KUNING} sudah ada dalam daftar. Dilewati.${NC}"
            else
                jq ". |= . + [$trimmed_id] | unique" "$FILE_PATH" > "${FILE_PATH}.tmp" && mv "${FILE_PATH}.tmp" "$FILE_PATH"
                echo -e "${HIJAU} ✅ Sukses! ID ${PUTIH}$trimmed_id${HIJAU} telah ditambahkan.${NC}"
            fi
        fi
    done
}

_remove_ids() {
    local ids_input="$1"
    if [[ -z "$ids_input" ]]; then echo -e "${BOLD}${MERAH}✖ Error: Input ID tidak boleh kosong.${NC}"; return 1; fi
    IFS=',' read -ra id_array <<< "$ids_input"

    echo ""
    for id in "${id_array[@]}"; do
        trimmed_id=$(echo "$id" | xargs)
        if [[ -n "$trimmed_id" ]]; then
            if _id_exists "$trimmed_id"; then
                jq "del(.[] | select(. == $trimmed_id))" "$FILE_PATH" > "${FILE_PATH}.tmp" && mv "${FILE_PATH}.tmp" "$FILE_PATH"
                echo -e "${HIJAU} ✅ Sukses! ID ${PUTIH}$trimmed_id${HIJAU} telah dihapus.${NC}"
            else
                echo -e "${KUNING} ℹ️ ID ${PUTIH}$trimmed_id${KUNING} tidak ditemukan dalam daftar. Dilewati.${NC}"
            fi
        fi
    done
}

_list_ids() {
    if ! jq -e '. | length > 0' "$FILE_PATH" > /dev/null; then
        echo -e "\n${BOLD}${KUNING}( Belum ada ID yang terdaftar )\n${NC}"
    else
        echo ""
        jq -r '.[]' "$FILE_PATH" | while read -r id; do
            echo -e "   ${BOLD}${HIJAU}•${NC} ${BOLD}${PUTIH}ID Admin:${NC} ${BOLD}${CYAN}$id${NC}"
        done
        echo ""
    fi
}

show_action_banner() {
    clear
    echo -e "${BOLD}${CYAN}
   ███████╗ █████╗ ███╗   ██╗ ██████╗
   ██╔════╝██╔══██╗████╗  ██║██╔═══██╗
   ███████╗███████║██╔██╗ ██║██║   ██║
   ╚════██║██╔══██║██║╚██╗██║██║   ██║
   ███████║██║  ██║██║ ╚████║╚██████╔╝
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝
${NC}"
    echo -e "${BOLD}${BIRU}=====================================================${NC}\n"
}

add_ids_interactive() {
    show_action_banner
    echo -e "${BOLD}${HIJAU}--- Menambah ID Admin yang Diizinkan ---${NC}"
    echo -e "${BOLD}${PUTIH} ➤ Masukkan satu atau lebih ID (pisahkan dengan koma):${NC}"
    read -p "   ↳ " id_input
    _add_ids "$id_input"
}

remove_ids_interactive() {
    show_action_banner
    echo -e "${BOLD}${MERAH}--- Menghapus ID Admin dari Daftar Izin ---${NC}"
    echo -e "${BOLD}${PUTIH} ➤ Masukkan satu atau lebih ID (pisahkan dengan koma):${NC}"
    read -p "   ↳ " id_input
    _remove_ids "$id_input"
}

list_ids_interactive() {
    show_action_banner
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║     ${BOLD}${PUTIH}Daftar ID Admin yang Diizinkan     ${BOLD}${CYAN}║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
    _list_ids
}

run_interactive_mode() {
    clear
    echo -e "${BOLD}${CYAN}
   ███████╗ █████╗ ███╗   ██╗ ██████╗
   ██╔════╝██╔══██╗████╗  ██║██╔═══██╗
   ███████╗███████║██╔██╗ ██║██║   ██║
   ╚════██║██╔══██║██║╚██╗██║██║   ██║
   ███████║██║  ██║██║ ╚████║╚██████╔╝
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝
${NC}"
    echo -e "${BOLD}${HIJAU}
    ██████╗  ██████╗ ██████╗██╗ ██████╗██╗ █████╗ ██╗
   ██╔═══██╗██╔════╝██╔════╝██║██╔════╝██║██╔══██╗██║
   ██║   ██║███████╗███████╗██║██║     ██║███████║██║
   ██║   ██║██╔════╝██╔════╝██║██║     ██║██╔══██║██║
   ╚██████╔╝██║     ██║     ██║╚██████╗██║██║  ██║██████╗
    ╚═════╝ ╚═╝     ╚═╝     ╚═╝ ╚═════╝╚═╝╚═╝  ╚═╝╚═════╝
${NC}"
    sleep 1

    while true; do
        clear
        echo -e "${BOLD}${CYAN}╭──────────────────────────────────────────────────╮${NC}"
        echo -e "${BOLD}${CYAN}│${NC}        ${BOLD}${BIRU}Anti-Rusuh - Admin ID Manager${NC}             ${BOLD}${CYAN}│${NC}"
        echo -e "${BOLD}${CYAN}│${NC}               ${BOLD}${BIRU}by FreeZeeHost Official${NC}                   ${BOLD}${CYAN}│${NC}"
        echo -e "${BOLD}${CYAN}├──────────────────────────────────────────────────┤${NC}"
        echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${HIJAU}[1] Tambah ID Admin yang Diizinkan${NC}             ${BOLD}${CYAN}│${NC}"
        echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${MERAH}[2] Hapus ID Admin dari Daftar Izin${NC}            ${BOLD}${CYAN}│${NC}"
        echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${OREN}[3] Lihat Semua ID yang Diizinkan${NC}              ${BOLD}${CYAN}│${NC}"
        echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${KUNING}[x] Keluar${NC}                                     ${BOLD}${CYAN}│${NC}"
        echo -e "${BOLD}${CYAN}╰──────────────────────────────────────────────────╯${NC}"
        
        echo -e "\n${BOLD}${KUNING} ➤ Pilih Opsi:${NC}"
        read -p "   ↳ " choice

        case $choice in
            1) add_ids_interactive ;;
            2) remove_ids_interactive ;;
            3) list_ids_interactive ;;
            [xX])
                echo -e "\n${BOLD}${BIRU}Keluar dari Admin Manager.${NC}"
                exit 0
                ;;
            *)
                echo -e "\n${BOLD}${MERAH}Pilihan tidak valid.${NC}"
                ;;
        esac
        echo -e "\n${BOLD}${KUNING}Tekan [Enter] untuk kembali ke menu...${NC}"
        read
    done
}

if [ -z "$1" ]; then
    run_interactive_mode
else
    case $1 in
        add)
            _add_ids "$2"
            ;;
        del)
            _remove_ids "$2"
            ;;
        list)
            echo -e "${BOLD}${BIRU}--- Daftar ID Admin yang Diizinkan ---${NC}"
            _list_ids
            echo -e "${BOLD}${BIRU}--------------------------------------${NC}"
            ;;
        *)
            echo "Penggunaan: $0 {add|del|list} [ID_Admin]"
            echo "Atau jalankan tanpa argumen untuk mode interaktif."
            exit 1
            ;;
    esac
fi
