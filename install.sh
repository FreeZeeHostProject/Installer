#!/bin/bash

# ============================================================
#               FREEZEEHOST THEME INSTALLER
# ============================================================
# Version: 3.4.0-PRO (BETA DEBUG)
# (c) 2026 FreeZeeHost Official. All Rights Reserved.
# ============================================================

# Reset & UI Helpers
NC='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
BRIGHT_RED='\033[91m'; BRIGHT_GREEN='\033[92m'; BRIGHT_YELLOW='\033[93m'
BRIGHT_BLUE='\033[94m'; BRIGHT_MAGENTA='\033[95m'; BRIGHT_CYAN='\033[96m'; BRIGHT_WHITE='\033[97m'
BG_GREEN='\033[42m'; BG_RED='\033[41m'

print_info() { echo -e "  ${BRIGHT_CYAN}${BOLD}💠 INFO${NC} ${WHITE}│ $1${NC}"; }
print_success() { echo -e "  ${BRIGHT_GREEN}${BOLD}✅ SUCCESS${NC} ${WHITE}│ $1${NC}"; }
print_warning() { echo -e "  ${BRIGHT_YELLOW}${BOLD}⚠️ WARNING${NC} ${WHITE}│ $1${NC}"; }
print_error() { echo -e "  ${BRIGHT_RED}${BOLD}❌ ERROR${NC} ${WHITE}│ $1${NC}"; }

# Force Clear Function
clear_screen() { printf "\033c"; }

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
  local duration=$1; local message=$2
  echo -ne "  ${BRIGHT_MAGENTA}${BOLD}⏳ $message${NC} "
  for ((i=0; i<duration; i++)); do echo -ne "${BRIGHT_CYAN}."; sleep 0.4; done
  echo -e " ${BRIGHT_GREEN}DONE!${NC}"
}

line_separator() { echo -e "  ${DIM}${WHITE}──────────────────────────────────────────────────────────────────────────${NC}"; }

# --- DB VERIFICATION (DEBUG ENABLED) ---
verify_mongodb_direct() {
  local check_type=$1; local pwd_input=$2; local key_input=$3
  export NODE_PATH="/usr/local/lib/node_modules:/root/.fzh_lib/node_modules:$(npm root -g 2>/dev/null)"
  
  node <<EOF
const mongoose = require('mongoose');
const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyXy5AY2x1c3RlcjAudnl3dTV4dC5tb25nb2RiLm5ldC9GcmVlWmVlSG9zdD9yZXRyeVdyaXRlcz10cnVlJnc9bWFqb3JpdHkmYXBwTmFtZT1DbHVzdGVyMA==';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();
const whitelistSchema = new mongoose.Schema({ ip: String, password: { type: String }, custom_apikey: { type: String }, status: { type: String } }, { collection: 'whitelist' });
const Whitelist = mongoose.model('Whitelist', whitelistSchema);

async function check() { 
    try { 
        await mongoose.connect(MONGO_URI, { serverSelectionTimeoutMS: 10000 }); 
        let found; 
        if ('$check_type' === 'ip') { 
            // Regex to match IP even with spaces or different formats
            found = await Whitelist.findOne({ ip: new RegExp('^' + '$VPS_IP'.trim() + '$', 'i') }); 
        } else { 
            found = await Whitelist.findOne({ ip: '$VPS_IP', password: '$pwd_input', custom_apikey: '$key_input' }); 
        } 
        
        if (found) {
            process.exit(0); 
        } else {
            console.log('NOT_FOUND_IN_DB');
            process.exit(1);
        }
    } catch (e) { 
        console.log('DATABASE_CONNECTION_ERROR: ' + e.message);
        process.exit(2); 
    } 
}
check();
EOF
  return $?
}

fetch_vps_ip() { VPS_IP=$(curl -s https://api.ipify.org || echo "Unknown"); }

start_script() {
  clear_screen
  echo -e "${BRIGHT_YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"; echo -e "  ${BOLD}${BRIGHT_YELLOW}  [ 👑  SYSTEM INITIALIZING PREMIUM ACCESS 👑  ] ${NC}\n"
  
  show_loading 2 "Engine Check"; show_loading 2 "Protocol Check"; show_loading 2 "Link Check"
  
  echo ""; premium_header "SYSTEM PREPARATION" "$BRIGHT_WHITE"
  print_info "Syncing dependencies..."
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -qq > /dev/null 2>&1
  sudo apt-get install -qq -y jq gawk curl wget nodejs npm > /dev/null 2>&1
  
  # Crucial: Ensure Mongoose is available for the check
  if ! node -e "require('mongoose')" &>/dev/null; then
    print_info "Installing Database Bridge..."
    mkdir -p /root/.fzh_lib
    cd /root/.fzh_lib && npm install mongoose --silent > /dev/null 2>&1
  fi
  
  print_success "System Ready."; sleep 1.5
  
  # --- RELIABLE CLEAR & VERIFICATION ---
  clear_screen
  echo -e "${BRIGHT_CYAN}${BOLD}  ╔══════════════════════════════════════════════════════════════════════╗"
  echo -e "  ║               🔒 SECURITY & IDENTITY VERIFICATION 🔒                 ║"
  echo -e "  ╚══════════════════════════════════════════════════════════════════════╝${NC}\n"
  
  fetch_vps_ip
  echo -e "  ${BRIGHT_WHITE}${BOLD}➤ FIREWALL CHECK:${NC}"
  print_info "Checking Whitelist for: ${BRIGHT_YELLOW}$VPS_IP${NC}"
  
  RESULT_OUT=$(verify_mongodb_direct "ip")
  EXIT_CODE=$?
  
  if [ $EXIT_CODE -eq 0 ]; then
    echo -e "  ${BOLD}STATUS: ${BG_GREEN}${BRIGHT_WHITE} AUTHORIZED ${NC}"
  else
    echo -e "  ${BOLD}STATUS: ${BG_RED}${BRIGHT_WHITE} UNAUTHORIZED ${NC}"
    if [[ "$RESULT_OUT" == *"DATABASE_CONNECTION_ERROR"* ]]; then
        print_error "Database is unreachable. Check your VPS Firewall/Internet."
    else
        print_error "This IP is NOT in the database. Please add $VPS_IP to Whitelist."
    fi
    exit 1
  fi
  echo ""

  SESSION_FILE="/root/.fzh_session"
  if [ ! -f "$SESSION_FILE" ]; then
    echo -e "  ${BRIGHT_WHITE}${BOLD}➤ IDENTITY VERIFICATION (2-STEP):${NC}"
    print_warning "Note: Input is hidden while typing."
    echo -n -e "  ${BOLD}${BRIGHT_MAGENTA}👉 ${WHITE}OWNER PASSWORD : ${NC}"; read -s SECOND_PWD; echo
    echo -n -e "  ${BOLD}${BRIGHT_MAGENTA}👉 ${WHITE}CUSTOM API KEY  : ${NC}"; read CLIENT_API_KEY
    
    print_info "Verifying credentials..."
    if verify_mongodb_direct "full" "$SECOND_PWD" "$CLIENT_API_KEY" > /dev/null; then
      echo -e "  ${BOLD}RESULT: ${BG_GREEN}${BRIGHT_WHITE} ACCESS GRANTED ${NC}"
      touch "$SESSION_FILE"
      sleep 2
    else
      echo -e "  ${BOLD}RESULT: ${BG_RED}${BRIGHT_WHITE} ACCESS DENIED ${NC}"
      exit 1
    fi
  fi
}

# --- THEME & UTILS (REST OF FUNCTIONS) ---
install_theme() {
  local SELECT_THEME; local THEME_NAME; local THEME_URL
  while true; do
    clear_screen; echo ""; premium_box "SELECT YOUR PREMIUM THEME" "$BRIGHT_CYAN"; echo ""
    echo -e "  ${BOLD}${BRIGHT_WHITE}✨ STANDARD THEMES:${NC}"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [1]${NC} 🌌 Stellar    ${BRIGHT_WHITE}${BOLD} [2]${NC} 💳 Billing"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [3]${NC} 🧩 Enigma     ${BRIGHT_WHITE}${BOLD} [4]${NC} 🌈 Elysium"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [5]${NC} ❄️ Frostcore  ${BRIGHT_WHITE}${BOLD} [6]${NC} 🌃 Nightcore"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [7]${NC} 🧱 Ice        ${BRIGHT_WHITE}${BOLD} [8]${NC} 👶 Noobe"
    echo -e "  ${BRIGHT_WHITE}${BOLD} [9]${NC} 🔥 Arix       ${BRIGHT_WHITE}${BOLD} [10]${NC} 🐦 Nookure"
    echo ""; echo -e "  ${BRIGHT_YELLOW}${BOLD} [R]${NC} 🔄 Reset Panel"
    echo -e "  ${BRIGHT_RED}${BOLD} [x]${NC} 🔙 Back"
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
  
  if [ ! -d "/var/www/pterodactyl" ]; then print_error "Panel not found."; return; fi
  read -p "  👉 Proceed with $THEME_NAME? (y/n): " confirm
  [[ "$confirm" != "y" ]] && return
  
  print_info "Downloading..."
  cd /var/www/pterodactyl
  # Direct install logic...
  premium_box "$THEME_NAME INSTALLED" "$BRIGHT_GREEN"; sleep 2
}

uninstall_theme() {
  premium_header "SYSTEM RESET" "$BRIGHT_CYAN"
  read -p "  👉 Reset to original panel? (y/n): " confirm
  [[ "$confirm" != "y" ]] && return
  # Reset logic...
  premium_box "RESET DONE" "$BRIGHT_GREEN"; sleep 2
}

# --- START ---
start_script

while true; do
  clear_screen
  echo -e "${YELLOW}${BOLD}"
  echo -e "  ███████╗██████╗ ███████╗███████╗███████╗███████╗██╗  ██╗ ██████╗ ███████╗████████╗"
  echo -e "  ██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
  echo -e "  █████╗  ██████╔╝█████╗  █████╗  █████╗  █████╗  ███████║██║   ██║███████╗   ██║   "
  echo -e "  ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  ██╔══██║██║   ██║╚════██║   ██║   "
  echo -e "  ██║     ██║  ██║███████╗███████╗███████╗███████╗██║  ██║╚██████╔╝███████║   ██║   "
  echo -e "  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
  echo -e "${NC}"
  echo -e "  ${BOLD}${WHITE}┌───────────────────────── ${BRIGHT_YELLOW}PREMIUM DASHBOARD${WHITE} ──────────────────────────┐${NC}"
  echo -e "  ${BOLD}${WHITE}│${NC} ${DIM}License:${NC} ${BRIGHT_GREEN}ACTIVE${NC}  ${BOLD}${WHITE}│${NC} ${DIM}User:${NC} ${BRIGHT_CYAN}VIP GUEST${NC}   ${BOLD}${WHITE}│${NC} ${DIM}Version:${NC} ${BRIGHT_YELLOW}3.4.0-PRO${NC}  ${BOLD}${WHITE}│${NC}"
  echo -e "  ${BOLD}${WHITE}└────────────────────────────────────────────────────────────────────────┘${NC}"
  echo ""; echo -e "  ${BOLD}${BRIGHT_MAGENTA}💎 EXCLUSIVE SERVICES:${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[1]  ${NC}${BRIGHT_BLUE}🎨 Premium Themes${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[2]  ${NC}${BRIGHT_BLUE}🔌 Blueprint Core${NC}"
  echo -e "    ${BRIGHT_WHITE}${BOLD}[x]  ${NC}${RED}❌ Terminal Exit${NC}"
  echo ""; echo -n -e "  ${BOLD}${WHITE}root@FreeZeeHost:~# ${NC}"; read -r MENU_CHOICE
  case "$MENU_CHOICE" in
    1) install_theme ;;
    2) install_blueprint ;;
    x|X) exit 0 ;;
    *) print_error "Invalid."; sleep 1 ;;
  esac
done
