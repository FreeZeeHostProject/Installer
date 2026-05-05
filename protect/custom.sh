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
CYAN='\033[0;36m'
PUTIH='\033[1;37m'
NC='\033[0m'
set -e

CORRECT_KEY="FreeZeeHostgege"

clear
echo -e "${BOLD}${CYAN}
   ███████╗ █████╗ ███╗   ██╗ ██████╗
   ██╔════╝██╔══██╗████╗  ██║██╔═══██╗
   ███████╗███████║██╔██╗ ██║██║   ██║
   ╚════██║██╔══██║██║╚██╗██║██║   ██║
   ███████║██║  ██║██║ ╚████║╚██████╔╝
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝
${NC}"
echo -e "${BOLD}${CYAN}              Anti-Rusuh Protection Tools${NC}"
echo -e "${BOLD}${BIRU}=====================================================${NC}"

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

if [ -f /etc/needrestart/needrestart.conf ]; then
    sudo sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
    sudo sed -i "s/\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
fi

if ! command -v gawk &> /dev/null; then
    sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get update -y > /dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get install -y gawk > /dev/null 2>&1
fi
sleep 0.5

echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║           ${BOLD}${PUTIH}Verifikasi Akses           ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
echo -e "\n${BOLD}${PUTIH} ➤ Masukkan Key:${NC}"
read -r -sp "   ↳ " user_key
if [[ "$user_key" != "$CORRECT_KEY" ]]; then
    echo -e "\n\n${BOLD}${MERAH}✖ Key yang Anda masukkan salah. Akses ditolak.${NC}"
    exit 1
fi
echo -e "\n\n${BOLD}${HIJAU}✓ Verifikasi berhasil...${NC}"
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

API_USER_CTRL="/var/www/pterodactyl/app/Http/Controllers/Api/Application/Users/UserController.php"
ADMIN_USER_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/UserController.php"
INDEX_SETTINGS="/var/www/pterodactyl/app/Http/Controllers/Admin/Settings/IndexController.php"
ADV_SETTINGS="/var/www/pterodactyl/app/Http/Controllers/Admin/Settings/AdvancedController.php"
MAIL_SETTINGS="/var/www/pterodactyl/app/Http/Controllers/Admin/Settings/MailController.php"
DB_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/DatabaseController.php"
MOUNT_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/MountController.php"
LOC_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/LocationController.php"
API_LOC_CTRL="/var/www/pterodactyl/app/Http/Controllers/Api/Application/Locations/LocationController.php"
ADMIN_NODES="/var/www/pterodactyl/app/Http/Controllers/Admin/NodesController.php"
API_NODES="/var/www/pterodactyl/app/Http/Controllers/Api/Application/Nodes/NodeController.php"
NEST_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/NestController.php"
EGG_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggController.php"
EGG_SCRIPT="/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggScriptController.php"
EGG_SHARE="/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggShareController.php"
EGG_VAR="/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggVariableController.php"
ADM_NODES_SETTINGS="/var/www/pterodactyl/app/Http/Controllers/Admin/Nodes/NodeViewController.php"
API_SERVER_CTRL="/var/www/pterodactyl/app/Http/Controllers/Api/Application/Servers/ServerController.php"
API_SERVERMANAGE_CTRL="/var/www/pterodactyl/app/Http/Controllers/Api/Application/Servers/ServerManagementController.php"
API_SERVERSTARTUP_CTRL="/var/www/pterodactyl/app/Http/Controllers/Api/Application/Servers/StartupController.php"
BUILD_SERVICE="/var/www/pterodactyl/app/Services/Servers/BuildModificationService.php"
ADM_SERVER_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/ServersController.php"
ADM_SERVERTF_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/Servers/ServerTransferController.php"
F2A_CTRL="/var/www/pterodactyl/app/Http/Controllers/Api/Client/TwoFactorController.php"
SERVER_FILE_CTRL="/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/FileController.php"
SERVER_SETTINGS_CTRL="/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/SettingsController.php"
API_CLIENT_SERVER_CTRL="/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/ServerController.php"
SERVER_EDIT_SERVICE="/var/www/pterodactyl/app/Services/Servers/DetailsModificationService.php"
ANCHOR_LINE="return \$this->connection->transaction(function () use (\$data, \$server) {"

TARGET_FILE_POPUP="/var/www/pterodactyl/resources/views/templates/base/core.blade.php"
ADMIN_INDEX_VIEW="/var/www/pterodactyl/resources/views/admin/index.blade.php"
LINK_FreeZeeHost_PROTECT="https://www.FreeZeeHost.biz.id/pterodactyl"

HTML_TOMBOL_FreeZeeHost='
<div class="row" style="margin-bottom: 20px;">
    <div class="col-xs-6 col-xs-offset-3 col-sm-4 col-sm-offset-4 text-center">
        <a href="'"$LINK_FreeZeeHost_PROTECT"'" target="_blank">
            <button class="btn btn-danger" style="width:100%; margin-top: 15px;">
                <i class="fa fa-fw fa-shield"></i> FreeZeeHost Protect
            </button>
        </a>
    </div>
</div>'

read -r -d '' HTML_FreeZeeHost_POPUP << 'EOF' || true

    {{-- START: FreeZeeHost NEON --}}
    <script>
    document.addEventListener("DOMContentLoaded", () => {
        const username = @json(auth()->user()->username ?? 'Sayang');
        const hour = new Date().getHours();
        
        let waktu = "Malam";
        let emojiIcon = "🌃";
        let textEmoji = "😊";

        if (hour >= 4 && hour < 11) {
            waktu = "Pagi";
            emojiIcon = "🌆";
        } else if (hour >= 11 && hour < 15) {
            waktu = "Siang";
            emojiIcon = "🏙️";
        } else if (hour >= 15 && hour < 18) {
            waktu = "Sore";
            emojiIcon = "🌇";
        }

        const style = document.createElement('style');
        style.innerHTML = `
            @keyframes FreeZeeHostRotate {
                0% { transform: translate(-50%, -50%) rotate(0deg); }
                100% { transform: translate(-50%, -50%) rotate(360deg); }
            }
            @keyframes FreeZeeHostFloat {
                0%, 100% { transform: translateY(0); }
                50% { transform: translateY(-3px); }
            }
            .FreeZeeHost-card-wrapper {
                position: fixed;
                top: 20px;
                left: 50%;
                transform: translateX(-50%) translateY(-30px);
                opacity: 0;
                width: auto;
                min-width: 280px;
                padding: 1px;
                border-radius: 12px;
                overflow: hidden;
                z-index: 99999;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
                font-family: 'Inter', 'Segoe UI Emoji', 'Noto Color Emoji', sans-serif;
                pointer-events: none;
                transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
            }
            .FreeZeeHost-neon-spinner {
                position: absolute;
                top: 50%;
                left: 50%;
                width: 600px;
                height: 600px;
                background: conic-gradient(
                    #00f2ff 0deg,
                    #00f2ff 140deg,
                    transparent 140deg,
                    transparent 180deg,
                    #00f2ff 180deg,
                    #00f2ff 320deg,
                    transparent 320deg,
                    transparent 360deg
                );
                filter: drop-shadow(0 0 5px #00f2ff);
                animation: FreeZeeHostRotate 2.5s linear infinite;
            }
            .FreeZeeHost-card-content {
                position: relative;
                background: rgba(15, 23, 42, 0.98);
                border-radius: 10.5px;
                padding: 10px 20px;
                z-index: 2;
            }
            .FreeZeeHost-layout {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 20px;
            }
            .FreeZeeHost-text-group {
                text-align: left;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }
            .FreeZeeHost-big-icon {
                font-size: 38px;
                line-height: 1;
                filter: drop-shadow(0 2px 5px rgba(0,0,0,0.3));
                animation: FreeZeeHostFloat 2s ease-in-out infinite;
            }
        `;
        document.head.appendChild(style);

        const toast = document.createElement("div");
        toast.className = "FreeZeeHost-card-wrapper";
        toast.innerHTML = `
            <div class="FreeZeeHost-neon-spinner"></div>
            <div class="FreeZeeHost-card-content">
                <div class="FreeZeeHost-layout">
                    <div class="FreeZeeHost-text-group">
                        <div style="font-size: 13px; color: #cbd5e1; font-weight: 500; margin-bottom: 2px;">Hai ${username} 👋,</div>
                        <div style="font-size: 15px; color: #ffffff; font-weight: 700;">Selamat ${waktu} ${textEmoji}</div>
                    </div>
                    <div class="FreeZeeHost-big-icon">${emojiIcon}</div>
                </div>
            </div>
        `;
        document.body.appendChild(toast);

        requestAnimationFrame(() => {
            setTimeout(() => {
                toast.style.opacity = "1";
                toast.style.transform = "translateX(-50%) translateY(0)";
            }, 100);
        });
        setTimeout(() => {
            toast.style.opacity = "0";
            toast.style.transform = "translateX(-50%) translateY(-30px)";
        }, 4000);
        setTimeout(() => toast.remove(), 5000);
    });
    </script>
    {{-- END: FreeZeeHost NEON --}}
EOF

inject_blade_FreeZeeHost() {
  local file="$1"
  export INJECTED_CODE="$HTML_FreeZeeHost_POPUP"
  if [[ ! -f "$file" ]]; then return; fi
  if grep -q "START: FreeZeeHost NEON" "$file"; then return; fi
  gawk '
    /<div id="app"><\/div>/ {
      print $0
      print ENVIRON["INJECTED_CODE"]
      done=1
      next
    }
    { print }

    END {
      if (!done) {
        print ""
        print ENVIRON["INJECTED_CODE"]
      }
    }
  ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

inject_blade_bottom() {
  local file="$1"
  export INJECTED_CODE="$2"
  if [[ ! -f "$file" ]]; then return; fi
  gawk '
    /FreeZeeHost.biz.id/ { already_exists=1 }
    /getDiscord/ || /getDonations/ || /github\.com/ || /pterodactyl/ || /reviactyl/ { safe_zone=1 }
    /@endsection/ {
      if (safe_zone && !done && !already_exists) {
        print ENVIRON["INJECTED_CODE"]
        done=1
      }
    }
    { print }
  ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

inject_after_brace() {
  local file="$1"; local pattern="$2"; export INJECTED_CODE="$3"
  if [[ ! -f "$file" ]]; then return; fi
  gawk -v pat="$pattern" '
    { print }
    (found_sig && !done && index($0, "{")) { 
        print ENVIRON["INJECTED_CODE"]; 
        done=1; 
        found_sig=0; 
    }
    (index($0, pat)) {
        if (index($0, "{") && !done) {
            print ENVIRON["INJECTED_CODE"];
            done=1;
            found_sig=0;
        } else {
            found_sig=1; 
        }
    }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

inject_after_line() {
  local file="$1"
  local pattern="$2"
  export INJECTED_CODE="$3"
  
  if [[ ! -f "$file" ]]; then
      return
  fi

  gawk -v pat="$pattern" '
    { print }
    (index($0, pat) && !done) {
        print ENVIRON["INJECTED_CODE"];
        done=1;
    }
  ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

while true; do
    ADMIN_ID=""
    while true; do
        clear
        echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
        echo -e "${BOLD}${CYAN}║           ${BOLD}${PUTIH}Konfigurasi Awal           ${BOLD}${CYAN}║${NC}"
        echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
        echo -e "${BOLD}${PUTIH} ➤ Masukkan ID admin utama (contoh: 1):${NC}"
        echo -e "   ${BOLD}${KUNING}(Ketik 'x' untuk keluar)${NC}"
        read -r -p "   ↳ " ADMIN_ID
        if [[ "$ADMIN_ID" == "x" || "$ADMIN_ID" == "X" ]]; then 
            echo -e "\n${BOLD}${BIRU}Proses dibatalkan.${NC}"; exit 0; 
        fi
        if [[ -z "$ADMIN_ID" ]]; then
            echo -e "\n${BOLD}${MERAH}✖ ID tidak boleh kosong. Silakan coba lagi.${NC}"; sleep 1
        elif ! [[ "$ADMIN_ID" =~ ^[0-9]+$ ]]; then
            echo -e "\n${BOLD}${MERAH}✖ Format salah! ID harus berupa angka (0-9).${NC}"; sleep 1
        else
            echo -e "${BOLD}${HIJAU} ✓ ID Admin Utama di-set ke:${BOLD}${PUTIH} $ADMIN_ID${NC}"; sleep 0.5
            break
        fi
    done

    base_choice=""
    while true; do
        clear
        echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${BOLD}${CYAN}║    ${BOLD}${PUTIH}[ Langkah 1/3: Pilih Proteksi Dasar ]     ${BOLD}${CYAN}║${NC}"
        echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo -e "${BOLD}${PUTIH}Pilih salah satu mode proteksi dasar:${NC}"
        echo -e "\n ${BOLD}${PUTIH}[1] Proteksi Dasar Biasa:${NC}"
        echo -e "     ${BOLD}${KUNING}• Melindungi akun Admin Utama agar tidak bisa diedit/dihapus oleh admin lain."
        echo -e "     ${BOLD}${KUNING}• Mencegah admin lain mengutak-atik panel (bagian settings, location, nodes, nest, dan egg).${NC}"
        echo -e "\n ${BOLD}${PUTIH}[2] Proteksi Dasar Lanjutan:${NC}"
        echo -e "     ${BOLD}${KUNING}• Semua fitur proteksi dasar biasa."
        echo -e "     ${BOLD}${KUNING}• Ditambah: Semua user tidak dapat diedit/dihapus oleh admin lain,"
        echo -e "     ${BOLD}${KUNING}  hanya Admin Utama yang bisa melakukannya.${NC}"
        echo -e "\n ${BOLD}${PUTIH}[x] Keluar${NC}"
        echo -e "\n${BOLD}${PUTIH}Pilihan Anda:${NC}"
        read -r -p "   ↳ " base_choice
        
        if [[ "$base_choice" == "1" || "$base_choice" == "2" ]]; then
            break
        elif [[ "$base_choice" == "x" || "$base_choice" == "X" ]]; then
            echo -e "\n${BOLD}${BIRU}Proses instalasi dibatalkan.${NC}"; exit 0
        else
            echo -e "\n${BOLD}${MERAH}✖ Input tidak valid. Pilih 1, 2, atau x.${NC}"; sleep 1
        fi
    done

    custom_choices_str=""
    while true; do
        clear
        echo -e "\n${BOLD}${CYAN}╔═══════════════════════════════════════════╗${NC}"
        echo -e "${BOLD}${CYAN}║    ${BOLD}${PUTIH}[ Langkah 2/3: Proteksi Tambahan ]     ${BOLD}${CYAN}║${NC}"
        echo -e "${BOLD}${CYAN}╚═══════════════════════════════════════════╝${NC}"
        echo -e "${BOLD}${PUTIH}Pilih proteksi tambahan (jika lebih dari 1, pisahkan dengan koma, tanpa spasi). Contoh: 1,4,7${NC}"
        echo -e "${BOLD}${PUTIH}Atau biarkan kosong jika tidak ada tambahan.${NC}"
        options=(
            "Anti Hapus Server Sembarangan"
            "Anti Manage Server Sembarangan"
            "Anti update Build Configuration Server Sembarangan"
            "Anti Edit Startup Server Sembarangan"
            "Anti Aktivasi 2FA oleh Non-Admin Utama"
            "Anti Intip Isi File Server Orang Lain"
            "Anti Maling/Download File Server Orang Lain"
            "Anti Utak-Atik (Rename) File Server Orang Lain"
            "Anti Hapus File Server Orang Lain"
            "Anti Intip Server Orang Lain"
            "Anti Ubah Owner Server (Pencegah Maling SC)"
            "Anti Admin Panel Ilegal (Sistem Whitelist)"
        )
        for i in "${!options[@]}"; do echo -e " ${BOLD}${PUTIH}[$((i+1))] ${options[$i]}${NC}"; done
        echo -e "\n ${BOLD}${PUTIH}[x] Keluar${NC}"
        echo -e "\n${BOLD}${PUTIH}Pilihan Anda:${NC}"
        read -r -p "   ↳ " custom_choices_str

        if [[ "$custom_choices_str" == "x" || "$custom_choices_str" == "X" ]]; then
            echo -e "\n${BOLD}${BIRU}Proses instalasi dibatalkan.${NC}"; exit 0
        fi
        
        if [[ -n "${custom_choices_str//[ ,]/}" || -z "$custom_choices_str" ]]; then
            break
        else
            echo -e "\n${BOLD}${MERAH}✖ Input tidak valid. Masukkan hanya angka dan koma.${NC}"; sleep 1
        fi
    done
    
    clear
    echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║          ${BOLD}${PUTIH}[ Langkah 3/3: Konfirmasi ]         ${BOLD}${CYAN}║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo -e "${BOLD}${PUTIH}Anda akan memasang proteksi dengan konfigurasi berikut:${NC}"
    
    if [[ "$base_choice" == "1" ]]; then echo -e " ${BOLD}${HIJAU}• Proteksi Dasar :${NC} ${BOLD}${PUTIH}Mode Biasa${NC}"; else echo -e " ${BOLD}${HIJAU}• Proteksi Dasar :${NC} ${BOLD}${PUTIH}Mode Lanjutan${NC}"; fi
    
    if [[ -n "$custom_choices_str" ]]; then
        echo -e " ${BOLD}${HIJAU}• Proteksi Tambahan:${NC}"
        IFS=',' read -ra custom_choices_array <<< "$custom_choices_str"
        for choice in "${custom_choices_array[@]}"; do
            index=$((choice-1))
            if [[ $index -ge 0 && $index -lt ${#options[@]} ]]; then
                echo -e "     ${BOLD}${CYAN}-${NC} ${BOLD}${PUTIH}${options[$index]}${NC}"
            fi
        done
    else
        echo -e " ${BOLD}${HIJAU}• Proteksi Tambahan :${NC} ${BOLD}${KUNING}(Tidak ada)${NC}"
    fi

    echo -e "\n${BOLD}${KUNING} ➤ Lanjutkan pemasangan? (y/n):${NC}"
    read -r -p "   ↳ " final_confirm
    
    if [[ "$final_confirm" == "y" || "$final_confirm" == "Y" ]]; then
        break
    else
        echo -e "\n${BOLD}${MERAH}✖ Pemasangan dibatalkan. Mengulang dari awal...${NC}"
        sleep 1
        continue
    fi
done

clear
echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║     ${BOLD}${PUTIH}Memulai proses instalasi...      ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
sleep 0.5

FILES_TO_BACKUP=(
    "$API_USER_CTRL"
    "$ADMIN_USER_CTRL"
    "$INDEX_SETTINGS"
    "$ADV_SETTINGS"
    "$MAIL_SETTINGS"
    "$DB_CTRL"
    "$MOUNT_CTRL"
    "$LOC_CTRL"
    "$API_LOC_CTRL"
    "$ADMIN_NODES"
    "$API_NODES"
    "$NEST_CTRL"
    "$EGG_CTRL"
    "$EGG_SCRIPT"
    "$EGG_SHARE"
    "$EGG_VAR"
    "$ADM_NODES_SETTINGS"
    "$API_SERVER_CTRL"
    "$BUILD_SERVICE"
    "$API_SERVERMANAGE_CTRL"
    "$API_SERVERSTARTUP_CTRL"
    "$ADM_SERVER_CTRL"
    "$ADM_SERVERTF_CTRL"
    "$SERVER_SETTINGS_CTRL"
    "$F2A_CTRL"
    "$SERVER_FILE_CTRL"
    "$API_CLIENT_SERVER_CTRL"
    "$SERVER_EDIT_SERVICE"
    "$ADMIN_INDEX_VIEW"
    "$TARGET_FILE_POPUP"
    # === FAKE FILES (Untuk Mengecoh Developer) ===
    "/var/www/pterodactyl/app/Services/Acl/Api/AdminAcl.php"
    "/var/www/pterodactyl/app/Http/Controllers/Auth/LoginController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Auth/ResetPasswordController.php"
    "/var/www/pterodactyl/app/Http/Requests/Auth/LoginRequest.php"
    "/var/www/pterodactyl/app/Models/Permission.php"
    "/var/www/pterodactyl/app/Models/ApiKey.php"
    "/var/www/pterodactyl/app/Models/Subuser.php"
    "/var/www/pterodactyl/app/Services/Subusers/SubuserCreationService.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/SubuserController.php"
    "/var/www/pterodactyl/app/Observers/SubuserObserver.php"
    "/var/www/pterodactyl/app/Observers/ServerObserver.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/BaseController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Nodes/NodeController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/ApiController.php"
    "/var/www/pterodactyl/app/Http/Middleware/VerifyCsrfToken.php"
    "/var/www/pterodactyl/app/Http/Requests/Admin/UserFormRequest.php"
    "/var/www/pterodactyl/app/Http/Requests/Admin/AdminFormRequest.php"
    "/var/www/pterodactyl/resources/views/admin/settings/index.blade.php"
    "/var/www/pterodactyl/resources/views/admin/api/index.blade.php"
    "/var/www/pterodactyl/resources/views/admin/nodes/index.blade.php"
    "/var/www/pterodactyl/app/Services/Api/KeyCreationService.php"
    "/var/www/pterodactyl/app/Models/Setting.php"
    "/var/www/pterodactyl/app/Exceptions/Http/HttpForbiddenException.php"
)
for file in "${FILES_TO_BACKUP[@]}"; do
    if [[ -f "$file" ]]; then
        cp "$file" "${file}.bak_$(date +%F_%T)"
    fi
done

IS_WHITELIST=false
IFS=',' read -ra check_opts <<< "$custom_choices_str"
for opt in "${check_opts[@]}"; do
    if [[ "$opt" == "12" ]]; then IS_WHITELIST=true; fi
done

ANTI_HAPUS_ADMIN_UTAMA="        /**
        * Created By FreeZeeHost Official (Bukan hasil nyomot/rinem wak😹)
        * Telegram: @FreeZeeHostofc
        */
        if (\$user->id === $ADMIN_ID) {
            if (request()->expectsJson()) {
                abort(403, 'Akses Ditolak! Akun Admin Utama tidak dapat dihapus.');
            } else {
                throw new \\Pterodactyl\\Exceptions\\DisplayException('Akses Ditolak! Akun Admin Utama tidak dapat dihapus.');
            }
        }
"
SECURITY_CODE="        /**
        * Created By FreeZeeHost Official (Bukan hasil nyomot/rinem wak😹)
        * Telegram: @FreeZeeHostofc
        */
        if (auth()->user()->id !== $ADMIN_ID) {
            if (request()->expectsJson()) {
                abort(403, 'Akses ditolak! Demi keamanan dan kenyamanan bersama, hanya Admin Utama yang dapat melakukan tindakan ini.');
            } else {
                throw new \\Pterodactyl\\Exceptions\\DisplayException('Akses ditolak! Demi keamanan dan kenyamanan bersama, hanya Admin Utama yang dapat melakukan tindakan ini.');
            }
        }
"
F2A_SECURITY_CODE="        /**
        * Created By FreeZeeHost Official (Bukan hasil nyomot/rinem wak😹)
        * Telegram: @FreeZeeHostofc
        */
        if (auth()->user()->id !== $ADMIN_ID) {
            if (request()->expectsJson()) {
                abort(403, 'Akses Ditolak: GAK USAH DINYALAIN!');
            } else {
                throw new \\Pterodactyl\\Exceptions\\DisplayException('GAK USAH DINYALAIN!');
            }
        }
"
SERVER_SECURITY_CODE="        /**
        * Created By FreeZeeHost Official (Bukan hasil nyomot/rinem wak😹)
        * Telegram: @FreeZeeHostofc
        */
        \$user = auth()->user();
        if (\$user->root_admin && \$user->id !== $ADMIN_ID && \$user->id !== \$server->owner_id) {
            if (request()->expectsJson()) {
                abort(403, 'Akses Ditolak! Demi menjaga keamanan, kenyamanan, dan privasi, tindakan ini hanya dapat dilakukan oleh Admin Utama dan Pemilik Server.');
            } else {
                throw new \\Pterodactyl\\Exceptions\\DisplayException('Akses Ditolak! Demi menjaga keamanan, kenyamanan, dan privasi, tindakan ini hanya dapat dilakukan oleh Admin Utama dan Pemilik Server.');
            }
        }
"
SERVER_BUILD_PROTECT="        /**
        * Created By FreeZeeHost Official (Bukan hasil nyomot/rinem wak😹)
        * Telegram: @FreeZeeHostofc
        */
        \$user = auth()->user();
        if (\$user->root_admin && \$user->id !== $ADMIN_ID && \$user->id !== \$server->owner_id) {
            \$restrictedFields = [
                'memory', 'swap', 'disk', 'cpu', 'io', 'threads', 
                'oom_disabled', 'database_limit', 'allocation_limit', 'backup_limit'
            ];

            foreach (\$restrictedFields as \$field) {
                if (array_key_exists(\$field, \$data) && \$data[\$field] != \$server->{\$field}) {
                    if (request()->expectsJson()) {
                        abort(403, 'Akses Ditolak! Selain Admin Utama hanya diizinkan mengubah Allocation (IP/Port) saja.');
                    } else {
                        throw new \\Pterodactyl\\Exceptions\\DisplayException('Akses Ditolak! Selain Admin Utama hanya diizinkan mengubah Allocation (IP/Port) saja.');
                    }
                }
            }
        }
"
OWNER_CHANGE_PROTECTION="
            /**
            * Created By FreeZeeHost Official (Bukan hasil nyomot/rinem wak😹)
            * Telegram: @FreeZeeHostofc
            */
            if (
                array_key_exists('owner_id', \$data) &&
                \$data['owner_id'] != \$server->owner_id &&
                auth()->user()->id !== $ADMIN_ID
            ) {
                if (request()->expectsJson()) {
                    abort(403, 'Akses Ditolak! Demi keamanan (barangkali ada perusuh yang mau maling), tindakan ini hanya dapat dilakukan oleh Admin Utama.');
                } else {
                    throw new \\Pterodactyl\\Exceptions\\DisplayException('Akses Ditolak! Demi keamanan (barangkali ada perusuh yang mau maling), tindakan ini hanya dapat dilakukan oleh Admin Utama.');
                }
            }
"
ANTI_ADP_ILEGAL_CREATE="        /**
        * Created By FreeZeeHost Official (Bukan hasil nyomot/rinem wak😹)
        * Telegram: @FreeZeeHostofc
        */
        \$allowedAdminIds = [];
        \$filePath = app_path('Http/Controllers/FreeZeeHostganteng.json');
        if (\\File::exists(\$filePath)) {
            \$allowedAdminIds = json_decode(\\File::get(\$filePath), true) ?? [];
        }
        \$data = \$request->validated();
        if (!in_array(auth()->user()->id, \$allowedAdminIds) && !empty(\$data['root_admin'])) {
            if (request()->expectsJson()) {
                abort(403, 'Akses Ditolak! Anda tidak memiliki izin akses untuk membuat admin panel. Silahkan minta izin akses dulu ke Owner (Admin Utama).');
            } else {
                throw new \\Pterodactyl\\Exceptions\\DisplayException('Akses Ditolak! Anda tidak memiliki izin akses untuk membuat admin panel. Silahkan minta izin akses dulu ke Owner (Admin Utama).');
            }
        }
"
PHP_START="        \$currentUser = auth()->user();
        \$targetUser = \$user;
        if (\$targetUser->id === $ADMIN_ID) {
            if (\$currentUser->id != $ADMIN_ID) {
                if (request()->expectsJson()) {
                    abort(403, 'Akses Ditolak! Profil Admin Utama dilindungi dan hanya dapat diedit oleh pemiliknya sendiri.');
                } else {
                    throw new \\Pterodactyl\\Exceptions\\DisplayException('Akses Ditolak! Profil Admin Utama dilindungi dan hanya dapat diedit oleh pemiliknya sendiri.');
                }
            }
            if (request()->has('root_admin') && (int)request()->input('root_admin') !== 1) {
                if (request()->expectsJson()) {
                    abort(403, 'BAHAYA! Jangan matikan status Admin Anda sendiri.');
                } else {
                    throw new \\Pterodactyl\\Exceptions\\DisplayException('BAHAYA! Jangan matikan status Admin Anda sendiri.');
                }
            }
        }
"
PHP_WHITELIST=""
if [[ "$IS_WHITELIST" == "true" ]]; then
    PHP_WHITELIST="        if (request()->has('root_admin')) {
            \$inputStatus = (int)request()->input('root_admin');
            \$currentStatus = (int)\$targetUser->root_admin;
            if (\$inputStatus !== \$currentStatus) {
                \$allowedAdminIds = [];
                \$filePath = app_path('Http/Controllers/FreeZeeHostganteng.json');
                if (\\File::exists(\$filePath)) {
                    \$allowedAdminIds = json_decode(\\File::get(\$filePath), true) ?? [];
                }
                if (\$currentUser->id != $ADMIN_ID && !in_array(\$currentUser->id, \$allowedAdminIds)) {
                    if (request()->expectsJson()) {
                        abort(403, 'Akses Ditolak! Anda tidak memiliki izin akses untuk mengubah status Administrator (baik memberi ataupun mencabut). Silahkan minta izin akses dulu ke Owner (Admin Utama).');
                    } else {
                        throw new \\Pterodactyl\\Exceptions\\DisplayException('Akses Ditolak! Anda tidak memiliki izin akses untuk mengubah status Administrator (baik memberi ataupun mencabut). Silahkan minta izin akses dulu ke Owner (Admin Utama).');
                    }
                }
            }
        }
"
elif [[ "$base_choice" == "2" ]]; then
    PHP_WHITELIST="        if (request()->has('root_admin')) {
            \$inputStatus = (int)request()->input('root_admin');
            \$currentStatus = (int)\$targetUser->root_admin;
            if (\$inputStatus !== \$currentStatus && \$currentUser->id != $ADMIN_ID) {
                if (request()->expectsJson()) {
                    abort(403, 'Akses Ditolak! Hanya Admin Utama yang dapat mengubah status Administrator.');
                } else {
                    throw new \\Pterodactyl\\Exceptions\\DisplayException('Akses Ditolak! Hanya Admin Utama yang dapat mengubah status Administrator.');
                }
            }
        }
"
else
    PHP_WHITELIST=""
fi
PHP_SENSITIVE=""
if [[ "$base_choice" == "2" ]]; then
    PHP_SENSITIVE="        if (\$currentUser->id != $ADMIN_ID && \$currentUser->id != \$targetUser->id) { 
            if (
                request()->filled('password') || 
                (request()->filled('email') && request()->input('email') != \$targetUser->email) ||
                (request()->filled('username') && request()->input('username') != \$targetUser->username)
            ) {
                if (request()->expectsJson()) {
                    abort(403, 'Akses Ditolak! Hanya Admin Utama yang boleh mengganti Email/Username/Password user lain. Anda hanya bisa mengedit akun Anda sendiri.');
                } else {
                    throw new \\Pterodactyl\\Exceptions\\DisplayException('Akses Ditolak! Hanya Admin Utama yang boleh mengganti Email/Username/Password user lain. Anda hanya bisa mengedit akun Anda sendiri.');
                }
            }
        }
"
fi
UPDATE_SECURITY_FINAL="        /**
        * Created By FreeZeeHost Official (Bukan hasil nyomot/rinem wak😹)
        * Telegram: @FreeZeeHostofc
        */
${PHP_START}${PHP_WHITELIST}${PHP_SENSITIVE}"

inject_after_brace "$API_USER_CTRL" "public function delete(DeleteUserRequest" "$ANTI_HAPUS_ADMIN_UTAMA"
inject_after_brace "$ADMIN_USER_CTRL" "public function delete(Request" "$ANTI_HAPUS_ADMIN_UTAMA"
inject_after_brace "$API_USER_CTRL" "public function update(UpdateUserRequest" "$UPDATE_SECURITY_FINAL"
inject_after_brace "$ADMIN_USER_CTRL" "public function update(UserFormRequest" "$UPDATE_SECURITY_FINAL"
while IFS=':' read -r file pattern; do
    inject_after_brace "$file" "$pattern" "$SECURITY_CODE"
done <<EOF
$INDEX_SETTINGS:public function update(BaseSettingsFormRequest
$ADV_SETTINGS:public function update(AdvancedSettingsFormRequest
$MAIL_SETTINGS:public function update(MailSettingsFormRequest
$DB_CTRL:public function create(DatabaseHostFormRequest
$DB_CTRL:public function update(DatabaseHostFormRequest
$DB_CTRL:public function delete(int \$host)
$MOUNT_CTRL:public function create(MountFormRequest
$MOUNT_CTRL:public function update(MountFormRequest
$MOUNT_CTRL:public function delete(Mount
$MOUNT_CTRL:public function addEggs(Request
$MOUNT_CTRL:public function addNodes(Request
$MOUNT_CTRL:public function deleteEgg(Mount
$MOUNT_CTRL:public function deleteNode(Mount
$LOC_CTRL:public function view(int \$id)
$LOC_CTRL:public function create(LocationFormRequest
$LOC_CTRL:public function update(LocationFormRequest
$LOC_CTRL:public function delete(Location
$API_LOC_CTRL:public function store(StoreLocationRequest
$API_LOC_CTRL:public function update(UpdateLocationRequest
$API_LOC_CTRL:public function delete(DeleteLocationRequest
$ADMIN_NODES:public function store(NodeFormRequest
$ADMIN_NODES:public function updateSettings(NodeFormRequest
$ADMIN_NODES:public function delete(int|Node
$ADM_NODES_SETTINGS:public function settings(Request
$ADM_NODES_SETTINGS:public function configuration(Request
$API_NODES:public function store(StoreNodeRequest
$API_NODES:public function update(UpdateNodeRequest
$API_NODES:public function delete(DeleteNodeRequest
$NEST_CTRL:public function store(StoreNestFormRequest
$NEST_CTRL:public function update(StoreNestFormRequest
$NEST_CTRL:public function destroy(int \$nest)
$EGG_CTRL:public function store(EggFormRequest
$EGG_CTRL:public function update(EggFormRequest
$EGG_CTRL:public function destroy(Egg
$EGG_SCRIPT:public function update(EggScriptFormRequest
$EGG_SHARE:public function export(Egg
$EGG_SHARE:public function update(EggImportFormRequest
$EGG_VAR:public function store(EggVariableFormRequest
$EGG_VAR:public function update(EggVariableFormRequest
$EGG_VAR:public function destroy(int \$egg, EggVariable \$variable)
EOF
IFS=',' read -ra custom_choices_array <<< "$custom_choices_str"
for choice in "${custom_choices_array[@]}"; do
    case $choice in
        1)
            inject_after_brace "$API_SERVER_CTRL" "public function delete(ServerWriteRequest" "$SECURITY_CODE"
            inject_after_brace "$ADM_SERVER_CTRL" "public function delete(Request" "$SECURITY_CODE"
            ;;
        2)
            inject_after_brace "$ADM_SERVER_CTRL" "public function toggleInstall(Server" "$SERVER_SECURITY_CODE"
            inject_after_brace "$ADM_SERVER_CTRL" "public function reinstallServer(Server" "$SERVER_SECURITY_CODE"
            inject_after_brace "$ADM_SERVER_CTRL" "public function manageSuspension(Request" "$SECURITY_CODE"
            inject_after_brace "$ADM_SERVERTF_CTRL" "public function transfer(Request" "$SECURITY_CODE"
            inject_after_brace "$SERVER_SETTINGS_CTRL" "public function reinstall(ReinstallServerRequest" "$SERVER_SECURITY_CODE"
            inject_after_brace "$API_SERVERMANAGE_CTRL" "public function suspend(ServerWriteRequest" "$SECURITY_CODE"
            inject_after_brace "$API_SERVERMANAGE_CTRL" "public function reinstall(ServerWriteRequest" "$SERVER_SECURITY_CODE"
            ;;
        3) inject_after_brace "$BUILD_SERVICE" "public function handle(Server \$server, array \$data): Server" "$SERVER_BUILD_PROTECT" ;;
        4)
            inject_after_brace "$ADM_SERVER_CTRL" "public function saveStartup(Request" "$SERVER_SECURITY_CODE"
            inject_after_brace "$API_SERVERSTARTUP_CTRL" "public function index(UpdateServerStartupRequest" "$SERVER_SECURITY_CODE"
            ;;
        5)
            inject_after_brace "$F2A_CTRL" "public function index(Request" "$F2A_SECURITY_CODE"
            inject_after_brace "$F2A_CTRL" "public function store(Request" "$F2A_SECURITY_CODE"
            ;;
        6)
            inject_after_brace "$SERVER_FILE_CTRL" "public function directory(ListFilesRequest" "$SERVER_SECURITY_CODE"
            inject_after_brace "$SERVER_FILE_CTRL" "public function contents(GetFileContentsRequest" "$SERVER_SECURITY_CODE"
            ;;
        7)
            inject_after_brace "$SERVER_FILE_CTRL" "public function download(GetFileContentsRequest" "$SERVER_SECURITY_CODE"
            inject_after_brace "$SERVER_FILE_CTRL" "public function pull(PullFileRequest" "$SERVER_SECURITY_CODE"
            ;;
        8)
            inject_after_brace "$SERVER_FILE_CTRL" "public function write(WriteFileContentRequest" "$SERVER_SECURITY_CODE"
            inject_after_brace "$SERVER_FILE_CTRL" "public function rename(RenameFileRequest" "$SERVER_SECURITY_CODE"
            ;;
        9) inject_after_brace "$SERVER_FILE_CTRL" "public function delete(DeleteFileRequest" "$SERVER_SECURITY_CODE" ;;
        10) inject_after_brace "$API_CLIENT_SERVER_CTRL" "public function index(GetServerRequest" "$SERVER_SECURITY_CODE" ;;
        11) inject_after_line "$SERVER_EDIT_SERVICE" "$ANCHOR_LINE" "$OWNER_CHANGE_PROTECTION" ;;
        12)
            ALLOWED_ADMINS_PATH="/var/www/pterodactyl/app/Http/Controllers/FreeZeeHostganteng.json"
            echo "[$ADMIN_ID]" > "$ALLOWED_ADMINS_PATH"
            chown www-data:www-data "$ALLOWED_ADMINS_PATH"
            inject_after_brace "$API_USER_CTRL" "public function store(StoreUserRequest" "$ANTI_ADP_ILEGAL_CREATE"
            inject_after_brace "$ADMIN_USER_CTRL" "public function store(NewUserFormRequest" "$ANTI_ADP_ILEGAL_CREATE"
            ;;
    esac
done
inject_blade_bottom "$ADMIN_INDEX_VIEW" "$HTML_TOMBOL_FreeZeeHost"
inject_blade_FreeZeeHost "$TARGET_FILE_POPUP"

cd /var/www/pterodactyl
rm -rf bootstrap/cache/* storage/framework/cache/* storage/framework/sessions/* storage/framework/views/*
php artisan optimize:clear > /dev/null 2>&1
php artisan view:clear > /dev/null 2>&1
php artisan config:clear > /dev/null 2>&1
chown -R www-data:www-data /var/www/pterodactyl/*
if systemctl is-active --quiet pteroq.service; then
    systemctl restart pteroq.service
fi
if command -v systemctl &> /dev/null; then
    systemctl restart php*-fpm.service
fi
sleep 0.5

clear
echo -e "\n${BOLD}${HIJAU}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${HIJAU}║                                      ║${NC}"
echo -e "${BOLD}${HIJAU}║${NC}       ${BOLD}${PUTIH}PROSES TELAH SELESAI!${NC}          ${BOLD}${HIJAU}║${NC}"
echo -e "${BOLD}${HIJAU}║${NC}   ${BOLD}${PUTIH}Sistem telah berhasil diperbarui.${NC}  ${BOLD}${HIJAU}║${NC}"
echo -e "${BOLD}${HIJAU}║                                      ║${NC}"
echo -e "${BOLD}${HIJAU}╚══════════════════════════════════════╝${NC}"
