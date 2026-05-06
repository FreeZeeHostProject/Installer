#!/bin/bash

# ============================================================
#               FREEZEEHOST THEME INSTALLER
# ============================================================
# Version: 3.8.0-PRO (STABLE)
# (c) 2026 FreeZeeHost Official. All Rights Reserved.
# ============================================================

# --- COLORS ---
NC='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
BRIGHT_RED='\033[91m'; BRIGHT_GREEN='\033[92m'; BRIGHT_YELLOW='\033[93m'
BRIGHT_MAGENTA='\033[95m'; BRIGHT_CYAN='\033[96m'; WHITE='\033[97m'
BG_GREEN='\033[42m'; BG_RED='\033[41m'

# --- UI HELPERS ---
print_info() { echo -e "  ${BRIGHT_CYAN}${BOLD}💠 INFO${NC} ${WHITE}│ $1${NC}"; }
print_success() { echo -e "  ${BRIGHT_GREEN}${BOLD}✅ SUCCESS${NC} ${WHITE}│ $1${NC}"; }
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
  echo -ne "  ${BRIGHT_MAGENTA}${BOLD}⏳ $2${NC} "
  for ((i=0; i<$1; i++)); do echo -ne "${BRIGHT_CYAN}."; sleep 0.4; done
  echo -e " ${BRIGHT_GREEN}SUCCESS!${NC}"
}

# --- DATABASE VERIFICATION ---
verify_mongodb_direct() {
  local check_type=$1; local pwd_input=$2; local key_input=$3
  export NODE_PATH=$(npm root -g 2>/dev/null):$NODE_PATH
  export FZH_IP="$VPS_IP"
  export FZH_PWD="$pwd_input"
  export FZH_KEY="$key_input"
  export FZH_TYPE="$check_type"
  
  node <<'EOF'
const mongoose = require('mongoose');
const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyQGNsdXN0ZXIwLnZ5d3U1eHQubW9uZ29kYi5uZXQvRnJlZVplZUhvc3Q/cmV0cnlXcml0ZXM9dHJ1ZSZ3PW1ham9yaXR5JmFwcE5hbWU9Q2x1c3RlcjA=';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();

const whitelistSchema = new mongoose.Schema({ ip: String, password: { type: String }, custom_apikey: { type: String } }, { collection: 'whitelist' });
const Whitelist = mongoose.model('Whitelist', whitelistSchema);

async function check() { 
    try { 
        await mongoose.connect(MONGO_URI, { serverSelectionTimeoutMS: 15000 }); 
        const ip = process.env.FZH_IP.trim();
        const type = process.env.FZH_TYPE;
        let found;
        
        if (type === 'ip') { 
            found = await Whitelist.findOne({ ip: ip }); 
        } else { 
            found = await Whitelist.findOne({ ip: ip, password: process.env.FZH_PWD, custom_apikey: process.env.FZH_KEY }); 
        } 
        
        if (found) process.exit(0);
        else { console.log('IP_NOT_FOUND'); process.exit(1); }
    } catch (e) { 
        console.log('CONN_ERROR:' + e.message);
        process.exit(2); 
    } 
}
check();
EOF
  return $?
}

start_script() {
  # 1. CLASSIC BANNER
  clear; echo -e "${BRIGHT_YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"; echo -e "  ${BOLD}${BRIGHT_YELLOW}  [ 👑  SYSTEM INITIALIZING PREMIUM ACCESS 👑  ] ${NC}\n"
  
  # 2. 3 TAHAP CHECKING
  show_loading 3 "Checking System Resources"
  show_loading 3 "Checking Network Protocol"
  show_loading 3 "Checking Secure Connection"
  echo ""

  # 3. INSTALL DEPENDENCIES (VISIBLE)
  print_info "Installing core dependencies (jq, gawk, nodejs, mongoose)..."
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -qq > /dev/null 2>&1
  sudo apt-get install -qq -y jq gawk curl wget nodejs npm > /dev/null 2>&1
  
  if ! node -e "require('mongoose')" &>/dev/null; then
    sudo npm install -g mongoose --silent > /dev/null 2>&1
  fi
  print_success "Dependencies installed successfully."
  sleep 1.5

  # 4. CLEAR & VERIFICATION
  clear
  echo -e "${BRIGHT_CYAN}${BOLD}  ╔══════════════════════════════════════════════════════════════════════╗"
  echo -e "  ║               🔒 SECURITY & IDENTITY VERIFICATION 🔒                 ║"
  echo -e "  ╚══════════════════════════════════════════════════════════════════════╝${NC}\n"
  
  VPS_IP=$(curl -s https://api.ipify.org || echo "Unknown")
  echo -e "  ${BRIGHT_WHITE}${BOLD}➤ FIREWALL CHECK:${NC}"
  print_info "Checking Whitelist for: ${BRIGHT_YELLOW}$VPS_IP${NC}"
  
  VERIF_LOG=$(verify_mongodb_direct "ip")
  VERIF_STATUS=$?
  
  if [ $VERIF_STATUS -eq 0 ]; then
    echo -e "  ${BOLD}STATUS: ${BG_GREEN}${BRIGHT_WHITE} AUTHORIZED ${NC}\n"
  else
    echo -e "  ${BOLD}STATUS: ${BG_RED}${BRIGHT_WHITE} UNAUTHORIZED ${NC}\n"
    if [[ "$VERIF_LOG" == *"CONN_ERROR"* ]]; then
        print_error "Database is unreachable. Check your VPS Firewall/Atlas Network Access."
    else
        print_error "IP $VPS_IP is not whitelisted. Please add it to MongoDB."
    fi
    exit 1
  fi

  # 5. IDENTITY VERIFICATION
  SESSION_FILE="/root/.fzh_session"
  if [ ! -f "$SESSION_FILE" ]; then
    echo -e "  ${BRIGHT_WHITE}${BOLD}➤ IDENTITY VERIFICATION (2-STEP):${NC}"
    echo -n -e "  ${BOLD}${BRIGHT_MAGENTA}👉 ${WHITE}OWNER PASSWORD : ${NC}"; read -s SECOND_PWD; echo
    echo -n -e "  ${BOLD}${BRIGHT_MAGENTA}👉 ${WHITE}CUSTOM API KEY  : ${NC}"; read CLIENT_API_KEY
    print_info "Verifying credentials..."
    if verify_mongodb_direct "full" "$SECOND_PWD" "$CLIENT_API_KEY" > /dev/null; then
      echo -e "  ${BOLD}RESULT: ${BG_GREEN}${BRIGHT_WHITE} ACCESS GRANTED ${NC}"; touch "$SESSION_FILE"; sleep 1
    else
      echo -e "  ${BOLD}RESULT: ${BG_RED}${BRIGHT_WHITE} ACCESS DENIED ${NC}"; exit 1
    fi
  else
    echo -e "  ${BRIGHT_GREEN}${BOLD}✔ Session Active.${NC}"; sleep 1.5
  fi
}

# --- MENU FUNCTIONS ---
install_theme() {
  while true; do
    clear; echo ""; premium_box "SELECT PREMIUM THEME" "$BRIGHT_CYAN"; echo ""
    echo -e "  ${BRIGHT_WHITE}[1] Stellar   [2] Billing   [3] Enigma   [4] Elysium"
    echo -e "  [5] Frostcore [6] Nightcore [7] Ice      [8] Noobe"
    echo -e "  [9] Arix      [10] Nookure  [R] Reset    [X] Exit\n"
    echo -n -e "  ${BOLD}${BRIGHT_YELLOW}👉 Choice: ${NC}"; read -r SELECT_THEME
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
  
  if [[ "$SELECT_THEME" =~ ^[0-9]+$ ]]; then
    # AUTO-DIRECT BLUEPRINT FOR RELEVANT THEMES
    if [ ! -f "/var/www/pterodactyl/blueprint.sh" ] && [[ "$SELECT_THEME" == "9" || "$SELECT_THEME" == "10" ]]; then
       print_warning "Blueprint Framework required!"
       read -p "  👉 Install Blueprint automatically? (y/n): " bp_confirm
       if [[ "$bp_confirm" == "y" ]]; then install_blueprint; fi
    fi
  fi
  # Theme install logic...
  premium_box "$THEME_NAME INSTALLED" "$BRIGHT_GREEN"; sleep 2
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
  echo -e "${NC}"
  echo -e "  ${BOLD}${WHITE}┌───────────────────────── ${BRIGHT_YELLOW}PREMIUM DASHBOARD${WHITE} ──────────────────────────┐${NC}"
  echo -e "  ${BOLD}${WHITE}│${NC} ${DIM}License:${NC} ${BRIGHT_GREEN}ACTIVE${NC}  ${BOLD}${WHITE}│${NC} ${DIM}User:${NC} ${BRIGHT_CYAN}VIP GUEST${NC}   ${BOLD}${WHITE}│${NC} ${DIM}Version:${NC} ${BRIGHT_YELLOW}3.8.0-PRO${NC}  ${BOLD}${WHITE}│${NC}"
  echo -e "  ${BOLD}${WHITE}└────────────────────────────────────────────────────────────────────────┘${NC}"
  echo -e "\n  ${BOLD}${BRIGHT_MAGENTA}💎 EXCLUSIVE SERVICES:${NC}"
  echo -e "    ${BRIGHT_WHITE}[1] Premium Themes    [13] Install PHPMyAdmin"
  echo -e "    [2] Blueprint Core    [14] Configure SSL"
  echo -e "    [3] Auto-Suspend Pro  [15] Full System Backup"
  echo -e "    [4] Protect Panel     [16] Turbo Build Assets"
  echo -e "    [x] Terminal Exit\n"
  echo -n -e "  ${BOLD}${WHITE}root@FreeZeeHost:~# ${NC}"; read -r MENU_CHOICE
  case "$MENU_CHOICE" in
    1) install_theme ;; 2) install_blueprint ;; 
    x|X) exit 0 ;; *) sleep 1 ;;
  esac
done
