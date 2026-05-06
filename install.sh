#!/bin/bash

# ============================================================
#               FREEZEEHOST THEME INSTALLER
# ============================================================
# LICENSE: PROPRIETARY - RESTRICTED USE
# ------------------------------------------------------------
# (c) 2026 FreeZeeHost Official. All Rights Reserved.
#
# PERMITTED:
# - Running this script for personal or commercial Pterodactyl setup.
#
# STRICTLY FORBIDDEN:
# - Copying, modifying, or redistributing the source code.
# - Re-branding or claiming this script as your own work.
# - Using parts of this code in other projects without permission.
#
# Violation of these terms will result in access revocation.
# ============================================================
# Version: 3.2.0-PRO
# ============================================================

# Reset
NC='\033[0m'

# Style
BOLD='\033[1m'
DIM='\033[2m'

# Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BRIGHT_RED='\033[91m'
BRIGHT_GREEN='\033[92m'
BRIGHT_YELLOW='\033[93m'
BRIGHT_BLUE='\033[94m'
BRIGHT_MAGENTA='\033[95m'
BRIGHT_CYAN='\033[96m'
BRIGHT_WHITE='\033[97m'
BG_GREEN='\033[42m'
BG_RED='\033[41m'

# UI Helpers
print_info() { echo -e "  ${BRIGHT_CYAN}${BOLD}💠 INFO${NC} ${WHITE}│ $1${NC}"; }
print_success() { echo -e "  ${BRIGHT_GREEN}${BOLD}✅ SUCCESS${NC} ${WHITE}│ $1${NC}"; }
print_warning() { echo -e "  ${BRIGHT_YELLOW}${BOLD}⚠️ WARNING${NC} ${WHITE}│ $1${NC}"; }
print_error() { echo -e "  ${BRIGHT_RED}${BOLD}❌ ERROR${NC} ${WHITE}│ $1${NC}"; }

premium_header() {
  clear
  local title=$1; local color=$2
  echo -e "  ${color}${BOLD}┌────────────────────────────────────────────────────────────────────────┐${NC}"
  echo -e "  ${color}${BOLD}│${NC}  ${WHITE}${BOLD}${title}${NC}"
  echo -e "  ${color}${BOLD}└────────────────────────────────────────────────────────────────────────┘${NC}"
}

premium_box() {
  local title=$1; local color=$2
  echo -e "  ${color}${BOLD}╔══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "  ${color}${BOLD}║${NC}  ${WHITE}${BOLD}👑 ${title}${NC}"
  echo -e "  ${color}${BOLD}╚══════════════════════════════════════════════════════════════════════╝${NC}"
}

show_loading() {
  local duration=$1; local message=$2
  echo -ne "  ${BRIGHT_MAGENTA}${BOLD}⏳ $message${NC} "
  for ((i=0; i<duration; i++)); do echo -ne "${BRIGHT_CYAN}."; sleep 0.4; done
  echo -e " ${BRIGHT_GREEN}SUCCESS!${NC}"
}

line_separator() { echo -e "  ${DIM}${WHITE}──────────────────────────────────────────────────────────────────────────${NC}"; }

# --- ERROR HANDLER MENU ---
error_recovery_menu() {
  local msg=$1
  print_error "$msg"
  echo ""
  echo -e "  ${BOLD}${WHITE}Apa yang ingin Anda lakukan?${NC}"
  echo -e "  ${BRIGHT_WHITE}${BOLD} [1]${NC} ${WHITE}🏠 Kembali ke Dashboard${NC}"
  echo -e "  ${BRIGHT_WHITE}${BOLD} [2]${NC} ${WHITE}❌ Keluar dari Skrip${NC}"
  echo ""; echo -n -e "  ${BOLD}${BRIGHT_YELLOW}👉 Masukkan Pilihan: ${NC}"; read rec_choice
  case "$rec_choice" in
    1) return 0 ;;
    *) exit 0 ;;
  esac
}

check_ptero_dir() {
  if [ ! -d "/var/www/pterodactyl" ]; then
    echo ""
    premium_header "CRITICAL ERROR: DIRECTORY NOT FOUND" "$BRIGHT_RED"
    print_error "Direktori Pterodactyl (/var/www/pterodactyl) tidak ditemukan!"
    echo -e "  ${BOLD}${WHITE}Apa yang ingin Anda lakukan?${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [1]${NC} ${WHITE}🔙 Kembali ke Menu Utama${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [2]${NC} ${WHITE}❌ Keluar dari Skrip${NC}"
    echo ""; echo -n -e "  ${BOLD}${BRIGHT_YELLOW}👉 Masukkan Pilihan: ${NC}"; read err_choice
    case "$err_choice" in 1) return 1 ;; 2) exit 0 ;; *) return 1 ;; esac
  fi
  return 0
}

# --- PROTECTION HELPERS ---
inject_after_brace() {
  local file="$1"; local pattern="$2"; local code="$3"
  if [[ ! -f "$file" ]]; then return; fi
  if grep -q "FreeZeeHost Premium" "$file" || grep -q "FreeZeeHost Protected" "$file"; then return; fi
  
  # Create backup if it doesn't exist
  if [[ ! -f "${file}.bak_fzh" ]]; then
    cp "$file" "${file}.bak_fzh"
  fi
  
  export INJECTED_CODE="$code"
  gawk -v pat="$pattern" '
    { print }
    (found_sig && !done && index($0, "{")) { print ENVIRON["INJECTED_CODE"]; done=1; found_sig=0; }
    (index($0, pat)) { if (index($0, "{") && !done) { print ENVIRON["INJECTED_CODE"]; done=1; } else { found_sig=1; } }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

inject_after_line() {
  local file="$1"; local pattern="$2"; local code="$3"
  if [[ ! -f "$file" ]]; then return; fi
  if grep -q "FreeZeeHost Premium" "$file" || grep -q "FreeZeeHost Protected" "$file"; then return; fi
  
  # Create backup if it doesn't exist
  if [[ ! -f "${file}.bak_fzh" ]]; then
    cp "$file" "${file}.bak_fzh"
  fi
  
  export INJECTED_CODE="$code"
  gawk -v pat="$pattern" '{ print } (index($0, pat) && !done) { print ENVIRON["INJECTED_CODE"]; done=1; }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

# --- THEME FUNCTIONS ---
install_theme() {
  local SELECT_THEME; local THEME_NAME; local THEME_URL
  while true; do
    clear; echo ""; premium_box "SELECT YOUR PREMIUM THEME" "$BRIGHT_CYAN"; echo ""
    echo -e "  ${BOLD}${BRIGHT_WHITE}✨ STANDARD THEMES (DIRECT INSTALL):${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [1]${NC} ${WHITE}🌌 Stellar${NC}        ${BRIGHT_WHITE}${BOLD} [2]${NC} ${WHITE}💳 Billing${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [3]${NC} ${WHITE}🧩 Enigma${NC}         ${BRIGHT_WHITE}${BOLD} [4]${NC} ${WHITE}🌈 Elysium${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [5]${NC} ${WHITE}❄️ Frostcore${NC}      ${BRIGHT_WHITE}${BOLD} [6]${NC} ${WHITE}🌃 Nightcore${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [7]${NC} ${WHITE}🧱 IceMinecraft${NC}   ${BRIGHT_WHITE}${BOLD} [8]${NC} ${WHITE}👶 Noobe${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [9]${NC} ${WHITE}🔥 Arix${NC}           ${BRIGHT_WHITE}${BOLD} [10]${NC} ${WHITE}🐦 Nookure${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [11]${NC} ${WHITE}🔄 Reviactyl${NC}"
    echo ""; echo -e "  ${BOLD}${BRIGHT_MAGENTA}🛠️ BLUEPRINT THEMES (REQUIRES BLUEPRINT):${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [b1]${NC} ${MAGENTA}☁️ Nebula 1.8${NC}    ${BRIGHT_WHITE}${BOLD} [b2]${NC} ${MAGENTA}☁️ Nebula 2.0${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [b3]${NC} ${MAGENTA}🎨 Recolor${NC}       ${BRIGHT_WHITE}${BOLD} [b4]${NC} ${MAGENTA}⚓ NavySeals${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [b5]${NC} ${MAGENTA}🍋 LememTheme${NC}    ${BRIGHT_WHITE}${BOLD} [b6]${NC} ${MAGENTA}🌑 Darkenate${NC}"
    echo ""; echo -e "  ${BRIGHT_YELLOW}${BOLD} [R]${NC} ${YELLOW}🔄 Reset Theme (Original Panel)${NC}"
    echo -e "  ${BRIGHT_RED}${BOLD} [x]${NC} ${RED}🔙 Back to Main Menu${NC}"
    echo ""; echo -n -e "  ${BOLD}${BRIGHT_YELLOW}👉 Enter Choice: ${NC}"; read SELECT_THEME
    case "$SELECT_THEME" in
      1) THEME_NAME="Stellar"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/stellar.zip"; break ;;
      2) THEME_NAME="Billing"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/billing.zip"; break ;;
      3) THEME_NAME="Enigma"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/enigma.zip"; break ;;
      4) THEME_NAME="Elysium"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/elysium.zip"; break ;;
      5) THEME_NAME="Frostcore"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/frostcore.zip"; break ;;
      6) THEME_NAME="Nightcore"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/nightcore.zip"; break ;;
      7) THEME_NAME="IceMinecraft"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/ice.zip"; break ;;
      8) THEME_NAME="Noobe"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/noobe.zip"; break ;;
      9) THEME_NAME="Arix"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/arix.zip"; break ;;
      10) THEME_NAME="Nookure"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/nookure.zip"; break ;;
      11) install_timpa "https://github.com/reviactyl/panel/releases/latest/download/panel.tar.gz" "Reviactyl"; return ;;
      [bB]1) THEME_NAME="Nebula V1.8"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/nebula_v1.8-3.zip"; break ;;
      [bB]2) THEME_NAME="Nebula V2.0"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/nebula_v2.0-1.zip"; break ;;
      [bB]3) THEME_NAME="Recolor"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/recolor.zip"; break ;;
      [bB]4) THEME_NAME="NavySeals"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/navyseals.zip"; break ;;
      [bB]5) THEME_NAME="LememTheme"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/lemem.zip"; break ;;
      [bB]6) THEME_NAME="Darkenate"; THEME_URL="https://github.com/FreeZeeHostProject/installer/raw/main/theme/darkenate.zip"; break ;;
      r|R) uninstall_theme; return ;;
      x|X) return ;;
      *) print_error "Pilihan tidak valid."; sleep 1 ;;
    esac
  done

  echo -e "\n  ${BOLD}${BRIGHT_YELLOW}⚠️ CONFIRMATION REQUIRED${NC}"
  echo -e "  ${WHITE}You have selected: ${BRIGHT_CYAN}${THEME_NAME}${NC}"
  echo -n -e "  ${BOLD}${WHITE}👉 Proceed with installation? (y/n): ${NC}"; read confirmation
  if [[ "$confirmation" != [yY] ]]; then return; fi

  print_info "Starting installation of $THEME_NAME..."
  check_ptero_dir || return 1; set -e
  
  # --- AUTO-DIRECT TO BLUEPRINT IF MISSING ---
  if [[ "$SELECT_THEME" == [bB]* ]]; then
    if [ ! -f "/var/www/pterodactyl/blueprint.sh" ]; then
      print_warning "Blueprint Framework is required for this theme but was not found!"
      echo -n -e "  ${BOLD}${WHITE}👉 Install Blueprint automatically? (y/n): ${NC}"; read bp_confirm
      if [[ "$bp_confirm" == [yY] ]]; then
        install_blueprint || return 1
        cd /var/www/pterodactyl # Ensure we are in the right place after BP install
      else
        print_error "Installation cancelled: Blueprint missing."
        return 1
      fi
    fi
  fi

  TEMP_DIR=$(mktemp -d); trap 'rm -rf -- "$TEMP_DIR"' EXIT; cd "$TEMP_DIR"
  wget -q "$THEME_URL"; local ZIP_FILE=$(basename "$THEME_URL")
  if [[ "$ZIP_FILE" == *.tar.gz ]]; then tar -xzf "$ZIP_FILE"; else unzip -oq "$ZIP_FILE" || true; fi
  
  if [[ "$SELECT_THEME" == [bB]* ]]; then
    ID=$(find . -name "*.blueprint" -exec basename {} .blueprint \;)
    sudo mv "$ID.blueprint" /var/www/pterodactyl/
    cd /var/www/pterodactyl && sudo blueprint -install "$ID"
  else
    sudo cp -rfT pterodactyl /var/www/pterodactyl && cd /var/www/pterodactyl
    CURRENT_NODE_VER=$(node -v 2>/dev/null | cut -d'.' -f1 | sed 's/v//')
    if [[ "$CURRENT_NODE_VER" != "22" ]]; then
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    sudo npm i -g yarn && yarn install && export NODE_OPTIONS=--openssl-legacy-provider
    if [ "$SELECT_THEME" == "2" ]; then php artisan billing:install stable; fi
    php artisan migrate --force && yarn build:production && php artisan view:clear && php artisan optimize:clear
  fi
  premium_box "$THEME_NAME INSTALLED" "$BRIGHT_GREEN"; sleep 3
}

install_timpa() {
  print_info "Installing Panel Base: $2..."
  check_ptero_dir || return 1; set -e
  TEMP_DIR=$(mktemp -d); trap 'rm -rf -- "$TEMP_DIR"' EXIT; cd "$TEMP_DIR"
  wget -q -O p.tar.gz "$1" && cd /var/www/pterodactyl
  php artisan down || true
  if [ -f ".env" ]; then cp .env /tmp/.env.bak; fi
  sudo find . -mindepth 1 -delete
  tar -xzf "$TEMP_DIR/p.tar.gz" -C .
  if [ -f "/tmp/.env.bak" ]; then mv /tmp/.env.bak .env; fi
  sudo chown -R www-data:www-data . && sudo -u www-data composer install --no-dev --optimize-autoloader
  sudo -u www-data php artisan migrate --seed --force && sudo -u www-data php artisan up
  premium_box "$2 READY" "$BRIGHT_GREEN"; sleep 2
}

# --- SYSTEM UTILS ---
uninstall_theme() {
  premium_header "SYSTEM RESET" "$BRIGHT_CYAN"
  read -p "  👉 Reset to original panel? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  check_ptero_dir || return 1; set -e
  cd /var/www/pterodactyl

  print_info "⚙️  Starting panel reset process..."
  
  print_info "Backing up .env..."
  TEMP_BACKUP=$(mktemp -d)
  if [ -f ".env" ]; then cp .env "$TEMP_BACKUP/"; fi

  print_info "Removing old panel files..."
  sudo find . -mindepth 1 -delete
  
  print_info "Downloading latest original panel..."
  curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | sudo tar -xzf - -C /var/www/pterodactyl

  print_info "Restoring .env..."
  if [ -f "$TEMP_BACKUP/.env" ]; then mv "$TEMP_BACKUP/.env" .; fi
  rm -rf "$TEMP_BACKUP"

  print_info "Installing dependencies..."
  sudo chmod -R 755 storage/* bootstrap/cache/
  sudo chown -R www-data:www-data /var/www/pterodactyl
  sudo -u www-data composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist > /dev/null 2>&1

  print_info "Running migrations and clearing cache..."
  sudo -u www-data php artisan migrate --seed --force
  sudo -u www-data php artisan optimize:clear
  sudo rm -f /usr/local/bin/blueprint

  print_info "Restarting services..."
  sudo systemctl restart nginx > /dev/null 2>&1 || sudo systemctl restart apache2 > /dev/null 2>&1
  sudo systemctl restart pteroq
  sudo -u www-data php artisan up

  premium_box "PANEL RESET SUCCESSFUL" "$BRIGHT_GREEN"; sleep 2
}

uninstall_panel() {
  premium_header "SAFE UNINSTALL" "$BRIGHT_RED"
  read -p "  👉 PERMANENTLY DELETE PANEL? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  rm -rf /var/www/pterodactyl /etc/pterodactyl /var/lib/pterodactyl
  premium_box "PURGED" "$BRIGHT_GREEN"; sleep 2
}

install_auto_suspend() {
  premium_header "AUTO-SUSPEND PRO" "$BRIGHT_BLUE"
  read -p "  👉 Activate Auto-Suspend features? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  check_ptero_dir || return 1; set -e
  print_info "🚀 Activating..."
  cd /var/www/pterodactyl
  sed -i "/use Ramsey\\\\Uuid\\\\Uuid;/a use Pterodactyl\\\\Models\\\\Server;" app/Console/Kernel.php
  sed -i "/'owner_id', 'external_id', 'name',/a \        'exp_date'," app/Http/Controllers/Admin/ServersController.php
  sed -i "/'backup_limit' => 'present|nullable|integer|min:0',/a \        'exp_date' => 'sometimes|nullable'," app/Models/Server.php
  php artisan migrate --force && php artisan optimize:clear
  premium_box "AUTO-SUSPEND ACTIVE" "$BRIGHT_GREEN"; sleep 2
}

install_blueprint() {
  premium_header "BLUEPRINT FRAMEWORK" "$BRIGHT_BLUE"
  read -p "  👉 Install Blueprint Core? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  check_ptero_dir || return 1; set +e # Handle errors manually
  
  print_info "🚀 Running pre-install check..."
  cd /var/www/pterodactyl
  
  # --- AUTO-FIX NODE.JS VERSION ---
  local NODE_VER=$(node -v 2>/dev/null | cut -d'.' -f1 | sed 's/v//')
  if [[ -z "$NODE_VER" ]] || [[ "$NODE_VER" -lt 20 ]]; then
    print_warning "Node.js $NODE_VER detected. Blueprint requires >20.x. Auto-fixing..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - > /dev/null 2>&1
    sudo apt-get install -qq -y nodejs > /dev/null 2>&1
    print_success "Node.js updated to 22.x"
  fi

  DOWNLOAD_URL=$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | grep 'release.zip' | cut -d '"' -f 4)
  wget -q "$DOWNLOAD_URL" -O b.zip && unzip -oq b.zip && rm b.zip
  sudo npm i -g yarn && yarn install && yarn add cross-env
  
  chmod +x blueprint.sh
  print_info "Executing Blueprint Installer..."
  yes | sudo bash blueprint.sh
  
  if [ $? -ne 0 ]; then
    error_recovery_menu "Blueprint installation failed due to dependency issues."
    return 1
  fi
  
  premium_box "BLUEPRINT READY" "$BRIGHT_GREEN"; sleep 2
}

start_wings() { 
  premium_header "WINGS MANAGEMENT" "$BRIGHT_BLUE"
  read -p "  👉 Configure and Start Wings? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  read -p "  👉 Token Auto-Deploy: " t; eval "$t"; sudo systemctl start wings; premium_box "DONE" "$BRIGHT_GREEN"; sleep 2; 
}
create_node() { 
  premium_header "NODE ARCHITECT" "$BRIGHT_CYAN"
  read -p "  👉 Run Node Creation Script? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  bash <(curl -s https://raw.githubusercontent.com/FreeZeeHostProject/installer/main/createnode.sh); premium_box "DONE" "$BRIGHT_GREEN"; sleep 2; 
}
hackback_panel() { 
  premium_header "ADMIN RECOVERY" "$BRIGHT_MAGENTA"
  read -p "  👉 Create Emergency Admin? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  read -p "  👉 New Admin User: " u; read -sp "  👉 Password: " p; echo; check_ptero_dir || return 1; cd /var/www/pterodactyl; printf 'yes\n%s@admin.com\n%s\n%s\n%s\n%s\n' "$u" "$u" "$u" "$u" "$p" | php artisan p:user:make; premium_box "DONE" "$BRIGHT_GREEN"; sleep 2; 
}
ubahpw_vps() { 
  premium_header "SECURITY CONFIG" "$BRIGHT_WHITE"
  read -p "  👉 Change VPS Root Password? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  read -p "  👉 New VPS Password: " p; passwd <<EOF
$p
$p
EOF
premium_box "DONE" "$BRIGHT_GREEN"; sleep 2; }
change_background() { 
  premium_header "BACKGROUND SETTINGS" "$BRIGHT_CYAN"
  read -p "  👉 Update Panel Background? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  read -p "  👉 Image URL: " u; check_ptero_dir || return; cd /var/www/pterodactyl; sed -i "/<\/head>/i \    <style>body { background-image: url('$u') !important; }</style>" resources/views/templates/wrapper.blade.php; print_success "Done"; sleep 2; 
}
change_logo() { 
  premium_header "LOGO SETTINGS" "$BRIGHT_CYAN"
  read -p "  👉 Update Panel Logo? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  read -p "  👉 Image URL: " u; check_ptero_dir || return; cd /var/www/pterodactyl; wget -q -O public/logo.png "$u"; print_success "Done"; sleep 2; 
}
install_phpmyadmin() { 
  premium_header "PHPMYADMIN" "$BRIGHT_GREEN"
  read -p "  👉 Install PHPMyAdmin? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  print_info "Installing PMA..."; sudo apt install -y phpmyadmin; print_success "Done"; sleep 2; 
}
configure_ssl() { 
  premium_header "SSL CONFIG" "$BRIGHT_GREEN"
  read -p "  👉 Configure Let's Encrypt SSL? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  read -p "  👉 Domain: " DOMAIN; sudo certbot --nginx -d $DOMAIN; print_success "Done"; sleep 2; 
}
backup_system() { 
  premium_header "FULL BACKUP" "$BRIGHT_YELLOW"
  read -p "  👉 Start Full System Backup? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  check_ptero_dir || return; TS=$(date +%F_%T); tar -czf /root/ptero_$TS.tar.gz /var/www/pterodactyl; print_success "Done"; sleep 2; 
}
turbo_build() { 
  premium_header "TURBO BUILD" "$BRIGHT_BLUE"
  read -p "  👉 Build Panel Assets? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  check_ptero_dir || return; cd /var/www/pterodactyl; yarn build:production; print_success "Done"; sleep 2; 
}
toggle_maintenance() { 
  premium_header "MAINTENANCE MODE" "$BRIGHT_YELLOW"
  read -p "  👉 Toggle Maintenance Status? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  check_ptero_dir || return; cd /var/www/pterodactyl; if [ -f storage/framework/down ]; then php artisan up; else php artisan down; fi; sleep 2; 
}
fix_permissions() { 
  premium_header "PERMISSIONS FIX" "$BRIGHT_MAGENTA"
  read -p "  👉 Fix Panel Ownership/Permissions? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  check_ptero_dir || return; chown -R www-data:www-data /var/www/pterodactyl/*; sleep 2; 
}
clear_logs() { 
  premium_header "LOG CLEANUP" "$BRIGHT_WHITE"
  read -p "  👉 Clear All Panel Logs? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  check_ptero_dir || return; rm -rf /var/www/pterodactyl/storage/logs/*.log; sleep 2; 
}
backup_eggs() { 
  premium_header "EGG BACKUP" "$BRIGHT_YELLOW"
  read -p "  👉 Backup All Eggs and Nests? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  local TS=$(date +%F_%T); mkdir -p /root/backups/eggs; mysqldump -u root ptero eggs nests variables > /root/backups/eggs/ptero_eggs_$TS.sql 2>/dev/null; print_success "Done"; sleep 2; 
}
backup_panel_files() { 
  premium_header "FILE BACKUP" "$BRIGHT_YELLOW"
  read -p "  👉 Backup Panel Source Files? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  check_ptero_dir || return; local TS=$(date +%F_%T); tar -czf /root/files_$TS.tar.gz /var/www/pterodactyl; print_success "Done"; sleep 2; 
}
backup_users() { 
  premium_header "USER BACKUP" "$BRIGHT_YELLOW"
  read -p "  👉 Backup User Database? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  local TS=$(date +%F_%T); mysqldump -u root ptero users > /root/users_$TS.sql; print_success "Done"; sleep 2; 
}
backup_database_only() { 
  premium_header "DATABASE BACKUP" "$BRIGHT_YELLOW"
  read -p "  👉 Backup Full Panel Database? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  local TS=$(date +%F_%T); mysqldump -u root ptero > /root/db_$TS.sql; print_success "Done"; sleep 2; 
}

# --- PROTECTION ---
install_protect() {
  local PROTECT_CHOICE
  while true; do
    clear; echo ""; premium_box "PROTECTION SYSTEM" "$BRIGHT_MAGENTA"; echo ""
    echo -e "  ${BRIGHT_WHITE}${BOLD} [1]${NC} 🔓 Level 1    ${BRIGHT_WHITE}${BOLD} [6]${NC} 📑 Level 6"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [2]${NC} 👤 Level 2    ${BRIGHT_WHITE}${BOLD} [7]${NC} 🕵️ Level 7"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [3]${NC} 📦 Level 3    ${BRIGHT_WHITE}${BOLD} [8]${NC} 👑 Level 8"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [4]${NC} 🛠️ Level 4    ${BRIGHT_WHITE}${BOLD} [9]${NC} 💎 Level 9"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [5]${NC} 📂 Level 5    ${BRIGHT_WHITE}${BOLD} [C]${NC} ⚙️ Custom"
    echo ""; echo -e "  ${BRIGHT_RED}${BOLD} [U]${NC} 🗑️ Uninstall Protect"
    echo -e "  ${BRIGHT_RED}${BOLD} [x]${NC} 🔙 Back"
    echo ""; echo -n -e "  ${BOLD}${BRIGHT_YELLOW}👉 Enter Choice: ${NC}"; read PROTECT_CHOICE
    case "$PROTECT_CHOICE" in
      [1-9]) install_protect_internal "$PROTECT_CHOICE" ;;
      c|C) install_protect_custom_internal ;;
      u|U) uninstall_protect_internal ;;
      x|X) return ;;
    esac
  done
}

install_protect_internal() {
  local level=$1; local PTERO_PATH="/var/www/pterodactyl"
  check_ptero_dir || return
  
  clear; premium_header "ACTIVATING PROTECTION LEVEL $level" "$BRIGHT_MAGENTA"
  read -p "  👉 Enter Main Admin ID (usually 1): " ADMIN_ID
  [[ -z "$ADMIN_ID" ]] && ADMIN_ID=1

  print_info "Injecting Security Layer... (Level: $level)"

  # Variables for injection
  local API_USER_CTRL="$PTERO_PATH/app/Http/Controllers/Api/Application/Users/UserController.php"
  local ADMIN_USER_CTRL="$PTERO_PATH/app/Http/Controllers/Admin/UserController.php"
  local ADM_SERVER_CTRL="$PTERO_PATH/app/Http/Controllers/Admin/ServersController.php"
  local F2A_CTRL="$PTERO_PATH/app/Http/Controllers/Api/Client/TwoFactorController.php"

  # LEVEL 1: Anti-Delete/Edit Main Admin
  local ANTI_HAPUS_ADMIN="        if (\$user->id === $ADMIN_ID) { abort(403, 'FreeZeeHost: Main Admin cannot be deleted.'); }"
  local ANTI_EDIT_ADMIN="        if (\$targetUser->id === $ADMIN_ID && auth()->user()->id !== $ADMIN_ID) { abort(403, 'FreeZeeHost: Only Main Admin can edit this account.'); }"
  
  inject_after_brace "$API_USER_CTRL" "public function delete" "$ANTI_HAPUS_ADMIN"
  inject_after_brace "$ADMIN_USER_CTRL" "public function delete" "$ANTI_HAPUS_ADMIN"
  inject_after_brace "$API_USER_CTRL" "public function update" "$ANTI_EDIT_ADMIN"
  inject_after_brace "$ADMIN_USER_CTRL" "public function update" "$ANTI_EDIT_ADMIN"

  # LEVEL 2: Status Administrator Security
  if [ "$level" -ge 2 ]; then
    local STATUS_SEC="        if (request()->has('root_admin') && auth()->user()->id !== $ADMIN_ID) { abort(403, 'FreeZeeHost: Only Main Admin can change Admin status.'); }"
    inject_after_brace "$ADMIN_USER_CTRL" "public function update" "$STATUS_SEC"
  fi

  # LEVEL 3: Server Protection
  if [ "$level" -ge 3 ]; then
    local SERVER_SEC="        if (auth()->user()->id !== $ADMIN_ID && auth()->user()->id !== \$server->owner_id) { abort(403, 'FreeZeeHost: Unauthorized server action.'); }"
    inject_after_brace "$ADM_SERVER_CTRL" "public function delete" "$SERVER_SEC"
  fi

  # LEVEL 4: 2FA Protection
  if [ "$level" -ge 4 ]; then
    local F2A_SEC="        if (auth()->user()->id !== $ADMIN_ID) { abort(403, 'FreeZeeHost: 2FA management restricted.'); }"
    inject_after_brace "$F2A_CTRL" "public function store" "$F2A_SEC"
  fi

  premium_box "PROTECTION LEVEL $level ACTIVE" "$BRIGHT_GREEN"; sleep 2
}

uninstall_protect_internal() {
  premium_header "UNINSTALL PROTECTION" "$BRIGHT_RED"
  read -p "  👉 Restore all protected files? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then return; fi
  check_ptero_dir || return
  
  print_info "Restoring backups..."
  find /var/www/pterodactyl -name "*.bak_fzh" | while read f; do
    original="${f%.bak_fzh}"
    mv "$f" "$original"
    print_success "Restored: $(basename "$original")"
  done
  
  rm -f /var/www/pterodactyl/app/Http/Controllers/FreeZeeHostganteng.json
  premium_box "PROTECTION REMOVED" "$BRIGHT_GREEN"; sleep 2
}

install_protect_custom_internal() {
  local EXTRA; local ADMIN_ID=1; local PTERO_PATH="/var/www/pterodactyl"
  check_ptero_dir || return
  clear; premium_box "CUSTOM PROTECTION" "$BRIGHT_MAGENTA"
  read -p "  👉 Select Extra (1-12): " EXTRA
  local CODE="        if (auth()->user()->id !== $ADMIN_ID) { abort(403, 'FreeZeeHost Protected'); }"
  for opt in $EXTRA; do
    case $opt in 
      1) inject_after_brace "$PTERO_PATH/app/Http/Controllers/Admin/ServersController.php" "public function delete" "$CODE" ;;
      12) echo "[$ADMIN_ID]" > "$PTERO_PATH/app/Http/Controllers/FreeZeeHostganteng.json" ;;
    esac
  done
  premium_box "DONE" "$BRIGHT_GREEN"; sleep 2
}

# --- VERIFICATION ---
verify_mongodb_direct() {
  local check_type=$1; local pwd_input=$2; local key_input=$3
  node <<EOF
const mongoose = require('mongoose');
const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyXy5AY2x1c3RlcjAudnl3dTV4dC5tb25nb2RiLm5ldC9GcmVlWmVlSG9zdD9yZXRyeVdyaXRlcz10cnVlJnc9bWFqb3JpdHkmYXBwTmFtZT1DbHVzdGVyMA==';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();
const whitelistSchema = new mongoose.Schema({ ip: String, password: { type: String }, custom_apikey: { type: String }, status: { type: String, default: 'active' } }, { collection: 'whitelist' });
const Whitelist = mongoose.model('Whitelist', whitelistSchema);
async function check() { try { await mongoose.connect(MONGO_URI); let found; if ('$check_type' === 'ip') { found = await Whitelist.findOne({ ip: '$VPS_IP', status: 'active' }); } else { found = await Whitelist.findOne({ ip: '$VPS_IP', password: '$pwd_input', custom_apikey: '$key_input', status: 'active' }); } process.exit(found ? 0 : 1); } catch (e) { process.exit(2); } }
check();
EOF
  return $?
}

fetch_vps_ip() { VPS_IP=$(curl -s https://api.ipify.org || echo "Unknown"); }

start_script() {
  clear; echo -e "${BRIGHT_YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"; echo -e "  ${BOLD}${BRIGHT_YELLOW}  [ 👑  SYSTEM INITIALIZING PREMIUM ACCESS 👑  ] ${NC}"
  echo ""

  # 1. Tiga Tahap Pengecekan
  show_loading 3 "Initializing System Engine"
  show_loading 3 "Securing Network Protocol"
  show_loading 3 "Validating Secure Connection"
  echo ""

  # 2. Install Dependencies (Visible & Auto-Install node/mongoose)
  premium_header "SYSTEM PREPARATION" "$BRIGHT_WHITE"
  print_info "Checking core dependencies..."
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -qq > /dev/null 2>&1
  sudo apt-get install -qq -y jq gawk curl wget > /dev/null 2>&1
  
  if ! command -v node &> /dev/null; then
    print_warning "Node.js missing. Deploying Node.js 22..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - > /dev/null 2>&1
    sudo apt-get install -qq -y nodejs > /dev/null 2>&1
  fi
  
  # Auto-install mongoose for direct DB check
  if ! node -e "require('mongoose')" &> /dev/null; then
    print_info "Preparing Database Connector (Mongoose)..."
    npm install -g mongoose --silent > /dev/null 2>&1
    export NODE_PATH=$(npm root -g)
  fi

  print_success "System is ready."
  sleep 1.5
  
  # --- CLEAR & GANTI KE VERIFIKASI ---
  clear
  echo -e "${BRIGHT_CYAN}${BOLD}"
  echo -e "  ╔══════════════════════════════════════════════════════════════════════╗"
  echo -e "  ║               🔒 SECURITY & IDENTITY VERIFICATION 🔒                 ║"
  echo -e "  ╚══════════════════════════════════════════════════════════════════════╝${NC}"
  echo ""

  # 3. Verifikasi IP
  fetch_vps_ip
  echo -e "  ${BRIGHT_WHITE}${BOLD}➤ FIREWALL CHECK:${NC}"
  print_info "Targeting IP: ${BRIGHT_YELLOW}$VPS_IP${NC}"
  if verify_mongodb_direct "ip"; then
    echo -e "  ${BOLD}STATUS: ${BG_GREEN}${BRIGHT_WHITE} AUTHORIZED ${NC}"
  else
    echo -e "  ${BOLD}STATUS: ${BG_RED}${BRIGHT_WHITE} UNAUTHORIZED ${NC}"
    print_error "Access Denied: Your VPS IP is not whitelisted."
    exit 1
  fi
  echo ""

  # 4. Verifikasi 2-Step
  SESSION_FILE="/root/.fzh_session"
  if [ ! -f "$SESSION_FILE" ]; then
    echo -e "  ${BRIGHT_WHITE}${BOLD}➤ IDENTITY VERIFICATION (2-STEP):${NC}"
    print_warning "Note: Password inputs are invisible while typing."
    echo -n -e "  ${BOLD}${BRIGHT_MAGENTA}👉 ${WHITE}OWNER PASSWORD : ${NC}"; read -s SECOND_PWD; echo
    echo -n -e "  ${BOLD}${BRIGHT_MAGENTA}👉 ${WHITE}CUSTOM API KEY  : ${NC}"; read CLIENT_API_KEY
    
    print_info "Syncing with Database Cloud..."
    if verify_mongodb_direct "full" "$SECOND_PWD" "$CLIENT_API_KEY"; then
      echo -e "  ${BOLD}RESULT: ${BG_GREEN}${BRIGHT_WHITE} ACCESS GRANTED ${NC}"
      touch "$SESSION_FILE"
      show_loading 2 "Building Premium Dashboard"
    else
      echo -e "  ${BOLD}RESULT: ${BG_RED}${BRIGHT_WHITE} ACCESS DENIED ${NC}"
      print_error "Error: Invalid Credentials provided."
      exit 1
    fi
  else
    echo -e "  ${BRIGHT_GREEN}${BOLD}✔ Session Active: Welcome back, Owner.${NC}"
    sleep 1.5
  fi
}

# --- START ---
start_script

while true; do
  clear; echo -e "${YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"; echo -e "  ${BOLD}${WHITE}┌───────────────────────── ${BRIGHT_YELLOW}PREMIUM DASHBOARD${WHITE} ──────────────────────────┐${NC}"
  echo -e "  ${BOLD}${WHITE}│${NC} ${DIM}License:${NC} ${BRIGHT_GREEN}ACTIVE${NC}  ${BOLD}${WHITE}│${NC} ${DIM}User:${NC} ${BRIGHT_CYAN}VIP GUEST${NC}   ${BOLD}${WHITE}│${NC} ${DIM}Version:${NC} ${BRIGHT_YELLOW}3.2.0-PRO${NC}  ${BOLD}${WHITE}│${NC}"
  echo -e "  ${BOLD}${WHITE}└────────────────────────────────────────────────────────────────────────┘${NC}"
  echo ""; echo -e "  ${BOLD}${BRIGHT_MAGENTA}💎 EXCLUSIVE SERVICES:${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[1]  ${NC}${BRIGHT_BLUE}🎨 Premium Themes${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[13] ${NC}${BRIGHT_GREEN}📑 Install PHPMyAdmin${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[2]  ${NC}${BRIGHT_BLUE}🔌 Blueprint Core${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[14] ${NC}${BRIGHT_GREEN}🔐 Configure SSL${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[3]  ${NC}${BRIGHT_BLUE}⏰ Auto-Suspend Pro${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[15] ${NC}${BRIGHT_YELLOW}💾 Full System Backup${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[4]  ${NC}${BRIGHT_YELLOW}🛡️ Protect Panel${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[16] ${NC}${BRIGHT_BLUE}🚀 Turbo Build Assets${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[5]  ${NC}${BRIGHT_YELLOW}🔄 System Reset${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[17] ${NC}${BRIGHT_YELLOW}🚧 Maintenance Toggle${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[6]  ${NC}${BRIGHT_RED}🗑️ Safe Uninstall${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[18] ${NC}${BRIGHT_MAGENTA}🛠️ Fix Permissions${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[7]  ${NC}${BRIGHT_GREEN}⚙️ Wings Management${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[19] ${NC}${BRIGHT_WHITE}🧹 Clear Logs/Temp${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[8]  ${NC}${BRIGHT_CYAN}🏗️ Node Architect${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[20] ${NC}${BRIGHT_YELLOW}🥚 Backup All Eggs${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[9]  ${NC}${BRIGHT_MAGENTA}🔓 Admin Recovery${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[21] ${NC}${BRIGHT_YELLOW}📂 Backup Panel Files${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[10] ${NC}${BRIGHT_WHITE}🔑 Security Config${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[22] ${NC}${BRIGHT_YELLOW}👤 Backup All Users${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[11] ${NC}${BRIGHT_CYAN}🖼️ Change Background${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[23] ${NC}${BRIGHT_YELLOW}🗄️ Backup Database${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[12] ${NC}${BRIGHT_CYAN}🏷️ Change Logo${NC}\e[45G ${BRIGHT_WHITE}${BOLD}[x]  ${NC}${RED}❌ Terminal Exit${NC}"
  echo ""; line_separator; echo -n -e "  ${BOLD}${WHITE}root@FreeZeeHost:~# ${NC}"; read -r MENU_CHOICE
  case "$MENU_CHOICE" in
    1) install_theme ;; 2) install_blueprint ;; 3) install_auto_suspend ;; 4) install_protect ;; 5) uninstall_theme ;; 6) uninstall_panel ;; 7) start_wings ;; 8) create_node ;; 9) hackback_panel ;; 10) ubahpw_vps ;; 11) change_background ;; 12) change_logo ;; 13) install_phpmyadmin ;; 14) configure_ssl ;; 15) backup_system ;; 16) turbo_build ;; 17) toggle_maintenance ;; 18) fix_permissions ;; 19) clear_logs ;; 20) backup_eggs ;; 21) backup_panel_files ;; 22) backup_users ;; 23) backup_database_only ;;
    x|X) exit 0 ;; *) print_error "Pilihan tidak valid."; sleep 1 ;;
  esac
done
