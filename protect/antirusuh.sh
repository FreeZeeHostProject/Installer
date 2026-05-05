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

INSTALL_SCRIPT_LEVEL_1="level_1.sh"
INSTALL_SCRIPT_LEVEL_2="level_2.sh"
INSTALL_SCRIPT_LEVEL_3="level_3.sh"
INSTALL_SCRIPT_LEVEL_4="level_4.sh"
INSTALL_SCRIPT_LEVEL_5="level_5.sh"
INSTALL_SCRIPT_LEVEL_6="level_6.sh"
INSTALL_SCRIPT_LEVEL_7="level_7.sh"
INSTALL_SCRIPT_LEVEL_8="level_8.sh"
INSTALL_SCRIPT_LEVEL_9="level_9.sh"
INSTALL_SCRIPT_CUSTOM="custom.sh"
UNINSTALL_SCRIPT="uninstall.sh"
MANAGE_ADMIN="adminmanager.sh"

GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
REPO="FreeZeeHostProject/protect"

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
sleep 0.5

clear
echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║         ${BOLD}${PUTIH}Pengecekan Sistem            ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
if [ ! -f "/var/www/pterodactyl/.env" ]; then
    echo -e "\n${BOLD}${MERAH}✖ ERROR FATAL: Panel Pterodactyl tidak terdeteksi!${NC}"
    echo -e "${BOLD}${KUNING}  File konfigurasi '/var/www/pterodactyl/.env' tidak ditemukan.${NC}"
    echo -e "${BOLD}${KUNING}  Pastikan Anda menjalankan skrip ini di VPS yang sudah terinstall Pterodactyl.${NC}"
    exit 1
else
    echo -e "\n${BOLD}${HIJAU}✓ Panel Pterodactyl terdeteksi.${NC}"
    sleep 0.5
fi

run_script_from_github() {
    local script_name="$1"
    local api_url="https://api.github.com/repos/$REPO/contents/$script_name"

    bash <(curl -H "Authorization: token $GITHUB_TOKEN" -fsSL "$api_url" | jq -r '.content' | base64 -d)
    sleep 1
}

show_features() {
    clear
    echo -e "\n${BOLD}${CYAN}╭──────────────────────────────────────────────────╮${NC}"
    echo -e "${BOLD}${CYAN}│${NC}           ${BOLD}${PUTIH}Penjelasan Fitur Setiap Versi          ${NC}${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}╰──────────────────────────────────────────────────╯${NC}"

    echo -e "\n${BOLD}${PUTIH} Proteksi Level 1 - ${BOLD}${HIJAU}Proteksi Dasar${NC}"
    echo -e "${BOLD}${PUTIH} • Proteksi Akun Admin Utama (Anti Edit/Hapus Sembarangan).${NC}"
    echo -e "${BOLD}${PUTIH} • Hanya Admin Utama Yang Dapat Mengutak-Atik Panel${NC}"
    echo -e "${BOLD}${PUTIH}   Bagian Settings, Databases, Locations, Nodes, Mounts, dan Nests.${NC}"
    
    echo -e "\n${BOLD}${PUTIH} Proteksi Level 2 - ${BOLD}${HIJAU}Proteksi User${NC}"
    echo -e "${BOLD}${PUTIH} • Mencakup semua fitur level 1.${NC}"
    echo -e "${BOLD}${PUTIH} + Proteksi Manajemen User (Anti Utak-Atik${NC}"
    echo -e "${BOLD}${PUTIH}   & Hapus User Sembarangan).${NC}"
   
    echo -e "\n${BOLD}${PUTIH} Proteksi Level 3 - ${BOLD}${HIJAU}Proteksi Server${NC}"
    echo -e "${BOLD}${PUTIH} • Mencakup semua fitur level 2.${NC}"
    echo -e "${BOLD}${PUTIH} + Proteksi Anti Utak-atik & Hapus Server Sembarangan.${NC}"
    
    echo -e "\n${BOLD}${PUTIH} Proteksi Level 4 - ${BOLD}${HIJAU}Proteksi Maintenance${NC}"
    echo -e "${BOLD}${PUTIH} • Mencakup semua fitur level 3.${NC}"
    echo -e "${BOLD}${PUTIH} + Proteksi Anti Aktivasi 2FA (cocok untuk ketika mau${NC}"
    echo -e "${BOLD}${PUTIH}   maintenance atau mau bersih-bersih panel).${NC}"
    
    echo -e "\n${BOLD}${PUTIH} Proteksi Level 5 - ${BOLD}${HIJAU}Proteksi File: Level Awal${NC}"
    echo -e "${BOLD}${PUTIH} • Mencakup semua fitur level 4.${NC}"
    echo -e "${BOLD}${PUTIH} + Proteksi File Manager (Anti intip isi file).${NC}"
    echo -e "${BOLD}${PUTIH} + Proteksi Download File (Anti maling file).${NC}"
    
    echo -e "\n${BOLD}${PUTIH} Proteksi Level 6 - ${BOLD}${HIJAU}Proteksi File: Level Lanjutan${NC}"
    echo -e "${BOLD}${PUTIH} • Mencakup semua fitur level 5.${NC}"
    echo -e "${BOLD}${PUTIH} + Proteksi Total File Manager (Anti Utak-Atik ${NC}"
    echo -e "${BOLD}${PUTIH}   Dan Anti Hapus File Sembarangan).${NC}"
    
    echo -e "\n${BOLD}${PUTIH} Proteksi Level 7 - ${BOLD}${HIJAU}Proteksi Expert${NC}"
    echo -e "${BOLD}${PUTIH} • Mencakup semua fitur level 6.${NC}"
    echo -e "${BOLD}${PUTIH} + Proteksi Anti Ambil Alih Server (Memindahkan Owner${NC}"
    echo -e "${BOLD}${PUTIH}   Server) Untuk Mencegah Kejadian Maling SC Orang.${NC}"
    echo -e "${BOLD}${PUTIH}    ↳ ${BOLD}${KUNING}Fitur ini mencegah admin lain memindahkan kepemilikan${NC}"
    echo -e "${BOLD}${KUNING}      sebuah server ke akun mereka untuk mencuri file.${NC}"
    
    echo -e "\n${BOLD}${PUTIH} Proteksi Level 8 - ${BOLD}${HIJAU}Proteksi Otoritas Penuh${NC}"
    echo -e "${BOLD}${PUTIH} • Mencakup semua fitur level 7.${NC}"
    echo -e "${BOLD}${PUTIH} + Proteksi Anti Admin Panel Ilegal${NC}"
    echo -e "${BOLD}${PUTIH}    ↳ ${BOLD}${KUNING}Kendalikan sepenuhnya siapa saja yang berhak membuat"
    echo -e "      akun admin panel baru melalui sistem daftar izin yang aman."

    echo -e "\n${BOLD}${PUTIH} Proteksi Level 9 - ${BOLD}${HIJAU}Proteksi Hierarki & Isolasi${NC}"
    echo -e "${BOLD}${PUTIH} • Mencakup semua fitur level 8.${NC}"
    echo -e "${BOLD}${PUTIH} + Sistem Manajemen Role & Isolasi Admin (Anti Rusuh Total).${NC}"
    echo -e "${BOLD}${PUTIH}    ↳ ${BOLD}${KUNING}Sistem tercanggih! Admin bawahan DIISOLASI: Hanya bisa${NC}"
    echo -e "${BOLD}${KUNING}      melihat & mengelola user/server yang mereka buat sendiri.${NC}"

    echo -e "\n${BOLD}${PUTIH} Proteksi Custom - ${BOLD}${HIJAU}Kombinasi Yang Dapat Disesuaikan${NC}"
    echo -e "${BOLD}${PUTIH} • Mencakup semua fitur pada level 8.${NC}"
    echo -e "${BOLD}${PUTIH}    ↳ ${BOLD}${KUNING}Walaupun fiturnya mirip, namun kombinasi proteksinya"
    echo -e "      bisa disesuaikan sesuai selera, ikuti saja langkah-langkahnya."

    echo -e "\n© FreeZeeHost Official"
    
    echo -e "\n\n${BOLD}${BIRU}  Tekan [Enter] untuk kembali ke menu utama...${NC}"
    read
}

show_menu() {
    clear
    echo -e "\n${BOLD}${CYAN}╭──────────────────────────────────────────────────╮${NC}"
    echo -e "${BOLD}${CYAN}│${NC}      ${BOLD}${BIRU}Panel Management Proteksi Anti-Rusuh${NC}        ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}               ${BOLD}${BIRU}by FreeZeeHost Official${NC}                   ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}├──────────────────────────────────────────────────┤${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[1] Pasang Proteksi Anti-Rusuh Level 1${NC}         ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[2] Pasang Proteksi Anti-Rusuh Level 2${NC}         ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[3] Pasang Proteksi Anti-Rusuh Level 3${NC}         ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[4] Pasang Proteksi Anti-Rusuh Level 4${NC}         ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[5] Pasang Proteksi Anti-Rusuh Level 5${NC}         ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[6] Pasang Proteksi Anti-Rusuh Level 6${NC}         ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[7] Pasang Proteksi Anti-Rusuh Level 7${NC}         ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[8] Pasang Proteksi Anti-Rusuh Level 8${NC}         ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[9] Pasang Proteksi Anti-Rusuh Level 9${NC}         ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[c] Pasang Proteksi Anti-Rusuh Custom${NC}          ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}                                                  ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[u] Hapus Proteksi Anti-Rusuh${NC}                 ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}                                                  ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[a] Pengelola Izin Admin (anti adp ilegal)${NC}     ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[p] Penjelasan Fitur Setiap Versi${NC}              ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}   ${BOLD}${PUTIH}[x] Keluar${NC}                                     ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}╰──────────────────────────────────────────────────╯${NC}"
}

while true; do
    show_menu
    echo -e "${BOLD}${KUNING} ➤ Pilih Opsi:${NC}"
    read -p "    ↳ " choice

    case $choice in
        1) clear; run_script_from_github "$INSTALL_SCRIPT_LEVEL_1" ;;
        2) clear; run_script_from_github "$INSTALL_SCRIPT_LEVEL_2" ;;
        3) clear; run_script_from_github "$INSTALL_SCRIPT_LEVEL_3" ;;
        4) clear; run_script_from_github "$INSTALL_SCRIPT_LEVEL_4" ;;
        5) clear; run_script_from_github "$INSTALL_SCRIPT_LEVEL_5" ;;
        6) clear; run_script_from_github "$INSTALL_SCRIPT_LEVEL_6" ;;
        7) clear; run_script_from_github "$INSTALL_SCRIPT_LEVEL_7" ;;
        8) clear; run_script_from_github "$INSTALL_SCRIPT_LEVEL_8" ;;
        9) clear; run_script_from_github "$INSTALL_SCRIPT_LEVEL_9" ;;
        [cC]) clear; run_script_from_github "$INSTALL_SCRIPT_CUSTOM" ;;
        [uU]) clear; run_script_from_github "$UNINSTALL_SCRIPT" ;;
        [aA])
            clear; 
                run_script_from_github "$MANAGE_ADMIN"
                ;;
        [pP])
            show_features
            ;;
        [xX])
            echo -e "\n ${BOLD}${BIRU}Terima kasih telah menggunakan skrip ini.${NC}"
            exit 0
            ;;
        *)
            echo -e "\n ${BOLD}${MERAH}Pilihan tidak valid. Silakan coba lagi.${NC}"
            sleep 1
            ;;
    esac
done
