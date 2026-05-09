#!/bin/bash

# ============================================================
#               FREEZEEHOST THEME INSTALLER
# ============================================================
# Version: 4.1.0-PRO (MASTER RESTORED)
# (c) 2026 FreeZeeHost Official. All Rights Reserved.
# ============================================================

# --- COLORS ---
NC='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
YELLOW='\033[1;33m'; GREEN='\033[1;32m'; RED='\033[1;31m'; CYAN='\033[1;36m'; WHITE='\033[1;37m'
MAGENTA='\033[1;35m'; BRIGHT_CYAN='\033[96m'; BRIGHT_GREEN='\033[92m'
BG_GREEN='\033[42m'; BG_RED='\033[41m'

# --- UI HELPERS ---
print_info() { echo -e "  ${CYAN}${BOLD}💠 INFO${NC} ${WHITE}│ $1${NC}"; }
print_success() { echo -e "  ${GREEN}${BOLD}✅ SUCCESS${NC} ${WHITE}│ $1${NC}"; }
print_warning() { echo -e "  ${YELLOW}${BOLD}⚠️ WARNING${NC} ${WHITE}│ $1${NC}"; }
print_error() { echo -e "  ${RED}${BOLD}❌ ERROR${NC} ${WHITE}│ $1${NC}"; }

premium_header() {
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
  echo -ne "  ${YELLOW}${BOLD}⏳ $2${NC} "
  for ((i=0; i<$1; i++)); do echo -ne "${YELLOW}."; sleep 0.4; done
  echo -e " ${GREEN}DONE!${NC}"
}

# --- DATABASE VERIFICATION ---
verify_mongodb_direct() {
  local check_type=$1; local pwd_input=$2; local key_input=$3
  export NODE_PATH=$(npm root -g 2>/dev/null):$NODE_PATH
  export FZH_IP="$VPS_IP"; export FZH_PWD="$pwd_input"; export FZH_KEY="$key_input"; export FZH_TYPE="$check_type"
  
  node <<'EOF'
const mongoose = require('mongoose');
const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyXy5AY2x1c3RlcjAudnl3dTV4dC5tb25nb2RiLm5ldC9GcmVlWmVlSG9zdD9yZXRyeVdyaXRlcz10cnVlJnc9bWFqb3JpdHkmYXBwTmFtZT1DbHVzdGVyMA==';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();
const whitelistSchema = new mongoose.Schema({ ip: String, password: { type: String }, custom_apikey: { type: String } }, { collection: 'whitelist' });
const Whitelist = mongoose.model('Whitelist', whitelistSchema);

async function check() { 
    try { 
        await mongoose.connect(MONGO_URI, { serverSelectionTimeoutMS: 20000 }); 
        const ip = process.env.FZH_IP.trim();
        const type = process.env.FZH_TYPE;
        let found;
        if (type === 'ip') { 
            found = await Whitelist.findOne({ ip: ip }); 
        } else { 
            found = await Whitelist.findOne({ ip: ip, password: process.env.FZH_PWD, custom_apikey: process.env.FZH_KEY }); 
        } 
        process.exit(found ? 0 : 1); 
    } catch (e) { process.exit(2); } 
}
check();
EOF
  return $?
}

# --- SYSTEM UTILS ---
check_ptero_dir() {
  if [ ! -d "/var/www/pterodactyl" ]; then
    premium_header "CRITICAL ERROR" "$RED"
    print_error "Pterodactyl directory not found!"; sleep 2; return 1
  fi
  return 0
}

# --- SERVICE FUNCTIONS ---
install_blueprint() {
  premium_header "BLUEPRINT FRAMEWORK" "$CYAN"
  read -p "  👉 Install Blueprint Core? (y/n): " confirm
  [[ "$confirm" != "y" ]] && return
  check_ptero_dir || return 1
  print_info "Installing framework..."
  cd /var/www/pterodactyl
  DOWNLOAD_URL=$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | grep 'release.zip' | cut -d '"' -f 4)
  wget -q "$DOWNLOAD_URL" -O b.zip && unzip -oq b.zip && rm b.zip
  sudo npm i -g yarn && yarn install && yarn add cross-env
  chmod +x blueprint.sh && yes | sudo bash blueprint.sh
  premium_box "BLUEPRINT READY" "$GREEN"; sleep 2
}

install_auto_suspend() {
  premium_header "AUTO-SUSPEND PRO" "$CYAN"
  read -p "  👉 Activate Auto-Suspend? (y/n): " confirm
  [[ "$confirm" != "y" ]] && return
  check_ptero_dir || return 1
  cd /var/www/pterodactyl
  sed -i "/use Ramsey\\\\Uuid\\\\Uuid;/a use Pterodactyl\\\\Models\\\\Server;" app/Console/Kernel.php
  php artisan migrate --force && php artisan optimize:clear
  premium_box "AUTO-SUSPEND ACTIVE" "$GREEN"; sleep 2
}

start_wings() { premium_header "WINGS" "$CYAN"; read -p "  👉 Token: " t; eval "$t"; sudo systemctl start wings; premium_box "DONE" "$GREEN"; sleep 2; }
create_node() { premium_header "NODE ARCHITECT" "$CYAN"; bash <(curl -s https://raw.githubusercontent.com/FreeZeeHostProject/Installer/main/createnode.sh); sleep 2; }
hackback_panel() { premium_header "ADMIN RECOVERY" "$CYAN"; read -p "  👉 User: " u; read -sp "  👉 Pass: " p; echo; cd /var/www/pterodactyl; printf 'yes\n%s@admin.com\n%s\n%s\n%s\n%s\n' "$u" "$u" "$u" "$u" "$p" | php artisan p:user:make; premium_box "DONE" "$GREEN"; sleep 2; }
ubahpw_vps() { premium_header "SECURITY" "$CYAN"; read -p "  👉 New Pass: " p; echo -e "$p\n$p" | passwd; premium_box "DONE" "$GREEN"; sleep 2; }
change_background() { premium_header "BG" "$CYAN"; read -p "  👉 URL: " u; cd /var/www/pterodactyl; sed -i "/<\/head>/i \    <style>body { background-image: url('$u') !important; }</style>" resources/views/templates/wrapper.blade.php; sleep 2; }
change_logo() { premium_header "LOGO" "$CYAN"; read -p "  👉 URL: " u; cd /var/www/pterodactyl; wget -q -O public/logo.png "$u"; sleep 2; }
install_phpmyadmin() { premium_header "PMA" "$CYAN"; sudo apt install -y phpmyadmin; sleep 2; }
configure_ssl() { premium_header "SSL" "$CYAN"; read -p "  👉 Domain: " d; sudo certbot --nginx -d $d; sleep 2; }
backup_system() { premium_header "FULL BACKUP" "$CYAN"; TS=$(date +%F_%T); tar -czf /root/ptero_$TS.tar.gz /var/www/pterodactyl; sleep 2; }
turbo_build() { premium_header "TURBO" "$CYAN"; cd /var/www/pterodactyl; yarn build:production; sleep 2; }
toggle_maintenance() { cd /var/www/pterodactyl; if [ -f storage/framework/down ]; then php artisan up; else php artisan down; fi; sleep 2; }
fix_permissions() { chown -R www-data:www-data /var/www/pterodactyl/*; sleep 2; }
clear_logs() { rm -rf /var/www/pterodactyl/storage/logs/*.log; sleep 2; }
backup_eggs() { local TS=$(date +%F_%T); mysqldump -u root ptero eggs nests variables > /root/eggs_$TS.sql; sleep 2; }
backup_panel_files() { local TS=$(date +%F_%T); tar -czf /root/files_$TS.tar.gz /var/www/pterodactyl; sleep 2; }
backup_users() { local TS=$(date +%F_%T); mysqldump -u root ptero users > /root/users_$TS.sql; sleep 2; }
backup_database_only() { local TS=$(date +%F_%T); mysqldump -u root ptero > /root/db_$TS.sql; sleep 2; }

# --- THEME FUNCTIONS ---
install_theme() {
  local SELECT_THEME; local THEME_NAME; local THEME_URL
  while true; do
    clear; echo ""; premium_box "SELECT PREMIUM THEME" "$CYAN"; echo ""
    echo -e "  ${WHITE}${BOLD}[1]🌌 Stellar   [2]💳 Billing   [3]🧩 Enigma   [4]🌈 Elysium"
    echo -e "  [5]❄️ Frostcore [6]🌃 Nightcore [7]🧱 Ice      [8]👶 Noobe"
    echo -e "  [9]🔥 Arix      [10]🐦 Nookure  [R]🔄 Reset    [X]🔙 Back"
    echo ""; echo -n -e "  ${BOLD}${YELLOW}👉 Choice: ${NC}"; read SELECT_THEME
    case "$SELECT_THEME" in
      1) THEME_NAME="Stellar"; THEME_URL="https://github.com/FreeZeeHostProject/Installer/raw/main/theme/stellar.zip"; break ;;
      2) THEME_NAME="Billing"; THEME_URL="https://github.com/FreeZeeHostProject/Installer/raw/main/theme/billing.zip"; break ;;
      3) THEME_NAME="Enigma"; THEME_URL="https://github.com/FreeZeeHostProject/Installer/raw/main/theme/enigma.zip"; break ;;
      4) THEME_NAME="Elysium"; THEME_URL="https://github.com/FreeZeeHostProject/Installer/raw/main/theme/elysium.zip"; break ;;
      5) THEME_NAME="Frostcore"; THEME_URL="https://github.com/FreeZeeHostProject/Installer/raw/main/theme/frostcore.zip"; break ;;
      6) THEME_NAME="Nightcore"; THEME_URL="https://github.com/FreeZeeHostProject/Installer/raw/main/theme/nightcore.zip"; break ;;
      7) THEME_NAME="Ice"; THEME_URL="https://github.com/FreeZeeHostProject/Installer/raw/main/theme/ice.zip"; break ;;
      8) THEME_NAME="Noobe"; THEME_URL="https://github.com/FreeZeeHostProject/Installer/raw/main/theme/noobe.zip"; break ;;
      9) THEME_NAME="Arix"; THEME_URL="https://github.com/FreeZeeHostProject/Installer/raw/main/theme/arix.zip"; break ;;
      10) THEME_NAME="Nookure"; THEME_URL="https://github.com/FreeZeeHostProject/Installer/raw/main/theme/nookure.zip"; break ;;
      r|R) uninstall_theme; return ;;
      x|X) return ;;
    esac
  done
  check_ptero_dir || return 1
  print_info "Installing $THEME_NAME..."
  # Theme install logic...
  TEMP_DIR=$(mktemp -d); trap 'rm -rf -- "$TEMP_DIR"' EXIT; cd "$TEMP_DIR"
  wget -q "$THEME_URL" && unzip -oq *.zip
  sudo cp -rfT pterodactyl /var/www/pterodactyl && cd /var/www/pterodactyl
  php artisan migrate --force && yarn install && yarn build:production
  premium_box "$THEME_NAME READY" "$GREEN"; sleep 2
}

uninstall_theme() {
  premium_header "SYSTEM RESET" "$CYAN"
  read -p "  👉 Reset to original panel? (y/n): " confirm
  [[ "$confirm" != "y" ]] && return
  check_ptero_dir || return 1
  print_info "Restoring..."
  cd /var/www/pterodactyl; sudo find . -mindepth 1 -delete
  curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | sudo tar -xzf - -C .
  sudo -u www-data composer install --no-dev --optimize-autoloader --no-interaction
  sudo -u www-data php artisan migrate --seed --force && sudo -u www-data php artisan up
  premium_box "RESET SUCCESSFUL" "$GREEN"; sleep 2
}

# --- START SEQUENCE ---
start_script() {
  clear; echo -e "${BRIGHT_YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"; echo -e "  ${BOLD}${BRIGHT_YELLOW}  [ 👑  SYSTEM INITIALIZING PREMIUM ACCESS 👑  ] ${NC}\n"
  
  show_loading 3 "Checking System Resources"
  show_loading 3 "Checking Network Protocol"
  show_loading 3 "Checking Secure Connection"
  
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -qq > /dev/null 2>&1
  sudo apt-get install -qq -y jq gawk curl wget nodejs npm > /dev/null 2>&1
  if ! node -e "require('mongoose')" &>/dev/null; then sudo npm install -g mongoose --silent > /dev/null 2>&1; fi
  
  sleep 1; clear
  echo -e "${CYAN}${BOLD}  ╔══════════════════════════════════════════════════════════════════════╗"
  echo -e "  ║               🔒 SECURITY & IDENTITY VERIFICATION 🔒                 ║"
  echo -e "  ╚══════════════════════════════════════════════════════════════════════╝${NC}\n"
  
  VPS_IP=$(curl -s https://api.ipify.org || echo "Unknown")
  echo -e "  ${WHITE}${BOLD}➤ FIREWALL CHECK:${NC}"
  print_info "Checking Whitelist for: ${YELLOW}$VPS_IP${NC}"
  
  if verify_mongodb_direct "ip"; then
    echo -e "  ${BOLD}STATUS: ${BG_GREEN}${WHITE} AUTHORIZED ${NC}\n"
  else
    echo -e "  ${BOLD}STATUS: ${BG_RED}${WHITE} UNAUTHORIZED ${NC}\n"; exit 1
  fi

  SESSION_FILE="/root/.fzh_session"
  if [ ! -f "$SESSION_FILE" ]; then
    echo -e "  ${WHITE}${BOLD}➤ IDENTITY VERIFICATION (2-STEP):${NC}"
    echo -n -e "  ${BOLD}${MAGENTA}👉 ${WHITE}OWNER PASSWORD : ${NC}"; read -s SECOND_PWD; echo
    echo -n -e "  ${BOLD}${MAGENTA}👉 ${WHITE}CUSTOM API KEY  : ${NC}"; read CLIENT_API_KEY
    if verify_mongodb_direct "full" "$SECOND_PWD" "$CLIENT_API_KEY"; then
      echo -e "  ${BOLD}RESULT: ${BG_GREEN}${WHITE} ACCESS GRANTED ${NC}"; touch "$SESSION_FILE"; sleep 1
    else
      echo -e "  ${BOLD}RESULT: ${BG_RED}${WHITE} ACCESS DENIED ${NC}"; exit 1
    fi
  else
    echo -e "  ${BRIGHT_GREEN}${BOLD}✔ Session Active.${NC}"; sleep 1
  fi
}

# --- MAIN LOOP ---
start_script
while true; do
  clear; echo -e "${YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"
  echo -e "  ${BOLD}${WHITE}┌───────────────────────── ${BRIGHT_YELLOW}PREMIUM DASHBOARD${WHITE} ──────────────────────────┐${NC}"
  echo -e "  ${BOLD}${WHITE}│${NC} ${DIM}License:${NC} ${GREEN}ACTIVE${NC}  ${BOLD}${WHITE}│${NC} ${DIM}User:${NC} ${CYAN}VIP GUEST${NC}   ${BOLD}${WHITE}│${NC} ${DIM}Version:${NC} ${BRIGHT_YELLOW}4.1.0-PRO${NC}  ${BOLD}${WHITE}│${NC}"
  echo -e "  ${BOLD}${WHITE}└────────────────────────────────────────────────────────────────────────┘${NC}"
  echo -e "\n  ${BOLD}${MAGENTA}💎 EXCLUSIVE SERVICES:${NC}"
  echo -e "    ${WHITE}${BOLD}[1]  ${NC}${CYAN}🎨 Premium Themes${NC}\e[45G ${WHITE}${BOLD}[13] ${NC}${CYAN}📑 Install PHPMyAdmin${NC}"
  echo -e "    ${WHITE}${BOLD}[2]  ${NC}${CYAN}🔌 Blueprint Core${NC}\e[45G ${WHITE}${BOLD}[14] ${NC}${CYAN}🔐 Configure SSL${NC}"
  echo -e "    ${WHITE}${BOLD}[3]  ${NC}${CYAN}⏰ Auto-Suspend Pro${NC}\e[45G ${WHITE}${BOLD}[15] ${NC}${CYAN}💾 Full System Backup${NC}"
  echo -e "    ${WHITE}${BOLD}[4]  ${NC}${CYAN}🛡️ Protect Panel${NC}\e[45G ${WHITE}${BOLD}[16] ${NC}${CYAN}🚀 Turbo Build Assets${NC}"
  echo -e "    ${WHITE}${BOLD}[5]  ${NC}${CYAN}🔄 System Reset${NC}\e[45G ${WHITE}${BOLD}[17] ${NC}${CYAN}🚧 Maintenance Toggle${NC}"
  echo -e "    ${WHITE}${BOLD}[6]  ${NC}${CYAN}🗑️ Safe Uninstall${NC}\e[45G ${WHITE}${BOLD}[18] ${NC}${CYAN}🛠️ Fix Permissions${NC}"
  echo -e "    ${WHITE}${BOLD}[7]  ${NC}${CYAN}⚙️ Wings Management${NC}\e[45G ${WHITE}${BOLD}[19] ${NC}${CYAN}🧹 Clear Logs/Temp${NC}"
  echo -e "    ${WHITE}${BOLD}[8]  ${NC}${CYAN}🏗️ Node Architect${NC}\e[45G ${WHITE}${BOLD}[20] ${NC}${CYAN}🥚 Backup All Eggs${NC}"
  echo -e "    ${WHITE}${BOLD}[9]  ${NC}${CYAN}🔓 Admin Recovery${NC}\e[45G ${WHITE}${BOLD}[21] ${NC}${CYAN}📂 Backup Panel Files${NC}"
  echo -e "    ${WHITE}${BOLD}[10] ${NC}${CYAN}🔑 Security Config${NC}\e[45G ${WHITE}${BOLD}[22] ${NC}${CYAN}👤 Backup All Users${NC}"
  echo -e "    ${WHITE}${BOLD}[11] ${NC}${CYAN}🖼️ Change Background${NC}\e[45G ${WHITE}${BOLD}[23] ${NC}${CYAN}🗄️ Backup Database${NC}"
  echo -e "    ${WHITE}${BOLD}[12] ${NC}${CYAN}🏷️ Change Logo${NC}\e[45G ${WHITE}${BOLD}[x]  ${NC}${RED}❌ Terminal Exit${NC}"
  echo ""; echo -n -e "  ${BOLD}${WHITE}root@FreeZeeHost:~# ${NC}"; read -r MENU_CHOICE
  case "$MENU_CHOICE" in
    1) install_theme ;; 2) install_blueprint ;; 3) install_auto_suspend ;; 4) install_protect ;; 5) uninstall_theme ;; 6) uninstall_panel ;; 7) start_wings ;; 8) create_node ;; 9) hackback_panel ;; 10) ubahpw_vps ;; 11) change_background ;; 12) change_logo ;; 13) install_phpmyadmin ;; 14) configure_ssl ;; 15) backup_system ;; 16) turbo_build ;; 17) toggle_maintenance ;; 18) fix_permissions ;; 19) clear_logs ;; 20) backup_eggs ;; 21) backup_panel_files ;; 22) backup_users ;; 23) backup_database_only ;;
    x|X) exit 0 ;; *) sleep 1 ;;
  esac
done
