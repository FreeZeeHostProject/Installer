#!/bin/bash

# ============================================================
#               FREEZEEHOST THEME INSTALLER
# ============================================================
# Version: 4.2.0-PRO (EXOTIC EDITION)
# (c) 2026 FreeZeeHost Official. All Rights Reserved.
# ============================================================

# --- COLORS & STYLE ---
NC='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
BRIGHT_RED='\033[91m'; BRIGHT_GREEN='\033[92m'; BRIGHT_YELLOW='\033[93m'
BRIGHT_BLUE='\033[94m'; BRIGHT_MAGENTA='\033[95m'; BRIGHT_CYAN='\033[96m'; BRIGHT_WHITE='\033[97m'
BG_GREEN='\033[42m'; BG_RED='\033[41m'

# --- UI HELPERS ---
print_info() { echo -e "  ${BRIGHT_CYAN}${BOLD}💠 INFO${NC} ${WHITE}│ $1${NC}"; }
print_success() { echo -e "  ${BRIGHT_GREEN}${BOLD}✅ SUCCESS${NC} ${WHITE}│ $1${NC}"; }
print_warning() { echo -e "  ${BRIGHT_YELLOW}${BOLD}⚠️ WARNING${NC} ${WHITE}│ $1${NC}"; }
print_error() { echo -e "  ${BRIGHT_RED}${BOLD}❌ ERROR${NC} ${WHITE}│ $1${NC}"; }

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
  echo -ne "  ${BOLD}${WHITE}⏳  $2 ... ${NC}"
  sleep 0.5
  echo -e "${BRIGHT_GREEN}DONE!${NC}"
}

line_separator() { echo -e "  ${DIM}${WHITE}──────────────────────────────────────────────────────────────────────────${NC}"; }

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

# --- SYSTEM CORE ---
check_ptero_dir() {
  if [ ! -d "/var/www/pterodactyl" ]; then
    premium_header "CRITICAL ERROR" "$BRIGHT_RED"
    print_error "Pterodactyl directory not found!"; sleep 2; return 1
  fi
  return 0
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
  echo -e "${NC}"; echo -e "    [ 👑  SYSTEM INITIALIZING PREMIUM ACCESS 👑  ] "
  echo ""
  
  show_loading 0 "Checking System Resources"
  show_loading 0 "Checking Network Protocol"
  show_loading 0 "Checking Secure Connection"
  
  print_info "Installing core dependencies (jq, gawk, nodejs, mongoose)..."
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -qq > /dev/null 2>&1
  sudo apt-get install -qq -y jq gawk curl wget nodejs npm > /dev/null 2>&1
  if ! node -e "require('mongoose')" &>/dev/null; then sudo npm install -g mongoose --silent > /dev/null 2>&1; fi
  print_success "Dependencies installed successfully."
  
  sleep 1.5; clear
  
  # --- VERIFICATION PHASE ---
  premium_header "SYSTEM FIREWALL - IP VERIFICATION" "$BRIGHT_CYAN"
  VPS_IP=$(curl -s https://api.ipify.org || echo "Unknown")
  print_info "Verifying IP: ${BRIGHT_YELLOW}$VPS_IP${NC}"
  
  if verify_mongodb_direct "ip"; then
    print_success "IP AUTHORIZED"; sleep 1
  else
    print_error "IP UNAUTHORIZED"; exit 1
  fi

  SESSION_FILE="/root/.fzh_session"
  if [ ! -f "$SESSION_FILE" ]; then
    premium_header "IDENTITY VERIFICATION REQUIRED" "$BRIGHT_MAGENTA"
    print_warning "Password entries are hidden (invisible) while typing."
    echo -n -e "  ${BOLD}${BRIGHT_WHITE}👉 OWNER PASSWORD : ${NC}"; read -s SECOND_PWD; echo
    echo -n -e "  ${BOLD}${BRIGHT_WHITE}👉 CUSTOM API KEY  : ${NC}"; read CLIENT_API_KEY
    
    print_info "Verifying credentials..."
    if verify_mongodb_direct "full" "$SECOND_PWD" "$CLIENT_API_KEY" > /dev/null; then
      print_success "Access Granted!"; touch "$SESSION_FILE"; sleep 1
    else
      print_error "Access Denied!"; exit 1
    fi
  else
    print_success "Session Active."; sleep 1
  fi
}

# --- SERVICE FUNCTIONS ---
install_blueprint() {
  premium_header "BLUEPRINT FRAMEWORK" "$BRIGHT_BLUE"
  read -p "  👉 Install Blueprint Core? (y/n): " confirm
  [[ "$confirm" != "y" ]] && return
  check_ptero_dir || return 1
  print_info "Downloading framework..."
  cd /var/www/pterodactyl
  DOWNLOAD_URL=$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | grep 'release.zip' | cut -d '"' -f 4)
  wget -q "$DOWNLOAD_URL" -O b.zip && unzip -oq b.zip && rm b.zip
  sudo npm i -g yarn && yarn install && yarn add cross-env
  chmod +x blueprint.sh && yes | sudo bash blueprint.sh
  premium_box "BLUEPRINT READY" "$BRIGHT_GREEN"; sleep 2
}

install_auto_suspend() {
  premium_header "AUTO-SUSPEND PRO" "$BRIGHT_BLUE"
  read -p "  👉 Activate? (y/n): " confirm
  [[ "$confirm" != "y" ]] && return
  check_ptero_dir || return 1
  cd /var/www/pterodactyl
  sed -i "/use Ramsey\\\\Uuid\\\\Uuid;/a use Pterodactyl\\\\Models\\\\Server;" app/Console/Kernel.php
  php artisan migrate --force && php artisan optimize:clear
  premium_box "DONE" "$BRIGHT_GREEN"; sleep 2
}

# --- THEME FUNCTIONS ---
install_theme() {
  local SELECT_THEME; local THEME_NAME; local THEME_URL
  while true; do
    clear; echo ""; premium_box "SELECT PREMIUM THEME" "$BRIGHT_CYAN"; echo ""
    echo -e "  ${BRIGHT_WHITE}${BOLD}[1]🌌 Stellar   [2]💳 Billing   [3]🧩 Enigma   [4]🌈 Elysium"
    echo -e "  [5]❄️ Frostcore [6]🌃 Nightcore [7]🧱 Ice      [8]👶 Noobe"
    echo -e "  [9]🔥 Arix      [10]🐦 Nookure  [R]🔄 Reset    [X]🔙 Back"
    echo ""; echo -n -e "  ${BOLD}${BRIGHT_YELLOW}👉 Choice: ${NC}"; read SELECT_THEME
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
  TEMP_DIR=$(mktemp -d); trap 'rm -rf -- "$TEMP_DIR"' EXIT; cd "$TEMP_DIR"
  wget -q "$THEME_URL" && unzip -oq *.zip
  sudo cp -rfT pterodactyl /var/www/pterodactyl && cd /var/www/pterodactyl
  php artisan migrate --force && yarn install && yarn build:production
  premium_box "$THEME_NAME READY" "$BRIGHT_GREEN"; sleep 2
}

# --- MAIN LOOP ---
start_script
while true; do
  clear; echo -e "${BRIGHT_YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"
  echo -e "  ${BOLD}${WHITE}┌───────────────────────── ${BRIGHT_YELLOW}PREMIUM DASHBOARD${WHITE} ──────────────────────────┐${NC}"
  echo -e "  ${BOLD}${WHITE}│${NC} ${DIM}License:${NC} ${BRIGHT_GREEN}ACTIVE${NC}  ${BOLD}${WHITE}│${NC} ${DIM}User:${NC} ${BRIGHT_CYAN}VIP GUEST${NC}   ${BOLD}${WHITE}│${NC} ${DIM}Version:${NC} ${BRIGHT_YELLOW}4.2.0-PRO${NC}  ${BOLD}${WHITE}│${NC}"
  echo -e "  ${BOLD}${WHITE}└────────────────────────────────────────────────────────────────────────┘${NC}"
  echo -e "\n  ${BOLD}${BRIGHT_MAGENTA}💎 EXCLUSIVE SERVICES:${NC}"
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
  echo ""; echo -n -e "  ${BOLD}${WHITE}root@FreeZeeHost:~# ${NC}"; read -r MENU_CHOICE
  case "$MENU_CHOICE" in
    1) install_theme ;; 2) install_blueprint ;; 3) install_auto_suspend ;; 5) uninstall_theme ;; 
    7) # wings
    ;; 8) create_node ;; 9) # recover
    ;; 10) ubahpw_vps ;; 11) # bg
    ;; 12) # logo
    ;; 13) # pma
    ;; 14) # ssl
    ;; 15) # backup
    ;; 16) # turbo
    ;; 17) # maintenance
    ;; 18) # fix
    ;; 19) # logs
    ;; 20) # eggs
    ;; 21) # files
    ;; 22) # users
    ;; 23) # db
    ;; x|X) exit 0 ;; *) sleep 1 ;;
  esac
done
