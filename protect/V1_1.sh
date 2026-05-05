#!/bin/bash

# ============================================================
# SKRIP INI DIBUAT OLEH FreeZeeHost OFFICIAL (TELEGRAM: @batuofc)
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

CORRECT_KEY="FreeZeeHostgege"

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

if ! command -v gawk &> /dev/null; then
    apt-get update -y > /dev/null 2>&1
    apt-get install -y gawk > /dev/null 2>&1
fi
sleep 2

echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║           ${BOLD}${PUTIH}Verifikasi Akses           ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
echo -e "\n${BOLD}${PUTIH} ➤ Masukkan Key:${NC}"
read -sp "   ↳ " user_key
if [[ "$user_key" != "$CORRECT_KEY" ]]; then
    sleep 1
    echo -e "\n\n${BOLD}${MERAH}✖ Key yang Anda masukkan salah. Akses ditolak.${NC}"
    exit 1
fi
sleep 1
echo -e "\n\n${BOLD}${HIJAU}✓ Verifikasi berhasil...${NC}"
sleep 2
clear

echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║           ${BOLD}${PUTIH}Konfigurasi Awal           ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"

echo -e "${BOLD}${PUTIH} ➤ Masukkan ID admin utama (contoh: 1):${NC}"
read -p "   ↳ " ADMIN_ID
if [[ -z "$ADMIN_ID" ]]; then
  echo -e "\n${BOLD}${MERAH} ✖ ID tidak boleh kosong. Proses dibatalkan.${NC}"
  exit 1
fi
echo -e "${BOLD}${HIJAU} ✓ ID Admin Utama di-set ke:${BOLD}${PUTIH} $ADMIN_ID${NC}"
sleep 0.5

echo -e "\n${BOLD}${PUTIH} ➤ Apakah Anda yakin ingin melanjutkan? (y/n):${NC}"
read -p "   ↳ " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo -e "\n${BOLD}${MERAH} ✖ Proses dibatalkan oleh pengguna.${NC}"
  exit 0
fi

API_USER_CTRL="/var/www/pterodactyl/app/Http/Controllers/Api/Application/Users/UserController.php"
ADMIN_USER_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/UserController.php"
INDEX_SETTINGS="/var/www/pterodactyl/app/Http/Controllers/Admin/Settings/IndexController.php"
ADV_SETTINGS="/var/www/pterodactyl/app/Http/Controllers/Admin/Settings/AdvancedController.php"
MAIL_SETTINGS="/var/www/pterodactyl/app/Http/Controllers/Admin/Settings/MailController.php"
LOC_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/LocationController.php"
ADMIN_NODES="/var/www/pterodactyl/app/Http/Controllers/Admin/NodesController.php"
API_NODES="/var/www/pterodactyl/app/Http/Controllers/Api/Application/Nodes/NodeController.php"
NEST_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/NestController.php"
EGG_CTRL="/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggController.php"
EGG_SCRIPT="/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggScriptController.php"
EGG_SHARE="/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggShareController.php"
EGG_VAR="/var/www/pterodactyl/app/Http/Controllers/Admin/Nests/EggVariableController.php"
ADM_NODES_SETTINGS="/var/www/pterodactyl/app/Http/Controllers/Admin/Nodes/NodeViewController.php"

inject_after_brace() {
  local file="$1"
  local pattern="$2"
  export INJECTED_CODE="$3"
  
  if [[ ! -f "$file" ]]; then
      return
  fi

  gawk -v pat="$pattern" '
    { print }
    (found_sig && !done && index($0, "{")) { print ENVIRON["INJECTED_CODE"]; done=1; found_sig=0; }
    (index($0, pat)) { found_sig=1; }
  ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

SECURITY_CODE="        if (auth()->user()->id !== $ADMIN_ID) {
            if (request()->expectsJson()) {
                abort(403, 'Akses Ditolak: Anda bukan Admin Utama. (Proteksi by FreeZeeHost Official)');
            } else {
                throw new \\Pterodactyl\\Exceptions\\DisplayException('Akses Ditolak! Anda bukan Admin Utama. (Proteksi by FreeZeeHost Official)');
            }
        }
"

clear
echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║     ${BOLD}${PUTIH}Memulai proses instalasi...      ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}║        ${BOLD}${PUTIH}Mohon tunggu sebentar.        ${BOLD}${CYAN}║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
sleep 2
FILES_TO_BACKUP=("$API_USER_CTRL" "$ADMIN_USER_CTRL" "$INDEX_SETTINGS" "$ADV_SETTINGS" "$MAIL_SETTINGS" "$LOC_CTRL" "$ADMIN_NODES" "$API_NODES" "$NEST_CTRL" "$EGG_CTRL" "$EGG_SCRIPT" "$EGG_SHARE" "$EGG_VAR" "$ADM_NODES_SETTINGS")
for file in "${FILES_TO_BACKUP[@]}"; do
    if [[ -f "$file" ]]; then
        cp "$file" "${file}.bak_$(date +%F_%T)"
    fi
done
while IFS=':' read -r file pattern; do
    inject_after_brace "$file" "$pattern" "$SECURITY_CODE"
done <<EOF
$API_USER_CTRL:public function delete(DeleteUserRequest
$API_USER_CTRL:public function update(UpdateUserRequest
$ADMIN_USER_CTRL:public function delete(Request
$ADMIN_USER_CTRL:public function update(UserFormRequest
$INDEX_SETTINGS:public function update(BaseSettingsFormRequest
$ADV_SETTINGS:public function update(AdvancedSettingsFormRequest
$MAIL_SETTINGS:public function update(MailSettingsFormRequest
$LOC_CTRL:public function create(LocationFormRequest
$LOC_CTRL:public function update(LocationFormRequest
$LOC_CTRL:public function delete(Location
$ADMIN_NODES:public function store(NodeFormRequest
$ADMIN_NODES:public function updateSettings(NodeFormRequest
$ADMIN_NODES:public function delete(int|Node
$ADM_NODES_SETTINGS:public function settings(Request
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
cd /var/www/pterodactyl
rm -rf bootstrap/cache/* storage/framework/cache/* storage/framework/sessions/* storage/framework/views/*
php artisan optimize:clear > /dev/null 2>&1
sleep 1

clear
echo -e "\n${BOLD}${HIJAU}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${HIJAU}║                                      ║${NC}"
echo -e "${BOLD}${HIJAU}║${NC}       ${BOLD}${PUTIH}PROSES TELAH SELESAI!${NC}          ${BOLD}${HIJAU}║${NC}"
echo -e "${BOLD}${HIJAU}║${NC}   ${BOLD}${PUTIH}Sistem telah berhasil diperbarui.${NC}  ${BOLD}${HIJAU}║${NC}"
echo -e "${BOLD}${HIJAU}║                                      ║${NC}"
echo -e "${BOLD}${HIJAU}╚══════════════════════════════════════╝${NC}"
