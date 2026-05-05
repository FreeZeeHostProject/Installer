#!/bin/bash

# ============================================================
# SKRIP INI DIBUAT OLEH FreeZeeHost OFFICIAL (TELEGRAM: @FreeZeeHostofc)
# FreeZeeHost PROTECTION - LEVEL 9 (ZIP INSTALLER VERSION)
# ============================================================

BOLD='\033[1m'
MERAH='\033[0;31m'
KUNING='\033[0;33m'
HIJAU='\033[0;32m'
BIRU='\033[0;34m'
CYAN='\033[0;36m'
PUTIH='\033[1;37m'
NC='\033[0m' # No Color

CORRECT_KEY="FreeZeeHostgege"

PTERO_PATH="/var/www/pterodactyl"
ZIP_NAME="level9.zip"
GITHUB_USER="BangFreeZeeHost"
GITHUB_REPO="protect"
GITHUB_BRANCH="main"
GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
ZIP_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}/${ZIP_NAME}"

set -e

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

if ! command -v gawk &> /dev/null || ! command -v unzip &> /dev/null; then
    sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get update -y > /dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a apt-get install -y gawk unzip > /dev/null 2>&1
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
if [ ! -d "$PTERO_PATH" ] || [ ! -f "$PTERO_PATH/artisan" ]; then
    echo -e "\n${BOLD}${MERAH}✖ ERROR FATAL: Panel Pterodactyl tidak terdeteksi!${NC}"
    echo -e "${BOLD}${KUNING}  Pastikan Anda menjalankan skrip ini di VPS yang sudah terinstall Pterodactyl.${NC}"
    exit 1
else
    echo -e "\n${BOLD}${HIJAU}✓ Panel Pterodactyl terdeteksi.${NC}"
    sleep 0.5
fi

echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║           ${BOLD}${PUTIH}Konfigurasi Awal           ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
echo -e "${BOLD}${PUTIH} ➤ Masukkan ID admin utama (contoh: 1):${NC}"
read -r -p "   ↳ " ADMIN_ID
if [[ -z "$ADMIN_ID" ]]; then
  echo -e "\n${BOLD}${MERAH} ✖ ID tidak boleh kosong. Proses dibatalkan.${NC}"
  exit 1
elif ! [[ "$ADMIN_ID" =~ ^[0-9]+$ ]]; then
  echo -e "\n${BOLD}${MERAH} ✖ Format salah! ID harus berupa angka (0-9). Proses dibatalkan.${NC}"
  exit 1
fi
echo -e "${BOLD}${HIJAU} ✓ ID Admin Utama di-set ke:${BOLD}${PUTIH} $ADMIN_ID${NC}"
sleep 0.5

echo -e "\n${BOLD}${PUTIH} ➤ Apakah Anda yakin ingin melanjutkan? (y/n):${NC}"
read -r -p "   ↳ " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo -e "\n${BOLD}${MERAH} ✖ Proses dibatalkan oleh pengguna.${NC}"
  exit 0
fi

TARGET_FILE_POPUP="$PTERO_PATH/resources/views/templates/base/core.blade.php"
ADMIN_INDEX_VIEW="$PTERO_PATH/resources/views/admin/index.blade.php"
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

clear
echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║     ${BOLD}${PUTIH}Memulai proses instalasi...      ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}║        ${BOLD}${PUTIH}Mohon tunggu sebentar.        ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
sleep 0.5

FILES_TO_BACKUP=(
    "app/Http/Controllers/Admin/Servers/ServerController.php"
    "app/Http/Controllers/Admin/Servers/ServerTransferController.php"
    "app/Http/Controllers/Admin/Servers/ServerViewController.php"
    "app/Http/Controllers/Admin/ServersController.php"
    "app/Http/Controllers/Admin/UserController.php"
    "app/Http/Controllers/Api/Application/Locations/LocationController.php"
    "app/Http/Controllers/Api/Application/Nests/EggController.php"
    "app/Http/Controllers/Api/Application/Nests/NestController.php"
    "app/Http/Controllers/Api/Application/Nodes/AllocationController.php"
    "app/Http/Controllers/Api/Application/Nodes/NodeConfigurationController.php"
    "app/Http/Controllers/Api/Application/Nodes/NodeController.php"
    "app/Http/Controllers/Api/Application/Nodes/NodeDeploymentController.php"
    "app/Http/Controllers/Api/Application/Servers/DatabaseController.php"
    "app/Http/Controllers/Api/Application/Servers/ExternalServerController.php"
    "app/Http/Controllers/Api/Application/Servers/ServerController.php"
    "app/Http/Controllers/Api/Application/Servers/ServerDetailsController.php"
    "app/Http/Controllers/Api/Application/Servers/ServerManagementController.php"
    "app/Http/Controllers/Api/Application/Servers/StartupController.php"
    "app/Http/Controllers/Api/Application/Users/ExternalUserController.php"
    "app/Http/Controllers/Api/Application/Users/UserController.php"
    "app/Http/Controllers/Api/Client/Servers/ActivityLogController.php"
    "app/Http/Controllers/Api/Client/Servers/BackupController.php"
    "app/Http/Controllers/Api/Client/Servers/CommandController.php"
    "app/Http/Controllers/Api/Client/Servers/DatabaseController.php"
    "app/Http/Controllers/Api/Client/Servers/FileController.php"
    "app/Http/Controllers/Api/Client/Servers/FileUploadController.php"
    "app/Http/Controllers/Api/Client/Servers/NetworkAllocationController.php"
    "app/Http/Controllers/Api/Client/Servers/PowerController.php"
    "app/Http/Controllers/Api/Client/Servers/ResourceUtilizationController.php"
    "app/Http/Controllers/Api/Client/Servers/ScheduleController.php"
    "app/Http/Controllers/Api/Client/Servers/ScheduleTaskController.php"
    "app/Http/Controllers/Api/Client/Servers/ServerController.php"
    "app/Http/Controllers/Api/Client/Servers/SettingsController.php"
    "app/Http/Controllers/Api/Client/Servers/StartupController.php"
    "app/Http/Controllers/Api/Client/Servers/SubuserController.php"
    "app/Http/Controllers/Api/Client/Servers/WebsocketController.php"
    "app/Http/Controllers/Api/Client/TwoFactorController.php"
    "app/Http/Kernel.php"
    "app/Http/Middleware/AdminAuthenticate.php"
    "app/Http/Middleware/Api/Client/Server/AuthenticateServerAccess.php"
    "app/Http/Controllers/Api/Client/ClientController.php"
    "app/Models/Server.php"
    "app/Models/User.php"
    "app/Observers/UserObserver.php"
    "app/Policies/ServerPolicy.php"
    "app/Services/Servers/DetailsModificationService.php"
    "app/Services/Users/UserCreationService.php"
    "app/Services/Users/UserUpdateService.php"
    "config/pterodactyl.php"
    "resources/views/layouts/admin.blade.php"
    "routes/admin.php"
    "routes/api-application.php"
    "routes/api-client.php" # diubah jika stellar
    "resources/views/admin/index.blade.php"
    "resources/views/admin/api/index.blade.php"
    "resources/views/templates/base/core.blade.php"
    "resources/views/templates/gmd/admin/nav.blade.php" # start billing
    "resources/views/templates/gmd/admin/navs/billing.blade.php"
    "routes/gmd.php"
    "routes/custom/affiliates.php"
    "routes/custom/billing_module.php"
    "routes/custom/general.php" # end billing
    "resources/views/admin/extensions.blade.php" # blueprint
    "routes/blueprint.php" # blueprint
    # === FAKE FILES (Untuk Mengecoh Developer) ===
    "app/Services/Acl/Api/AdminAcl.php"
    "app/Http/Controllers/Auth/LoginController.php"
    "app/Http/Controllers/Auth/ResetPasswordController.php"
    "app/Http/Requests/Auth/LoginRequest.php"
    "app/Models/Permission.php"
    "app/Models/ApiKey.php"
    "app/Models/Subuser.php"
    "app/Services/Subusers/SubuserCreationService.php"
    "app/Observers/SubuserObserver.php"
    "app/Observers/ServerObserver.php"
    "app/Http/Controllers/Admin/BaseController.php"
    "app/Http/Controllers/Admin/Nodes/NodeController.php"
    "app/Http/Controllers/Admin/ApiController.php"
    "app/Http/Middleware/VerifyCsrfToken.php"
    "app/Http/Requests/Admin/UserFormRequest.php"
    "app/Http/Requests/Admin/AdminFormRequest.php"
    "resources/views/admin/settings/index.blade.php"
    "resources/views/admin/api/index.blade.php"
    "resources/views/admin/nodes/index.blade.php"
    "app/Services/Api/KeyCreationService.php"
    "app/Models/Setting.php"
    "app/Exceptions/Http/HttpForbiddenException.php"
)

for file_rel in "${FILES_TO_BACKUP[@]}"; do
    file_path="$PTERO_PATH/$file_rel"
    if [[ -f "$file_path" ]]; then
        cp "$file_path" "${file_path}.bak_$(date +%F_%T)"
    fi
done

cd "$PTERO_PATH"

php <<PHP
<?php
require __DIR__.'/vendor/autoload.php';
\$app = require __DIR__.'/bootstrap/app.php';
\$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;

\$MAIN = $ADMIN_ID;

try {
    if (!Schema::hasTable('panel_roles')) {
        Schema::create('panel_roles', function (Blueprint \$t) {
            \$t->id();
            \$t->string('name');
            \$t->unsignedInteger('level');
            \$t->boolean('is_system')->default(true);
            \$t->timestamps();
        });
    }

    if (DB::table('panel_roles')->count() == 0) {
        DB::table('panel_roles')->insert([
            ['name'=>'Admin Panel','level'=>1, 'created_at'=>now(), 'updated_at'=>now()],
            ['name'=>'Partner Panel','level'=>2, 'created_at'=>now(), 'updated_at'=>now()],
            ['name'=>'Owner Panel','level'=>3, 'created_at'=>now(), 'updated_at'=>now()],
        ]);
    }

    Schema::table('users', function (Blueprint \$t) {
        if (!Schema::hasColumn('users','panel_role_id')) {
            \$t->unsignedBigInteger('panel_role_id')->default(0);
        }
        if (!Schema::hasColumn('users','creator_id')) {
            \$t->unsignedBigInteger('creator_id')->nullable()->index();
        }
    });

    DB::table('users')->whereNull('creator_id')->update(['creator_id' => \$MAIN]);

    DB::table('users')
        ->where('root_admin', 1)
        ->where('id', '!=', \$MAIN)
        ->where(function(\$q) {
            \$q->where('panel_role_id', 0)->orWhereNull('panel_role_id');
        })
        ->update(['panel_role_id' => 1]);

    DB::table('users')->where('id', \$MAIN)->update(['panel_role_id' => 0]);

} catch (\Exception \$e) {
    echo "   [DB ERROR] " . \$e->getMessage() . "\n";
    exit(1);
}
PHP

TMP_DIR="$(mktemp -d)"
cd "$TMP_DIR"

curl -fsSL \
  -H "Authorization: token $GITHUB_TOKEN" \
  "$ZIP_URL" -o "$ZIP_NAME" || { echo -e "${MERAH}Gagal download ZIP. Cek token atau koneksi.${NC}"; exit 1; }

unzip -oq "$ZIP_NAME"
rm "$ZIP_NAME"

IS_BILLING=false
if [ -f "$PTERO_PATH/config/billing.php" ] || [ -d "$PTERO_PATH/app/Models/Billing" ]; then
    IS_BILLING=true
fi

IS_ELYSIUM=false
if [ -d "$PTERO_PATH/resources/views/admin/elysium" ] || [ -d "$PTERO_PATH/app/Http/Controllers/Admin/Elysium" ]; then
    IS_ELYSIUM=true
fi

IS_REVIACTYL=false
if [ -d "$PTERO_PATH/public/reviactyl" ] || [ -d "$PTERO_PATH/resources/views/admin/designify" ]; then
    IS_REVIACTYL=true
fi

IS_STELLAR=false
if [ -d "$PTERO_PATH/resources/views/admin/theme" ] || [ -f "$PTERO_PATH/routes/admin/theme.php" ] || grep -q "admin.theme" "$PTERO_PATH/routes/admin.php"; then
    IS_STELLAR=true
fi

IS_BLUEPRINT=false
if [ -f "$PTERO_PATH/routes/blueprint.php" ] || [ -d "$PTERO_PATH/blueprint" ] || [ -d "$PTERO_PATH/app/BlueprintFramework" ]; then
    IS_BLUEPRINT=true
fi

if [ "$IS_BILLING" = true ]; then
    echo -e " ${BOLD}${HIJAU}✓ Admin Dashboard Terdeteksi: BILLING${NC}"
    find . -name "stellar_*" -delete
    find . -name "elysium_*" -delete
    find . -name "reviactyl_*" -delete
    find . -name "billing_*" | while read file; do
        dir=$(dirname "$file")
        filename=$(basename "$file")
        new_filename="${filename#billing_}"
        mv -f "$file" "$dir/$new_filename"
    done

elif [ "$IS_ELYSIUM" = true ]; then
    echo -e " ${BOLD}${HIJAU}✓ Admin Dashboard Terdeteksi: ELYSIUM${NC}"
    find . -name "billing_*" -delete
    find . -name "stellar_*" -delete
    find . -name "reviactyl_*" -delete
    rm -rf "resources/views/templates/gmd" "routes/custom"
    find . -name "elysium_*" | while read file; do
        dir=$(dirname "$file")
        filename=$(basename "$file")
        new_filename="${filename#elysium_}"
        mv -f "$file" "$dir/$new_filename"
    done

elif [ "$IS_REVIACTYL" = true ]; then
    echo -e " ${BOLD}${HIJAU}✓ Admin Dashboard Terdeteksi: REVIACTYL${NC}"
    find . -name "billing_*" -delete
    find . -name "stellar_*" -delete
    find . -name "elysium_*" -delete
    rm -rf "resources/views/templates/gmd" "routes/custom"
    find . -name "reviactyl_*" | while read file; do
        dir=$(dirname "$file")
        filename=$(basename "$file")
        new_filename="${filename#reviactyl_}"
        mv -f "$file" "$dir/$new_filename"
    done

elif [ "$IS_STELLAR" = true ]; then
    echo -e " ${BOLD}${HIJAU}✓ Admin Dashboard Terdeteksi: STELLAR${NC}"
    find . -name "billing_*" -delete
    find . -name "elysium_*" -delete
    find . -name "reviactyl_*" -delete
    rm -rf "resources/views/templates/gmd" "routes/custom"
    find . -name "stellar_*" | while read file; do
        dir=$(dirname "$file")
        filename=$(basename "$file")
        new_filename="${filename#stellar_}"
        mv -f "$file" "$dir/$new_filename"
    done

else
    echo -e " ${BOLD}${BIRU}✓ Admin Dashboard Terdeteksi: ORIGINAL / DEFAULT${NC}"
    find . -name "billing_*" -delete
    find . -name "stellar_*" -delete
    find . -name "elysium_*" -delete
    find . -name "reviactyl_*" -delete
    rm -rf "resources/views/templates/gmd" "routes/custom"
fi

if [ "$IS_BLUEPRINT" = true ]; then
    echo -e " ${BOLD}${CYAN}✓ Extension Manager Terdeteksi: BLUEPRINT${NC}"
    if [ "$IS_REVIACTYL" = true ]; then
        echo -e "   └─ Menggabungkan Tema Reviactyl + Blueprint..."
        find . -name "blueprint_reviactyl_admin.blade.php" | while read file; do
             mv -f "$file" "resources/views/layouts/admin.blade.php"
        done
        find . -name "blueprint_admin.blade.php" -delete

    else
        find . -name "blueprint_admin.blade.php" | while read file; do
             mv -f "$file" "resources/views/layouts/admin.blade.php"
        done
        find . -name "blueprint_reviactyl_admin.blade.php" -delete
    fi

    find . -name "blueprint_*" | while read file; do
        dir=$(dirname "$file")
        filename=$(basename "$file")
        new_filename="${filename#blueprint_}"
        mv -f "$file" "$dir/$new_filename"
    done
    
else
    find . -name "blueprint_*" -delete
fi

cp -rf ./* "$PTERO_PATH/"
cd "$PTERO_PATH"
rm -rf "$TMP_DIR"

if ! grep -q "mainAdminId" "$PTERO_PATH/app/Models/User.php"; then
    echo -e "${KUNING}   [WARNING] File User.php belum terupdate.${NC}"
fi

CONFIG_FILE="$PTERO_PATH/config/pterodactyl.php"

if grep -q "'main_admin_id'" "$CONFIG_FILE"; then
    sed -i "s/'main_admin_id' => .*,/'main_admin_id' => $ADMIN_ID,/" "$CONFIG_FILE"
else
    sed -i "/return \[/a \    'main_admin_id' => $ADMIN_ID," "$CONFIG_FILE"
fi

inject_blade_bottom "$ADMIN_INDEX_VIEW" "$HTML_TOMBOL_FreeZeeHost"
inject_blade_FreeZeeHost "$TARGET_FILE_POPUP"

cd "$PTERO_PATH"
rm -rf bootstrap/cache/* storage/framework/cache/* storage/framework/sessions/* storage/framework/views/*
php artisan optimize:clear > /dev/null 2>&1
php artisan view:clear > /dev/null 2>&1
php artisan config:clear > /dev/null 2>&1
chown -R www-data:www-data "$PTERO_PATH"
if systemctl is-active --quiet pteroq.service; then
    systemctl restart pteroq.service
fi
if command -v systemctl &> /dev/null; then
    systemctl restart $(systemctl list-units --type=service | awk '/php.*-fpm/ {print $1}' | head -n 1) 2>/dev/null || true
fi

sleep 0.5

clear
echo -e "\n${BOLD}${HIJAU}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${HIJAU}║                                      ║${NC}"
echo -e "${BOLD}${HIJAU}║${NC}       ${BOLD}${PUTIH}PROSES TELAH SELESAI!${NC}          ${BOLD}${HIJAU}║${NC}"
echo -e "${BOLD}${HIJAU}║${NC}   ${BOLD}${PUTIH}Sistem telah berhasil diperbarui.${NC}  ${BOLD}${HIJAU}║${NC}"
echo -e "${BOLD}${HIJAU}║                                      ║${NC}"
echo -e "${BOLD}${HIJAU}╚══════════════════════════════════════╝${NC}"
