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

set -e
FILES_TO_RESTORE=(
    "/var/www/pterodactyl/app/Http/Controllers/Admin/UserController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Settings/IndexController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Settings/AdvancedController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Settings/MailController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/DatabaseController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/MountController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/LocationController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/NodesController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/NestController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggScriptController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggShareController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggVariableController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Nodes/NodeViewController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/ServersController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Servers/ServerController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Servers/ServerTransferController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Admin/Servers/ServerViewController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Users/UserController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Locations/LocationController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Nodes/NodeController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Nests/EggController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Nests/NestController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Nodes/AllocationController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Nodes/NodeConfigurationController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Nodes/NodeDeploymentController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Servers/DatabaseController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Servers/ExternalServerController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Servers/ServerDetailsController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Users/ExternalUserController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Servers/ServerController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Servers/ServerManagementController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Application/Servers/StartupController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/StartupController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/TwoFactorController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/FileController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/SettingsController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/ServerController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/ActivityLogController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/BackupController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/CommandController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/DatabaseController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/FileUploadController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/NetworkAllocationController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/PowerController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/ResourceUtilizationController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/ScheduleController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/ScheduleTaskController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/Servers/WebsocketController.php"
    "/var/www/pterodactyl/app/Http/Controllers/Api/Client/ClientController.php"
    "/var/www/pterodactyl/resources/views/admin/index.blade.php"
    "/var/www/pterodactyl/resources/views/admin/api/index.blade.php"
    "/var/www/pterodactyl/resources/views/templates/base/core.blade.php"
    "/var/www/pterodactyl/app/Http/Kernel.php"
    "/var/www/pterodactyl/app/Http/Middleware/AdminAuthenticate.php"
    "/var/www/pterodactyl/app/Http/Middleware/Api/Client/Server/AuthenticateServerAccess.php"
    "/var/www/pterodactyl/app/Models/Server.php"
    "/var/www/pterodactyl/app/Models/User.php"
    "/var/www/pterodactyl/app/Observers/UserObserver.php"
    "/var/www/pterodactyl/app/Policies/ServerPolicy.php"
    "/var/www/pterodactyl/app/Services/Servers/DetailsModificationService.php"
    "/var/www/pterodactyl/app/Services/Users/UserCreationService.php"
    "/var/www/pterodactyl/app/Services/Users/UserUpdateService.php"
    "/var/www/pterodactyl/config/pterodactyl.php"
    "/var/www/pterodactyl/resources/views/layouts/admin.blade.php"
    "/var/www/pterodactyl/routes/admin.php"
    "/var/www/pterodactyl/routes/api-application.php"
    "/var/www/pterodactyl/resources/views/templates/gmd/admin/nav.blade.php"
    "/var/www/pterodactyl/resources/views/templates/gmd/admin/navs/billing.blade.php"
    "/var/www/pterodactyl/routes/gmd.php"
    "/var/www/pterodactyl/routes/custom/affiliates.php"
    "/var/www/pterodactyl/routes/custom/billing_module.php"
    "/var/www/pterodactyl/routes/custom/general.php"
    "/var/www/pterodactyl/resources/views/admin/extensions.blade.php" # blueprint
    "/var/www/pterodactyl/routes/blueprint.php" # blueprint
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

FILES_TO_DELETE=(
    "/var/www/pterodactyl/app/Http/Controllers/Admin/RoleController.php"
    "/var/www/pterodactyl/app/Http/Middleware/Admin/AdminLevelGuard.php"
    "/var/www/pterodactyl/app/Models/PanelRole.php"
    "/var/www/pterodactyl/app/Support/FreeZeeHostMainAdminGuard.php"
    "/var/www/pterodactyl/app/Support/FreeZeeHostServerGuard.php"
    "/var/www/pterodactyl/resources/views/admin/roles"
)

ALLOWED_ADMINS_PATH="/var/www/pterodactyl/app/Http/Controllers/FreeZeeHostganteng.json"

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

clear
echo -e "${BOLD}${CYAN}
   ███████╗ █████╗ ███╗   ██╗ ██████╗
   ██╔════╝██╔══██╗████╗  ██║██╔═══██╗
   ███████╗███████║██╔██╗ ██║██║   ██║
   ╚════██║██╔══██║██║╚██╗██║██║   ██║
   ███████║██║  ██║██║ ╚████║╚██████╔╝
   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝
${NC}"
echo -e "${BOLD}${PUTIH}          Deinstalasi Proteksi Anti-Rusuh${NC}"
echo -e "${BOLD}${BIRU}=====================================================${NC}"
sleep 0.5

echo -e "\n${BOLD}${KUNING} ➤ Memindai file backup...${NC}"
BACKUP_FOUND=0

for file_check in "${FILES_TO_RESTORE[@]}"; do
    if ls "${file_check}.bak_"* 1>/dev/null 2>&1; then
        BACKUP_FOUND=1
        break 
    fi
done

if [ "$BACKUP_FOUND" -eq 0 ]; then
    echo -e "${BOLD}${MERAH} ✖ File backup tidak ditemukan satupun.${NC}"
    echo -e "${BOLD}${KUNING} ⚠ Peringatan: Proses PEMULIHAN FILE akan DIBATALKAN.${NC}"
    echo -e "${BOLD}${KUNING}   Namun, skrip tetap akan membersihkan cache sistem.${NC}"
else
    echo -e "${BOLD}${HIJAU} ✓ File backup ditemukan.${NC}"
fi

echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║           ${BOLD}${PUTIH}Konfirmasi Awal            ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
echo -e "${BOLD}${KUNING} ┃ ${BOLD}${PUTIH}INFO:${NC} Skrip ini akan menghapus proteksi."
if [ "$BACKUP_FOUND" -eq 1 ]; then
    echo -e "${BOLD}${KUNING} ┃${NC} File asli akan dikembalikan dari backup."
else
    echo -e "${BOLD}${MERAH} ┃${NC} Karena backup tidak ada, file TIDAK akan berubah."
    echo -e "${BOLD}${KUNING} ┃${NC} Hanya cache sistem yang akan dibersihkan."
fi

sleep 0.5
echo -e "\n${BOLD}${PUTIH} ➤ Apakah Anda yakin ingin melanjutkan? (y/n):${NC}"
read -p "   ↳ " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo -e "\n${BOLD}${MERAH} ✖ Proses dibatalkan oleh pengguna.${NC}"
  exit 0
fi

restore_file() {
    local original_file="$1"
    if ls "${original_file}.bak_"* 1>/dev/null 2>&1; then
        local latest_backup=$(ls -t "${original_file}.bak_"* | head -n 1)
        mv "$latest_backup" "$original_file"
    fi
}

clear
echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║     ${BOLD}${PUTIH}Memulai proses deinstalasi...    ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}║         ${BOLD}${PUTIH}Mohon tunggu sebentar.       ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
sleep 0.5

if [ "$BACKUP_FOUND" -eq 1 ]; then
    echo -e "\n${BOLD}${HIJAU} ➤ Mengembalikan file asli...${NC}"
    for file_path in "${FILES_TO_RESTORE[@]}"; do
        restore_file "$file_path"
    done
    rm -f "$ALLOWED_ADMINS_PATH"
else
    echo -e "\n${BOLD}${MERAH} ➤ Langkah Pemulihan File DILEWATI (Backup Kosong).${NC}"
fi

echo -e "\n${BOLD}${HIJAU} ➤ Menghapus file sistem tambahan...${NC}"
for del_path in "${FILES_TO_DELETE[@]}"; do
    if [ -d "$del_path" ]; then
        rm -rf "$del_path"
    elif [ -f "$del_path" ]; then
        rm -f "$del_path"
    fi
done

echo -e "\n${BOLD}${KUNING} ➤ Membersihkan cache sistem...${NC}"
cd /var/www/pterodactyl || { echo -e "${BOLD}${MERAH} ✖ Gagal masuk direktori Pterodactyl.${NC}"; exit 1; }
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
if [ "$BACKUP_FOUND" -eq 1 ]; then
    echo -e "${BOLD}${HIJAU}║${NC}   ${BOLD}${PUTIH}Proteksi telah berhasil dihapus.${NC}   ${BOLD}${HIJAU}║${NC}"
else
    echo -e "${BOLD}${HIJAU}║${NC}   ${BOLD}${PUTIH}Cache bersih (Backup tidak ada).${NC}   ${BOLD}${HIJAU}║${NC}"
fi
echo -e "${BOLD}${HIJAU}║                                      ║${NC}"
echo -e "${BOLD}${HIJAU}╚══════════════════════════════════════╝${NC}"
